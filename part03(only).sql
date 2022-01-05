--56. 출력되는 행 제한하기 (ROWNUM)

SELECT ROWNUM, empno, ename, job, sal  
    FROM emp
    WHERE ROWNUM <= 5; 


--57. 출력되는 행 제한하기 2 (Simple TOP-n Queries)
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC FETCH FIRST 4 ROWS ONLY;

SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal desc
  FETCH FIRST 20 PERCENT ROWS ONLY;
  
--WITH TIES
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC FETCH FIRST 2 ROWS WITH TIES;
    
--OFFSET
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC OFFSET 9 ROWS;
    
--OFFSET과 FETCH
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC OFFSET 9 ROWS
    FETCH FIRST 2 ROWS ONLY;


--58. 여러 테이블의 데이터를 조인해서 출력하기 1 (EQUI JOIN)

SELECT ename, loc
    FROM emp, dept
    WHERE emp.deptno = dept.deptno;

SELECT ename, loc
    FROM emp, dept;
    
SELECT ename, loc, job
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';
    
SELECT ename loc, job, deptno
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job='ANALYST'; --ERROR!

SELECT ename, loc, job, emp.deptno
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

SELECT emp.ename, dept.loc, emp.job
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job='ANALYST';
    
SELECT e.ename, d.loc, e.job
    FROM emp e, dept d
    WHERE e.deptno = d.deptno and e.job='ANALYST';

SELECT emp.ename, d.loc, e.job
    FROM emp e, dept d
    WHERE e.deptno = d.deptno and e.job='ANALYST'; --Error!


--59. 여러 테이블의 데이터를 조인해서 출력하기 2 (NON EQUI JOIN)
SELECT e.ename, e.sal, s.grade
    FROM emp e, salgrade s
    WHERE e.sal between s.losal and s.hisal;

SELECT * FROM salgrade;

SELECT e.ename, e.sal, s.grade
    FROM emp e, salgrade s
    WHERE e.sal between s.losal and s.hisal; 


--60. 여러 테이블의 데이터를 조인해서 출력하기 3 (OUTER JOIN)

SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno (+) = d.deptno;


--61. 여러 테이블의 데이터를 조인해서 출력하기 4 (SELF JOIN)
SELECT e.ename as 사원, e.job as 직업, m.ename as 관리자, m.job as 직업
    FROM emp e, emp m
    WHERE e.mgr = m.empno and e.job='SALESMAN';
    

--62. 여러 테이블의 데이터를 조인해서 출력하기 5 (ON절)
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e JOIN dept d
    ON (e.deptno = d.deptno)
    WHERE e.job = 'SALESMAN';
    
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno; --오라클 EQUI JOIN
    
SELECT e.ename, d.loc
    FROM emp e JOIN dept d
    ON (e.deptno = d.deptno); --ON절을 사용한 조인
    
--여러 개의 테이블 조인: (조인 조건의 개수 = 테이블 개수 - 1)
SELECT e.ename, d.loc, s.grade
    FROM emp e, dept d, salgrade s
    WHERE e.deptno = d.deptno
    AND e.sal between s.losal and s.hisal; --오라클 EQUI JOIN
    
SELECT e.ename, d.loc, s.grade
    FROM emp e
    JOIN dept d ON (e.deptno = d.deptno)
    JOIN salgrade s ON (e.sal between s.losal AND s.hisal); --ON절을 사용한 조인


--63. 여러 테이블의 데이터를 조인해서 출력하기 5 (USING 절)
SELECT e.ename as 이름, e. job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e join dept d
    USING (deptno)
    WHERE e.job = 'SALESMAN'; 

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e join dept d
    USING (e.deptno)
    WHERE e.job = 'SALESMAN'; --Error!
    
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno; --오라클 EQUI JOIN

SELECT e.ename, d.loc
    FROM emp e JOIN dept d
    USING (deptno); --USING절을 사용한 조인
    )
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e join dept d
    USING deptno
    WHERE e.job='SALESMAN'; -- Error!
    
