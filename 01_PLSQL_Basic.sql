-- PL/SQL

-- 다수의 SQL 명령이 모여서 하나의 작업모듈 또는 트랜잭션을 이룰 때 
-- 이를 하나의 블럭으로 묶어서 한 번에 실행하게 하는 단위 실행명령
-- 두 가지 이상의 명령을 동시에 실행해야 할 때

-- 예를 들어 일반적인 쇼핑몰 데이터베이스에서
-- 장바구니에 있는 목록을 꺼내 주문 테이블에 넣어야 할 때
-- 1. 장바구니 테이블에서 현재 접속자가 넣어둔 목록 조회(select)
-- 2. 목록을 주문테이블에 추가(insert)

-- 위와 같이 두 개 이상의 SQL이 한 번에 실행되고자 한다면 select의 결과를 변수에 넣고
-- 변수에 저장된 값을 다시 insert 해야 할 수 있음

-- 오라클이 제공하는 프로그래밍 요소와 함게 SQL 명령 그룹(블럭)을 만들어 한 번에 실행할 수 있게 함
-- 만들어진 PL/SQL 블럭은 추 후에 우리가 학습할 MyBatis 에서도 활용됨

-- 블럭
-- PL/SQL 은 여러 블럭으로 구성되어 있는데
-- 쉽게 짐작할 수 있는 실행할 SQL 명령이 모여있는 블럭 등은 명령의 실행단위
-- 이외에 익명블럭, 이름이 존재하는 블럭들도 있고, 내부는 기는별로 이름부, 선언부, 실행부, 예외처리부로 구분하기도 함

IS (AS)
--이름부

DECLARE
-- 선언부(변수 선언 등등)
BEGIN
-- 실행부 (SQL명령)
EXCEPTION
--예외 처리부
END;
--BEGIN, END를 제외한 나머지는 필요에 의해 생략 가능




--익명블럭 (사용하지 않는 영역 키워드는 생략해도 무방함)
DECLARE
    num number; -- 변수선언
BEGIN
    num := 100; -- num 변수에 100을 저장    -> 실행명령1
    DBMS_OUTPUT.PUT_LINE(num) ; -- 결과화면에 num 변수값을 출력    -> 실행명령2

END;


-- 화면 출력을 하기 위해 기능을 ON
SET SERVEROUTPUT ON

-- 실행시간을 출력하기 위한 기능을 ON
SET TIMING ON
SET TIMING OFF


