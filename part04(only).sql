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