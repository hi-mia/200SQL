--71. 서브 쿼리 사용하기 1 (단일행 서브쿼리)
--JONES보다 더 많은 월급을 받는 사원들의 이름과 월급
SELECT ename, sal
    FROM emp
    WHERE sal > (SELECT sal
                    FROM EMP
                    WHERE ename='JONES');

--JONES의 월급 검색 (서브쿼리)
SELECT sal
    FROM emp
    WHERE ename = 'JONES';

--그것보다 월급이 높은 사원
SELECT ename, sal
    FROM emp
    WHERE sal > 2975;
    
--SCOTT과 같은 월급을 받는 사원들의 이름과 월급 출력
SELECT ename, sal
    FROM emp
    WHERE sal = (SELECT sal
                    FROM emp
                    WHERE ename = 'SCOTT'); --SCOTT도 같이 출력된다

--SCOTT 출력X
SELECT ename, sal
    FROM emp
    WHERE sal = (SELECT sal
                    FROM emp
                    WHERE ename='SCOTT')
    AND ename != 'SCOTT'; --이부분은 메인쿼리 / 서브쿼리는 괄호안이 서브쿼리


--72. 서브 쿼리 사용하기 2 (다중 행 서브쿼리)
--직업이 SALESMAN인 사원들과 같은 월급을 받는 사원들의 이름과 월급 출력
SELECT ename, sal
    FROM emp
    WHERE sal in (SELECT sal
                    FROM emp
                    WHERE job='SALESMAN');
        
--직업이 SALESMAN인 사원들이 여러 명이기 때문에 이퀄(=)을 사용하면 에러 발생 -> IN 연산자 사용
SELECT ename, sal
    FROM emp
    WHERE sal = (SELECT sal
                    FROM emp
                    WHERE job='SALESMAN'); --ERROR!

/*
다중 행 서브 쿼리: 서브 쿼리에서 메인 쿼리로 여러 개의 값이 반환되는 것

1) 단일 행 서브 쿼리: 서브 쿼리에서 메인 쿼리로 하나의 값이 반환 됨
2) 다중 행 서브 쿼리: 서브 쿼리에서 메인 쿼리로 여러 개의 값이 반환 됨
3) 다중 컬럼 서브 쿼리: 서브 쿼리에서 메인 쿼리로 여러 개의 컬럼 값이 반환 됨

*연산자
단일 행 서브 쿼리: =, !=, >, <, >=, <=
다중 행 서브 쿼리: In, not in, >any, <any, >all, <all

In: 리스트의 값과 동일하다
NOT in: 리스트의 값과 동일하지 않다
>all: 리스트에서 가장 큰 값보다 크다
>any: 리스트에서 가장 작은 값보다 크다
<all: 리스트에서 가장 작은 값보다 작다
<any: 리스트에서 가장 큰 값보다 작다
*/
                    

--73. 서브 쿼리 사용하기 3 (NOT IN)
--관리자가 아닌 사원들(EMPNO가 MGR이 아닌 사원)의 이름과 월급과 직업을 출력
SELECT ename, sal, job
    FROM emp
    WHERE empno not in (SELECT mgr
                          FROM emp
                          WHERE mgr is not null);

--NOT IN 연산자를 사용하여 관리자 번호가 아닌 사원들을 검색
SELECT ename, sal, job
    FROM emp
    WHERE empno not in (7839, 7698, 7902, 7566, 7788, 7782);

--NOT IN을 사용하면 서브 쿼리에서 메인 쿼리로 NULL값이 하나라도 리턴되면 결과가 출력되지 않음
--서브 쿼리문 where절에 mgr is not null을 사용하지 않았을 경우
SELECT ename, sal, job
    FROM emp
    WHERE empno not in (SELECT mgr
                        FROM emp); --결과X (mgr 컬럼에 NULL 값이 있기 때문)
        
