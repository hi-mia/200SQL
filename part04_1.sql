--126. 엑셀 데이터를 DB에 로드하는 방법
CREATE TABLE CANCER
(암종     VARCHAR2(50),
 질병코드   VARCHAR2(20),
 환자수    NUMBER(10),
 성별     VARCHAR2(20),
 조유병률   NUMBER(10, 2),
 생존률    NUMBER(10, 2)); --csv 파일을 저장할 테이블 생성
 
SELECT * FROM CANCER;

/*
IMPORT
일치 기준: '위치'
*/


--127. 스티브 잡스 연설문에서 가장 많이 나오는 단어는 무엇인가?
CREATE TABLE SPEECH
(  SPEECH_TEXT  VARCHAR2(1000)  );

/*
IMPORT할 때
구분자는 아무것도 없는 상태 / 왼쪽 둘러싸기 '없음' 선택
일치 기준: '이름'
*/

SELECT count(*) FROM speech;

SELECT REGEXP_SUBSTR('I never graduated from college', '[^ ]+', 1, 2) word
    FROM dual;
    
/*
REGEXP_SUBSTR 함수로 문장을 어절 단위로 나눔
REGEXP_SUBSTR: 정규표현식 함수 / 좀더 정교하게 문자열에서 원하는 단어나 철자 추출 가능

이 예제에선 문자열에서 공백이 아닌 문자를 검색
'[^ ]+' : 공백이 아니면서 철자가 여러 개가 있는 것 / 1 : 첫 번째 어절부터 / 2: 2번째 어절
-> 첫 번째부터 읽어 두 번째로 만나는 어절 출력

-연설문에서 가장 많이 나오는 단어 알아내기 -> 먼저 문자열을 어절로 잘라내기
연설문: 143개의 줄, 가장 긴 문장의 어절 개수는 52개
-> speech 테이블과 숫자 1부터 52까지 출력하는 숫자 집합과 조인 조건 없이 전부 조인하면 
143개 문장 모두 어절 단위로 출력
*/

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

--import시 구분자: 탭

--SQL 작성을 심플하게 하기 위해 127번 예제 쿼리 결과를 VIEW로 생성
SELECT REGEXP_SUBSTR(lower(speech_text), '[^ ]+', 1, a) word
    FROM speech, (  SELECT level a
                        FROM dual
                        CONNECT BY level <= 52);

--위 예제를 VIEW로 생성
CREATE VIEW SPEECH_VIEW
AS
SELECT REGEXP_SUBSTR(lower(speech_text), '[^ ]+', 1, a) word
    FROM speech,    ( SELECT level a
                        FROM dual
                        CONNECT BY level <= 52);

--연설문에서 긍정 단어의 건수가 어떻게 되는지 조회(긍정 단어를 서브 쿼리로 비교)
SELECT count(word) as 긍정단어
    FROM speech_view
    WHERE lower(word) IN ( SELECT lower(p_text)
                             FROM positive );
                            
--부정 단어 조회(부정 단어를 서브 쿼리로 비교)
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

--import 시 한글이 깨진다면 인코딩 타입: UTF8

/*
특정 범죄가 많이 발생한 요일을 출력하기 용이하도록 unpivot문을 이용하여 
요일 컬럼을 로우로 검색한 데이터를 crime_day_unpivot 테이블로 생성
*/
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
/*
crime_type이 절도 범죄로만 행을 제한하고 rank 함수를 이용하여 건수가 가장 많은 순으로 순위를 부여함,
그리고 그 중 순위 1위만 출력
*/


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
--UNIVERSITY_FEE 테이블에서 등록금(TUITION_FEE)이 가장 높은 학교 순으로 순위를 부여하여 출력,
--FROM절의 서브 쿼리 결과 중 순위가 1위인 것만 출력


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
                    
--서브 쿼리문을 사용하여 price 테이블에서 최대가격 출력 후 
--메인 쿼리에서 그 가격에 해당하는 품목 이름과 가격 출력


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
--FROM절의 서브 쿼리인 인라인 뷰를 이용해서 범죄 유형이 살인인 장소와 그 순위를 출력하게 함
--그리고 메인 쿼리에서 순위가 1위인 장소를 출력


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

--범죄 동기가 출력되기 용이하도록 unpivot문을 이용하여 범죄 동기 컬럼을 로우로 검색한 데이터를 
--CRIME_CAUSE2 테이블로 생성
CREATE TABLE CRIME_CAUSE2
AS
SELECT *
    FROM CRIME_CAUSE
    UNPIVOT (CNT FOR TERM IN (생계형, 유흥, 도박, 허영심, 복수, 해고, 징벌,
                              가정불화, 호기심, 유혹, 사고, 불만, 부주의, 기타));

--서브쿼리로 가정불화로 인한 범죄 원인의 건수 중에 가장 큰 건수 출력
--그리고 그 건수와 가트면서 원인이 가정 불화인 범죄 유형을 메인 쿼리에서 조회
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
/*
서브 쿼리에서 범죄 유형이 방화인 최대 건수를 출력
그리고 메인 쿼리에서 그 건수에 해당하는 원인을 조회하는데 최대 건수에 다른 범죄 유형이 중복될 수 있으므로
AND 다음에 범죄유형 = '방화' 조건을 추가하여 검색
*/


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
    
--FROM절의 서브 쿼리에서 교통 사고 건수가 많은 순으로 순위를 부여하여 결과를 출력함
--그리고 메인 쿼리에서 서브 쿼리의 결과 중 순위 5위까지만 제한을 걸어 출력


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
    
--FROM 절의 서브 쿼리문에서 치킨집 폐업 건수가 높은 순으로 순위를 출력
--그리고 메인 쿼리문의 WHERE 절에서 순위가 1위의 데이터만 출력함


--137. 세계에서 근무 시간이 가장 긴 나라는 어디인가?
CREATE  TABLE  WORKING_TIME
( COUNTRY      VARCHAR2(30),
  Y_2014       NUMBER(10),
  Y_2015       NUMBER(10),
  Y_2016       NUMBER(10),
  Y_2017       NUMBER(10),
  Y_2018       NUMBER(10) );

  /* 연도로 데이터 검색을 용이하게 하기 위해 unpivot문을 이용하여 연도 컬럼을 로우로 생성한
쿼리의 결과를 view로 생성 */  
CREATE VIEW C_WORKING_TIME
AS
SELECT *
    FROM WORKING_TIME
    UNPIVOT (CNT FOR Y_YEAR IN (Y_2014, Y_2015, Y_2016, Y_2017, Y_2018));
    
SELECT COUNTRY, CNT, RANK() OVER (ORDER BY CNT DESC) 순위
    FROM C_WORKING_TIME
    WHERE Y_YEAR = 'Y_2018';

--RANK 함수를 이용하여 연간 근로 시간이 가장 높은 순으로 순위를 부여하여 나라명과 같이 출력함


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

/*
1) 성별이 남자인 데이터에서 환자수가 가장 많은 암이 무엇인지 조회
2) UNION ALL 집합 연산자를 사용하여 위아래 쿼리의 결과를 같이 출력되게 함
3) 서브쿼리에서 넘겨 받은 환자수에 대한 조건에 만족하는 암종과 성별과 환자수를 출력함
4) 성별이 여자인 환자수의 최대값을 출력하여 메인 쿼리문에 전달
*/                    


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
