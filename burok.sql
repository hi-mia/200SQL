--SQL 200제 실습 스크립트
alter session set nls_date_format='RR/MM/DD';

drop table emp;
drop table dept;

CREATE TABLE DEPT
       (DEPTNO number(10),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) ,
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) );

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

drop  table  salgrade;

create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );

insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);

commit;


--부록 1. Kaggle 상위권에 도전하기1
/* 타이타닉호의 생존자/사망자 예측 모델 생성 */

-- 1. 머신러닝 모델이 학습할 테이블을 생성
DROP  TABLE TITANIC;

CREATE TABLE TITANIC
( PASSENGERID	NUMBER(5),
SURVIVED	NUMBER(5),
PCLASS	        NUMBER(5),
NAME	        VARCHAR2(100),
SEX	        VARCHAR2(20),
AGE	        NUMBER(5,2),
SIBSP	        NUMBER(5), 
PARCH	        NUMBER(5),
TICKET	        VARCHAR2(20),
FARE	        NUMBER(18,5),
CABIN	        VARCHAR2(50),
EMBARKED      VARCHAR2(5) );
-- 데이터 입력: SQL Developer를 이용해서 train.csv 를 titanic 테이블에 입력

SELECT COUNT(*) FROM TITANIC;
--891

-- 2. 머신러닝 모델을 구성하기 위한 환경 설정 테이블을 생성
DROP TABLE SETTINGS_GLM;

CREATE TABLE SETTINGS_GLM
AS
SELECT *
     FROM TABLE (DBMS_DATA_MINING.GET_DEFAULT_SETTINGS)
    WHERE SETTING_NAME LIKE '%GLM%';

BEGIN

   INSERT INTO SETTINGS_GLM
        VALUES (DBMS_DATA_MINING.ALGO_NAME, 'ALGO_RANDOM_FOREST');

   INSERT INTO SETTINGS_GLM
        VALUES (DBMS_DATA_MINING.PREP_AUTO, 'ON');

   INSERT INTO SETTINGS_GLM
        VALUES (
                  DBMS_DATA_MINING.GLMS_REFERENCE_CLASS_NAME,
                  'GLMS_RIDGE_REG_DISABLE');

   INSERT INTO SETTINGS_GLM
        VALUES (
                  DBMS_DATA_MINING.ODMS_MISSING_VALUE_TREATMENT,
                  'ODMS_MISSING_VALUE_MEAN_MODE');

   COMMIT;
END;
/

-- 3. 머신러닝 모델을 삭제
BEGIN
   DBMS_DATA_MINING.DROP_MODEL( 'MD_CLASSIFICATION_MODEL');
END;
/

-- 4. 머신러닝 모델을 생성
BEGIN 
   DBMS_DATA_MINING.CREATE_MODEL(
      model_name         => 'MD_CLASSIFICATION_MODEL',
      mining_function       =>  DBMS_DATA_MINING.CLASSIFICATION,
      data_table_name       => 'TITANIC',
      case_id_column_name   => 'PASSENGERID',
      target_column_name    =>  'SURVIVED',
      settings_table_name   => 'SETTINGS_GLM');
END;
/

-- 5. 머신러닝 모델을 확인
SELECT MODEL_NAME,
       ALGORITHM,
       MINING_FUNCTION
  FROM ALL_MINING_MODELS
 WHERE MODEL_NAME = 'MD_CLASSIFICATION_MODEL';

-- 6. 머신러닝 모델 설정 정보를 확인 
SELECT SETTING_NAME, SETTING_VALUE
FROM ALL_MINING_MODEL_SETTINGS
WHERE MODEL_NAME = 'MD_CLASSIFICATION_MODEL';

-- 7. 테스트 데이터를 저장할 테이블을 생성
DROP TABLE TITANIC_TEST;

CREATE TABLE TITANIC_TEST
( PASSENGERID	NUMBER(5),
PCLASS	        NUMBER(5),
NAME	        VARCHAR2(100),
SEX	        VARCHAR2(20),
AGE	        NUMBER(5,2),
SIBSP	        NUMBER(5), 
PARCH	        NUMBER(5),
TICKET	        VARCHAR2(20),
FARE	        NUMBER(18,5),
CABIN	        VARCHAR2(50),
EMBARKED      VARCHAR2(5) );
-- 데이터 입력: SQL Developer를 이용해서 test.csv 를 titanic 테이블에 입력

SELECT COUNT(*) FROM TITANIC_TEST;
--418

-- 8. 모델이 예측한 결과를 확인
SELECT passengerid ,
 PREDICTION (MD_CLASSIFICATION_MODEL USING *) MODEL_PREDICT_RESPONSE
FROM titanic_test 
order by passengerid;



--부록2. Kaggle 상위권에 도전하기 2
/* 타이타닉 생존자 예측 모델 성능 높이기
성능 높이기 위해서는 
1) 머신러닝 모델이 잘 학습(공부)할 수 있도록 좋은 데이터 제공해줘야 함
좋은 데이터 = 기존의 데이터를 가지고 만든 파생변수

2) 결측치를 채우는 것
훈련 데이터 나이의 결측치를 호칭(Mrs, Miss, Mr, Other)별 평균 나이로 치환하여 머신러닝 모델이 더 잘 학습할수 있도록 함

3) 훈련 데이터에서 운임의 이상치를 제거하고 학습 시킴
*/

