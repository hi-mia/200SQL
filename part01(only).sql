--01. 테이블에서 특정 열 선택하기
SELECT empno, ename, sal
    FROM emp;


--02. 테이블에서 모든 열 출력하기
SELECT *
    FROM emp;

SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
    FROM emp; --일일이 나열

 SELECT dept.*, deptno from dept;   


--03. 컬럼 별칭을 사용하여 출력되는 컬럼명 변경하기
SELECT empno as 사원번호, ename as 사원이름, sal as "Salary"
    FROM emp;

SELECT ename, sal *(12 + 3000)
    FROM emp;

SELECT ename, sal *(12 + 3000) as 월급
    FROM emp;

SELECT ename, sal *(12+3000) as 월급
    FROM emp
    ORDER BY 월급 desc;


--04. 연결 연산자 사용하기(||)
SELECT ename || sal
    FROM emp;

SELECT ename || '의 월급은 ' || sal || '입니다 ' as 월급정보
    FROM emp;

SELECT ename || '의 직업은 ' || job || '입니다 ' as 직업정보
    FROM emp;


--05. 중복된 데이터를 제거해서 출력하기(DISTINCT)
SELECT DISTINCT job
    FROM emp;

SELECT UNIQUE job
    FROM emp;


--06. 데이터를 정렬해서 출력하기(ORDER BY)
SELECT ename, sal  
    FROM emp
    ORDER BY sal asc;

SELECT ename, sal as 월급
    FROM emp
    ORDER BY 월급 asc;

SELECT ename, deptno, sal
    FROM emp
    ORDER BY deptno asc, sal desc;

SELECT ename, deptno, sal
    FROM emp
    ORDER BY 2 asc, 3 desc;


--07. WHERE절 배우기 1 (숫자 데이터 검색)
SELECT ename, sal, job
    FROM emp
    WHERE sal = 3000;

SELECT ename as 이름, sal as 월급
    FROM emp
    WHERE sal >= 3000;    

SELECT ename as 이름, sal as 월급
    FROM emp
    WHERE 월급 >= 3000; --ERROR!


--08. WHERE절 배우기 2 (문자와 날짜 검색)
SELECT ename, sal, job, hiredate, deptno
    FROM emp
    WHERE ename='SCOTT';

SELECT ename, hiredate
    FROM emp
    WHERE hiredate = '81/11/17'; 

SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE PARAMETER = 'NLS_DATE_FORMAT';

ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD';

SELECT ename, sal
    FROM emp
    WHERE hiredate = '81/11/17';

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';


--09. 산술 연산자 배우기 (*, /, +, -)
SELECT ename, sal*12 as 연봉
    FROM emp
    WHERE sal*12 >= 36000;

SELECT ename, sal, comm, sal + comm
    FROM emp
    WHERE deptno = 10;

SELECT sal + NVL(comm, 0)
    FROM emp
    WHERE ename = 'KING';


--10. 비교 연산자 배우기 1 (>, <, >=, <=, =, !=, <>, ^=)
SELECT ename, sal, job, deptno
    FROM emp
    WHERE sal <= 1200;


--11. 비교 연산자 배우기 2 (BETWEEN AND)
SELECT ename, sal
    FROM emp
    WHERE sal BETWEEN 1000 AND 3000;

SELECT ename, sal
    FROM emp
    WHERE (sal >= 1000 AND sal <= 3000);

SELECT ename, sal
    FROM emp
    WHERE sal NOT BETWEEN 1000 AND 3000;

SELECT ename, sal
    FROM emp
    WHERE (sal < 1000 OR sal > 3000);

SELECT ename, hiredate
    FROM emp
    WHERE hiredate BETWEEN '1982/01/01' AND '1982/12/31';


--12. 비교 연산자 배우기 3 (LIKE)
SELECT ename, sal
    FROM emp
    WHERE ename LIKE 'S%';

SELECT ename
    FROM emp
    WHERE ename LIKE '_M%';

SELECT ename
    FROM emp
    WHERE ename LIKE '%T';

SELECT ename
    FROM emp
    WHERE ename LIKE '%A%';


--13. 비교 연산자 배우기 4 (IS NULL)
SELECT ename, comm
    FROM emp
    WHERE comm is null;


--14. 비교 연산자 배우기 5 (IN)
SELECT ename, sal, job
    FROM emp
    WHERE job in ('SALESMAN', 'ANALYST', 'MANAGER');

SELECT ename, sal, job
    FROM emp
    WHERE (job = 'SALESMAN' or job = 'ANALYST' or job = 'MANAGER'); 

SELECT ename, sal, job
    FROM emp
    WHERE job NOT in('SALESMAN', 'ANALYST', 'MANAGER');

SELECT ename, sal, job
   FROM emp
   WHERE (job != 'SALESMAN' or job != 'ANALYST' or job != 'MANAGER');


--15. 논리 연산자 배우기 (AND, OR, NOT)
SELECT ename, sal, job
    FROM emp
    WHERE job='SALESMAN' AND sal >= 1200;

SELECT ename, sal, job
    FROM emp
    WHERE job='ABCDEFG' AND sal >= 1200; --데이터 반환(X)