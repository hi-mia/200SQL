--93. 일반 테이블 생성하기 (CREATE TABLE)
--사원 번호, 이름, 월급, 입사일을 저장할 수 있는 테이블 생성
CREATE TABLE EMP01
(EMPNO  NUMBER(10),
 ENAME  VARCHAR2(10),
 SAL    NUMBER(10,2),
 HIREDATE   DATE);
 
/*
테이블명 작성 규칙
-반드시 문자로 시작
-이름의 길이는 30자 이하
-대문자 알파벳과 소문자 알파벳과 숫자를 포함할 수 있음
-특수문자는 $, _, #만 포함할 수 있음

-NUMBER: 숫자 데이터 유형, 숫자 자릿수 1~38, 소수점 자리수 -84~127
NUMBER(10,2): 숫자 전체 10자리 허용, 그중 소수점 2자리를 허용
-CHAR: 고정 길이 문자 데이터 유형, 최대 길이 2000
-VARCHAR2: 가변 길이 문자 데이터 유형, 최대 길이 4,000 (알파벳 철자 기준)
-LONG: 가변 길이 문자 데이터 유형, 최대 2GB 문자 데이터 허용
-CLOB: 문자 데이터 유형, 최대 4GB 문자 데이터 허용
-BLOB: 바이너리 데이터 유형, 최대 4GB의 바이너리 데이터 허용
-DATE: 날짜 데이터 유형, B.C 4712/1/1 ~ A.C 9999/12/31
*/


--94. 임시 테이블 생성하기 (CREATE TEMPORARY TABLE)
CREATE GLOBAL TEMPORARY TABLE EMP37
(   EMPNO   NUMBER(10),
    ENAME   VARCHAR2(10),
    SAL     NUMBER(10))
    ON COMMIT DELETE ROWS;
    
--GLOBAL TEMPORARY TABLE: 임시 테이블은 데이터를 영구히 저장하지는 않음
/*
데이터를 보관하는 주기
-ON COMMIT DELETE ROWS: 임시 테이블에 데이터를 입력하고 COMMIT할 때까지만 데이터를 보관(COMMIT하면 데이터 사라짐)
-ON COMMIT PRESERVE ROWS: 임시 테이블에 데이터를 입력하고 세션이 종료될 때까지 데이터를 보관
*/

INSERT INTO emp37 VALUES(1111, 'scott', 3000);
INSERT INTO emp37 VALUES(2222, 'smith', 4000);

SELECT * FROM emp37;

COMMIT;

SELECT * FROM emp37; --결과X

--ON COMMIT PRESERVE ROWS 옵션으로 만든 임시 테이블: 세션(SESSION)을 로그아웃하면 데이터 사라짐
CREATE GLOBAL TEMPORARY TABLE EMP38
 (  EMPNO   NUMBER(10),
    ENAME   VARCHAR2(10),
    SAL     NUMBER(10))
    ON COMMIT PRESERVE ROWS;
    
INSERT INTO emp38 VALUES(1111, 'scott', 3000);
INSERT INTO emp38 VALUES(2222, 'smith', 4000);

SELECT * FROM emp38;

COMMIT;

SELECT * FROM emp38;

/*
exit
sqlplus scott/tiger
*/


--95. 복잡한 쿼리를 단순하게 하기 1 (VIEW)
--직업이 SALESMAN인 사원들의 사원 번호, 이름, 월급, 직업, 부서 번호를 출력하는 VIEW
CREATE VIEW EMP_VIEW
AS
SELECT empno, ename, sal, job, deptno
    FROM emp
    WHERE job = 'SALESMAN';
    
--CREATE VIEW 뷰 이름 AS (VIEW를 통해 보여줘야 할 쿼리)

SELECT * FROM emp_view;
--EMP 테이블의 모든 컬럼을 보는게 아니라 일부 컬럼만 볼 수 있음 -> 보안상 공개하면 안되는 데이터 있을 때 유용

--VIEW를 변경 -> 실제 테이블 변경됨
UPDATE EMP_VIEW SET sal=0 WHERE ename='MARTIN';

SELECT * FROM emp where job = 'SALESMAN';

/*
EMP_VIEW 데이터를 수정 -> EMP 테이블의 데이터 변경됨
VIEW: 데이터를 가지고 있지 않고 단순히 테이블을 바로 보는 객체
VIEW를 쿼리하면 뷰를 만들 때 작성했던 쿼리문이 수행되면서 실제 EMP 테이블을 쿼리함

UPDATE문도 마찬가지로 EMP_VIEW를 갱신하면 실제 테이블인 EMP의 데이터가 갱신됨
*/