--1.여자와 아이를 구분하기 위한 파생 변수를 생성할 컬럼을 추가
ALTER TABLE TITANIC
  ADD WOMEN_CHILD NUMBER(5);

--2. 추가한 파생변수에 여자와 10세미만의 아이들은 값을 1로 갱신하고 아니면 0으로 값을 갱신
UPDATE TITANIC T1
SET WOMEN_CHILD = ( SELECT CASE WHEN AGE < 10 OR SEX='FEMALE'  
                                         THEN 1 ELSE 0 END    
                                 FROM TITANIC T2
                                 WHERE T2.PASSENGERID = T1.PASSENGERID ); 
                           
COMMIT;

--3. 테스트 테이블에도 똑같은 컬럼을 추가
ALTER TABLE TITANIC_TEST
  ADD WOMEN_CHILD NUMBER(5);

--4. 추가한 파생변수에 여자와 10세미만의 아이들은 값을 1로 아니면 0으로 값을 갱신
UPDATE TITANIC_TEST T1
SET WOMEN_CHILD = ( SELECT CASE  WHEN  AGE < 10  OR  SEX='FEMALE'  THEN  1  ELSE 0  END  
                                  FROM   TITANIC_TEST   T2
                                  WHERE  T2.PASSENGERID = T1.PASSENGERID  ); 
                           
COMMIT;

--5. 1 과 0의 빈도수를 확인
SELECT WOMEN_CHILD, COUNT(*)
 FROM TITANIC
 GROUP BY WOMEN_CHILD;

--6. 나이(AGE) 의 결측치를 확인
SELECT COUNT(*) FROM TITANIC WHERE AGE IS NULL;

--7. 나이의 결측치를 이름의 호칭의 평균값으로 채우기 위해 이름에서 호칭만 출력
SELECT name, SUBSTR(name, (instr(name, ',')+1), instr(name, '.')-instr(name, ',')-1) as 호칭 
  FROM titanic;

--8. titanic 테이블에 title (호칭) 컬럼을 추가
ALTER TABLE TITANIC
  ADD TITLE VARCHAR2(20);

--9. titanic 테이블에 추가한 title(호칭) 컬럼을 호칭 값으로 갱신
MERGE INTO TITANIC T
USING ( SELECT PASSENGERID, NAME, 
                  SUBSTR( NAME, INSTR( NAME, ',')+2, 
                                 INSTR( NAME, '.')-INSTR( NAME, ',')-2 ) AS 호칭
            FROM TITANIC ) A
  ON ( T.PASSENGERID = A.PASSENGERID )
  WHEN MATCHED THEN
  UPDATE SET T.TITLE = A.호칭 ;

COMMIT;

--10. title(호칭) 컬럼의 값이 잘 변경되었는지 확인
SELECT name, title FROM titanic;

--11. titanic 테이블에 title2 (호칭2) 컬럼을 추가
ALTER TABLE TITANIC
 ADD TITLE2 VARCHAR2(20);

--12. 변경전 호칭을 변경후 호칭으로 대체한 쿼리문을 실행
SELECT title,
       CASE WHEN title in ('Mlle','Mme','Ms') then 'Miss'
              WHEN title in ('Dr','Major','Rev','Sir','Don','Master','Capt') then 'Mr'
              WHEN title in('Lady','the Countess') then 'Mrs'
              WHEN title in ('Jonkheer','Col') then 'Other'
              ELSE title END 호칭2
 FROM titanic;

--13. title2(호칭2) 컬럼을 변경 후 호칭으로 변경
MERGE INTO titanic t
USING titanic i
On (t.passengerid = i.passengerid)
WHEN MATCHED Then
UPDATE SET title2 =  CASE WHEN title in ('Mlle','Mme','Ms') then 'Miss'
                                   WHEN title in ('Dr','Major','Capt', 'Sir' , 'Don' , 'Master') 
                                   THEN 'Mr'
                                   WHEN title in ('the Countess', 'Lady') then 'Mrs'
                                   WHEN title in ('Jonkheer', 'Col' , 'Rev') then 'Other'
                                   ELSE title END;

COMMIT;

--14. title2 를 출력하고 title2 별 평균나이를 출력
SELECT  title2, round(avg(age))
  FROM  titanic
  GROUP  BY  title2;

--15. title2 별로 age의 null 값이 몇 개가 있는지 카운트하여 확인
SELECT title2 ,count(*)
   FROM  titanic
   WHERE age is null
   GROUP BY title2;

--16. 나이의 결측치를 해당 title2 의 평균 나이로 값을 갱신해서 채워 넣음
MERGE INTO titanic t
USING ( SELECT title2, round(avg(age)) 평균나이 
            FROM titanic 
            GROUP BY title2 ) tt
ON ( t.title2 = tt.title2 )
WHEN MATCHED THEN
UPDATE SET t.age = tt.평균나이
WHERE  t.age is null ;

