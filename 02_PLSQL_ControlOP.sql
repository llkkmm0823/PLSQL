--02_PLSQL_ControlOP.sql

--IF 문
-- 경우의 수가 둘 중 하나이고, 단독 if로 사용할 때
--if 조건 then
--              실행문1
--end if



--경우의 수가 둘 중 하나이고, else와 함께 사용할 때 
--if 조건 then
--          실행문1
--else
--          실행문2
--end if


--경우의 수가 셋 이상일 때
--if 조건1 then
--              실행문1
-- elsif 조건2 then                             --elsif 오타아님
--              실행문2
--else
--              실행문3
--end if


declare
    vn_num1 number := 35;
    vn_num2 number := 16;
begin
        if vn_num1 >= vn_num2 then
            dbms_output.put_line(vn_num1 ||'이(가) 큰 수') ;
        else
            dbms_output.put_line(vn_num2 ||'이(가) 큰 수') ;
        end if;
end;



-- emp 테이블에서 사원 한 명을 선별하여 그 월급(sal)의 금액에 따라 낮음, 중간, 높음이라는 단어를 출력하는 익명블럭을 제작
--(1~1000 낮음  1001~2500 보통  2501 ~  높음)
--사원을 선별하는 방법은 DBMS_RANDOM.VALUE 함수 이용
--랜덤한 부서번호로 조회하되 그 부서에 사우너이 여럿이면 첫 번째 사원으로 선택
SET SERVEROUTPUT ON
DECLARE
    v_sal number := 0;
    v_deptno number := 0;
BEGIN
    -- 사원 한 명 선별 : 랜덤하게 부서번호를 결정해서 그 부서의 첫 번째 사원
    
    -- 랜덤하게 부서번호를 발생
    -- DBMS_RANDOM.VALUE(시작숫자, 끝숫자) : 시작숫자부터 끝숫자 사이의 임의 숫자 발생
    -- round(숫자, 반올림자릿수) : 숫자를 지정된 반올림자리에서 반올림
    -- 반올림자릿수 1이면 소숫점 둘째자리에서 반올림해서 첫째자리까지 남김
    -- 반올림자릿수 -1이면 1의 자리에서 반올림
    
   v_deptno := round(DBMS_RANDOM.VALUE(10, 40) , -1);
   -- dbms_output.put_line(v_deptno) ;
   
   select sal into v_sal from emp where deptno = v_deptno and rownum=1;
   --rownum = 1 : deptno를 보여주되 첫 번째거 하나만 보여줘
   
   dbms_output.put_line(v_deptno);
   dbms_output.put_line(v_sal);
   
    if v_sal between 1 and 1000 then
        dbms_output.put_line('낮음');
    elsif v_sal >=1001 and v_sal <=2500 then
        dbms_output.put_line('보통');
        elsif v_sal >2500 then
        dbms_output.put_line('높음');
    end if;

END;


--case 문 

DECLARE
    v_sal number := 0;
    v_deptno number := 0;
BEGIN
    v_deptno := round(DBMS_RANDOM.VALUE(10, 40) , -1);
   select sal into v_sal from emp where deptno = v_deptno and rownum=1;
   dbms_output.put_line(v_deptno);
   dbms_output.put_line(v_sal);
   
   case when v_sal between 1 and 1000 then
        dbms_output.put_line('낮음');
    when v_sal >=1001 and v_sal <=2500 then
        dbms_output.put_line('보통');
    when v_sal >2500 then
        dbms_output.put_line('높음');
    end case;
END;


--case 유형 1

--case when 조건식1 then
--            실행문1
--        when 조건식2 then
--            실행문2
--        else
--            실행문3
--end case;
--
-------------------------------------------------------------------------------
--case 유형 2
--표현식의 결과값 또는 변수의 값들이 경우의 수로 분기

--case 표현식 또는 변수
--        when 값1 tehn
--            실행문1
--        when 값2 tehn
--            실행문2
--        else 값3 tehn
--            실행문3
--end case;

-------------------------------------------------------------------------------

--LOOP문
--
--반복실행 유형 1 -----------------------------------------------------
--loop
--    실행문;
--    exit[when 조건];
--end loop;

DECLARE
vn_base_num number := 7 ;  --단
vn_cnt number := 1;            -- 반복제어변수 겸 승수
BEGIN

    loop
        dbms_output.put_line(vn_base_num || 'x' || vn_cnt || '=' || vn_base_num*vn_cnt ) ;          --구구단 출력
        vn_cnt := vn_cnt+1;     --반복제어 변수 1증가
        exit when vn_cnt > 9;   --반복제어 변수가 9를 초과하면 반복실행 멈춤
    end loop;  

END;


--반복실행 유형 2 -----------------------------------------------------
--while 조건
-- loop
--    실행문;
-- end loop;

DECLARE
vn_base_num number := 6 ;  --단
vn_cnt number := 1;            -- 반복제어변수 겸 승수
BEGIN
    while vn_cnt<=9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복 실행
        loop
            dbms_output.put_line(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt ) ;  
            vn_cnt := vn_cnt+1;     --vn_cnt 값을 1씩 증가
        end loop;  
END;


--while과 exit when의 혼합 사용----------------------------------------------------
DECLARE
vn_base_num number := 9 ;  --단
vn_cnt number := 1;            -- 반복제어변수 겸 승수
BEGIN
    while vn_cnt<=9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복 실행
        loop
            dbms_output.put_line(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt ) ;  
            exit when vn_cnt = 5;
            vn_cnt := vn_cnt+1;     --vn_cnt 값을 1씩 증가
        end loop;  
END;





--For 문
--for 변수명 in [reverse] 시작값...끝값
--loop
--    실행문
--end loop;
--시작값부터 끝값까지 반복실행.  reverse 쓰여진 경우, 반대방향의 숫자진행으로 반복실행

declare
    vn_base_num number := 8;
begin
    for i in 1..9
    loop
        dbms_output.put_line(vn_base_num || 'x' || i || '=' || vn_base_num * i ) ;
    end loop;
end;

-- reverse를 사용한 경우----------------------------------

declare
    vn_base_num number := 8;
begin
    for i in reverse 1..9
    loop
        dbms_output.put_line(vn_base_num || 'x' || i || '=' || vn_base_num * i ) ;
    end loop;
end;

