--34. IF문을 SQL로 구현하기 1 (DECODE)
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) as 보너스
    FROM emp;

/*
부서번호가 10번이면 300 / 20번이면 400 / 10번, 20번이 아니면 0으로 출력
IF DEPTNO = 10 THEN 300
ELSE IF DEPTNO = 20 THEN 400
ELSE 0

DECODE의 맨 끝 값: 앞의 값에 만족하지 않는 데이터라면 출력하는 값(default), 생략가능
*/    

SELECT empno, mod(empno,2), DECODE(mod(empno,2),0,'짝수',1,'홀수') as 보너스
    FROM emp;  --사원번호 홀수/짝수 출력, default값 없음
    
SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) as 보너스
    FROM emp;  --직업이 SALESMAN이면 5000출력, 아니면 2000 출력


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
    WHERE job IN('SALESMAN', 'ANALYST'); --보너스는 커미션이 NULL이면 500 출력, NULL이 아니면 0 출력
    
SELECT ename, job, CASE WHEN job in('SALESMAN', 'ANALYST') THEN 500
                        WHEN job in('CLERK', 'MANAGER') THEN 400
                    ELSE 0 END as 보너스
    FROM emp; --보너스에서 직업이 SALESMAN, ANALYST면 500 / CLERK,MANAGER면 400 / 나머지 0


--36. 최대값 출력하기(Max)
SELECT MAX(sal)
    FROM emp; --최대 월급 출력

SELECT MAX(sal)
    FROM emp   
    WHERE job = 'SALESMAN'; --직업 세일즈맨 중 최대 월급
    
SELECT job, MAX(sal)
    FROM emp
    WHERE job='SALESMAN'; --Error
    
SELECT job, MAX(sal)
    FROM emp
    WHERE job = 'SALESMAN'
    GROUP BY job; --직업이 세일즈맨인 사원들 중 최대 월급을 직업과 같이 출력
    
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


--48. COLUMN을 ROW로 출력하기 2 (PIVOT)
SELECT *
    FROM (select deptno, sal from emp)
    PIVOT (sum(sal) for deptno in (10, 20, 30)); --예제 47 좀더 간단
    
--문자형 데이터
--직업과 직업별 토탈 월급을 가로로 출력하는 예제
SELECT *
    FROM (select job, sal from emp)
    PIVOT (sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));
/*
*PIVOT문 사용: FROM절에 괄호를 사용해서 특정 컬럼만 선택해야 함 
괄호 안에는 결과에 필요한 컬럼만 선택하는 쿼리문을 작성

1) 출력되는 결과에 필요한 데이터가 있는 컬럼인 직업과 월급을 선택
2) PIVOT문을 이용해서 토탈 월급을 출력
3) 컬럼명에 싱글 쿼테이션 마크 -> 출력X려면 as 뒤에 해당 직업을 더블 쿼테이션으로 둘러서 작성
*/    

SELECT *
    FROM (select job, sal from emp)
    PIVOT(sum(sal) for job in('ANALYST' as "ANALYST", 'CLERK' as "CLERK",
            'MANAGER' as "MANAGER", 'SALESMAN' as "SALESMAN")); --싱글 쿼테이션 제거


--49. ROW를 COLUMN으로 출력하기(UNPIVOT)
drop  table order2;

--테이블 생성
create table order2
( ename  varchar2(10),
  bicycle  number(10),
  camera   number(10),
  notebook  number(10) );

insert  into  order2  values('SMITH', 2,3,1);
insert  into  order2  values('ALLEN',1,2,3 );
insert  into  order2  values('KING',3,2,2 );

commit;

--UNPIVOT: PIVOT문과는 반대로 열을 행으로 출력 
SELECT *
    FROM order2
    UNPIVOT(건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));
    
 SELECT *
    FROM order2
    UNPIVOT (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

/*
건수: 가로로 저장되어 있는 데이터를 세로로 unpivot시킬 출력 열 이름, 이 열 이름은 임의로 지정
아이템: 가로로 되어 있는 order2 테이블의 컬럼명을 unpivot시켜 세로로 출력할 열 이름, 이름 임의 지정
*/

--order2 테이블의 데이터에 NULL이 포함되어 있다면 UNPIVOT된 결과에서 출력이 되지 않는다
UPDATE ORDER2 SET NOTEBOOK = NULL WHERE ENAME='SMITH'; -- NULL값으로 변경

--INCLUDE NULL: NULL 값인 행도 결과에 포함
SELECT *
    FROM order2
    UNPIVOT INCLUDE NULLS(건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C',
                                             NOTEBOOK as 'N'));


--50. 데이터 분석 함수로 누적 데이터 출력하기(SUM OVER)
SELECT empno, ename, sal, SUM(SAL) OVER (ORDER BY empno ROWS
                                        BETWEEN UNBOUNDED PRECEDING
                                        AND CURRENT ROW) 누적치
        FROM emp
        WHERE job in('ANALYST', 'MANAGER'); --월급의 누적치
        
