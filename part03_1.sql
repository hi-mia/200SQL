--56. 출력되는 행 제한하기 (ROWNUM)

SELECT ROWNUM, empno, ename, job, sal  
    FROM emp
    WHERE ROWNUM <= 5; --사원번호, 이름, 직업, 월급의 상단 5개의 행만 출력
    
--ROWNUM: PSEUDO COLUMN / '가짜의' / 별포(*)로 검색해서는 출력되지 않는 감춰진 컬럼
--ROWNUM + WHERE: 전체 테이블 다 안 읽고 데이터 상단 행만 잠깐 살펴볼 때 사용


--57. 출력되는 행 제한하기 2 (Simple TOP-n Queries)
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC FETCH FIRST 4 ROWS ONLY; --월급이 높은 순으로 사원 번호, 이름, 직업, 월급을 4개의 행으로 제한 출력

/*
TOP-N Query: 정렬된 결과로부터 위쪽 또는 아래쪽의 N개의 행을 반환하는 쿼리
FETCH FIRST N ROWS ONLY 사용하면 간단 / 서브쿼라 사용X
*/   

--월급이 높은 사원들 중 20%에 해당하는 사원들만 출력하는 쿼리
SELECT empno, ename, job, sal
  FROM emp
  ORDER BY sal desc
  FETCH FIRST 20 PERCENT ROWS ONLY;
  
--WITH TIES: 여러 행이 N번째 행의 값과 동일하다면 같이 출력해줌
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC FETCH FIRST 2 ROWS WITH TIES;
    
--OFFSET: 출력이 시작되는 행의 위치를 지정
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC OFFSET 9 ROWS; --월급이 (9+1)번째로 높은 사원부터 끝까지 결과 출력
    
--OFFSET과 FETCH를 서로 조합하여 사용 가능
SELECT empno, ename, job, sal
    FROM emp
    ORDER BY sal DESC OFFSET 9 ROWS
    FETCH FIRST 2 ROWS ONLY; --OFFSET 9로 출력된 5개의 행 중에서 2개의 행만 출력


--58. 여러 테이블의 데이터를 조인해서 출력하기 1 (EQUI JOIN)

--EQUI JOIN: 조인 조건이 이퀄(=)

--사원(EMP) 테이블과 부소(DEPT) 테이블을 조인하여 이름과 부서 위치 출력
SELECT ename, loc
    FROM emp, dept
    WHERE emp.deptno = dept.deptno;
    
/*
JOIN: 서로 다른 테이블에 있는 컬럼들을 하나의 결과로 출력

from 절에는 emp와 dep 둘 다 기술,
emp 테이블의 부서 번호는 dept 테이블의 부서 번호와 같다라는 조건인
emp.deptno = dept.deptno를 주어 조인 수행
*/   

SELECT ename, loc
    FROM emp, dept; -- 조인조건 안 주고 조인하면 전부 다 조인되어 56(14x4)의 행이 출력됨
    
SELECT ename, loc, job
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';
    
SELECT ename loc, job, deptno
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job='ANALYST'; --ERROR!
--deptno는 emp 테이블에도 존재하고 dept 테이블에도 존재하는 컬럼이기 때문에 어느 테이블에 있는 컬럼을 출력할지 몰라 에러

--열 이름 앞에 테이블명을 접두어로 붙여준다
SELECT ename, loc, job, emp.deptno
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

--검색속도 향상을 위해 가급적 열 이름 앞에 테이블명을 붙여서 작성 권장
SELECT emp.ename, dept.loc, emp.job
    FROM emp, dept
    WHERE emp.deptno = dept.deptno and emp.job='ANALYST';
    
--테이블명 뒤에 테이블 별칭을 사용하여 조인코드 더 간결
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
--사원(EMP) 테이블과 급여 등급(SALGRADE)테이블 조인 + 이름, 월급, 금여 등급 출력
--sagrade: 급여 등급 / grade: 등급 / losal: 등급을 나누는 월급 범위의 하단 / hisal: 월급 범위의 상단

SELECT * FROM salgrade;

/*
emp와 salgrade 테이블 조인해서 이름(ename)과 급여등급(grade)를 하나의 결과로 출력
-> 그런데 emp와 salgrade 사이에 동일한 컬럼이 없음(equi join 불가)
-> 조인 조건에 equal 조건을 줄 수 없을 때 사용하는 조인이 non equi join
-> 두 테이블 사이에 동일한 컬럼은 없지만 비슷한 컬럼이 있음: sal(emp) vs losal, hisal(salgrade)
**emp 테이블의 월급은 salgrade 테이블의 losal과 hisal 사이에 있음**
*/

