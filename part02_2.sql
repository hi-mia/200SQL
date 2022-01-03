--34. IF문을 SQL로 구현하기 1 (DECODE)
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) as 보너스
    FROM emp;
--DECODE의 맨 끝 값: 앞의 값에 만족하지 않는 데이터라면 출력하는 값(default) / 생략가능

SELECT empno, mod(empno,2), DECODE(mod(empno,2),0,'짝수',1,'홀수') as 보너스
    FROM emp;
    
SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) as 보너스
    FROM emp;


--35. IF문을 SQL로 구현하기 2 (CASE)
SELECT ename, job, sal, CASE WHEN sal >= 3000 THEN 500
                            WHEN SAL >= 2000 THEN 300
                            WHEN SAL >= 1000 THEN 200
                            ELSE 0 END AS BONUS
    FROM emp
    WHERE job IN ('SALESMAN', 'ANALYST'); --이름, 직업, 월급, 보너스 출력

/*
DECODE: 등호(=)비교만 가능
CASE: 등호(=) 비교와 부등호(>=, <=, >, <) 둘 다 가능
*/  

SELECT ename, job, comm, CASE WHEN comm is null THEN 500
                        ELSE 0 END BONUS
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST');
    
SELECT ename, job, CASE WHEN job in('SALESMAN', 'ANALYST') THEN 500
                        WHEN job in('CLERK', 'MANAGER') THEN 400
                    ELSE 0 END as 보너스
    FROM emp; --직업이 SALESMAN, ANALYST면 500 / CLERK,MANAGER면 400 / 나머지 0


--36. 최대값 출력하기(Max)
SELECT MAX(sal)
    FROM emp; --최대 월급 출력

SELECT MAX(sal)
    FROM emp   
    WHERE job = 'SALESMAN';
    
SELECT job, MAX(sal)
    FROM emp
    WHERE job='SALESMAN'; --Error
    
SELECT job, MAX(sal)
    FROM emp
    WHERE job = 'SALESMAN'
    GROUP BY job;
    
SELECT deptno, MAX(sal)
    FROM emp
    GROUP BY deptno; --부서번호와 부서번호 별 최대 월급 출력 쿼리


--37. 최소값 출력하기(MIN)
SELECT MIN(sal)
    FROM emp
    WHERE job = 'SALESMAN';
    
SELECT job, MIN(sal) 최소값
    FROM emp
    GROUP BY job
    ORDER BY 최소값 DESC; --직업과 직업별 최소 월급 출력
    
--그룹함수 특징은 WHERE절의 조건이 거짓이어도 결과 항상 출력
SELECT MIN(sal)
    FROM emp
    WHERE 1 = 2; -- NULL
    
SELECT NVL(MIN(sal),0)
    FROM emp
    WHERE 1 = 2; -- 0
    
--직업에서 SALESMAN은 제외하고 직업별 최소 월급이 높은 것부터 출력하는 쿼리
SELECT job, MIN(sal)
    FROM emp
    WHERE job != 'SALESMAN'
    GROUP BY job
    ORDER BY MIN(sal) DESC;


--38. 평균값 출력하기(AVG)
SELECT AVG(comm)
    FROM emp; --NULL이 아닌 숫자들만 합계
    
--그룹함수는 NULL값을 무시함, NULL값 대신 0으로 치환 뒤 평균값 내면 결과 달라짐
SELECT ROUND(AVG(NVL(comm,0)))
    FROM emp; --0이 합계 연산에 포함 된다  


--39. 토탈값 출력하기(SUM)
SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno; --부서 번호별 토탈 월급
    
SELECT job, SUM(sal)
    FROM emp
    GROUP BY job
    ORDER BY sum(sal) DESC;
    
SELECT job, SUM(sal)
    FROM emp
    WHERE sum(sal) >= 4000
    GROUP BY job; --ERROR!
    
--그룹함수로 조건을 줄 때는 WHERE 대신 HAVING절
SELECT job, SUM(sal)
    FROM emp
    GROUP BY job
    HAVING sum(sal) >= 4000;
    