--여러 개의 테이블 조인
SELECT e.ename, d.loc
    FROM emp e, dept d, salgrade s
    WHERE e.deptno = d.deptno
    AND e.sal between s.losal and s.hisal; --오라클 EQUI JOIN
    
SELECT e.ename, d.loc, s.grade
    FROM emp e
    JOIN dept d USING (deptno)
    JOIN salgrade s ON (e.sal between s.losal and s.hisal); -- USING 절을 사용한 조인
    

--64. 여러 테이블의 데이터를 조인해서 출력하기 6 (NATURAL JOIN) 
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e natural join dept d
    WHERE e.job = 'SALESMAN';  

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e natural join dept d
    WHERE e.job='SALESMAN' and e.deptno = 30; -- ERROR!
    
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e natural join dept d
    WHERE e.job='SALESMAN' and deptno = 30; 


--65. 여러 테이블의 데이터를 조인해서 출력하기 7 (LEFT/RIGHT OUTER JOIN)

--RIGHT OUTER JOIN
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e RIGHT OUTER JOIN dept d
    ON (e.deptno = d.deptno);

SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno (+) = d.deptno; --오라클 OUTER JOIN
    
SELECT e.ename, d.loc
    FROM emp e RIGHT OUTER JOIN dept d
    ON (e.deptno = d.deptno); --ANSI RIGHT OUTER JOIN
    
--LEFT OUTER JOIN
INSERT INTO emp(empno, ename, sal, job, deptno)
        VALUES(8282, 'JACK', 3000, 'ANALYST', 50); --부서번호 50 삽입
        
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e LEFT OUTER JOIN dept d
    ON (e.deptno = d.deptno);
    
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno (+); --오라클 OUTER JOIN
    
SELECT e.ename, d.loc
    FROM emp e LEFT OUTER JOIN dept d
    ON (e.deptno = d.deptno); --ANSI LEFT OUTER JOIN


--66. 여러 테이블의 데이터를 조인해서 출력하기 8 (FULL OUTER JOIN)
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e FULL OUTER JOIN dept d
    ON (e.deptno = d.deptno);
        
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno (+) = d.deptno(+); -- ERROR!
    
--FULL OUTER JOIN을 사용하지 않고 동일한 결과 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e LEFT OUTER JOIN dept d
    ON (e.deptno = d.deptno)
  UNION
  SELECT e.ename, e.job, e.sal, d.loc
    FROM emp e RIGHT OUTER JOIN dept d
    ON (e.deptno = d.deptno);


--67. 집합 연산자로 데이터를 위아래로 연결하기 1 (UNION ALL)
delete  from  emp
 where ename='JACK';
commit;

SELECT deptno, sum(sal)
    FROM emp
    GROUP BY deptno
UNION ALL
SELECT TO_NUMBER(null) as deptno, sum(sal)
    FROM emp; --DEPTNO(숫자) - TO_NUMBER(NULL)(숫자)
    
--UNION ALL
SELECT COL1 FROM A
    UNION ALL
SELECT COL1 FROM B;


--68. 집합 연산자로 데이터를 위아래로 연결하기 2 (UNION) 
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY deptno
UNION
SELECT null as deptno, sum(sal)
    FROM emp;

SELECT COL1 FROM C
    UNION
SELECT COL1 FROM D; --중복 데이터 제거 + 결과 내림차순 정렬


--69. 집합 연산자로 데이터의 교집합을 출력하기 (INTERSECT)
SELECT ename, sal, job, deptno
    FROM emp
    WHERE deptno in (10,20)
INTERSECT
SELECT ename, sal, job, deptno
    FROM emp
    WHERE deptno in (20, 30);

SELECT COL1 FROM E
    INTERSECT
SELECT COL1 FROM F; --중복된 데이터 제거 + 결과 내림차순 정렬


--70. 집합 연산자로 데이터의 차이를 출력하기(MINUS)
SELECT ename, sal, job, deptno
    FROM emp
    WHERE deptno in (10,20)