COMMIT;

--17. titanic_test 테이블에 title (호칭) 컬럼을 추가
ALTER TABLE TITANIC_TEST
 ADD TITLE  VARCHAR2(20);

--18. 추가한 title 컬럼에 호칭을 갱신
MERGE INTO titanic_test t
USING ( SELECT passengerid, name, 
                  SUBSTR( name, instr( name, ',')+2, 
                                     instr( name, '.')-instr( name, ',')-2 ) as 호칭
            FROM titanic_test ) a
  ON ( t.passengerid = a.passengerid )
  WHEN MATCHED THEN
  UPDATE SET t.title = a.호칭 ;

COMMIT;

--19. . titanic_test 테이블에 title2 컬럼을 추가
ALTER TABLE TITANIC_TEST
 ADD TITLE2  VARCHAR2(20);

--20. title2(호칭2) 컬럼을 변경 후 호칭으로 변경
MERGE INTO titanic_test t
USING titanic_test i
ON (t.passengerid = i.passengerid)
WHEN MATCHED THEN
UPDATE SET title2 =  CASE WHEN title in ('Mlle','Mme','Ms') then 'Miss'
                                   WHEN title in ('Dr','Major','Capt', 'Sir' , 'Don' , 'Master') 
                                   THEN 'Mr'
                                   WHEN title in ('the Countess', 'Lady') then 'Mrs'
                                   WHEN title in ('Jonkheer', 'Col' , 'Rev') then 'Other'
                                   ELSE title END;

COMMIT;

--21. 나이의 결측치를 해당 title2 의 평균 나이로 값을 갱신하여 결측치를 채움
MERGE INTO titanic_test t
USING ( SELECT title2, round(avg(age)) 평균나이 
            FROM titanic_test 
            GROUP BY title2 ) tt
ON ( t.title2 = tt.title2 )
WHEN MATCHED THEN
UPDATE SET t.age = tt.평균나이
WHERE t.age is null ;

COMMIT;

--22. 운임의 이상치(Outlier)를 확인
SELECT PASSENGERID, FARE, 이상치기준
  FROM( SELECT T.*,
                     ROUND( AVG(FARE) OVER () + 5 * STDDEV(FARE) OVER ()) "이상치기준"
              FROM TITANIC  T
        )
   WHERE FARE > 이상치기준;

--23. 운임의 이상치를 제거하고 훈련 데이터를 구성하기 위해 VIEW를 생성
CREATE OR REPLACE VIEW TT_VIEW
AS
SELECT *
    FROM( SELECT T.*,
                      ROUND( AVG(FARE) OVER () + 5 * STDDEV(FARE) OVER ()) "이상치기준"
                FROM TITANIC  T
        )
    WHERE FARE < 이상치기준;

--24 머신러닝 모델을 구성하기 위한 환경 설정 테이블을 생성
DROP TABLE SETTINGS_GLM3;

CREATE TABLE SETTINGS_GLM3
AS
SELECT *
     FROM TABLE (DBMS_DATA_MINING.GET_DEFAULT_SETTINGS)
     WHERE SETTING_NAME LIKE '%GLM%';

BEGIN

   INSERT INTO SETTINGS_GLM3
        VALUES (DBMS_DATA_MINING.ALGO_NAME, 'ALGO_RANDOM_FOREST');

   INSERT INTO SETTINGS_GLM3
        VALUES (DBMS_DATA_MINING.PREP_AUTO, 'ON');

  INSERT INTO SETTINGS_GLM3
     VALUES (DBMS_DATA_MINING.CLAS_MAX_SUP_BINS, 254);

   COMMIT;

END;
/

--25. 기존의 머신러닝 모델을 삭제
BEGIN
   DBMS_DATA_MINING.DROP_MODEL( 'MD_CLASSIFICATION_MODEL3');
END;
/

--26. 머신러닝 모델을 생성
BEGIN 
   DBMS_DATA_MINING.CREATE_MODEL(
      MODEL_NAME         => 'MD_CLASSIFICATION_MODEL3',
      MINING_FUNCTION       => DBMS_DATA_MINING.CLASSIFICATION,
      DATA_TABLE_NAME       => 'TT_VIEW',
      CASE_ID_COLUMN_NAME   => 'PASSENGERID',
      TARGET_COLUMN_NAME    => 'SURVIVED',
      SETTINGS_TABLE_NAME   => 'SETTINGS_GLM3');
END;
/

--27. 머신러닝 모델을 확인
SELECT MODEL_NAME,
       ALGORITHM,
       MINING_FUNCTION
 FROM ALL_MINING_MODELS
 WHERE MODEL_NAME = 'MD_CLASSIFICATION_MODEL3';

--28. 테스트 데이터로 예측 값을 확인 
SELECT PASSENGERID,
          PREDICTION (MD_CLASSIFICATION_MODEL3 USING *) MODEL_PREDICT_RESPONSE
FROM TITANIC_TEST 
ORDER BY PASSENGERID;

--29. 케글 Submit Predictions 텝을 클릭

--30. Step1에 gender_submission.csv 파일을 업로드


