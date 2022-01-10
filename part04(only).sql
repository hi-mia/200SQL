--126. 엑셀 데이터를 DB에 로드하는 방법
CREATE TABLE CANCER
(암종     VARCHAR2(50),
 질병코드   VARCHAR2(20),
 환자수    NUMBER(10),
 성별     VARCHAR2(20),
 조유병률   NUMBER(10, 2),
 생존률    NUMBER(10, 2)); 


--127. 스티브 잡스 연설문에서 가장 많이 나오는 단어는 무엇인가?
CREATE TABLE SPEECH
(  SPEECH_TEXT  VARCHAR2(1000)  );

SELECT count(*) FROM speech;

SELECT REGEXP_SUBSTR('I never graduated from college', '[^ ]+', 1, 2) word
    FROM dual;
    
SELECT REGEXP_SUBSTR(lower(speech_text), '[^ ]+', 1, a) word
    FROM speech, (  SELECT level a
                        FROM dual
                        CONNECT BY level <= 52);
                        
--어절 단위로 나눈 단어들을 카운트하여 가장 많이 나오는 단어 순으로 정렬
SELECT word, count(*)
    FROM (  SELECT REGEXP_SUBSTR(lower(speech_text), '[^ ]+', 1, a) word
            FROM speech, ( SELECT level a
                            FROM dual
                            CONNECT BY level <= 52)
        )
    WHERE word is not null
    GROUP BY word
    ORDER BY count(*) desc;


--128. 스티브 잡스 연설문에는 긍정 단어가 많은가 부정 단어가 많은가?
CREATE TABLE POSITIVE ( P_TEXT VARCHAR2(2000) ); --긍정 단어 저장
CREATE TABLE NEGATIVE ( N_TEXT VARCHAR2(2000) ); --부정 단어 저장

--VIEW 생성
CREATE VIEW SPEECH_VIEW
AS
SELECT REGEXP_SUBSTR(lower(speech_text), '[^ ]+', 1, a) word
    FROM speech,    ( SELECT level a
                        FROM dual
                        CONNECT BY level <= 52);

--연설문에서 긍정 단어의 건수가 어떻게 되는지 조회
SELECT count(word) as 긍정단어
    FROM speech_view
    WHERE lower(word) IN ( SELECT lower(p_text)
                             FROM positive );
                            
--부정 단어 조회
SELECT count(word) as 부정단어
    FROM speech_view
        WHERE lower(word) IN ( SELECT lower(n_text)
                                FROM negative);


--129. 절도가 많이 발생하는 요일은 언제인가?
CREATE TABLE CRIME_DAY
(CRIME_TYPE     VARCHAR2(50),
  SUN_CNT       NUMBER(10),
  MON_CNT       NUMBER(10),
  TUE_CNT       NUMBER(10),
  WED_CNT       NUMBER(10),
  THU_CNT       NUMBER(10),
  FRI_CNT       NUMBER(10),
  SAT_CNT       NUMBER(10),
  UNKNOWN_CNT   NUMBER(10));

CREATE TABLE CRIME_DAY_UNPIVOT
 AS
 SELECT *
    FROM CRIME_DAY
    UNPIVOT (CNT FOR DAY_CNT    IN (SUN_CNT, MON_CNT, TUE_CNT, WED_CNT,
                                    THU_CNT, FRI_CNT, SAT_CNT));
                                    
SELECT *
    FROM (
            SELECT DAY_CNT, CNT, RANK() OVER (ORDER BY CNT DESC) RNK
                FROM CRIME_DAY_UNPIVOT
                WHERE TRIM(CRIME_TYPE) = '절도'
        )
    WHERE   RNK = 1;


--130. 우리나라에서 대학 등록금이 가장 높은 학교는 어디인가?
CREATE TABLE UNIVERSITY_FEE
(DIVISION       VARCHAR2(20), --학제별
 TYPE           VARCHAR2(20), --설립별
 UNIVERSITY     VARCHAR2(60), --대학명
 LOC            VARCHAR2(40), --지역별
 ADMISSION_CNT  NUMBER(20),   --입학정원합(명)
 ADMISSION_FEE  NUMBER(20),   --평균입학금(천원)
 TUITION_FEE    NUMBER(20));  --평균등록금(천원)

SELECT *
    FROM (
        SELECT UNIVERSITY, TUITION_FEE,
                    RANK() OVER (ORDER BY TUITION_FEE DESC NULLS LAST) 순위
            FROM UNIVERSITY_FEE
        )
    WHERE 순위 = 1;


--131. 서울시 물가 중 가장 비싼 품목과 가격은 무엇인가?
create  table price 
(P_SEQ	        number(10), --상품 번호
 M_SEQ	        number(10), --상품 분류
 M_NAME         varchar2(80),  --시장 이름
 A_SEQ	        number(10),  --상품 단위
 A_NAME	        varchar2(60),  --상품명
 A_UNIT	        varchar2(40),  --상품 개수
 A_PRICE	    number(10),  --상품 가격
 P_YEAR_MONTH	varchar2(30),  --물가측정날짜
 ADD_COL	    varchar2(180),  --추가정보
 M_TYPE_CODE	varchar2(20),  --시장코드
 M_TYPE_NAME	varchar2(20),  --시장이름
 M_GU_CODE	    varchar2(10),  --구코드
 M_GU_NAME	    varchar2(30) );  --구이름