MINUS
SELECT ename, sal, job, deptno
    FROM emp
    WHERE deptno in (20,30);

SELECT COL1 FROM G
    MINUS
SELECT COL1 FROM H; --결과 내림차순 정렬 출력

--71. 서브 쿼리 사용하기 1 (단일행 서브쿼리)
SELECT ename, sal
    FROM emp
    WHERE sal > (SELECT sal
                    FROM EMP
                    WHERE ename='JONES');

SELECT sal
    FROM emp
    WHERE ename = 'JONES'; --JONES의 월급 검색 (서브쿼리)

SELECT ename, sal
    FROM emp
    WHERE sal > 2975; --그것보다 월급이 높은 사원
    
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
    AND ename != 'SCOTT'; 

--72. 서브 쿼리 사용하기 2 (다중 행 서브쿼리)
SELECT ename, sal
    FROM emp
    WHERE sal in (SELECT sal
                    FROM emp
                    WHERE job='SALESMAN');
        
SELECT ename, sal
    FROM emp
    WHERE sal = (SELECT sal
                    FROM emp
                    WHERE job='SALESMAN'); --ERROR!


--73. 서브 쿼리 사용하기 3 (NOT IN)
SELECT ename, sal, job
    FROM emp
    WHERE empno not in (SELECT mgr
                          FROM emp
                          WHERE mgr is not null);

SELECT ename, sal, job
    FROM emp
    WHERE empno not in (7839, 7698, 7902, 7566, 7788, 7782);

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
    

--74. 서브 쿼리 사용하기 4 (EXISTS와 NOT EXISTS)
SELECT *
    FROM dept d
    WHERE EXISTS (SELECT *
                    FROM emp e
                    WHERE e.deptno = d.deptno); 

--NOT EXIST
SELECT *
    FROM dept d
    WHERE NOT EXISTS (SELECT *
                            FROM emp e
                            WHERE e.deptno = d.deptno);



--75. 서브 쿼리 사용하기 5 (HAVING절의 서브 쿼리)
SELECT job, sum(sal)
    FROM emp
    GROUP BY job
    HAVING sum(sal) > (SELECT sum(sal)
                        FROM emp
                        WHERE job='SALESMAN');
                        
--GROUP BY: HAVING절 사용
SELECT job, sum(sal)
    FROM emp
    WHERE sum(sal) > (SELECT sum(sal)
                        FROM emp
                        WHERE job='SALESMAN')
    GROUP BY job; --ERROR!
    

--76. 서브 쿼리 사용하기 6 (FROM절의 서브 쿼리)
SELECT v.ename, v.sal, v.순위
    FROM(SELECT ename, sal, rank() over (order by sal desc) 순위
            FROM emp) v
    WHERE v.순위 = 1;
--FROM 절의 서브 쿼리: in line view

SELECT ename, sal, rank() over (order by sal desc) 순위
    FROM emp
    WHERE rank() over (order by sal desc) = 1; --ERROR!


--77. 서브 쿼리 사용하기 7 (SELECT절의 서브 쿼리)
SELECT ename, sal, (select max(sal) from emp where job='SALESMAN') as "최대 월급",
                    (select min(sal) from emp where job='SALESMAN') as "최소 월급"
FROM emp
WHERE job = 'SALESMAN';

--SELECT절에 서브 쿼리를 사용하지 않고 출력
SELECT ename, sal, max(sal), min(sal)
        FROM emp
        WHERE job='SALESMAN';
        

--78. 데이터 입력하기(INSERT)
INSERT INTO emp(empno, ename, sal, hiredate, job)
    VALUES(2812, 'JACK', 3500, TO_DATE('2019/06/05', 'RRRR/MM/DD'), 'ANALYST');

--괄호 안 쓸 때
INSERT INTO emp
    VALUES(1234, 'JAMES', 'ANALYST', 7566, TO_DATE('2019/06/22', 'RRRR/MM/DD'),
            3500, NULL, 20);