--96. 복잡한 쿼리를 단순하게 하기 2 (VIEW)
CREATE VIEW EMP_VIEW2
AS
SELECT deptno, round(avg(sal)) "평균 월급"
    FROM emp
    GROUP BY deptno;
--뷰 쿼리문에 그룹 함수 사용 / 뷰 생성시 함수나 그룹 함수 작성할 때는 반드시 컬럼 별칭 사용

/*
복합 뷰: 뷰에 함수나 그룹 함수가 포함되어 있음
            테이블 개수      함수 포함 여부     데이터 수정 여부
-단순 VIEW:    1개             포함 안함           수정 가능
-복합 VIEW    2개 이상            포함        수정 불가능할 수 있음

그룹함수를 쿼리하는 복합 뷰는 수정 되지 않음
데이터는 수정되지 않지만 복잡한 쿼리를 단순화시킬 수 있다는 장점이 있음
*/

SELECT * FROM emp_view2;

--30번 부서 번호의 평균 월급 1567 -> 3000 변경 (에러남)
UPDATE emp_view2
    SET "평균 월급" = 3000
    WHERE deptno = 30; -- ERROR!
    
SELECT e.ename, e.sal, e.deptno, v.평균월급
    FROM emp e, (SELECT deptno, round(avg(sal)) 평균월급
                    FROM emp
                    GROUP BY deptno) v
    WHERE e.deptno = v.deptno and e.sal > v.평균월급;
    
--복합 뷰를 이용한 단순화
SELECT e.ename, e.sal, e.deptno, v."평균 월급"
    FROM emp e, emp_view2 v
    WHERE e.deptno = v.deptno and e.sal > v."평균 월급";


--97. 데이터 검색 속도를 높이기(INDEX)
CREATE INDEX EMP_SAL
    ON EMP(SAL);
    
/*
인덱스(INDEX): 테이블에서 데이터를 검색할 때 검색 속도를 높이기 위해 사용하는 데이터 베이스 객체(OBJECT)

인덱스 이름 지정 방법은 테이블 이름과 컬럼 이름의 규칙과 동일
ON절 다음에 인덱스를 생성하고자 하는 테이블과 컬럼명을 '테이블명(컬렴명)'으로 작성

인덱스가 없을 때: 테이블 전체를 FULL로 스캔
인덱스가 있을 때: 인덱스를 통해 테이블 엑세스, 검색할 데이터만 바로 스캔 / 테이블 FULL SCAN(X)

인덱스: 컬럼값과 ROWID로 구성
ROWID: 데이터가 있는 행(ROW)의 물리적 주소
컬럼값: 내림차순 정렬됨

인덱스를 통해서 테이블을 엑세스하는 방법
1) 인덱스가 월급을 내림차순으로 정렬하고 있으므로 바로 월급 1600을 찾음
2) 인덱스의 ROWID로 테이블의 해당 ROWID 찾아 이름과 월급을 조회함
*/


--98. 절대로 중복되지 않는 번호 만들기(SEQUENE)
--숫자 1번부터 100번까지 출력하는 시퀀스
CREATE SEQUENCE SEQ1
START WITH 1 --첫 시작 숫자
INCREMENT BY 1 --숫자의 증가치
MAXVALUE 100 --시퀀스에서 출력될 최대 숫자
NOCYCLE; --최대 숫자까지 숫자가 출력된 이후 다시 처음 1번부터 번호를 생성할지 여부

/*
시퀀스: 일련 번호 생성기
번호를 순서대로 생성하는 데이터베이스 오브젝트
테이블에 번호를 입력할 때 중복되지 않게 번호를 입력해야 하는 경우 사용

시퀀스이름.NEXTVAL: 시퀀스의 다음 번호 출력 또는 확인
*/

--시퀀스 없이 사원 테이블에 중복X번호 넣기: 최대숫자 검색 -> 그보다 높은 값 삽입
SELECT max(empno)
    FROM emp;
    
INSERT INTO EMP(empno, ename, sal, job, deptno)
    VALUES(7935, 'JACK', 3400, 'ANALYST', 20);

--시퀀스 사용하여 사원 테이블에 데이터를 입력
CREATE TABLE emp02
(EMPNO  NUMBER(10),
 ENAME  VARCHAR2(10),
 SAL    NUMBER(10));
 