SELECT A_NAME as "상품", A_PRICE as "가격", M_NAME as "매장명"
FROM PRICE
WHERE A_PRICE = (SELECT MAX(A_PRICE)
                    FROM PRICE);


--132. 살인이 가장 많이 발생하는 장소는 어디인가?
create  table  crime_loc
( CRIME_TYPE    varchar2(50), --범죄 유형
  C_LOC         varchar2(50), --범죄 장소
  CNT           number(10) ); --범죄 건수

SELECT *
FROM ( 
    SELECT c_loc, cnt, rank() over (order by cnt desc)  rnk
        FROM crime_loc
        WHERE crime_type='살인'
    )
WHERE  rnk = 1;


--133. 가정불화로 생기는 가장 큰 범죄 유형은 무엇인가?
create table crime_cause
( 범죄유형     varchar2(30),
  생계형       number(10),
  유흥        number(10),
  도박        number(10),
  허영심       number(10),
  복수        number(10),
  해고        number(10),
  징벌        number(10),
  가정불화      number(10),
  호기심       number(10),
  유혹        number(10),
  사고        number(10),
  불만        number(10),
  부주의      number(10),
  기타       number(10)  );

--CRIME_CAUSE2 테이블 생성
CREATE TABLE CRIME_CAUSE2
AS
SELECT *
    FROM CRIME_CAUSE
    UNPIVOT (CNT FOR TERM IN (생계형, 유흥, 도박, 허영심, 복수, 해고, 징벌,
                              가정불화, 호기심, 유혹, 사고, 불만, 부주의, 기타));

SELECT 범죄유형
    FROM CRIME_CAUSE2
    WHERE CNT = (SELECT MAX(CNT)
                    FROM CRIME_CAUSE2
                    WHERE TERM = '가정불화')
    AND TERM = '가정불화';


--134. 방화 사건의 가장 큰 원인은 무엇인가?
SELECT TERM AS 원인
    FROM CRIME_CAUSE2
    WHERE CNT = (SELECT MAX(CNT)
                    FROM CRIME_CAUSE2
                    WHERE 범죄유형 = '방화')
    AND 범죄유형 = '방화';


--135. 전국에서 교통사고가 제일 많이 발생하는 지역은 어디인가?
CREATE TABLE ACC_LOC_DATA
(ACC_LOC_NO    NUMBER(10), --사고지역 관리 번호
 ACC_YEAR       NUMBER(10), --사고년도
 ACC_TYPE       VARCHAR2(20), --사고유형구분
 ACC_LOC_CODE   NUMBER(10), --위치코드
 CITY_NAME      VARCHAR2(50), --시도시군구명
 ACC_LOC_NAME  VARCHAR2(200), --사고지역위치명
 ACC_CNT        NUMBER(10), --발생건수
 AL_CNT          NUMBER(10), --사상자수
 DEAD_CNT       NUMBER(10), --사망자수
 M_INJURY_CNT   NUMBER(10), --중상자수
 L_INJURY_CNT    NUMBER(10), --경상자수
 H_INJURY_CNT   NUMBER(10), --부상자수
 LAT              NUMBER(15,8), --위도
 LOT              NUMBER(15,8), --경도
 DATA_UPDATE_DATE   DATE ); --데이터 기준 일자


SELECT *
    FROM ( SELECT ACC_LOC_NAME AS 사고장소, ACC_CNT AS 사고건수,
                DENSE_RANK() OVER (ORDER BY ACC_CNT DESC NULLS LAST) AS 순위
            FROM ACC_LOC_DATA
            WHERE ACC_YEAR=2017
            )
    WHERE 순위 <= 5;


--136. 치킨집 폐업이 가장 많았던 연도가 언제인가?
CREATE TABLE CLOSING
(  년도        NUMBER(10),
   미용실      NUMBER(10),
   양식집      NUMBER(10),
   일식집      NUMBER(10),
   치킨집      NUMBER(10),
   커피음료    NUMBER(10),
   한식음식점   NUMBER(10),
   호프간이주점  NUMBER(10) ) ;

SELECT 년도 "치킨집 폐업 연도", 치킨집 "건수"
    FROM (SELECT 년도, 치킨집,
                rank() over(order by 치킨집 desc) 순위
          FROM closing)
    WHERE 순위 = 1;


--137. 세계에서 근무 시간이 가장 긴 나라는 어디인가?
CREATE  TABLE  WORKING_TIME
( COUNTRY      VARCHAR2(30),
  Y_2014       NUMBER(10),
  Y_2015       NUMBER(10),
  Y_2016       NUMBER(10),
  Y_2017       NUMBER(10),
  Y_2018       NUMBER(10) );

--view로 생성
CREATE VIEW C_WORKING_TIME
AS
SELECT *
    FROM WORKING_TIME
    UNPIVOT (CNT FOR Y_YEAR IN (Y_2014, Y_2015, Y_2016, Y_2017, Y_2018));
    