--테이블에 NULL 값을 입력하는 방법
--1) 암시적으로 입력
INSERT INTO EMP(empno, ename, sal)
    VALUES(2912, 'JANE', 4500); --값: 빈칸
--2) 명시적으로 입력
INSERT INTO EMP(empno, ename, sal, job)
    VALUES(8381, 'JACK', NULL, NULL); --값: NULL

INSERT INTO EMP(empno, ename, sal, job)
    VALUES(8381, 'JACK', '', ''); --값: ''
    

--79. 데이터 수정하기(UPDATE)
UPDATE emp
    SET sal = 3200
    WHERE ename = 'SCOTT';
    
UPDATE emp
    SET sal = 3200; 
    
--UPDATE문으로 여러 개의 열 값 수정
UPDATE emp
    SET sal=5000, comm=200
    WHERE ename = 'SCOTT';
    
--UPDATE문도 서브 쿼리 사용 가능
UPDATE emp
    SET sal = (SELECT sal FROM emp WHERE ename='KING')
    WHERE ename = 'SCOTT'; --SET 절의 서브쿼리


--80. 데이터 삭제하기(DELETE, TRUNCATE, DROP)
DELETE FROM emp
    WHERE ename='SCOTT'; --SCOTT의 행 데이터 삭제
    
--WHERE절을 작성하지 않으면 모든 행이 삭제
DELETE FROM EMP;

TRUNCATE TABLE emp;

DROP TABLE emp;


--81. 데이터 저장 및 취소하기 (COMMIT, ROLLBACK)

INSERT INTO emp(empno, ename, sal, deptno)
    VALUES (1122, 'JACK', 3000, 20);
    
COMMIT;
------------------------ 롤백 시점
UPDATE emp
    SET sal = 4000
    WHERE ename='SCOTT';

ROLLBACK; --COMMIT 이후까지 ROLLBACK됨


--82. 데이터 입력, 수정, 삭제 한번에 하기(MERGE)
ALTER TABLE emp
    ADD loc varchar2(10);

MERGE INTO emp e
USING dept d 
ON (e.deptno = d.deptno)
WHEN MATCHED THEN  -- MERGE UPDATE절
UPDATE set e.loc = d.loc 
WHEN NOT MATCHED THEN   --MERGE INSERT절
INSERT (e.empno, e.deptno, e.loc) VALUES (1111, d.deptno, d.loc);

--MERGE INSERT절을 수행하지 않고 MERGE UPDATE절만 수행하고 싶을 때
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


--84. SELECT FOR UPDATE절 이해하기: 검색하는 행에 락(LOCK)을 거는 SQL문

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


--85. 서브 쿼리를 사용하여 데이터 입력하기
CREATE TABLE emp2
    as
        SELECT *
            FROM emp
            WHERE 1=2; --EMP 테이블의 구조만 가져와 EMP2 테이블 생성

INSERT INTO emp2(empno, ename, sal, deptno)
  SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10;
    

--86. 서브 쿼리를 사용하여 데이터 수정하기
UPDATE emp
  SET sal = (SELECT sal
                FROM emp
                WHERE ename='ALLEN')
WHERE job='SALESMAN';

--SET절에 여러 개의 컬럼들을 기술하여 한 번에 갱신 가능
UPDATE emp
    SET(sal, comm) = (SELECT sal, comm
                        FROM emp
                        WHERE ename='ALLEN')
    WHERE ename='SCOTT';


--87. 서브 쿼리를 사용하여 데이터 삭제하기
DELETE FROM emp
WHERE sal > (SELECT sal
               FROM emp
               WHERE ename='SCOTT');              

DELETE FROM emp m
WHERE sal > (SELECT avg(sal)
                FROM emp s
                WHERE s.deptno = m.deptno);


--88. 서브 쿼리를 사용하여 데이터 합치기
ALTER TABLE dept
    ADD sumsal number(10); --SUMSAL 컬럼 추가

MERGE INTO dept d
USING (SELECT deptno, sum(sal) sumsal
        FROM emp
        GROUP BY deptno) v