--NOT IN으로 작성한 서브 쿼리문의 의미
SELECT ename, sal, job
    FROM emp
    WHERE empno != 7839 AND empno != 7698 AND empno != 7902
    AND empno != 7566 AND empno != 7566 AND empno != 7788
    AND empno != 7782 AND empno != NULL; --결과: NULL
    
/*
TRUE AND TRUE AND TRUE AND TRUE AND TRUE AND TRUE AND TRUE AND NULL
-> 결과: NULL
따라서 NOT IN에서 결과를 얻으려면 NULL 리턴(X)
*/


--74. 서브 쿼리 사용하기 4 (EXISTS와 NOT EXISTS)
--부서 테이블에 있는 부서 번호 중에서 사원 테이블에도 존재하는 부서 번호의 부서 번호, 부서명, 부서 위치 출력
SELECT *
    FROM dept d
    WHERE EXISTS (SELECT *
                    FROM emp e
                    WHERE e.deptno = d.deptno); 
--DEPT 테이블에 존재하는 부서 번호가 EMP 테이블에도 존재하는지 검색                    
--WHERE 절 바로 다음에 EXISTS문을 작성, 따로 컬럼명 기술X

/*
EXISTS/NOT EXISTS: 테이블 A에 존재하는 데이터가 테이블 B에 존재하는지 여부를 확인
존재 여부만을 확인하기 때문에 데이터가 아무리 많아도 처음부터 스캔하다 부서 번호가 존재하기만 하면
스캔을 멈춘다(indexOf와 비슷)
*/  

--DEPT 테이블에는 존재하는 부서 번호인데 EMP 테이블에 존재하지 않는 데이터를 검색할 때: NOT EXIST
SELECT *
    FROM dept d
    WHERE NOT EXISTS (SELECT *
                            FROM emp e
                            WHERE e.deptno = d.deptno);



--75. 서브 쿼리 사용하기 5 (HAVING절의 서브 쿼리)
--직업과 직업별 토탈 월급을 출력하는데, 직업이 SALESMAN인 사원들의 토탈 월급보다 더 큰 값들만 출력
SELECT job, sum(sal)
    FROM emp
    GROUP BY job
    HAVING sum(sal) > (SELECT sum(sal)
                        FROM emp
                        WHERE job='SALESMAN');
                        
--GROUP BY: HAVING절 사용(WHERE절은 ERROR)
SELECT job, sum(sal)
    FROM emp
    WHERE sum(sal) > (SELECT sum(sal)
                        FROM emp
                        WHERE job='SALESMAN')
    GROUP BY job; --ERROR!
    
/*
SELECT문의 6가지 절
SELECT / FROM / WHERE / GROUP BY / HAVING / ORDER BY
GROUP BY 제외하고 전부 서브쿼리 사용 가능
*/


--76. 서브 쿼리 사용하기 6 (FROM절의 서브 쿼리)
--이름과 월급과 순위를 출력하는데 순위가 1위인 사원만 출력
SELECT v.ename, v.sal, v.순위
    FROM(SELECT ename, sal, rank() over (order by sal desc) 순위
            FROM emp) v
    WHERE v.순위 = 1;
    
--FROM 절의 서브 쿼리: in line view
--서브 쿼리: 이름과 월급, 월급이 높은 순서로 순위를 출력하는 쿼리 / 별칭 v
-- FROM절에 서브 쿼리문 사용, 서브 쿼리 먼저 실행 -> 출력 결과 데이터를 하나의 집합으로 만듦

--WHERE 절에는 분석 함수를 사용할 수 없다 -> FROM절에 서브 쿼리문 사용
SELECT ename, sal, rank() over (order by sal desc) 순위
    FROM emp
    WHERE rank() over (order by sal desc) = 1; --ERROR!


--77. 서브 쿼리 사용하기 7 (SELECT절의 서브 쿼리)
--SALESMAN인 사원들의 이름과 월급을 출력 + 직업이 SALESMAN인 사원들의 최대 월급과 최소 월급도 출력
SELECT ename, sal, (select max(sal) from emp where job='SALESMAN') as "최대 월급",
                    (select min(sal) from emp where job='SALESMAN') as "최소 월급"