SELECT COUNTRY, CNT, RANK() OVER (ORDER BY CNT DESC) 순위
    FROM C_WORKING_TIME
    WHERE Y_YEAR = 'Y_2018';


--138. 남자와 여자가 각각 많이 걸리는 암은 무엇인가?
SELECT DISTINCT(암종), 성별, 환자수
    FROM CANCER
    WHERE 환자수 = (SELECT MAX(환자수)
                    FROM CANCER
                    WHERE 성별 = '남자' AND 암종 != '모든암')
UNION ALL
SELECT DISTINCT(암종), 성별, 환자수
    FROM CANCER
    WHERE 환자수 = (SELECT MAX(환자수)
                    FROM CANCER
                    WHERE 성별 = '여자');           


--139. PL/SQL 변수 이해하기 1
set serveroutput on
accept p_num1 prompt    '첫 번재 숫자를 입력하세요 ~ '
accept p_num2 prompt    '두 번째 숫자를 입력하세요 ~ '

declare
        v_sum   number(10);
begin
        v_sum  :=  &p_num1 + &p_num2;
        
        dbms_output.put_line('총합은: ' || v_sum);
end;
/


--140. PL/SQL 변수 이해하기 2
set serveroutput on
accept p_empno prompt   '사원 번호를 입력하세요 ~ '
    declare
            v_sal   number(10);
    begin  
            select sal into v_sal
              from emp
              where empno = &p_empno;
    dbms_output.put_line('해당 사원의 월급은 ' || v_sal);
end;
/


--141. PL/SQL IF 이해하기 1 (IF ~ ELSE문)
set serveroutput on
set verify off
accept  p_num   prompt  '숫자를 입력하세요 ~  '
begin
    if  mod(&p_num, 2) = 0  then
        dbms_output.put_line('짝수입니다.');
    else
        dbms_output.put_line('홀수입니다.');
    end if;
end;
/
--숫자를 물어보게 하고 숫자를 입력하면 해당 숫자가 짝수인지 홀수인지 출력되게 하는 PL/SQL


--142. PL/SQL IF 이해하기 2 (IF ~ ELSEIF ~ ELSE문)
set serveroutput on
set verify off
accept p_ename prompt '사원 이름을 입력합니다 ~ '
declare
    v_ename emp.ename%type := upper('&p_ename');
    v_sal   emp.sal%type;

begin
    select sal into v_sal
        from emp
        where ename = v_ename;

    if  v_sal >= 3000    then
        dbms_output.put_line('고소득자입니다.');
    elsif   v_sal >= 2000   then
        dbms_output.put_line('중간 소득자입니다.');
    else
        dbms_output.put_line('저소득자입니다.');
    end if;
end;
/
--이름을 입력받아 해당 사원의 월급 구간에 따라 고소득자/중간 소득자/저소득자 메시지 출력 PL/SQL문


--143. PL/SQL Basic Loop 이해하기
set serveroutput on
declare   
      v_count    number(10) := 0 ; 
begin
      loop
        v_count  :=  v_count + 1; 
   dbms_output.put_line ( '2 x ' || v_count || ' = ' ||  2*v_count);                          
        exit when v_count = 9;
     end loop;
end;
/
--구구단 2단 출력


--144. PL/SQL While Loop 이해하기
set serveroutput on
declare
        v_count     number(10) := 0; 
begin
        while v_count < 9 loop
            v_count := v_count + 1;
            dbms_output.put_line ('2 x ' || v_count || '=' || 2 * v_count);
        end loop; 
end;
/

/*
[While loop문 문법]

[While 루프문을 반복시킬 조건 loop
  반복할 실행문
  End loop;]
*/


--145. PL/SQL for Loop 이해하기
set serveroutput on
begin
    for i in 1 .. 9 loop
        dbms_output.put_line ('2 x ' || i || ' = ' || 2 * i);
    end loop;
end;
/

/*
[For loop문 문법]

[For 인덱스 카운터 in 하한값..상한값
  반복할 실행문
End loop;]
*/


--146. PL/SQL 이중 Loop문 이해하기
set serveroutput on
prompt 구구단 전체를 출력합니다
begin
    for i in 2 .. 9 loop
      for j in 1 .. 9 loop
        dbms_output.put_line( i || ' x ' || j || ' = ' || i * j);
      end loop;
    end loop;
end;
/

/*
[중첩 for loop문 문법]

[For 인덱스 카운터 in 하한값 .. 상한값      
    For 인덱스 카운터 in 하한값 .. 상한값   
                        반복할 실행문
    End loop;                              
End loop;                                  
]
*/


--147. PL/SQL Cursor문 이해하기 (Basic LOOP)
set serveroutput on
set verify off
declare
    v_ename   emp.ename%type;
    v_sal     emp.sal%type;
    v_deptno  emp.deptno%type;
  
    cursor emp_cursor is
       select ename, sal, deptno
         from emp
         where deptno = &p_deptno;
begin
    open  emp_cursor ;
     loop
          fetch  emp_cursor into v_ename, v_sal, v_deptno;
          exit  when  emp_cursor%notfound;
          dbms_output.put_line(v_ename||' '||v_sal||' '|| v_deptno);        
     end loop;
   close  emp_cursor;             