/* 
OVER 다음의 괄호 안에는 값을 누적할 윈도우를 지정할 수 있음

ROWS: 윈도우 기준
<윈도우 방식>
UNBOUNDED PRECEDING: 맨 첫 번째 행을 가리킵니다
UNBOUNDED FOLLOWING: 맨 마지막 행을 가리킵니다
CURRENT ROW: 현재 행을 가리킵니다

BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW: 제일 첫번째 행부터 현재 행까지의 값
*/


--51. 데이터 분석 함수로 비율 출력하기 (RATIO_TO_REPORT)
SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER () as 비율
    FROM emp
    WHERE deptno = 20; --20번 부서 내에서의 자신의 월급 비율
    
SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER() as 비율,
                            SAL/SUM(sal) OVER () as "비교 비율"
        FROM emp
        WHERE deptno = 20; --RATIO_TO_REPORT(sal)의 결과와 동일 출력
--20번 부서 번호인 사원들의 월급을 20번 부서 번호인 사원드르이 전체 월급으로 나누어 출력


--52. 데이터 분석 함수로 집계 결과 출력하기 1 (ROLLUP)
SELECT job, sum(sal)
    FROM emp
    GROUP BY job; --ROLLUP 추가X

SELECT job, sum(sal)
    FROM emp
    GROUP BY ROLLUP(job); -- 맨 마지막 행에 토탈 월급 출력
--ROLLUP을 이용하여 직업과 직업별 토탈월급을 출력하고 맨 아래쪽에 전체 토탈 월급을 추가적으로 출력

--직업과 직업별 토탈 월급을 출력하는 쿼리에 ROLLUP만 붙여주면 전체 토탈 월급을 추가적으로 볼 수 있음
--맨 아래에 토탈 월급도 출력되고 JOB 컬럼의 데이터도 오름차순으로 정렬되어 출력됨

--ROLLUP에 컬럼 2개 사용: 3가지 집계 결과
SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY ROLLUP(deptno, job); 
--1) 부서번호별 직업별 토탈 월급 deptno, job / 2) 부서 번호별 토탈 월급 deptno / 3) 전체 토탈 월급 ()


--53. 데이터 분석 함수로 집계 결과 출력하기 2 (CUBE)
SELECT job, sum(sal)
    FROM emp
    GROUP BY job; --CUBE(X)

SELECT job, sum(sal)
    FROM emp
    GROUP BY CUBE(job); --첫 번째 행에 토탈 월급 출력
    
--CUBE에 컬럼 2개: 4가지 집계 결과
SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY CUBE(deptno, job);

/*
1) 전체 토탈 월급() / 2) 직업별 토탈 월급 job /
3) 부서 번호별 토탈 월급 deptno / 4) 부서 번호별 직업별 토탈 월급 deptno, job
*/    


--54. 데이터 분석 함수로 집계 결과 출력하기 3 (GROUPING SETS)
SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY GROUPING SETS((deptno), (job), ());

/*
GROUPING SETS 괄호 안에 집계하고 싶은 컬럼명을 기술하면, 기술한대로 결과를 출력

1) GROUPING SETS((deptno), (job), ()) : 부서 번호별 집계, 직업별 집계, 전체 집계
2) GROUPING SETS((deptno), (job)): 부서 번호별 집계, 직업별 집계
3) GROUPING SETS((deptno, job), ()): 부서 번호와 직업별 집계, 전체 집계
4) GROUPING SETS((deptno, job)): 부서 번호와 직업별 집계
*/

--ROLLUP 사용
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY ROLLUP(deptno);

--GROUPING SETS를 사용
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY GROUPING
SETS((deptno), () );
--()는 전체를 의미, 전체를 대상으로 월급을 집계 / 결과는 동일하나 GROUPING SETS가 결과 예측 더 용이


--55. 데이터 분석 함수로 출력 결과 넘버링 하기(ROW_NUMBER)
SELECT empno, ename, sal, RANK() OVER (ORDER BY sal DESC) RANK,
                        DENSE_RANK() OVER (ORDER BY sal DESC) DENSE_RANK,
                        ROW_NUMBER() OVER (ORDER BY sal DESC) 번호
    FROM emp
    WHERE deptno = 20;
    
/*
ROW_NUMBER(): 출력되는 각 행에 고유한 숫자 값을 부여하는 데이터 분석 함수
출력되는 결과에 번호를 순서대로 부여해서 출력
OVER 다음 괄호 안에 반드시 ORDER BY절을 기술해야 한다!
PSEUDOCOLUMN인 ROWNUM과 유사 / RANK와 DENSE_RANK와 다름
*/    

SELECT empno, ename, sal, ROW_NUMBER() OVER ()번호
    FROM emp
    WHERE deptno = 20; -- ERROR! (윈도우 지정에 ORDER BY 표현식이 없습니다)
    
--부서 번호별로 월급에 대한 순위를 출력하는 쿼리
--PARTITION BY를 사용하여 부서 번호별로 파티션해서 순위를 부여
SELECT deptno, ename, sal, ROW_NUMBER() OVER(PARTITION BY deptno
                                        ORDER BY sal DESC) 번호
        FROM emp
        WHERE deptno in (10, 20);