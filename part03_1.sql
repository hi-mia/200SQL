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