end;               
/


--148. PL/SQL Cursor문 이해하기 (FOR LOOP)
set serveroutput on
set verify off
accept p_deptno prompt '부서 번호를 입력하세요 ~'
declare
     cursor emp_cursor is           
       select ename, sal, deptno     
         from emp                    
         where deptno = &p_deptno;     
begin
     for emp_record in emp_cursor   loop 
      dbms_output.put_line(emp_record.ename ||' '||emp_record.sal 
                                   ||' '||emp_record.deptno);
     end loop;
end;
/


--149. PL/SQL Cursor for loop문 이해하기
set serveroutput on
set verify off
accept p_deptno prompt '부서 번호를 입력하세요 ~'
begin
  for emp_record in ( select  ename, sal, deptno
                           from  emp                  
                          where deptno = &p_deptno )  loop 

     dbms_output.put_line(emp_record.ename ||' '||
                                       emp_record.sal ||' ' || emp_record.deptno);

  end loop;
end;
/


--150. 프로시저 구현하기
create or replace procedure pro_ename_sal
(p_ename    in emp.ename%type)
is
        v_sal   emp.sal%type;
begin
        select sal into v_sal
            from emp
            where ename = p_ename;
    dbms_output.put_line(v_sal || 'won');
    
end;
/
--이름을 입력받아 해당 사원의 월급이 출력되게 하는 프로시저 생성


--151. 함수 구현하기
create or replace function get_loc
(p_deptno in dept.deptno%type)
return  dept.loc%type
is
        v_loc   dept.loc%type;
begin
        select loc into v_loc
                from dept
                where deptno = p_deptno;
    return v_loc;
end;
/


--152. 수학식 구현하기 1 (절대값)
set serveroutput on
accept p_num    prompt '숫자를 입력하세요 ~ '

declare
    v_num number(10) := &p_num;

begin
    if v_num >= 0 then
        dbms_output.put_line(v_num);
    else
        dbms_output.put_line(-1 * v_num);
    end if;
end;
/


--153. 수학식 구현하기 2 (직각삼각형)
set serveroutput on
set verify off
accept p_num1 prompt ' 밑변을 입력하세요 ~ '
accept p_num2 prompt ' 높이를 입력하세요 ~ '
accept p_num3 prompt ' 빗변을 입력하세요 ~ '

begin

    if power(&p_num1, 2) + power(&p_num2, 2) = power(&p_num3, 2)
    then
        dbms_output.put_line('직각삼각형입니다. ');

    else
        dbms_output.put_line('직각삼각형이 아닙니다.');
    end if;
end;
/
--밑변과 높이와 빗변을 각각 물어보게 하고 직각삼각형이 맞는지 출력되게 하는 PL/SQL


--154. 수학식 구현하기 3 (지수 함수)
set serveroutput on --dbms.output.put_line을 실행하기 위한 SQL*PLUS 명령어
set verify off
accept p_num1 prompt '밑수를 입력하세요 ~'
accept p_num2 prompt '지수를 입력하세요 ~'

declare 
    v_result number(10) := 1;
    v_num2 number(10) := &p_num1;
    v_count number(10) := 0;
begin
        loop
            v_count := v_count + 1;
            v_result := v_result * v_num2;
            exit when v_count = &p_num2;
        end loop;
            dbms_output.put_line(v_result);
end;
/


--155. 수학식 구현하기 4 (로그 함수)
set serveroutput on
set verify off
accept p_num1 prompt '밑수를 입력하세요 ~ '
accept p_num2 prompt '진수를 입력하세요 ~ '

declare 
        v_num1      number(10) := &p_num1;   
        v_num2      number(10) := &p_num2;   
        v_count     number(10) := 0;        
        v_result    number(10) := 1;         
begin
    loop
        v_count := v_count + 1;              
        v_result := v_result * v_num1;
        exit when v_result = v_num2;          
    end loop;
        dbms_output.put_line(v_count);
end;
/


--156. 수학식 구현하기 5 (순열)
create table sample
( num  number(10),
 fruit   varchar2(10) );

insert into sample values (1, '사과');
insert into sample values (2, '바나나');
insert into sample values (3, '오렌지');
commit;

select * from sample; 

--순열 구현
set serveroutput on
set verify off
declare
    v_name1     sample.fruit%type; 

    v_name2     sample.fruit%type;
begin
    for i in 1 .. 3 loop
        for j in 1 .. 3 loop
            select fruit into v_name1 from sample where num = i;
            select fruit into v_name2 from sample where num = j;
            if i != j then
                dbms_output.put_line(v_name1 || ', ' || v_name2);
            end if;
        end loop;
    end loop;
end;
/

/*
순열: 서로 다른 n개 중에서 r개를 택하여 일렬로 배열하는 것
*/


--157. 수학식 구현하기 6 (조합)
set serveroutput on
declare
    v_name1     sample.fruit%type;
    v_name2     sample.fruit%type;

