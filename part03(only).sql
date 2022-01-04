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
                    