FROM emp
WHERE job = 'SALESMAN';

--SELECT절에 서브 쿼리를 사용하지 않고 출력할 때
SELECT ename, sal, max(sal), min(sal)
        FROM emp
        WHERE job='SALESMAN';
        
--SELECT 절의 서브 쿼리: 스칼라(scalar) 서브쿼리(서브 쿼리가 SELECT절로 확장 됨)
/*스칼라 서브쿼리는 출력되는 행 수만큼 반복되어 실행됨 (직업 SALESMAN 4명 -> 스칼라 서브쿼리도 각각 4번 수행)

같은 SQL이 반복되어 4번이나 실행되면서 같은 데이터를 반복해서 출력하므로
성능을 위해 첫 번째 행인 MARTIN 행을 출력할 대 직업이 SALESMAN인 사원의 최대 월급과 최소 월급을
메모리에 올려놓고 두 번째 행인 ALLEN부터는 메모리에 올려놓은 데이터를 출력: 서브 쿼리 캐싱(CACHING)
*/


--78. 데이터 입력하기(INSERT)
INSERT INTO emp(empno, ename, sal, hiredate, job)
    VALUES(2812, 'JACK', 3500, TO_DATE('2019/06/05', 'RRRR/MM/DD'), 'ANALYST');
--괄호 다음에 데이터를 컬럼명 순서대로 기술

--괄호 안 쓰면 전체 컬럼에 모두 데이터를 입력해야 함
INSERT INTO emp
    VALUES(1234, 'JAMES', 'ANALYST', 7566, TO_DATE('2019/06/22', 'RRRR/MM/DD'),
            3500, NULL, 20);

--숫자는 그대로 기술하면 되지만, 문자와 날짜는 양쪽에 싱글 쿼테이션 마크 / 날짜입력: TO_DATE

--테이블에 NULL 값을 입력하는 방법
--1) 암시적으로 입력: 특정 컬럼에만 데이터를 입력하면 나머지 컬럼에는 자동으로 NULL 입력
INSERT INTO EMP(empno, ename, sal)
    VALUES(2912, 'JANE', 4500); --값: 빈칸
--2) 명시적으로 입력: 입력하고 싶은 칸에 직접 NULL or ''을 INSERT
INSERT INTO EMP(empno, ename, sal, job)
    VALUES(8381, 'JACK', NULL, NULL); --값: NULL

INSERT INTO EMP(empno, ename, sal, job)
    VALUES(8381, 'JACK', '', ''); --값: ''
    
/*
DML문: 테이블에 데이터를 입력하고 수정하고 삭제하는 SQL문
INSERT / UPDATE / DELETE / MERGE(데이터 입력, 수정, 삭제를 한 번에 수행)
*/


--79. 데이터 수정하기(UPDATE)
UPDATE emp
    SET sal = 3200
    WHERE ename = 'SCOTT'; -- SCOTT의 월급 수정
    
UPDATE emp
    SET sal = 3200; -- WHERE절이 없으면 EMP 테이블의 모든 월급이 3200으로 갱신
    
--UPDATE문으로 여러 개의 열 값 수정 가능: SET절에 변경할 컬럼을 콤마(,)로 구분 작성
UPDATE emp
    SET sal=5000, comm=200
    WHERE ename = 'SCOTT';
    
--UPDATE문도 서브 쿼리 사용 가능: UPDATE, SET, WHERE 모든 절 서브 쿼리 가능
UPDATE emp
    SET sal = (SELECT sal FROM emp WHERE ename='KING')
    WHERE ename = 'SCOTT'; --SET 절의 서브쿼리


--80. 데이터 삭제하기(DELETE, TRUNCATE, DROP)
DELETE FROM emp
    WHERE ename='SCOTT'; --SCOTT의 행 데이터 삭제
    
