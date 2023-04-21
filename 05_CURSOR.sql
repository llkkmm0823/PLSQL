-- 05_CURSOR.sql

--cursor
-- 주로 프로시져 내부의 sql 명령 중 select명령의 결과가 다수의 행으로 얻어졌을 때 사용하는 결과 저장용 변수를 말함
set serveroutput on;


declare
    v_job varchar2(30);
begin
    select job into v_job from emp where deptno = 30;
    dbms_output.put_line(v_job);
end;
-- 위의 익명블럭은 select 명령의 결과가 1행(row)이므로 실행이 가능하나
-- select 명령의 결과가 2행이상이라면 에러 발생.

-- 2행 이상의 결과를 담을 수 있는 메모리 영역(또는 변수) 으로 사용하는 것이 cursor이며 자바의 리스트와 비슷한 구조를 갖고있음
-- 또는 반복실행문을 이용하여 그 값들을 참조하고 출력하고 리턴할 수 있음
-- 그냥 쉽게 변수라고 생각하면 됨


--cursor의 생성-실행단계

-- 1. cursor 의 생성 (정의)
-----------------------------------------------------------
--cursor 사용할 커서의 이름 [ (매개변수1, 매개변수2, ...) ]
--is
--select ...sql문장
-----------------------------------------------------------
--매개변수의 역할 : select 명령에서 사용할 값들을 저장(주로 where절에서 사용할 값들)
--select...sql 문장 : 실행되어 cursor에 결과를 도출할 sql명령


-- 2. cursor 의 open (호출)
-----------------------------------------------------------
--open 사용할 커서의 이름 [ (전달인수1, 전달인수2, ...) ]
-----------------------------------------------------------
-- 실제로 전달인수를 전달하여 커서안의 sql문을 실행하고 결과를 커서에 저장



--3. 결과를 반복실행문과 함께 필요에 맞게 처리
-----------------------------------------------------------

--loop
--        fetch 커서 이름 into 변수(들) ;
--        exit when 커서이름 %notfound;       -- select에 의해 얻어진 레코드가 다 소진되어 없을 때까지 반복 계속
--        필요에 맞는 처리 실행
--end loop;
-----------------------------------------------------------
--fetch 커서이름 into 변수 ; 커서에 담긴 데이터들 중 한 줄씩 꺼내서 변수(들)에 넣는 동작
--exit when 커서이름 %notfound ;   꺼냈는데 데이터가 존재하지 않으면 종료
--loop안에서 필요에 맞는 처리를 데이터가 없을 때까지 반복



--4. cursor 닫기
-----------------------------------------------------------
--  close 커서명
-----------------------------------------------------------


--cursor의 사용
--전달인수로 부서번호를 전달한 후 그 부서의 사원이름과 직업들을 얻어오는 커서
declare
    v_ename emp.ename%type;
    v_job emp.job%type;
    
--1. 커서의 정의
    cursor cur_emp(p_deptno emp.deptno%type)
    is
    select ename, job from emp where deptno = p_deptno;
begin
--2. 커서 호출 및 실행
    open cur_emp(30);
--3. 반복 실행문으로 얻어진 커서안의 내용을 하나씩 꺼내어 출력 
    loop
        fetch cur_emp into v_ename, v_job;
        exit when cur_emp%notfound;
        dbms_output.put_line(v_ename || ' - ' || v_job);
    end loop;
close cur_emp;
end;



--기존의 for 문
--for 인덱스 변수 in [reverse] 처음값... 끝값------------------------
--loop
--    실행문
--end loop;
--처음값부터 끝값까지 하나씩 인덱스 변수에 저장하면 반복실행
--------------------------------------------------------------------------




--커서와 함께 사용하는 for 문-----------------------------------------
--for 레코드변수 in 커서이름 (전달인수1, 전달인수2...)
--loop 
--    실행문
--end loop
---------------------------------------------------------------------------
--open과 loop가 합쳐진 예

declare
-- emp_rec라는 레코드 변수 안에 필드명이 모두 존재, 각 행의 필드값을 저장할 별도의 변수를 필요로 하지 않음
    cursor cur_emp ( p_deptno emp.deptno%type)
    is
    select ename,job from emp where deptno = p_deptno;
begin
    for emp_rec in cur_emp(30) -- for문에 의해 반복될 횟수가 지정된 것으로 보다 간편해짐
    loop
        -- 필요한 필드는 emp_rec 뒤로 필드명을 지정하여 사용 가능 ( ex) emp_rec.job)
        dbms_output.put_line(emp_rec.ename || ' - ' || emp_rec.job);
    end loop;
    
    
-- 일반적인 cursor의 사용과 비교
--    open cur_emp(30);
--    loop
--        fetch cur_emp into v_ename, v_job;
--        exit when cur_emp%notfound;
--        dbms_output.put_line(v_ename || ' - ' || v_job);
--    end loop;
--    close cur_emp;

end;



----------------------------------------------------------------------------------------------------------------------------
--for문을 이용하여 커서변수의 사용이 조금 더 간단해짐

--조금 더 간결한 for문과 커서의 사용
declare
begin
    for emp_rec in (select * from emp where deptno =30)
    loop
        dbms_output.put_line(emp_rec.ename || ' - ' || emp_rec.job);
    end loop;
end;



--연습문제
-- 부서번로가 30번인 사원의 이름, 부서명, 급여, 급여 수준(높음, 보통, 낮음)을 출력
-- 급여(sal)는 1000미만 낮음, 100~2500 보통 나머지 높음으로 출력
-- 이름 - 부서명 - 급여 - 높음 순으로 출력
declare
    level varchar2(10);