begin
    for i in 1 .. 3 loop
        for j in 1 .. 3 loop
            select fruit into v_name1 from sample where num = i;
            select fruit into v_name2 from sample where num = j;
            dbms_output.put_line(v_name1 || ',' || v_name2);
        end loop;
    end loop;
end;
/

/*
조합: 서로 다른 n개의 원소 중에서 r개를 선택하여 조를 만들 때, 각각 조들의 모임
*/


--158. 기초 통계 구현하기 1 (평균값)
set serveroutput on
set verify off
accept p_arr prompt '숫자를 입력하세요 ~ ';

declare
   type arr_type is varray(5) of number(10); --숫자형 데이터 배열 변수 선언(size 5)
   v_num_arr   arr_type := arr_type(&p_arr);
   v_sum  number(10)  := 0; 
   v_cnt  number(10) := 0; 
begin
    for i in 1 .. v_num_arr.count loop
         v_sum :=  v_sum  + v_num_arr(i) ;
         v_cnt  := v_cnt + 1;
    end loop;

dbms_output.put_line( v_sum / v_cnt); 

end;
/

/*
여러 개의 숫자들을 입력받은 후 입력받은 숫자들의 평균값을 출력하는 PL/SQL문
*/


--159. 기초 통계 구현하기 2 (중앙값)
accept p_arr prompt '숫자를 입력하세요 ~ ';
declare
type arr_type is varray(10) of number(10); 
    v_num_arr   arr_type    := arr_type(&p_arr);
    v_n     number(10);
    v_medi      number(10,2);
begin
    v_n := v_num_arr.count;
    if mod(v_n, 2) = 1 then 
        v_medi := v_num_arr((v_n+1)/2);
    else                  
        v_medi := (v_num_arr(v_n/2) + v_num_arr((v_n/2)+1))/2;
    end if;
    dbms_output.put_line(v_medi);
end;
/


--160. 기초 통계 구현하기 3 (최빈값)
accept p_num1 prompt '데이터를 입력하세요 ~ '
declare
    type array_t is varray(10) of varchar2(10);
    v_array array_t := array_t(&p_num1);
    v_cnt number(10);
    v_tmp number(10);
    v_max number(10) := 0;
    v_tmp2 number(10);
begin
    for i in 1 .. v_array.count loop
        v_cnt := 1;
        for j in i+1 .. v_array.count loop 
            if v_array(i) = v_array(j) then
                v_tmp := v_array(i);
                v_cnt := v_cnt+1;
            end if;
        end loop;

        if v_max <= v_cnt then 
            v_max := v_cnt;
            v_tmp2 := v_tmp;
        end if;
    end loop;
dbms_output.put_line('최빈값은 ' || v_tmp2 || '이고 ' || v_max || '개입니다');
end;
/


--161. 기초 통계 구현하기 4 (분산과 표준편차)
set serveroutput on
set verify off
accept p_arr prompt '숫자를 입력하세요 ~ ';

declare
    type    arr_type is varray(10) of number(10);
    v_num_arr   arr_type := arr_type(&p_arr);
    v_sum       number(10, 2) := 0;   
    v_cnt       number(10, 2) := 0;
    v_avg       number(10, 2) := 0;
    v_var       number(10, 2) := 0;

begin
    for i in 1 .. v_num_arr.count loop
        v_sum := v_sum + v_num_arr(i);
        v_cnt := v_cnt + 1;
    end loop;

    v_avg := v_sum / v_cnt;

    for i in 1 .. v_num_arr.count loop
        v_var := v_var + power(v_num_arr(i) - v_avg, 2);
    end loop;

    v_var := v_var / v_cnt;

    dbms_output.put_line('분산값은: ' || v_var);
    dbms_output.put_line('표준편차는: ' || round(sqrt(v_var)));
end;
/


--162. 기초 통계 구현하기 5 (공분산)
accept p_arr1 prompt '키를 입력하세요 ~ ';
accept p_arr2 prompt '체중을 입력하세요 ~ ';

declare
    type arr_type is varray(10) of number(10, 2);
    v_num_arr1      arr_type := arr_type(&p_arr1);
    v_sum1          number(10, 2) := 0;
    v_avg1          number(10, 2) := 0;

    v_num_arr2      arr_type := arr_type(&p_arr2);
    v_sum2          number(10, 2) := 0;
    v_avg2          number(10, 2) := 0;

    v_cnt           number(10, 2);
    v_var           number(10, 2) := 0;

begin

    v_cnt := v_num_arr1.count;

    for i in 1 .. v_num_arr1.count loop
        v_sum1 := v_sum1 + v_num_arr1(i);
    end loop;
    
      v_avg1 := v_sum1 / v_cnt;
    
    for i in 1 .. v_num_arr2.count loop
            v_sum2 := v_sum2 + v_num_arr2(i);
    end loop;

    v_avg2 := v_sum2 / v_cnt;

    for i in 1 .. v_cnt loop
        v_var := v_var + (v_num_arr1{i) - v_avg1) * (v_num_arr2(i) - v_avg2) / v_cnt;
    end loop;

    dbms_output.put_line('공분산 값은: ' || v_var);
end;
/

/*
5명의 키와 체중 데이터를 각각 입력받은 후 공분산 값을 출력하는 PL/SQL문 작성
*/