INSERT INTO emp02 VALUES(SEQ1.NEXTVAL, 'JACK', 3500);
INSERT INTO emp02 VALUES(SEQ1.NEXTVAL, 'JAMES', 4500);

SELECT * FROM emp02;


--99. 실수로 지운 데이터 복구하기 1 (FLASHBACK QUERY)
--사원 테이블의 5분 전 KING 데이터를 검색
SELECT *
    FROM EMP
    AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE)
    WHERE ENAME = 'KING';
    
/*
AS OF TIMESTAMP: 과거 시점
SYSTIMESTAMP: 현재 시간

SYSTIMESTAMP - INTERVAL '5' MINUTE : 현재 시간에서 5분을 뺀 시간
*/ 

--오늘 현재 시간 확인
SELECT SYSTIMESTAMP
    FROM dual;
    
--오늘 현재 시간에서 5분 전의 시간 확인
SELECT SYSTIMESTAMP - INTERVAL '5' MINUTE
    FROM dual;    
    
/*
KING의 데이터를 변경하고 과거 시점의 데이터 확인
1) KING의 월급 조회
2) KING의 월급을 0으로 변경
3) COMMIT 수행
4) 5분 전의 KING의 데이터 확인
*/

--1)
SELECT ename, sal
    FROM emp
    WHERE ename='KING';
    
--2)
UPDATE EMP
    SET SAL = 0
    WHERE ENAME='KING';
    
--3)
COMMIT;

--4)
SELECT ename, sal
    FROM emp
    AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE)
    WHERE ENAME='KING';

--구체적으로 시간을 적어서 조회도 가능.. 인데 에러남 ㅎㅎㅎㅎㅎ
SELECT ename, sal
    FROM emp
    AS OF TIMESTAMP '21/01/05 11:19:12' --ORA-00932: 일관성 없는 데이터 유형: TIMESTAMP이(가) 필요하지만 CHAR임
    WHERE ename='KING';
    
--테이블을 플래쉬백할 수 있는 골든 타임: 15분 (데이터 파라미터인 UNDO_RETENTION으로 확인 가능)
SELECT name, value
    FROM V$PARAMETER
    WHERE name='undo_retention'; --value: 900(900초라는 뜻)
    
    
--100. 실수로 지운 데이터 복구하기 2 (FLASHBACK TABLE)
--사원 테이블을 5분 전으로 돌림
ALTER TABLE emp ENABLE ROW MOVEMENT;

SELECT row_movement
    FROM user_tables
    WHERE table_name = 'EMP'; --플래쉬백 가능한 상태인지 확인(ENABLED)
    
FLASHBACK TABLE emp TO TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE);

/*
사원(EMP) 테이블을 플래쉬백 하려면 먼저 플래쉬백이 가능한 상태로 변경해야 함
ALTER 명령어로 사원 테이블을 플래쉬백 가능한 상태로 설정함

사원 테이블을 현재시점(SYSTIMESTAMP)에서 5분 전으로 플래쉬백(FLASHBACK) 함
5분 전부터 현재까지 수행했던 DML 작업을 반대로 수행하면서 과거로 되돌림 / 백업을 가지고 복구(X)
ex) DELETE -> INSERT / INSERT -> DELETE
성공적으로 플래쉬백 -> 데이터 확인 후 COMMIT해야 함
*/

--EMP 테이블만 특정 시점으로 되돌릴 수 있음
FLASHBACK TABLE emp TO TIMESTAMP
TO_TIMESTAMP('22/06/30 13:03:15', 'RR/MM/DD HH24:MI:SS');
/*
TO_TIMESTAMP: 이 함수를 통해 날짜, 시, 분, 초를 지정하면 해당 시간으로 EMP 테이블을 되돌림
(모든 작업 반대로 수행)
지정된 과거 시점부터 현재 시점 사이에 DDL이나 DCL문 수행했으면 FLASHBACK 명령어가 수행되지 않고 에러 발생
*/


--101. 실수로 지운 데이터 복구하기 3 (FLASHBACK DROP)
--DROP하여 휴지통에 있다면 휴지통에서 다시 복구
DROP TABLE emp;

SELECT ORIGINAL_NAME, DROPTIME
    FROM USER_RECYCLEBIN; -- 테이블 DROP 후 휴지통에 존재하는지 확인