begin
    for emp_rec in (select a.ename,b.dname,a.sal from emp a, dept b where a.deptno = b.deptno and a.deptno =30)
    loop
        if emp_rec.sal <1000 then
            level := '낮음';
        elsif emp_rec.sal <=2500 then
            level := '보통';
        else 
            level := '높음';
        end if;    
        dbms_output.put_line(emp_rec.ename || ' - ' || emp_rec.dname || ' - ' ||emp_rec.sal || ' - ' || level);
    end loop;
end;


--커서 변수
--앞에서 생성한 커서의 이름은 함수처럼 호출되는 이름이며 커서를 대표하는 이름
--그러나 커서의 이름으로 다른 커서를 만들지는 못함
--변수로 치면 앞에서 만든 커서의 이름은 상수 정도로 표현 가능
--앞으로 나올 이름은 변수로서 사용되고 다른 커서도 저장할 수 있게 사용하고자 함
--커서 변수를 사용해야 프로시져 내에서 커서변수를 OUT변수로 지정하고 리턴 동작으로 활용할 수 있음


--커서 변수의 선언
-- 스스로 만든 자료형으로 쓰는 커서변수

--TYPE 사용할 커서의 타입이름 ID REF CURSOR [RETURN 반환타입] ;   -> 생성된 커서타임의 이름으로 커서 변수를 선언할 예정
-- 커서변수이름 커서타입이름;
TYPE DEP_CURTYPE1 IS REF CURSOR RETURN EMP%ROWTYPE;  -- 강한 커서 타입
TYPE DEP_CURTYPE2 IS REF CURSOR ;  -- 약한 커서 타입
-- 위 두줄의 명령은 커서의 이름을 생성한 것이 아니라 커서를 선언할 수 있는 "커서 자료형(TYPE)을 생성한 것
-- 커서자료형(TYPE)을 이용하여 이제 실제 커서변수를 선언할 수 있음
CURSOR1 DEP_CURTYPE1;
CURSOR2 DEP_CURTYPE2;

--cursor1과 cursor2 변수에는 select 명령을 담아서 커서를 완성할 수 있음
--또한 커서내용(select 문)이 고정적이지 않고 바뀔 수 있음
--다만 cursor1은 강한 커서 타입이므로 정의되어있는 대로 (return departments%rowtype)레코드 전체의 결과를 얻는 select만 저장할 수 있음

open cursor1 for select empno, ename from emp where deptno = 30; -- X 불가능
open cursor1 for select * from emp where deptno = 30; -- O 가능

open cursor2 for select empno, ename from emp where deptno = 30; -- O 가능
open cursor2 for select * from emp where deptno = 30; --O 가능
--커서 변수를 만들어서 필요할 때마다 커서 내용을 저장하고 호출해서 그 결과를 사용하려 변수를 생성


curtype3 sys_refcursor;         --시스템에서 제공해주는 커서타입을 사용할 예정
-- sys_refcursor를 사용하면 
-- type emp_dep_curtype is ref cursor;  -->커서타입 생성 생략가능
-- emp_curvar_emp_dep_curtype;    --> 변수 선언 sys_refcursor 형태로 선언
 
 declare
    v_deptno emp.deptno%type;   -->일반 변수 선언
    v_ename emp.ename%type;    -->일반 변수 선언
    emp_curvar sys_refcursor;   --> sys_refcursor 타입의 커서 변수 선언 ( 커서 자료형 생성이 필요없이 사용 가능)
begin 
    open emp_curvar for select ename, deptno from emp where deptno = 20;    --커서변수에 select문 설정
    loop
        fetch emp_curvar into v_ename, v_deptno;        --최초 사용형태처럼 각 자료를 저장할 변수가 필요
        exit when emp_curvar%notfound;
        dbms_output.put_line(v_ename || '-' || v_deptno);
    end loop;
end;
--1. sys_refcursor 변수 생성
--2. 변수에 select 연결
--3. fetch로 꺼내어 처리 (반복실행)



-- 프로시저에서의 커서 사용 예
-- select의 결과를 커서 변수에 담아서 프로시저를 호출한 out 변수에 리턴
-- 프로시저 내용 : 부서번호가 10번인 사원의 이름과 급여 리턴
create or replace procedure testCursorArg (
    p_curvar out sys_refcursor
    --매개변수로 select 명령의 결과를 담아서 다시 리턴해줄 out 변수 ( 자료형 sys_refcursor ) 생성
)
is
    temp_curvar sys_refcursor;  -- 프로시저 안에서 사용할 커서 변수
begin  
    -- 문제에서 요구한 부서번호가 10인 사원의 이름과 급여를 temp_curvar 변수에 저장
    open temp_curvar for select ename, sal from emp where deptno = 10;
    -- 현재 위치에서 커서의 내용을 fetch하지 않음.
    --fetch 로 반복실행도 하지 않음
    --out 변수에 실행된 커서변수의 내용을 담음
    p_curvar := temp_curvar;
end;

declare
    curvar sys_refcursor;
    v_ename emp.ename%type;
    v_sal emp.sal%type;
begin
    testCursorArg(curvar);
    loop
        fetch curvar into v_ename, v_sal;
        exit when curvar%notfound;
        dbms_output.put_line(v_ename || '-' || v_sal);
    end loop;
end;