--163. 기초 통계 구현하기 6 (상관계수)
set serveroutput on
set verify off

accept p_arr1 prompt'키를 입력하세요 ~ ';
accept p_arr2 prompt '체중을 입력하세요 ~ ';

declare
    type arr_type is varray(10) of number(10,2);
    v_num_arr1    arr_type := arr_type(&p_arr1);
    v_sum1   number(10,2)  := 0; 
    v_avg1   number(10,2) := 0;

    v_num_arr2    arr_type := arr_type(&p_arr2);
    v_sum2   number(10,2)  := 0; 
    v_avg2   number(10,2) := 0;

    v_cnt    number(10,2);
    cov_var    number(10,2) := 0;

    v_num_arr1_var  number(10,2) := 0;
    v_num_arr2_var  number(10,2) := 0;
    v_corr   number(10,2) ;
    
begin

   v_cnt :=  v_num_arr1.count ;

    for i in 1 .. v_num_arr1.count loop
         v_sum1 :=  v_sum1  + v_num_arr1(i) ;
    end loop;
    
    v_avg1 := v_sum1 / v_cnt;

   for i in 1 .. v_num_arr2.count loop
         v_sum2 :=  v_sum2  + v_num_arr2(i) ;
    end loop;

   v_avg2 := v_sum2 / v_cnt; 

  for i in 1 .. v_cnt loop
   cov_var:= cov_var+  (v_num_arr1(i) - v_avg1) * ( v_num_arr2(i) - v_avg2) / v_cnt;
   v_num_arr1_var := v_num_arr1_var  +  power(v_num_arr1(i) - v_avg1,2);
   v_num_arr2_var := v_num_arr2_var  +  power(v_num_arr2(i) - v_avg2,2);
  end loop;

       v_corr := cov_var /  sqrt( v_num_arr1_var * v_num_arr2_var ) ;
        dbms_output.put_line('상관관계는: ' || v_corr);
end;
/

/*
키와 체중 데이터를 각각 입력받은 후 키와 체중 간의 상관관계가 있는지 PL/SQL문으로 구현
*/


--164. 기초 통계 구현하기 7 (확률)
set serveroutput on
set verify off

declare
    v_loop number(10) := 10000;
    v_coin number(10) ;
    v_0  number(10) := 0 ;
    v_1  number(10) := 0 ; 

begin
    for i in 1..v_loop loop    

        select  round(dbms_random.value(1,2)) into v_coin
              from dual;

        if  v_coin = 1 then 
            v_0 := v_0 + 1;

        else  
            v_1 := v_1+1;
     
        end if;
    end loop;

    dbms_output.put_line('동전이 앞면이 나올 확률: ' || round((v_0/v_loop),2));
    dbms_output.put_line('동전이 뒷면이 나올 확률: ' || round((v_1/v_loop),2));  

end;
/

/*
하나의 동전을 여러 번 던졌을 때 앞면과 뒷면이 나올 확률이 각각 50%임을 확인하는 PL/SQL
*/


--165. 기초 통계 구현하기 8 (확률)
set serveroutput on
set verify off

declare
    v_loop number(10) := 10000;
    v_coin1 number(10);
    v_coin2 number(10);
    v_0 number(10) := 0;
    v_1 number(10) := 0;
    v_2 number(10) := 0;

begin
    for i in 1..v_loop loop
        select round(dbms_random.value(0,1)), round(dbms_random.value(0,1))
                            into v_coin1, v_coin2
                from dual;
        
        if v_coin1 = 0 and v_coin2 = 0 then
            v_0 := v_0 + 1;

        elsif v_coin1 = 1 and v_coin2 = 1 then
            v_1 := v_1+1;
        else
            v_2 := v_2+1;
        end if;
    end loop;

    dbms_output.put_line('동전 둘 다 앞면이 나올 확률: ' || round((v_0/v_loop),2));
    dbms_output.put_line('동전 둘중 하나가 앞면, 다른 하나는 뒷면이 나올 확률: ' || round((v_2/v_loop),2));
    dbms_output.put_line('동전 둘 다 뒷면이 나올 확률: ' || round((v_1/v_loop),2));
end;
/    

/*
동전 두 개를 동시에 던져 둘 다 앞면이 나올 확률과 둘 다 뒷면이 나올 확률, 하나는 앞면 하나는 뒷면이
나올 확률 각각 출력 PL/SQL
*/


--166. 기초 통계 구현하기 9 (이항 분포)
create or replace function mybin
(p_h in number)
return number
is
    v_h number(10) := p_h;
    v_sim number(10) := 100000;
    v_cnt number(10) := 0;
    v_cnt2 number(10) := 0;
    v_res number(10,2); 

begin
     for n in 1..v_sim loop
     v_cnt := 0;
          for i in 1..10 loop
               if dbms_random.value<0.5 then
                      v_cnt := v_cnt+1;
              end if;
          end loop;
          if v_cnt=v_h then
                v_cnt2 := v_cnt2+1;
 end if;
    end loop;

    v_res := v_cnt2/v_sim;

 return v_res;
end;
/