ON (d.deptno = v.deptno)
WHEN MATCHED THEN
UPDATE set d.sumsal = v.sumsal;

--MERGE문으로 수행하지 않고 서브 쿼리를 사용한 UPDATE문으로 수행
UPDATE dept d
    SET sumsal = (SELECT SUM(SAL)
                    FROM emp e
                    WHERE e.deptno = d.deptno);


--89. 계층형 질의문으로 서열을 주고 데이터 출력하기 1
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
    FROM emp
    START WITH ename = 'KING'
    CONNECT BY prior empno = mgr;


--90. 계층형 질의문으로 서열을 주고 데이터 출력하기 2
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
    FROM emp
    START WITH ename='KING'
    CONNECT BY prior empno = mgr AND ename != 'BLAKE'; 


--91. 계층형 질의문으로 서열을 주고 데이터 출력하기 3

SELECT rpad(' ', level*3) || ename as employee, level, sal, job
    FROM emp
    START WITH ename='KING'
    CONNECT BY prior empno = mgr
    ORDER SIBLINGS BY sal desc;
--서열 순서를 유지하면서 월급이 높은 사원부터 출력: SIBLINGS

--SIBLINGS를 사용하지 않았을 때
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
    FROM emp
    START WITH ename='KING'
    CONNECT BY prior empno = mgr
    ORDER BY sal desc;


--92. 계층형 질의문으로 서열을 주고 데이터 출력하기 4
SELECT ename, SYS_CONNECT_BY_PATH(ename, '/') as path
    FROM emp
    START WITH ename='KING'
    CONNECT BY prior empno = mgr;
--계층형 질의문 + SYS_CONNECT_BY 함수 이용 서열 순서 가로로 출력    

--LTRIM 사용하여 맨 처음의 '/' 제거
SELECT ename, LTRIM(SYS_CONNECT_BY_PATH(ename, '/'), '/') as path
    FROM emp
    START WITH ename='KING'
    CONNECT BY prior empno = mgr;


--93. 일반 테이블 생성하기 (CREATE TABLE)
CREATE TABLE EMP01
(EMPNO  NUMBER(10),
 ENAME  VARCHAR2(10),
 SAL    NUMBER(10,2),
 HIREDATE   DATE);


--94. 임시 테이블 생성하기 (CREATE TEMPORARY TABLE)
CREATE GLOBAL TEMPORARY TABLE EMP37
(   EMPNO   NUMBER(10),
    ENAME   VARCHAR2(10),
    SAL     NUMBER(10))
    ON COMMIT DELETE ROWS;

INSERT INTO emp37 VALUES(1111, 'scott', 3000);
INSERT INTO emp37 VALUES(2222, 'smith', 4000);

SELECT * FROM emp37;
COMMIT;

SELECT * FROM emp37; --결과X

--ON COMMIT PRESERVE ROWS: 세션(SESSION)을 로그아웃하면 데이터 사라짐
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
CREATE VIEW EMP_VIEW
AS
SELECT empno, ename, sal, job, deptno
    FROM emp
    WHERE job = 'SALESMAN';
    
--CREATE VIEW 뷰 이름 AS (VIEW를 통해 보여줘야 할 쿼리)

SELECT * FROM emp_view;

--VIEW를 변경 -> 실제 테이블 변경됨
UPDATE EMP_VIEW SET sal=0 WHERE ename='MARTIN';

SELECT * FROM emp where job = 'SALESMAN';


--96. 복잡한 쿼리를 단순하게 하기 2 (VIEW)
CREATE VIEW EMP_VIEW2
AS
SELECT deptno, round(avg(sal)) "평균 월급"
    FROM emp
    GROUP BY deptno;
--뷰 쿼리문에 그룹 함수 사용 / 뷰 생성시 함수나 그룹 함수 작성할 때는 반드시 컬럼 별칭 사용

SELECT * FROM emp_view2;

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
ON절 다음에 인덱스를 생성하고자 하는 테이블과 컬럼명을 '테이블명(컬렴명)'으로 작성
*/