FLASHBACK TABLE emp TO BEFORE DROP; --휴지통에서 복원

--휴지통에서 복구할 대 테이블명을 다른 이름으로 변경
FLASHBACK TABLE emp TO BEFORE DROP RENAME TO emp2;


--102. 실수로 지운 데이터 복구하기 4 (FLASHBACK VERSION QUERY)
--사원 테이블의 데이터가 과거 특정 시점부터 지금까지 어떻게 변경되어 왔는지 이력 정보 출력
SELECT ename, sal, versions_starttime, versions_endtime, versions_operation
    FROM emp
    VERSIONS BETWEEN TIMESTAMP
        TO_TIMESTAMP('2022-01-04 13:10:00', 'RRRR-MM-DD HH24:MI:SS')
        AND MAXVALUE
    WHERE ename = 'KING'
    ORDER BY versions_starttime;
    
/*
VERSIONS절: 변경 이력 정보를 보고 싶은 기간을 정함
TO_TIMESTAMP 변환 함수를 사용하여 시:분:초까지 상세히 시간 설정 가능

ORDER BY versions_starttime : 이력 정보를 기록하기 시작한 순서대로 정렬해서 출력
*/    

--현재시간 확인
SELECT SYSTIMESTAMP FROM dual;

--변경 전 KING 데이터 확인
SELECT ename, sal, deptno
    FROM emp
    WHERE ename='KING';
    
--KING의 월급을 8000으로 변경하고 COMMIT
UPDATE emp
    SET sal = 8000
    WHERE ename = 'KING';
    
COMMIT;

--KING의 부서번호를 20번으로 변경
UPDATE emp
    SET deptno = 20
    WHERE ename = 'KING';

COMMIT;

--KING의 데이터 변경 이력 정보를 확인
SELECT ename, sal, deptno, versions_starttime, versions_endtime, versions_operation
FROM emp
VERSIONS BETWEEN TIMESTAMP
        TO_TIMESTAMP('2022/01/05 13:50:44', 'RRRR-MM-DD HH24:MI:SS')
        AND MAXVALUE
    WHERE ename = 'KING'
    ORDER BY versions_starttime;
    
--VERSIONS_OPERATION의 U: UPDATE
--VERSIONS절을 사용하면 KING의 월급과 부서 번호가 언제 어떻게 변경되었는지 확인 가능

--변경 이력 확인 후 emp 테이블을 10분 전으로 되돌리고 COMMIT
FLASHBACK TABLE emp TO TIMESTAMP(SYSTIMESTAMP - INTERVAL '10' MINUTE);
COMMIT;


--103. 실수로 지운 데이터 복구하기 5 (FLASHBACK TRANSACTION QUERY)
--사원 테이블의 데이터를 5분 전으로 되돌리기 위한 DML문 출력
SELECT undo_sql
    FROM flashback_transaction_query
    WHERE table_owner = 'SCOTT' AND table_name = 'EMP'
    AND commit_scn between 9457390 AND 9457397
    ORDER BY start_timestamp desc; --UNDO(취소)할 수 있는 SQL 조회
    
/*
SCN: System Change Number / commit할 때 생성되는 번호
특정 시간대의 SCN 번호로 범위를 지정

ORDER BY start_timestamp desc: 최근 UNDO(취소) 정보가 먼저 출력되게 정렬

TRANSACTION QUERY의 결과를 보기 위해서는 데이터베이스 모드를 아카이브 모드로 변경해야 함
아카이브 모드로 변경 = 장애가 발생했을 때 DB를 복구할 수 있는 로그 정보를 자동으로 저장하게 하는 모드
아카이브 모드로 변경하기 위해서는 DB를 한번 내렸다 올려야 함 -> SQL PLUS에서 작업
*/

/*
SQL PLUS 작업
C:\Users\oracl\sqlplus "/as sysdba"

-DB정상 종료
SHUTDOWN IMMEDIATE;

-데이터 베이스를 마운트 상태로 올림
STARTUP MOUNT

-아카이브 모드로 데이터 베이스를 변경
ALTER DATABASE ARCHIVELOG;

-DML문이 redo log file에 저장될 수 있도록 설정
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

-SCOTT 유저로 접속
connect scott/tiger
*/

--변경 전 KING의 데이터 확인
SELECT ename, sal, deptno
    FROM emp
    WHERE ename = 'KING';
    
UPDATE emp
    SET sal = 8000
    WHERE ename = 'KING';