--WHERE절을 작성하지 않으면 모든 행이 삭제된다
DELETE FROM EMP;

TRUNCATE TABLE emp;

DROP TABLE emp;

/*
데이터를 삭제하는 명령어 3가지
1)DELETE - DML
2)TRUNCATE: 모든 데이터를 한 번에 삭제, 삭제 후 취소 불가능 / DELETE보다 삭제 속도 빠름
데이터를 모두 지우고 테이블 구조만 남겨두는 것 - DDL
3)DROP: 테이블 전체를 한 번에 삭제하는 명령어 / 삭제 후 취소(ROLLBACK) 불가
플래쉬백(FLASHBACK)으로 테이블 복구 가능 - DDL

DDL은 수행되면서 암시적인 COMMIT이 발생한다
CREATE / ALTER / DROP / TRUNCATE / RENAME(객체 이름 변경)
*/


--81. 데이터 저장 및 취소하기 (COMMIT, ROLLBACK)
--사원 테이블에 입력한 데이터가 데이터베이스에 저장되도록
INSERT INTO emp(empno, ename, sal, deptno)
    VALUES (1122, 'JACK', 3000, 20);
    
COMMIT;
------------------------ 롤백 시점
UPDATE emp
    SET sal = 4000
    WHERE ename='SCOTT';

ROLLBACK; --COMMIT 이후까지 ROLLBACK됨

/*
COMMIT: COMMIT 이전에 수행했던 DML 작업들을 데이터베이스에 영구히 반영하는 TCL
ROLLBACK: 마지막 COMMIT 명령어를 수행한 이후 DML을 취소하는 TCL

TCL의 종류
1) COMMIT: 모든 변경 사항을 데이터베이스에 반영
2) ROLLBACK: 모든 변경 사항을 취소
3) SAVEPOINT: 특정 지점까지의 변경을 취소
*/


--82. 데이터 입력, 수정, 삭제 한번에 하기(MERGE)
ALTER TABLE emp
    ADD loc varchar2(10);

--사원 테이블에 부서 위치 컬럼을 추가, 부서 테이블을 이용하여 해당 사원의 부서 위치로 값이 갱신
--만약 부서 테이블에는 존재하는 부서인데 사원 테이블에 없는 부서 번호라면 새롭게 사원 테이블에 입력되게 함
MERGE INTO emp e
USING dept d 
ON (e.deptno = d.deptno)
WHEN MATCHED THEN  -- MERGE UPDATE절
UPDATE set e.loc = d.loc 
WHEN NOT MATCHED THEN   --MERGE INSERT절
INSERT (e.empno, e.deptno, e.loc) VALUES (1111, d.deptno, d.loc);

/*
MERGE: 데이터 입력과 수정과 삭제를 한 번에 수행할 수 있게 해주는 명령어

위 예제는 emp 테이블에 부서 위치(loc) 컬럼에 해당 사원의 부서 위치로 값을 갱신해주는 MERGE문
1) MERGE INTO emp e
MERGE INTO 다음에 MERGE 대상이 되는 TARGET 테이블명을 작성
2) USING dept d 
USING절 다음에는 SOURCE 테이블명을 작성함
SOURCE 테이블인 DEPT로부터 데이터를 읽어와 DEPT 테이블의 데이터로 EMP 테이블을 MERGE함
3) ON (e.deptno = d.deptno)
TARGET 테이블과 SOURCE 테이블을 조인하는 구문.
조인에 성공하면 MERGE UPDATE절을 실행하고 실패하면 MERGE INSERT절을 실행
4) WHEN MATCHED THEN UPDATE set e.loc = d.loc
조인에 성공하면 수행되는 절
조인에 성공하면 사원 테이블의 부서 위치 컬럼을 부서 테이블의 부서 위치로 갱신
5) WHEN NOT MATCHED THEN INSERT (e.empno, e.deptno, e.loc) VALUES (1111, d.deptno, d.loc);
조인에 실패하면 수행되는 절
조인에 실패하면 실패한 부서 테이블의 데이터를 사원 테이블에 입력
*/

