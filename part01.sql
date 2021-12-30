--01. 테이블에서 특정 열 선택하기
SELECT empno, ename, sal
    FROM emp;


--02. 테이블에서 모든 열 출력하기
SELECT *
    FROM emp;

SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
    FROM emp; --일일이 나열

 SELECT dept.*, deptno from dept;   
 -- emp 테이블의 모든 컬럼을 출력하고 맨 끝에 다시 한번 특정 컬럼을 한번 더 출력
-- * 앞에 '테이블명.'을 붙여 주어 작성하고 그 다음 한번 더 출력하고자 하는 컬럼명 작성


--03. 컬럼 별칭을 사용하여 출력되는 컬럼명 변경하기
SELECT empno as 사원번호, ename as 사원이름, sal as "Salary"
    FROM emp;
--칼럼명 변경: 컬럼명 + as + 출력하고 싶은 컬럼명
--컬럼 별칭에 쌍따옴표: 대소문자 구분 출력 / 공백문자 출력 / 특수문자 출력($, _, #만 가능)

--(1)
SELECT ename, sal *(12 + 3000)
    FROM emp;

--(2)
SELECT ename, sal *(12 + 3000) as 월급
    FROM emp;

--(3)
SELECT ename, sal *(12+3000) as 월급
    FROM emp
    ORDER BY 월급 desc;

/*
(1) 수식을 사용하여 결과를 출력할 때 컬럼 별칭이 유용

(2) 수식을 사용할 경우 출력되는 컬럼며도 수식으로 출력됨
수식명이 아닌 한글로 컬럼명을 출력하고 싶다면 수식 뒤에 as + 컬럼 별칭

(3) 수식에 컬럼 별칭을 사용하면 ORDER BY절을 사용할 때 유용
ORDER BY절에 수식명X, 컬럼 별칭만 사용하면 되어서 간편
*/


--04. 연결 연산자 사용하기(||)
--연결 연산자를 이용하면 컬럼+컬럼 연결 / 컬럼+문자열 연결 가능
SELECT ename || sal
    FROM emp;

SELECT ename || '의 월급은 ' || sal || '입니다 ' as 월급정보
    FROM emp;

--연결 연산자를 이용하여 컬럼들을 연결했다면 컬럼 별칭은 맨 마지막에 사용