UPDATE emp
    SET deptno=20
    WHERE ename='KING';

COMMIT;

--KING의 데이터 변경 이력 정보를 확인
SELECT versions_startscn, versions_endscn, versions_operation, sal, deptno
    FROM emp
    VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE
    WHERE ename='KING';
    
SELECT undo_sql
    FROM flashback_transaction_query
    WHERE table_owner = 'SCOTT' AND table_name = 'EMP'
    AND commit_scn between 9454013 AND 9454017
    ORDER BY start_timestamp desc;
    
--ROWID: 해당 로우의 물리적인 주소
--결과 값인 UNDO_SQL의 UPDATE문으로 다시 원래 데이터로 되돌리기 가능


--104. 데이터의 품질 높이기 1 (PRIMARY KEY)
--DEPTNO 컬럼에 PRIMARY KEY 제약을 걸면서 테이블을 생성하는 예제
CREATE TABLE DEPT2
(DEPTNO     NUMBER(10) CONSTRAINT DPET2_DEPNO_PK PRIMARY KEY,
 DNAME      VARCHAR2(14),
 LOC        VARCHAR2(10));
 
 /*
PRIMARY KEY 제약이 걸린 컬럼에는 중복된 데이터와 NULL 값을 입력할 수 없다(고유한 행)
특정 컬럼 중에는 중복된 데이터가 입력되거나 NULL 값이 입력되면 안 되는 컬럼들이 있음
 
CONSTRAINT 키워드 + 제약 이름(테이블명_컬럼명_제약종류축약) + 제약의 종류(PRIMARY KEY)

제약을 생성하는 시점: 1)테이블이 생성되는 시점 / 2)테이블 생성 후
 */
 
--테이블에 생성된 제약을 확인하는 방법
SELECT a.CONSTRAINT_NAME, a.CONSTRAINT_TYPE, b.COLUMN_NAME
    FROM USER_CONSTRAINTS a, USER_CONS_COLUMNS b
    WHERE a.TABLE_NAME = 'DEPT2'
    AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME;
    
--테이블 생성 후 제약을 생성
CREATE TABLE DEPT2
(DEPTNO NUMBER(10),
 DNAME  VARCHAR2(13),
 LOC    VARCHAR2(10)); --제약 없이 테이블 생성
 
ALTER TABLE DEPT2 --ALTER 명령어로 DPET2 테이블 수정
    ADD CONSTRAINT DEPT2_DEPTNO_PK PRIMARY KEY(DEPTNO);  --ADD 명령어로 제약 추가
--PRIMARY KEY 다음에는 괄호를 열고 어느 컬럼에 PRIMARY KEY 제약 생성할 지 명시


--105. 데이터의 품질 높이기 2 (UNIQUE)
CREATE TABLE DEPT3
(DEPTNO NUMBER(10),
 DNAME  VARCHAR2(14) CONSTRAINT DEPT3_DNAME_UN UNIQUE,
 LOC    VARCHAR2(10)); --테이블 생성 시 제약 생성
 
/*
UNIQUE 제약: 테이블의 특정 컬럼에 중복된 데이터가 입력되지 않게 제약을 검 / NULL값 입력 가능

CONSTRAINT + 제약 이름(테이블명_컬럼명_제약 종류) + UNIQUE
*/

--테이블에 생성된 제약 확인
SELECT a.CONSTRAINT_NAME, a.CONSTRAINT_TYPE, b.COLUMN_NAME
    FROM USER_CONSTRAINTS a, USER_CONS_COLUMNS b
    WHERE a.TABLE_NAME = 'DEPT3'
    AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME;
    
--테이블 생성 후 제약 생성
CREATE TABLE DEPT4
(DEPTNO NUMBER(10),
 DNAME  VARCHAR2(13),
 LOC    VARCHAR2(10)); --테이블 생성 시 제약X
 
ALTER TABLE DEPT4
    ADD CONSTRAINT DEPT4_DNAME_UN UNIQUE(DNAME);
--ADD 명령어로 UNIQUE 제약 추가, UNIQUE(제약 생성할 컬럼)


--106. 데이터의 품질 높이기 3 (NOT NULL)
CREATE TABLE DEPT5
(DEPTNO NUMBER(10),
 DNAME  VARCHAR2(14),
 LOC    VARCHAR2(10) CONSTRAINT DEPT5_LOC_NN NOT NULL);
 