--MERGE INSERT절을 수행하지 않고 MERGE UPDATE절만 수행하고 싶다면 다음과 같이 수행
MERGE INTO emp e
    USING dept d
    ON (e.deptno = d.deptno)
    WHEN MATCHED THEN
    UPDATE set e.loc = d.loc;
    
--MERGE문을 사용하지 않을 때
UPDATE EMP e
    SET loc = (SELECT loc
                FROM dept d
                WHERE d.deptno = e.deptno);


--83. 락(LOCK) 이해하기: 같은 데이터를 동시에 갱신하는 것을 막음
--SCOTT으로 접속한 터미널 창1
UPDATE emp
SET sal = 3000
WHERE ename='JONES';

COMMIT;

--SCOTT으로 접속한 터미널 창2
UPDATE emp
SET sal = 9000
WHERE ename = 'JONES';

/*
UPDATE문을 수행하면 UPDATE 대상이 되는 행(ROW)을 잠궈버림
UPDATE할 때 락(LOCK)을 거는 이유: 데이터의 일관성을 보장하기 위함

UPDATE는 행 전체를 잠그기 때문에 JONES 월급뿐만 아니라 다른 컬럼들의 데이터도 변경할 수 없고 WAITING하게 됨

터미널 창1에서 COMMIT을 수행하게 되면 JONES의 월급은 3000으로 저장되고 행에 걸렸던 잠금은 해제됨
터미널 창 1에서 행에 걸린 잠금을 해제하였기 때문에 터미널 창 2는 JONES의 월급을 9000으로 수정할 수 있게 됨

락이 걸리지 않았다면 순서 2에서 JONES의 월급이 9000으로 변경되었을 것이고 JONES의 월급을
3000으로 변경한 터미널창 1에서는 그 사실을 모르고 있을 것 -> 일관성 깨짐

터미널 창 1은 자기가 변경한 데이터를 커밋하기 전까지 일관되게 유지해야 함, 락이 없으면 일관성 깨짐
커밋하기 전까지는 자기가 변경한 데이터에 대해 일관성이 보장되어야 함
-> LOCK을 사용하여 UPDATE문을 수행하면 해당 행에 LOCK을 검
*/


--84. SELECT FOR UPDATE절 이해하기: 검색하는 행에 락(LOCK)을 거는 SQL문
--JONES의 이름과 월급과 부서 번호를 조회하는 동안 다른 세션에서 JONES의 데이터를 갱신하지 못하도록 함

--SCOTT으로 접속한 터미널창1
SELECT ename, sal, deptno
    FROM emp
    WHERE ename='JONES'
    FOR UPDATE;

COMMIT;

--SCOTT으로 접속한 터미널창2
UPDATE emp
    SET sal = 9000
    WHERE ename='JONES';

/*
1) 
터미널창 1에서 SELECT FOR UPDATE문으로 JONES의 데이터를 검색함. JONES의 행에 자동으로 락(LOCK) 걸림

2) 터미널창 2에서 JONES의 월급을 9000으로 변경하면 변경이 안 되고 WAITING하게 됨

3) 터미널창 1에서 COMMIT을 수행하면 LOCK이 해제되면서 터미널창 2의 UPDATE문이 수행됨
*/    


--85. 서브 쿼리를 사용하여 데이터 입력하기
--EMP 테이블의 구조를 그대로 복제한 EMP2 테이블에 부서 번호가 10번인 사원들의 정보 입력

CREATE TABLE emp2
    as
        SELECT *
            FROM emp
            WHERE 1=2; --EMP 테이블의 구조만 가져와 EMP2 테이블 생성(구조만 가져옴 -> 데이터X)

INSERT INTO emp2(empno, ename, sal, deptno)
  SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10;
    