--직업에서 SALESMAN은 제외하고, 직업별 토탈 월급이 4000이상인 사원들만 출력
SELECT job, SUM(sal)
    FROM emp
    WHERE job !='SALESMAN'
    GROUP BY job
    HAVING sum(sal) >= 4000;
    
SELECT job as 직업, SUM(sal)
    FROM emp
    WHERE job != 'SALESMAN'
    GROUP BY 직업
    HAVING sum(sal) >= 4000; --GROUP BY 절에 별칭을 사용하면 ERROR!


--40. 건수 출력하기(COUNT)
SELECT COUNT(empno)
    FROM emp; --empno만 카운트
    
SELECT COUNT(*)
    FROM emp; --전체 행을 하나씩 카운트
--COUNT 함수: 건수를 세는 함수 // 그룹함수는 NULL값 무시

SELECT COUNT(COMM)
    FROM emp; --커미션 카운트: NULL값 무시, comm 카운트
    

--41. 데이터 분석 함수로 순위 출력하기 1 (RANK)
SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) 순위
    FROM emp
    WHERE job in('ANALYST', 'MANAGER');
/*
RANK(): 순위를 출력하는 데이터 분석 함수
RANK() + OVER( ): OVER안의 괄호에 출력하고 싶은 데이터를 정렬하는 SQL 문장을 넣으면
그 컬럼 값에 대한 데이터의 순위가 출력 됨
*/

--DENSE_RANK: 중복 순위더라도 1,2,3..모든 숫자 다 나타내고 싶을 때
SELECT ename, sal, job, RANK() over (PARTITION BY job
                                    ORDER BY sal DESC) as 순위
    FROM emp;


--42. 데이터 분석 함수로 순위 출력하기 2 (DENSE_RANK)
SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) AS RANK,
                        DENSE_RANK() over (ORDER BY sal DESC) AS DENSE_RANK
    FROM emp
    WHERE job IN ('ANALYST', 'MANAGER');
    
SELECT job, ename, sal, DENSE_RANK() OVER (PARTITION BY job
                                            ORDER BY sal DESC) 순위
    FROM emp
    WHERE hiredate BETWEEN to_date('1981/01/01', 'RRRR/MM/DD')
                    AND to_date('1981/12/31', 'RRRR/MM/DD');
                    
--DENSE_RANK 바로 다음에 나오는 괄호에도 다음과 같이 데이터를 넣고 사용할 수 있음
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위
    FROM emp; --어느 그룹 이내에서 2975위가 나오는가? / 어느 그룹: group 바로 다음에 나오는 괄호 안의 문법
    
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위
    FROM emp;


--43. 데이터 분석 함수로 등급 출력하기(NTILE)
SELECT ename, job, sal,
    NTILE(4) over (order by sal desc nulls last) 등급
  FROM emp
  WHERE job in ('ANALYST', 'MANAGER', 'CLERK'); --월급 4등급 나눔
  
--NULLS LAST: NULL을 맨 아래에 출력
SELECT ename, comm
    FROM emp
    WHERE deptno = 30
    ORDER BY comm DESC;
    
SELECT ename, comm
    FROM emp
    WHERE deptno = 30
    ORDER BY comm DESC NULLS LAST;


--44. 데이터 분석 함수로 순위의 비율 출력하기 (CUME_DIST)
SELECT ename, sal, RANK() over (order by sal desc) as RANK,
                    DENSE_RANK() over (order by sal desc) as DENSE_RANK,
                    CUME_DIST() over (order by sal desc) as CUM_DIST
    FROM emp;
--같은 등수가 없고 그 등수에 해당하는 사원이 한 명이면 전체 등수로 해당 등수를 나눠서 계산,
--같은 등수가 여러 명 있으면 여러 명 중 마지막 등수로 계산
    
SELECT job, ename, sal, RANK() over (partition by job
                                    order by sal desc) as RANK,
                        CUME_DIST() over (partition by job
                                    order by sal desc) as CUM_DIST
    FROM emp;