SELECT e.ename, e.sal, s.grade
    FROM emp e, salgrade s
    WHERE e.sal between s.losal and s.hisal; --NTILE 함수보다 등급 범위 더 자유롭게 지정


--60. 여러 테이블의 데이터를 조인해서 출력하기 3 (OUTER JOIN)

--사원 테이블과 부서 테이블 조인 + 이름과 부서 위치 출력
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno (+) = d.deptno; --EQUI JOIN과는 다르게 BOSTON 출력
    
/*
'BOSTON에는 사원이 배치되지 않았다' 정보 확인: OUTER JOIN
OUTER JOIN: 기존 EQUI JOIN 문법에 OUTER 조인 사인(+)만 추가한 것

OUTER JOIN 사인 (+)는 EMP와 DEPT 테이블 중 결과가 덜 나오는 쪽에 붙여 줌
여기서는 EMP 테이블의 ENAME 데이터가 DEPT 테이블의 LOC 데이터보다 모자라게 출력됨 -> EMP에 (+)
*/    


--61. 여러 테이블의 데이터를 조인해서 출력하기 4 (SELF JOIN)
--사원(EMP) 테이블 자기 자신의 테이블과 조인 + 이름, 직업, 해당 사원의 관리자 이름과 관리자 직업 출력
SELECT e.ename as 사원, e.job as 직업, m.ename as 관리자, m.job as 직업
    FROM emp e, emp m
    WHERE e.mgr = m.empno and e.job='SALESMAN';
    
--MGR: 해당 사원의 직속 상사의 사원 번호(직속 상사 = 관리자) 
/*
조인할 때 사원번호(empno)와 관리자 번호(mgr)가 필요함
FROM절에 사원 테이블 2개 기술, 하나는 별칭e, 다른 하나는 별칭m
(emp 테이블에 사원과 관리자 섞여서 구성됨)
사원 테이블 emp와 관리자 테이블 emp의 연결고리로는 e.mgr = m.empno가 사용됨
*/


--62. 여러 테이블의 데이터를 조인해서 출력하기 5 (ON절)

/*
JOIN 작성법: 1)오라클 조인  2)ANSI/ISO SQL:1999 standards 조인
1) 오라클 조인: EQUI JOIN / NON EQUI JOIN / OUTER JOIN / SELF JOIN
2) ANSI: ON절을 사용한 JOIN / LEFT/RIGHT/FULL OUTER JOIN / USING절을 이용한 JOIN /
        NATURAL JOIN / CROSS JOIN
*/

SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e JOIN dept d
    ON (e.deptno = d.deptno)
    WHERE e.job = 'SALESMAN'; --EQUI JOIN에서 WHERE절에 작성했던 조인조건을 ON에 작성함

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
    WHERE e.job = 'SALESMAN'; --WHERE절 대신 USING절을 사용하여 조인
    
--USING절에는 조인조건 대신 두 테이블을 연결할 때 사용할 칼럼인 DEPTNO만 기술하면 됨

--DEPTNO 앞에는 테이블명이나 테이블 별칭을 사용할 수 없음(오류 발생)
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
    
--USING절에는 반드시 괄호를 사용해야 한다(안그러면 에러)
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
/*
조인 조건을 명시적으로 작성하지 않아도 FROM 절에 EMP와 DEPT 사이에 NATURAL JOIN하겠다고
기술하면 조인이 되는 쿼리
두 테이블에 둘 다 존재하는 동일한 컬럼을 기반으로 암시적인 조인을 수행
둘 다 존재하는 동일한 컬럼인 DEPTNO를 오라클이 알아서 찾아서 조인
*/    

--WHERE 절에 조건을 기술할 때 조인의 연결고리가 되는 컬럼인 DEPTNO는 테이블명을 테이블 별칭없이 기술해야 함
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e natural join dept d
    WHERE e.job='SALESMAN' and e.deptno = 30; -- ERROR!
    
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e natural join dept d
    WHERE e.job='SALESMAN' and deptno = 30; --별칭 없어야 에러X


--65. 여러 테이블의 데이터를 조인해서 출력하기 7 (LEFT/RIGHT OUTER JOIN)
--RIGHT OUTER JOIN: EMP와 DEPT를 조인할 때 오른쪽의 DEPT 테이블의 데이터는 전부 출력
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e RIGHT OUTER JOIN dept d
    ON (e.deptno = d.deptno);

SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno (+) = d.deptno; --오라클 OUTER JOIN
    
SELECT e.ename, d.loc
    FROM emp e RIGHT OUTER JOIN dept d
    ON (e.deptno = d.deptno); --ANSI RIGHT OUTER JOIN
    
--LEFT OUTER JOIN: 왼쪽의 EMP 테이블은 전부 출력
INSERT INTO emp(empno, ename, sal, job, deptno)
        VALUES(8282, 'JACK', 3000, 'ANALYST', 50); --부서번호 50 삽입
        
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e LEFT OUTER JOIN dept d
    ON (e.deptno = d.deptno); --DEPT테이블에 70번 존재하지 않아 NULL / EMP는 모두 출력
    
SELECT e.ename, d.loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno (+); --오라클 OUTER JOIN
    
SELECT e.ename, d.loc
    FROM emp e LEFT OUTER JOIN dept d
    ON (e.deptno = d.deptno); --ANSI LEFT OUTER JOIN


--66. 여러 테이블의 데이터를 조인해서 출력하기 8 (FULL OUTER JOIN)
SELECT e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as "부서 위치"
    FROM emp e FULL OUTER JOIN dept d
    ON (e.deptno = d.deptno); -- RIGHT OUTER JOIN + LEFT OUTER JOIN 한번에 수행
        
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

--부서 번호와 부서 번호별 토탈 월급을 출력, 맨 아래쪽 행에 토탈 월급 출력
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY deptno
UNION ALL
SELECT TO_NUMBER(null) as deptno, sum(sal)
    FROM emp; --DEPTNO(숫자) - TO_NUMBER(NULL)(숫자)
    
/*
UNION ALL: 위쪽 쿼리와 아래쪽 쿼리의 결과를 하나의 결과로 출력하는 집합 연산자
위아래 쿼리의 결과를 그대로 출력하여 위아래를 붙여서 출력
동일한 데이터가 있어도 중복을 제거하지 않고 그대로 출력(중복 제거X)

집합 연산자 작성 시 주의사항
1) UNION ALL 위쪽 쿼리와 아래쪽 쿼리 컬럼의 개수가 동일해야 함
2) UNION ALL 위쪽 쿼리와 아래쪽 쿼리 컬럼의 데이터 타입이 동일해야 함
3) 결과로 출력되는 컬럼명은 위쪽 쿼리의 커럼명으로 출력됨
4) ORDER BY절은 제일 아래쪽 쿼리에만 작성할 수 있음
*/    

--테이블 생성
DROP TABLE A;
DROP TABLE B;

CREATE TABLE A (COL1 NUMBER(10) );
INSERT INTO A VALUES(1);
INSERT INTO A VALUES(2);
INSERT INTO A VALUES(3);
INSERT INTO A VALUES(4);
INSERT INTO A VALUES(5);
commit;

CREATE TABLE B (COL1 NUMBER(10) );
INSERT INTO A VALUES(3);
INSERT INTO A VALUES(4);
INSERT INTO A VALUES(5);
INSERT INTO A VALUES(6);
INSERT INTO A VALUES(7);
commit;

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
    FROM emp; --부서 번호와 부서번호별 토탈 월급 출력 + 맨 아래행에 토탈 월급 출력
--UNION 연산자를 이용하여 두 개의 쿼리의 결과를 위아래로 이어 붙여 출력 / 부서 번호 내림차순 정렬

/*
UNION 연산자가 UNION ALL과 다른 점
1) 중복된 데이터를 하나의 고유한 값으로 출력함
2) 첫 번째 컬럼의 데이터를 기준으로 내림차순으로 정렬하여 출력함
3) 중복 데이터는 한 번만 출력된다(중복 제거O)
*/

--테이블 생성
DROP  TABLE   C;
DROP  TABLE   D;

CREATE TABLE C (COL1 NUMBER(10) );
INSERT INTO C VALUES(1);
INSERT INTO C VALUES(2);
INSERT INTO C VALUES(3);
INSERT INTO C VALUES(4);
INSERT INTO C VALUES(5);
COMMIT;

CREATE TABLE D (COL1 NUMBER(10) );
INSERT INTO D VALUES(3);
INSERT INTO D VALUES(4);
INSERT INTO D VALUES(5);
INSERT INTO D VALUES(6);
INSERT INTO D VALUES(7);
COMMIT;

SELECT COL1 FROM C
    UNION
    SELECT COL1 FROM D; --중복 데이터 제거 + 결과 내림차순 정렬