/*
NOT NULL: 테이블의 특정 컬럼에 NULL 값 입력을 허용하지 않도록 함

NOT NULL 제약 생성 시점은 1)테이블이 생성되는 시점 2) 테이블 생성된 이후 가능
기존 테이블 데이터 중에 NULL 값이 존재하지 않아야만 제약 생성 가능
*/

--테이블 생성 후 제약 생성
CREATE TABLE DEPT6
( DEPTNO  NUMBER(10),
  DNAME   VARCHAR2(13),
  LOC   VARCHAR2(10) );

ALTER TABLE DEPT6
  MODIFY LOC CONSTRAINT DEPT6_LOC_NN NOT NULL;
    
--NOT NULL 제약은 MODIFY로 생성(ADD(X)) / NOT NULL 다음에는 괄호 열고 컬럼명 명시X
--기존 데이터 중 NULL 값이 포함되어 있다면 ALTER 컬럼에 NOT NULL 제약 생성 불가


--107. 데이터의 품질 높이기 4 (CHECK)
--월급이 0~6000 사이의 데이터만 입력되거나 수정될 수 있도록 제약 + 사원테이블 생성
CREATE TABLE EMP6
( EMPNO NUMBER(10),
  ENAME VARCHAR2(20),
  SAL   NUMBER(10) CONSTRAINT EMP6_SAL_CK
  CHECK ( SAL BETWEEN 0 AND 6000)   ); --월급이 0~6000 사이의 데이터만 허용하도록 CHECK 제약 생성

/*
CHECK 제약: 특정 컬럼에 특정 조건의 데이터만 입력되거나 수정되도록 제한을 거는 제약
ex) 성별 컬럼: 남자 or 여자만 입력

CHECK + (제한하고 싶은 데이터에 대한 조건)
*/

INSERT  INTO emp6 VALUES (7839, 'KING', 5000);
INSERT  INTO emp6 VALUES (7698, 'BLAKE', 2850);
INSERT  INTO emp6 VALUES (7782, 'CLARK', 2450);
INSERT  INTO emp6 VALUES (7839, 'JONES', 2975);
COMMIT;

--범위 밖의 수치로 UPDATE/INSERT -> ERROR
UPDATE emp6
    SET sal = 9000
    WHERE ename = 'CLARK'; --ERROR!
    
INSERT  INTO emp6 VALUES (7566, 'ADAMS', 9000); --ERROR!

--월급을 6000 이상으로 수정하거나 입력하려면 체크 제약 삭제
ALTER TABLE emp6
    DROP CONSTRAINT emp6_sal_ck; --제약 삭제: ALTER TABLE + 삭제하고 싶은 제약 이름 지정
    
INSERT  INTO emp6 VALUES (7566, 'ADAMS', 9000); --입력 가능    


--108. 데이터의 품질 높이기 5 (FOREIGN KEY)
--사원 테이블의 부서 번호에 데이터를 입력할 대 부서 테이블에 존재하는 부서 번호만 입력될 수 있도록 제약
CREATE TABLE DEPT7
(DEPTNO NUMBER(10) CONSTRAINT DEPT7_DEPTNO_PK PRIMARY KEY,
 DNAME  VARCHAR2(14),
 LOC    VARCHAR2(10));
 
CREATE TABLE EMP7
(EMPNO  NUMBER(10),
 ENAME  VARCHAR2(20),
 SAL    NUMBER(10),
 DEPTNO NUMBER(10)
 CONSTRAINT EMP7_DEPTNO_FK REFERENCES DEPT7(DEPTNO));
 
 /*
 FOREIGN KEY: 특정 컬럼에 데이터를 입력할 때 다른 테이블의 데이터를 참조해서 해당하는 데이터만을 허용
 FOREIGN KEY = 자식키

여기서는 DEPTNO에 자식키 걸음
자식키를 생성할 때 DEPT7 테이블에 DEPTNO를 참조하겠다고 기술함
-> DEPT7 테이블은 부모 테이블 / EMP7 테이블은 자식 테이블

EMP7 테이블의 DEPTNO가 DEPT7 테이블의 DEPTNO를 참조 중
-> EMP7 테이블의 DEPTNO에 데이터를 입력/수정할 때 DEPT7 테이블의 DEPTNO에 존재하는 부서번호에
대해서만 입력 또는 수정이 가능

서로 제약이 걸린 상황에서 DEPT7 테이블의 PRIMARY KEY를 삭제하려면 삭제되지 않음
-> 자식 테이블인 EMP7 테이블이 부모 테이블인 DEPT7 테이블을 참조하고 있기 때문
 */
 