/*
VALUES절에 VALUE 대신 입력하고자 하는 서브 쿼리문을 기술
서브 쿼리문의 컬럼 순서는 INSERT절 괄호 안의 컬럼 순서대로 작성

기본 INSERT문은 한 번에 하나의 행만 입력됨
서브 쿼리를 사용하여 INSERT를 수행하면 여러 개의 행을 한 번에 테이블에 입력 가능
*/    


--86. 서브 쿼리를 사용하여 데이터 수정하기
--직업이 SALESMAN인 사원들의 월급을 ALLEN의 월급으로 변경(SET에 서브쿼리)
UPDATE emp
  SET sal = (SELECT sal
                FROM emp
                WHERE ename='ALLEN')
WHERE job='SALESMAN';

--UPDATE문은 모든 절에서 서브 쿼리 사용 가능(UPDATE, SET, WHERE)

--SET절에 여러 개의 컬럼들을 기술하여 한 번에 갱신 가능
UPDATE emp
    SET(sal, comm) = (SELECT sal, comm
                        FROM emp
                        WHERE ename='ALLEN')
    WHERE ename='SCOTT';


--87. 서브 쿼리를 사용하여 데이터 삭제하기
--SCOTT보다 더 많은 월급을 받는 사원들 삭제
DELETE FROM emp
WHERE sal > (SELECT sal
               FROM emp
               WHERE ename='SCOTT');              
--서브쿼리X일 때: SCOTT의 월급 출력 -> SCOTT의 월급 3000을 가지고 다시 DELETE문 수행

--월급이 해당 사원이 속한 부서 번호의 평균 월급보다 크면 삭제하는 DELETE 서브쿼리
DELETE FROM emp m
WHERE sal > (SELECT avg(sal)
                FROM emp s
                WHERE s.deptno = m.deptno);


--88. 서브 쿼리를 사용하여 데이터 합치기
/*
부서 테이블에 숫자형으로 SUMSAL 컬럼 추가
사원 테이블을 이용하여 SUMSAL 컬럼의 데이터를 부서 테이블의 부서 번호별 토탈 월급으로 갱신
*/

ALTER TABLE dept
    ADD sumsal number(10); --SUMSAL 컬럼 추가

MERGE INTO dept d
USING (SELECT deptno, sum(sal) sumsal
        FROM emp
        GROUP BY deptno) v
ON (d.deptno = v.deptno)
WHEN MATCHED THEN
UPDATE set d.sumsal = v.sumsal;
--부서 테이블에 새롭게 추가된 SUMSAL 컬럼에 해당 부서 번호의 토탈 월급으로 값을 갱신하는 MERGE문

/*
1) MERGE INTO dept d USING (SELECT deptno, sum(sal) sumsal FROM emp GROUP BY deptno) v
USING절에서 서브 쿼리를 사용하여 출력하는 데이터로 DEPT 테이블을 MERGE함
서브 쿼리에서 반환하는 데이터는 부서 번호와 부서 번호별 토탈 월급

2) ON (d.deptno = v.deptno)
서브 쿼리에서 반환하는 데이터인 부서 번호와 사원 테이블의 부서 번호로 조인 조건을 줌

3) WHEN MATCHED THEN UPDATE set d.sumsal = v.sumsal;
서브 쿼리에서 반환하는 부서 번호와 사원 테이블의 부서 번호가 서로 일치하는지 확인하여
일치하면 해당 부서 번호의 토탈 월급으로 값을 갱신

결과: 서브 쿼리와 MATCH되는 부서 번호 10번, 20번, 30번은 값이 갱신되고 
40번은 MATCH하지 않으므로 갱신되지 않음
*/

--MERGE문으로 수행하지 않고 서브 쿼리를 사용한 UPDATE문으로 수행
UPDATE dept d
    SET sumsal = (SELECT SUM(SAL)
                    FROM emp e
                    WHERE e.deptno = d.deptno);

--89. 계층형 질의문으로 서열을 주고 데이터 출력하기 1
                    