--45. 데이터 분석 함수로 데이터를 가로로 출력하기(LISTAGG)
SELECT deptno, LISTAGG(ename, ',') within group (order by ename) as EMPLOYEE
    FROM emp
    GROUP BY deptno; --부서번호 옆에 해당 부서에 속하는 사원들의 이름을 가로로 출력
    
/*
LISTAGG함수: 데이터를 가로로 출력하는 함수 / 구분자로 콤마(,) / GROUP BY절 필수
WITHIN GROUP: group 다음에 나오는 괄호에 속한 그룹의 데이터를 출력하겠다는 뜻
*/    

SELECT job, LISTAGG(ename, ',') within group(ORDER BY ename asc) as employee
    FROM emp
    GROUP BY job;
    
--이름 옆에 월급도 같이 출력: 연결 연산자
SELECT job,
LISTAGG(ename||'('||sal||')', ',') within group(ORDER BY ename asc) as employee
    FROM emp
    GROUP BY job;


--46. 데이터 분석 함수로 바로 전 행과 다음 행 출력하기(LAG, LEAD)
--바로 전 행, 바로 다음 행 월급 출력
SELECT empno, ename, sal,
    LAG(sal, 1) over (order by sal asc) "전 행",
    LEAD(sal, 1) over (order by sal asc) "다음 행"
  FROM emp
  WHERE job in ('ANALYST', 'MANAGER');
  
/*
LAG 함수: 바로 전 행의 데이터를 출력하는 함수 / 1:바로 전 행, 2: 바로 전 전 행
LEAD 함수: 바로 다음 행의 데이터를 출력하는 함수 / 1: 바로 다음 행, 2: 바로 다음 다음 행
*/  

SELECT empno, ename, hiredate,
        LAG(hiredate, 1) over (order by hiredate asc) "전 행",
        LEAD(hiredate, 1) over (order by hiredate asc) "다음 행"
    FROM emp
    WHERE job in ('ANALYST', 'MANAGER');
    
--부서 번호 별로 구분해서 출력
SELECT deptno, empno, ename, hiredate,
        LAG(hiredate, 1) over (partition by deptno
                                order by hiredate asc) "전 행",
        LEAD(hiredate, 1) over (partition by deptno
                                order by hiredate asc) "다음 행"
    FROM emp;


--47. COLUMN을 ROW로 출력하기 1 (SUM+DECODE)
SELECT SUM(DECODE(deptno, 10, sal)) as "10",
        SUM(DECODE(deptno, 20, sal)) as "20",
        SUM(DECODE(deptno, 30, sal)) as "30"
    FROM emp; --가로로 출력
    
-- 1) 부서 번호가 10번이면 월급이 출력, 아니면 NULL이 출력    
SELECT deptno, DECODE(deptno, 10, sal) as "10"
    FROM emp; 
    
--2) 위의 결과에서 DEPTNO 컬럼을 제외하고 DECODE(deptno, 10, sal)만 출력한 다음 
--출력된 결과 값을 다 더해서 출력    
SELECT SUM(DECODE(deptno, 10, sal)) as "10"
    FROM emp; 
    
--3) 여기에 20, 30번도 같이 출력
SELECT SUM(DECODE(deptno, 10, sal)) as "10",
        SUM(DECODE(deptno, 20, sal)) as "20",
        SUM(DECODE(deptno, 30, sal)) as "30"
    FROM emp;
    
--4) 직업, 직업별 토탈 월급을 출력하는데 가로로 출력
SELECT SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST",
        SUM(DECODE(job, 'CLERK', sal)) as "CLERK",
        SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER",
        SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
    FROM emp;
    
--위의 예제에서 SELECT절에 DEPTNO를 추가 (부서 번호별로 각각 직업의 토탈 월급의 분포를 보기 위함)
SELECT DEPTNO, SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST",
                SUM(DECODE(job, 'CLERK', sal)) as "CLERK",
                SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER",
                SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
    FROM emp
    GROUP BY deptno;