SELECT level-1 grade, mybin(level-1) 확률, lpad('■', mybin(level-1)*100, '■') "막대그래프"
  FROM dual
  CONNECT BY level < 12;

/*
동전 던지기의 이항 확률 분포를 PL/SQL문으로 구현
*/


--167. 기초 통계 구현하기 10 (정규분포)
set serveroutput on

create or replace procedure probn
 ( p_mu in number,
   p_sig in number,
   p_bin in number)
is

   type arr_type is varray(9) of number(30);

  v_sim number(10) := 10000;
  v_rv number(20,7);
  v_mu number(10) := p_mu;
  v_sig number(10) := p_sig;
  v_nm arr_type := arr_type('',0,0,0,0,0,0,0,'');
  v_cnt arr_type := arr_type(0,0,0,0,0,0,0,0);
  v_rg arr_type := arr_type(-power(2,31),-3,-2,-1,0,1,2,3,power(2,32));

begin
   for i in v_nm.first+1..v_nm.last-1 loop
       v_nm(i) := v_mu-3*p_bin+(i-2)*p_bin;
   end loop;

  for i in 1..v_sim loop
      v_rv := dbms_random.normal*v_sig+v_mu;

        for i in 2..v_rg.count loop
             if v_rv >= v_mu+v_rg(i-1)*p_bin and v_rv < v_mu+v_rg(i)*p_bin then
                    v_cnt(i-1) := v_cnt(i-1)+1;
             end if;
        end loop;
  end loop;

  for i in 1..v_cnt.count loop
dbms_output.put_line(rpad(v_nm(i)||'~'||v_nm(i+1), 10, ' ')||lpad('■',trunc((v_cnt(i)/v_sim)*100),'■'));
  end loop;
end;
/


--168. PL/SQL로 알고리즘 문제 풀기 1 (삼각형 출력)
set serveroutput on

accept p_num prompt '숫자를 입력하세요 ~ '
declare 
     v_cnt  number(10) := 0; 
begin 
      while v_cnt < &p_num loop  
        v_cnt := v_cnt + 1;
        dbms_output.put_line(lpad('★',v_cnt,'★' ));              
     end loop;
end;
/


--169. PL/SQL로 알고리즘 문제 풀기 2 (사각형 출력)
set serveroutput on 
accept p_a prompt '가로의 숫자를 입력하세요 ~'
accept p_b prompt '세로의 숫자를 입력하세요 ~'

begin 
   for  i  in  1 .. &p_b loop
      dbms_output.put_line( lpad('★',&p_a,'★') );
   end loop;
end;
/


--170. PL/SQL로 알고리즘 문제 풀기 3 (피타고라스의 정리)
set serveroutput on
set verify off
accept p_num1 prompt '밑변의 길이를 입력하세요 :  ' 
accept p_num2 prompt '높이를 입력하세요 :  '
accept p_num3 prompt '빗변의 길이를 입력하세요 :  '

declare 
	v_num1 number(10) :=&p_num1;
	v_num2 number(10) :=&p_num2;
	v_num3 number(10) :=&p_num3;

begin 
   if (v_num1)**2 + (v_num2)**2=(v_num3)**2 then
	dbms_output.put_line('직각삼각형이 맞습니다');
   else 
	dbms_output.put_line('직각삼각형이 아닙니다');ㄴ
   end if ;
end;
/


--171. PL/SQL로 알고리즘 문제 풀기 4 (팩토리얼)
set serveroutpu on
set verify off
accept p_num prompt '숫자를 입력하세요 ' 
declare 
v_num1 number(10):= &p_num;
v_num2 number(10) :=&p_num;

begin 
loop 
	v_num1 := v_num1-1;
	v_num2 :=v_num2*v_num1; 
	exit when v_num1=1;
end loop;
	dbms_output.put_line(v_num2);
end; 
/


--172. PL/SQL로 알고리즘 문제 풀기 5 (최대 공약수)
set verify off
accept p_num1 prompt  '첫 번째 숫자를 입력하세요 ~'
accept p_num2 prompt  '두 번째 숫자를 입력하세요 ~'
declare
      v_cnt   number(10);
      v_mod  number(10);

begin
    for i in reverse   1 .. &p_num1 loop
        v_mod := mod(&p_num1, i) + mod(&p_num2, i);
        v_cnt := i ;
        exit when v_mod = 0;
   end loop;
        dbms_output.put_line( v_cnt);
 end;
/


--173. PL/SQL로 알고리즘 문제 풀기 6 (최소 공배수)
set serveroutput on
set verify off
accept p_num1 prompt '첫 번째 숫자를 입력하세요 ~ '
accept p_num2 prompt '두 번째 숫자를 입력하세요 ~ '
declare
      v_num1 number(10) := &p_num1;
      v_num2 number(10) := &p_num2;
      v_cnt   number(10);
      v_mod  number(10);
      v_result number(10);
begin
    for i in reverse 1 .. v_num1 loop
        v_mod := mod(v_num1, i) + mod(v_num2, i);
        v_cnt := i ;
        exit when v_mod = 0;
   end loop;
        v_result := (v_num1 / v_cnt) *( v_num2 / v_cnt) * v_cnt;
        dbms_output.put_line( v_result );
 end;