--98. 절대로 중복되지 않는 번호 만들기(SEQUENE)
--숫자 1번부터 100번까지 출력하는 시퀀스
CREATE SEQUENCE SEQ1
START WITH 1 --첫 시작 숫자
INCREMENT BY 1 --숫자의 증가치
MAXVALUE 100 --시퀀스에서 출력될 최대 숫자
NOCYCLE; --최대 숫자까지 숫자가 출력된 이후 다시 처음 1번부터 번호를 생성할지 여부

--시퀀스이름.NEXTVAL: 시퀀스의 다음 번호 출력 또는 확인

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
SELECT *
    FROM EMP
    AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE)
    WHERE ENAME = 'KING'; --사원 테이블의 5분 전 KING 데이터를 검색
    
/*
AS OF TIMESTAMP: 과거 시점
SYSTIMESTAMP: 현재 시간
*/ 

--오늘 현재 시간 확인
SELECT SYSTIMESTAMP
    FROM dual;
    
--오늘 현재 시간에서 5분 전의 시간 확인
SELECT SYSTIMESTAMP - INTERVAL '5' MINUTE
    FROM dual;    
    

--KING의 데이터를 변경하고 과거 시점의 데이터 확인
--1) KING의 월급 조회
SELECT ename, sal
    FROM emp
    WHERE ename='KING';
    
--2) KING의 월급을 0으로 변경
UPDATE EMP
    SET SAL = 0
    WHERE ENAME='KING';
    
--3) COMMIT 수행
COMMIT;

--4) 5분 전의 KING의 데이터 확인
SELECT ename, sal
    FROM emp
    AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE)
    WHERE ENAME='KING';

--구체적으로 시간을 적어서 조회도 가능.. 인데 에러남 ㅎㅎㅎㅎㅎ
SELECT ename, sal
    FROM emp
    AS OF TIMESTAMP '21/01/05 11:19:12' --ORA-00932: 일관성 없는 데이터 유형: TIMESTAMP이(가) 필요하지만 CHAR임
    WHERE ename='KING';
    
--테이블을 플래쉬백할 수 있는 타임 확인
SELECT name, value
    FROM V$PARAMETER
    WHERE name='undo_retention'; --value: 900(900초라는 뜻)
    
    
--100. 실수로 지운 데이터 복구하기 2 (FLASHBACK TABLE)
ALTER TABLE emp ENABLE ROW MOVEMENT; --사원 테이블을 5분 전으로 돌림

SELECT row_movement
    FROM user_tables
    WHERE table_name = 'EMP'; --플래쉬백 가능한 상태인지 확인(ENABLED)
    
FLASHBACK TABLE emp TO TIMESTAMP(SYSTIMESTAMP - INTERVAL '5' MINUTE);

/*
사원(EMP) 테이블을 플래쉬백 하려면 먼저 플래쉬백이 가능한 상태로 변경해야 함 (ALTER 명령어)

사원 테이블을 현재시점(SYSTIMESTAMP)에서 5분 전으로 플래쉬백(FLASHBACK) 함
(작업을 반대로 수행하면서 되돌림)
플래쉬백 성공 -> 데이터 확인 후 COMMIT
*/

--EMP 테이블만 특정 시점으로 되돌라가
FLASHBACK TABLE emp TO TIMESTAMP
TO_TIMESTAMP('22/06/30 13:03:15', 'RR/MM/DD HH24:MI:SS');
/*
TO_TIMESTAMP: 이 함수를 통해 날짜, 시, 분, 초를 지정하면 해당 시간으로 EMP 테이블을 되돌림
(모든 작업 반대로 수행)*/


--101. 실수로 지운 데이터 복구하기 3 (FLASHBACK DROP)
DROP TABLE emp;

SELECT ORIGINAL_NAME, DROPTIME
    FROM USER_RECYCLEBIN; -- 테이블 DROP 후 휴지통에 존재하는지 확인

FLASHBACK TABLE emp TO BEFORE DROP; --휴지통에서 복원

