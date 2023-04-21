--03_PLSQL_Function.sql



--함수
--PL/SQL 코드 작성 시에는 지금까지 사용하던 익명 블럭은 잘 사용하지 않음
--일반적으로 이름이 있는 서브 프로그램(함수) 또는 프로시저를 사용함
--익명 블럭은 한 번 사용하고 나면 사라져 버리는 휘발성 블럭
--함수 또는 프로시저는 컴파일을 거쳐 데이터베이스에 저장되어 재 사용이 가능한 구조




--함수의 정의 형태

--    CREATE OR REPLACE FUNCTION 함수이름(매개변수 1, 매개변수 2...)
--    RETURN 리턴될 데이터 타입;
--    IS[AS]
--        변수, 상수 선언
--    BEGIN
--        실행부
--        RETURN 리턴값;
--    [EXCEPTION
--               예외처리부]   -- 생략 가능
--    END [함수이름];


--   각 키워드별 상세내용
--   CREATE OR REPLACE FUNCTION : CREATE OR REPLACE FUNCTION 이라는 구문을 이용하여 함수를 생성
--   함수를 만들고 수정하더라도 이 구문을 계속 컴파일 할 수 있고, 마지막으로 컴파일 한 내용이 함수의 내용과 이름으로 사용됨

-- 매개변수 : 전달인수를 저장하는 변수로 "변수이름 변수의 자료형" 형태로 작성
-- 첫 번째 RETURN 구분 다음에는 리턴될 자료의 자료형을 쓰고, 아래쪽 두 번째 RETURN 구문옆에는 그 자료형으로 실제 리턴될 값 또는 변수 이름을 작성
-- [ ] 안에 있는 EXCEPTION구문은 필요치 않을 시 생략 가능



-- 두 개의 정수를 전달해서 첫 번쨰 값을 두 번째 값으로 나눈 나머지를 구해서 리턴해주는 함수

create or replace function myMod(num1 number, num2 number)
        return number
is
    v_remainder number := 0;        -- 나눈 나머지를 저장할 변수선언
    v_mok number := 0;             --나눈 몫을 저장할 변수선언
begin
    v_mok := floor(num1 / num2);        -- 나눈 몫의 정수 부분만 저장 _ floor : 소숫점 절사
    v_remainder := num1 - (num2 * v_mok);       --몫 * 젯수 를 피젯수에서 빼면 나머지가 계산이 됨
    return v_remainder;
end;

select myMod(14, 4) from dual;





-- 연습문제1
-- 도서번호를 전달인수로 전달하여, booklist에서 해당 도서 제목을 리턴받는 함수를 제작

--함수 호출 명령
select subjectbynum(5) , subjectbynum(8) from dual;

--함수 제작
CREATE OR REPLACE FUNCTION subjectbynum (num number)
    RETURN varchar2
IS
    v_subject varchar2(50);
BEGIN
    select subject 
    into v_subject     -- 이 변수에 조회 결과가 저장됨
    from booklist 
    where booknum=num;
    
    RETURN v_subject;  -- 저장된 결과만 리턴해주면 됨
END;

-- 연습문제2
-- 위의 함수의 기능 중 전달된 도서번호로 검색된 도서가 없다면 ' 해당 도서 없음' 이라는 문구가 리턴되도록 수정
-- function 내부에서 count(*)함수 활용   조회한 도서번의 레코드 갯수가 0개이면 "해당 도서 없음 "리턴
--도서가 있으면 도서제목 리턴
select subjectbynum(8), subjectbynum(20) from dual;

CREATE OR REPLACE FUNCTION subjectbynum (num number)
    RETURN varchar2
IS
    v_subject booklist.subject%type;
    v_count number;
    
BEGIN
    select count(*)   -- 전달받은 도서번호에 해당하는 도서 권 수 조회
    into v_count
    from booklist 
    where booknum=num;
    
if  v_count = 0 then
    v_subject := '해당 도서 없음';
else 
    select subject 
    into v_subject 
    from booklist 
    where booknum=num;    
end if;
    return v_subject;
END; 




-- 매개변수가 없는 함수

CREATE OR REPLACE FUNCTION fn_get_user -- 매개변수가 없는 함수는 괄호 없이 정의하기도 함
    RETURN varchar2
IS
   vs_user_name varchar2(80);
    
BEGIN
    select user
    into vs_user_name
    from dual; -- 현재 오라클 로그인 유저 조회 > vs_user_name 변수에 저장
    
    return vs_user_name;  -- 사용자 이름 리턴
    
END; 
select fn_get_user(), fn_get_user from dual; -- 매개변수가 없는 함수는 괄호없이 호출하기도 함




-- 연습문제 3
--emp테이블에서 각 부서번호를 전달받아 급여의 평균값을 계산하여 리턴하는 함수를 제작
--전달된 부서번호의 사원이 없으면 급여 평균은 0으로 리턴
--함수호출은 아래와 같음
select salAvgDept(10),salAvgDept(20),salAvgDept(30),salAvgDept(40) from dual;

CREATE OR REPLACE FUNCTION salAvgDept(num number)
    RETURN number
IS
   emp_sal number;
   emp_avg number;
   emp_count number;
    
BEGIN
select count(*)
    into emp_count
    from emp
    where deptno=num;  --전달된 부서번호가 존재하는지 먼저 검사

if emp_count = 0 then
    emp_avg := 0;
else
    select sum(sal)  
    -- 선생님의 해설에선 select avg(sal) 을 활용하심. avg함수는 기억안나고 sum함수만 기억나서 이렇게 풀었지만, 다음엔 함수활용하여 풀기!
    into emp_sal
    from emp
    where deptno=num;
    emp_avg := round((emp_sal/emp_count),1);
end if;
    return emp_avg;
END; 