ALTER TABLE DEPT7
DROP CONSTRAINT DEPT7_DEPTNO_PK; --ERROR!

--CASCADE 옵션을 붙여야 삭제 가능
ALTER TABLE DEPT7
DROP CONSTRAINT DEPT7_DEPTNO_PK cascade; --이때 EMP7 테이블의 FOREIGN KEY 제약도 같이 삭제됨


--109. WITH절 사용하기 1 (WITH ~ AS)
--WITH절을 이용하여 직업과 직업별 토탈 월급을 출력 + 직업별 토탈 월급들의 평균값보다 더 큰값만 출력
WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) as 토탈
                            FROM EMP
                            GROUP BY JOB)
SELECT JOB, 토탈
    FROM JOB_SUMSAL
    WHERE 토탈 > (SELECT AVG(토탈)
                        FROM JOB_SUMSAL);

/*
WITH절: 검색 시간이 오래 걸리는 SQL이 하나의 SQL 내에서 반복되어 사용될 때 성능을 높이기 위해 사용
WITH절에서 사용한 TEMP 테이블은 WITH절 내에서만 사용 가능

위 예제는 직업과 직업별 토탈 월급을 출력하는 SQL이 두번 반복되는 것을 WITH절로 수행

WITH절의 수행 원리
1) 직업과 직업별 토탈 월급을 출력하여 임시 저장 영역(Temporary Tablespace)에 테이블명을
JOB_SUMSAL로 명명지어 저장
2) 임시 저장 영역에 저장된 테이블인 JOB_SUMSAL을 불러와서 직업별 토탈 월급들의 평균값보다
더 큰 직업별 토탈 월급들을 출력
임시 저장 영역에서 저장된 데이터를 출력하는데 많은 시간이 걸렸다면 WITH절은 이 시간 절반으로 줄여줌
*/
                        
                        
--위의 WITH절을 서브 쿼리문으로 수행
SELECT JOB, SUM(SAL) as 토탈
    FROM EMP
    GROUP BY JOB
    HAVING SUM(SAL) > (SELECT AVG(SUM(SAL))
                            FROM EMP
                            GROUP BY JOB);


--110. WITH절 사용하기 2 (SUBQUERY FACTORING)
--직업별 토탈 값의 평균값에 3000을 더한 값보다 더 큰 부서 번호별 토탈 월급들을 출력
WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) 토탈
                            FROM EMP
                            GROUP BY JOB) ,
    DEPTNO_SUMSAL AS (SELECT DEPTNO, SUM(SAL) 토탈
                            FROM EMP
                            GROUP BY DEPTNO
                            HAVING SUM(SAL) > (SELECT AVG(토탈) + 3000
                                                FROM JOB_SUMSAL)
                    )
    SELECT DEPTNO, 토탈
        FROM DEPTNO_SUMSAL;

--WITH절을 사용하면 특정 서브 쿼리문의 컬럼을 다른 서브 쿼리문에서 참조하는 것이 가능
--SUBQUERY FACTORING: WITH절의 쿼리의 결과를 임시 테이블로 생성하는 것

/*
1) 직업과 직업별 토탈 월급을 출력하여 JOB_SUMSAL이라는 이름으로 임시 저장 영역에 저장함
2) 부서 번호와 부서 번호별 토탈 월급을 출력하는데 JOB_SUMSAL의 토탈 값의 평균값에
    3000을 더한 값보다 더 큰 토탈 월급을 출력함 / 여기서 JOB_SUMSAL 임시 테이블을 참조

이 방법은 FROM절의 서브 쿼리로는 불가능 하다!
FROM 절의 서브쿼리로는 불가능하지만 WITH절을 이용하면 임시 저장 영역에 임시테이블을 생성하므로 참조 가능
*/

SELECT DEPTNO, SUM(SAL)
FROM (SELECT JOB, SUM(SAL) 토탈
                    FROM EMP
                    GROUP BY JOB) as JOB_SUMSAL,
        (SELECT DEPTNO, SUM(SAL) 토탈
                    FROM EMP
                    GROUP BY DEPTNO
                    HAVING SUM(SAL) > (SELECT AVG(토탈) + 3000
                                            FROM JOB_SUMSAL)
                            ) DEPTNO_SUMSAL; -- ERROR!