-- 우리의 현재 목표 : 웹사이트에서 전달받은 전달인수로 연산(SQL)하고, 결과를 웹사이트로 다시 리턴해주는 것
-- 현재는 그 상황까지 공부하지 못했으므로 내가 값을 넣어주고(NUM := 100;) 결과를 화면으로 출력
-- (DBMS_OUTPUT.PUT_LINE(NUM);

-- 변수 : 첫 번째 SQL에서 Order 테이블에 레코드를 삽입하고 가장 큰 기본키값을 조회한 후 
-- 그 값을 order_detail의 입력값으로 사용하려면 변수를 선언하고 값을 저장하여 활용

-- 변수 선언방법
-- 변수명 변수자료타입
--  := 초기값; SQL 명령내의 =과 구분하기 위해 :=으로 사용



-- PL/SQL의 자료형
-- 기존의 Oracle 자료형은 모두 포함하며, 자유롭게 사용할 수 있음
-- BOOLEAN : True, False, Null의 값을 갖는 자료형
-- PLS_INTEGER : -2147483648 ~ 2147483647 값을 갖는 정수 number형에 비해 저장공간을 덜 차지
-- BINARY_INTEGER : PLS_INTEGER과 같은 용량, 같은 용도로 사용
-- NATRAL : PLS_INTEGER중 양수 ( 0포함)
-- NATRALN : NATRAL 과 같지만 NULL 허용이 없고 선언과 동시에 초기화가 필요
-- POSITIVE : PLS_INTEGER 과 같지만, NULL허용이 없고 선언과 동시에 초기화가 필요
-- SIGNTYPE : -1, 0, 1
-- SIMPLE_INTEGER : PLS_INTEGER 중 NULL이 아닌 모든 값 , 선언과 동시에 초기화가 필요


--연산자
-- ** : 제곱 (자승) 연산  -> 3**4  3의 4승
-- +, - : 양수 음수 구분 연산
-- 사칙연산 +, -, *, /, ||(문자열 연결)
-- 비교연산 =, >, <, >=, <=, <>, !=, IS NULL , LIKE, BETWEEN ,IN
-- 논리연산 NOT AND OR


-- PL / SQL 블럭에 연산자를 사용한 예
DECLARE
    A INTEGER;
 BEGIN
    A := 2**2*3**2;
    DBMS_OUTPUT.PUT_LINE('A = ' || TO_CHAR(A));
END;

-- BEGIN등의 각 영역 내부에서는 한 문장의 SQL문도 하나의 명령어로 인식,
-- 연산자를 포함한 일반 명령어도 하나의 명령어로 인식해서 명령의 맨 뒤에 ';' 세미콜론이 있는 곳까지 실행

--SQL DEVELOPER 쿼리창에는 반드시 블럭만 사용할 수 있는 건 아님. 
-- 일반적인 SQL문도 사용가능
SELECT * FROM EMP;


--★★★SQL문과 같이 사용되는 PL/SQL블럭

--★★EMP 테이블에서 사원번호가 7900인 사원의 이름을 출력
SELECT ENAME FROM EMP WHERE EMPNO=7900;   -- -> 질의 경과 창에 TABLE형식으로 출력

--★★위 문장을 PL/SQL의 블럭에 넣고 결과를 변수에 저장해서 DBMS_OUTPUT_LINE으로 출력

DECLARE
    V_ENAME VARCHAR2(30); 
 BEGIN
   SELECT ENAME 
   INTO V_ENAME -- SQL문을 쓸때만 쓸 수 있는 INTO , 변수 저장 완료
   FROM EMP 
   WHERE EMPNO=7900;  
   -- 블럭안에서 SQL명령 실행 가능 
   -- 블럭안에 SQL문은 따로 별도 지정 없이 다른 명령과 같이 기술
   -- SELECT와 FROM사이에 INTO 키워드 넣고 저장될 변수 지정
   -- SELECT와 FROM 사이에 지정한 필드가 여러개라면 그 갯수만큼 INTO에 변수를 지정하여 모두 저장될 수 있게 함
   DBMS_OUTPUT.PUT_LINE(V_ENAME);
END;


--사원번호가 7900인 사원의 이름과 급여를 출력

DECLARE
    V_ENAME VARCHAR2(30); 
    V_SAL NUMBER; 
 BEGIN
   SELECT ENAME, SAL
   INTO V_ENAME , V_SAL
   FROM EMP 
   WHERE EMPNO=7900;  
  
   DBMS_OUTPUT.PUT_LINE('성명 : ' || V_ENAME ||' , 급여 : '||TO_CHAR(V_SAL) );
END;


--변수의 갯수가 많은 경우 자료형을 일일히 맞춰 선언하기 번거로우므로,
--매칭할 필드의 이름과 %TYPE을 이용하여 자동으로 자료형이 맞춰지도록 함

DECLARE
    V_ENAME EMP.ENAME%TYPE;   -- EMP테이블의 ENAME필드의 자료형으로 변수의 자료형을 맞춰주세요
    V_SAL EMP.SAL%TYPE;
 BEGIN
   SELECT ENAME, SAL
   INTO V_ENAME , V_SAL
   FROM EMP 
   WHERE EMPNO=7900;  
  
   DBMS_OUTPUT.PUT_LINE('성명 : ' || V_ENAME ||' , 급여 : '||TO_CHAR(V_SAL) );
END;


-- 연습문제 1 
-- DBMS_OUTPUT.PUT_LINE() 을 9번 사용하여 구구단 7단을 출력하는 익명블럭을 제작
-- 이어붙이기 연산도 사용
-- 현재는 변수가 필요하지 않기 때문에 DECLARE 쓰지 않아도 됨
-- 3x1=3, 3x2=6 .... 에서 3,6,9는 계산에 의해 출력되게 함

BEGIN
DBMS_OUTPUT.PUT_LINE('7 x 1 = ' || 7*1);
DBMS_OUTPUT.PUT_LINE('7 x 2 = ' || 7*2);
DBMS_OUTPUT.PUT_LINE('7 x 3 = ' || 7*3);
DBMS_OUTPUT.PUT_LINE('7 x 4 = ' || 7*4);
DBMS_OUTPUT.PUT_LINE('7 x 5 = ' || 7*5);
DBMS_OUTPUT.PUT_LINE('7 x 6 = ' || 7*6);
DBMS_OUTPUT.PUT_LINE('7 x 7 = ' || 7*7);
DBMS_OUTPUT.PUT_LINE('7 x 8 = ' || 7*8);
DBMS_OUTPUT.PUT_LINE('7 x 9 = ' || 7*9);

END;


-- 연습문제 2
-- emp테이블에서 사원번호 7788번 사원의 이름과 부서명을 출력하는 익명블록 제작
-- join명령사용, '이름-부서면' 을 스크립트 출력창에 출력

DECLARE
    ename1 emp.ename%type;
    dname1 dept.dname%type;
 BEGIN
   SELECT a.ename, b.dname
   INTO ename1, dname1
   FROM emp a, dept b
   WHERE a.deptno=b.deptno and empno=7788;  
  
   DBMS_OUTPUT.PUT_LINE('성명 : ' || ename1 ||' , 부서명 : '|| dname1 );
END;


-- 연습문제3
-- select 로 얻어낸 값을 insert 명령에 사용
-- 사원테이블(emp)테이블에서 가장 큰 사원번호(empno)로 조회
-- 그 사원번호보다 1만큼 큰 숫자를 새로운 입력 레코드의 사원번호로 하여 레코드를 추가
-- 일련번호 필드에 시퀀스가 없는 경우 사용하는 방법

--사원명 : HARRISON
--JOB : MANAGER
--MGR : 7566
--HIREDATE : 2023/04/20(오늘 날짜)
--SAL : 3000
--COMM : 700
--DEPTNO : 40

declare
    max_empno emp.empno%type;
BEGIN
select max(empno)
into max_empno
from emp;

--max_empno := max_empno+1;

insert into emp(empno, ename, job, mgr, hiredate,sal,comm,deptno)
values(max_empno+1,'HARRISON', 'MANAGER',7566,SYSDATE,3000,700,40);

commit;

END;

select*from emp order by empno desc;