--휴지통에서 복구할 대 테이블명을 다른 이름으로 변경
FLASHBACK TABLE emp TO BEFORE DROP RENAME TO emp2;


--102. 실수로 지운 데이터 복구하기 4 (FLASHBACK VERSION QUERY)
--과거 이력 정보 출력
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

TRANSACTION QUERY의 결과를 보기 위해서는 데이터베이스 모드를 아카이브 모드로 변경
-> SQL PLUS에서 작업
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


--104. 데이터의 품질 높이기 1 (PRIMARY KEY)
--DEPTNO 컬럼에 PRIMARY KEY 제약을 걸면서 테이블을 생성
CREATE TABLE DEPT2
(DEPTNO     NUMBER(10) CONSTRAINT DPET2_DEPNO_PK PRIMARY KEY,
 DNAME      VARCHAR2(14),
 LOC        VARCHAR2(10));
 
 /*
PRIMARY KEY 제약이 걸린 컬럼에는 중복된 데이터와 NULL 값을 입력할 수 없다(고유한 행)
CONSTRAINT 키워드 + 제약 이름(테이블명_컬럼명_제약종류축약) + 제약의 종류(PRIMARY KEY)
 */
 
--테이블에 생성된 제약을 확인
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
    ADD CONSTRAINT DEPT4_DNAME_UN UNIQUE(DNAME); --ADD 명령어로 UNIQUE 제약 추가


--106. 데이터의 품질 높이기 3 (NOT NULL)
CREATE TABLE DEPT5
(DEPTNO NUMBER(10),
 DNAME  VARCHAR2(14),
 LOC    VARCHAR2(10) CONSTRAINT DEPT5_LOC_NN NOT NULL);
 
/*
NOT NULL: 테이블의 특정 컬럼에 NULL 값 입력을 허용하지 않도록 함
기존 테이블 데이터 중에 NULL 값이 존재하지 않아야만 제약 생성 가능
*/

--테이블 생성 후 제약 생성
CREATE TABLE DEPT6
( DEPTNO  NUMBER(10),
  DNAME   VARCHAR2(13),
  LOC   VARCHAR2(10) );

ALTER TABLE DEPT6
  MODIFY LOC CONSTRAINT DEPT6_LOC_NN NOT NULL;  --NOT NULL 제약은 MODIFY로 생성
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
 */
 
ALTER TABLE DEPT7
DROP CONSTRAINT DEPT7_DEPTNO_PK; --ERROR!

--CASCADE 옵션을 붙여야 삭제 가능
ALTER TABLE DEPT7
DROP CONSTRAINT DEPT7_DEPTNO_PK cascade; --EMP7 테이블의 FOREIGN KEY 제약도 같이 삭제


--109. WITH절 사용하기 1 (WITH ~ AS)
WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) as 토탈
                            FROM EMP
                            GROUP BY JOB)
SELECT JOB, 토탈
    FROM JOB_SUMSAL
    WHERE 토탈 > (SELECT AVG(토탈)
                        FROM JOB_SUMSAL);
--WITH절을 이용하여 직업과 직업별 토탈 월급을 출력 + 직업별 토탈 월급들의 평균값보다 더 큰값만 출력                        
--직업과 직업별 토탈 월급을 출력하는 SQL이 두번 반복되는 것을 WITH절로 수행

/*
WITH절: 검색 시간이 오래 걸리는 SQL이 하나의 SQL 내에서 반복되어 사용될 때 성능을 높이기 위해 사용
WITH절에서 사용한 TEMP 테이블은 WITH절 내에서만 사용 가능

WITH절의 수행 원리
필요 데이터를 임시 저장 영역(Temporary Tablespace)에 테이블명을 임의의 이름으로 명명지어 저장,
필요할때마다 꺼내 씀
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

--SUBQUERY FACTORING: WITH절의 쿼리의 결과를 임시 테이블로 생성하는 것
--이 방법은 FROM절의 서브 쿼리로는 불가능

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