/


--174. PL/SQL로 알고리즘 문제 풀기 7 (버블 정렬)
set serveroutput on
set verify off
accept p_num prompt '정렬할 5개의 숫자를 입력하세요: '

declare
type array_t is varray(10) of number(10);
array array_t := array_t(); 
tmp number := 0;
v_num varchar2(50) := '&p_num';
v_cnt number := regexp_count(v_num,' ')+1;

begin
array.extend(v_cnt);
dbms_output.put('정렬 전 숫자 : ');

for i in 1 .. array.count loop         
	 array(i) := regexp_substr('&p_num','[^ ]+',1,i);
  dbms_output.put(array(i)||' ');
end loop;

dbms_output.new_line;

for i in 1 .. array.count-1 loop
for j in i+1.. array.count loop
	       if array(i) > array(j) then
	            tmp := array(i);
	            array(i) := array(j);
	            array(j) := tmp;
	        end if;
    end loop;
end loop;
dbms_output.put('정렬 후 숫자 : ');

for i in 1.. array.count loop
	dbms_output.put(array(i)||' ');
end loop;
	dbms_output.new_line;
end;
/


--175. PL/SQL로 알고리즘 문제 풀기 8 (삽입 정렬)
set serveroutput on
set verify off

accept p_num prompt '정렬할 5개의 숫자를 입력하세요: '

declare
   type array_t is varray(100) of number(10) ;
   varray array_t :=  array_t();
   v_temp number(10) ;

begin

 varray.extend( regexp_count('&p_num' ,' ')+1) ;

    for i in 1 .. varray.count loop
        varray(i) := to_number( regexp_substr('&p_num','[^ ]+',1,i ) ) ;
    end loop ;

 for j in 2 .. varray.count loop
    for k in 1 .. j-1 loop

       if varray(k) > varray(j) then 
          v_temp := varray(j) ; 
   
       for z in reverse k .. j-1 loop
          varray(z+1) := varray(z) ;
        end loop;
          
          varray(k) := v_temp ; 
       end if ;
    end loop ;
 end loop ;

 for i in 1 .. varray.count loop
     dbms_output.put( varray(i) || ' ' ) ;
 end loop ;

 dbms_output.new_line ;
end ;
/


--176. PL/SQL로 알고리즘 문제 풀기 9 (순차탐색)
set serveroutput on
set verify off
accept p_num prompt '랜덤으로 생성할 숫자들의 개수를 입력하세요 ~'
accept p_a prompt '검색할 숫자를 입력하세요 ~ '

declare

type array_t is varray(1000) of number(30);
array_s  array_t := array_t();
v_cnt  number(10) := &p_num; 
v_a  number(10) := &p_a;
v_chk  number(10) := 0;

begin

array_s.extend(v_cnt);

for i in 1 .. v_cnt loop 
    array_s(i) := round( dbms_random.value(1, v_cnt)) ;
    dbms_output.put(array_s(i) ||',');
end loop;
    dbms_output.new_line;

for i in array_s.first..array_s.last loop

 if v_a=array_s(i) then
     v_chk := 1;
dbms_output.put(i||'번째에서 숫자 '||v_a||'를 발견했습니다.');
 end if;

end loop;

	dbms_output.new_line;

if v_chk=0 then
 dbms_output.put_line('숫자를 발견하지 못했습니다..');
end if;

end;
/


--177. PL/SQL로 알고리즘 문제 풀기 10 (몬테카를로 알고리즘)
set serveroutput on

declare 
   v_cnt   number(10,2) := 0;
   v_a    number(10,2);
   v_b    number(10,2); 
   v_pi   number(10,2);

begin
  for  i  in  1 .. 1000000  loop
        v_a := dbms_random.value(0,1);
        v_b := dbms_random.value(0,1);
 
        if  power(v_a,2) + power(v_b,2) <= 1 then
             v_cnt := v_cnt  + 1 ;
        end if; 
    end  loop;

      v_pi := (v_cnt/1000000) * 4 ;
      dbms_output.put_line( v_pi );
end;
/


--178. PL/SQL로 알고리즘 문제 풀기 11 (탐욕 알고리즘)
set serveroutput on 
set verify off
accept p_money prompt '잔돈 전체 금액을 입력하세요 ~'
accept p_coin prompt '잔돈 단위를 입력하세요 ~ ' 

declare
   v_money number(10) := &p_money ;
   type array_t is varray(3) of number(10); 
   v_array array_t := array_t(&p_coin); 
   v_num array_t := array_t( 0, 0, 0);

begin
   for i in 1 .. v_array.count loop 
      if v_money >= v_array(i) then
         v_num(i) := trunc(v_money/v_array(i));
         v_money := mod(v_money,v_array(i));
     end if;
         dbms_output.put( v_array(i)||'원의 개수 :' || v_num(i)||'개, ');
   end loop;
   dbms_output.new_line;
end;
/

/*
전체 금액과 잔돈의 단위를 각각 물어보게 하고 탐욕 알고리즘을 이용하여 입력한 금액에 맞추어
잔돈을 거슬러주는 PL/SQL문
*/