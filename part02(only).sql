--16. 대소문자 변환 함수 배우기 (UPPER, LOWER, INITCAP)
SELECT UPPER(ename), LOWER(ename), INITCAP(ename)
    FROM emp;

SELECT ENAME, SAL
    FROM emp
    WHERE LOWER(ename)='scott';


--17. 문자에서 특정 철자 추출하기(SUBSTR)
SELECT SUBSTR('SMITH', 1,3)
    FROM DUAL;


--18. 문자열의 길이를 출력하기(LENGTH)
SELECT ename, LENGTH(ename)
    FROM emp;

SELECT LENGTH('가나다라마')
    FROM DUAL;

SELECT LENGTHB('가나다라마')
    FROM DUAL;


--19. 문자에서 특정 철자의 위치 출력하기(INSTR)
SELECT INSTR('SMITH', 'M')
    FROM DUAL;

SELECT INSTR('abcdefg@naver.com', '@')
    FROM DUAL; --@의 위치 추출

SELECT SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1)
    FROM DUAL;

--naver만 출력
SELECT RTRIM(SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1), '.com')
    FROM DUAL;


--20. 특정 철자를 다른 철자로 변경하기(REPLACE)
SELECT ename, REPLACE(sal, 0, '*') -- 0을 *로 변환
    FROM emp;

SELECT ename, REGEXP_REPLACE(sal, '[0-3]', '*') as SALARY
    FROM emp;    


CREATE TABLE TEST_ENAME
(ENAME VARCHAR2(10));

INSERT INTO TEST_ENAME VALUES('김인호');
INSERT INTO TEST_ENAME VALUES('안상수');
INSERT INTO TEST_ENAME VALUES('최영희');
COMMIT;

SELECT REPLACE(ENAME, SUBSTR(ENAME, 2, 1), '*') as "전광판_이름"
    FROM test_ename;


--21. 특정 철자를 N개 만큼 채우기(LPAD, RPAD)
SELECT ename, LPAD(sal, 10, '*') as salary1, RPAD(sal, 10, '*') as salary2
    FROM emp;

SELECT ename, sal, lpad('■', round(sal/100), '■') as bar_chart
    FROM emp;


--22. 특정 절차 잘라내기 (TRIM, RTRIM, LTRIM)
SELECT 'smith', LTRIM('smith', 's'), RTRIM('smith', 'h'), TRIM('s' from 'smiths')
FROM dual;

insert into emp(empno, ename, sal, job, deptno) values(8291, 'JACK  ', 3000,
                'SALESMANE', 30);
commit;

SELECT ename, sal
    FROM emp
    WHERE ename = 'JACK'; --결과 출력(X)
    
SELECT ename, sal
    FROM emp
    WHERE RTRIM(ename)='JACK'; --결과 출력(O)
    
DELETE FROM EMP WHERE TRIM(ENAME)='JACK'; 
COMMIT;


--23. 반올림해서 출력하기(ROUND)
SELECT '876.567' as 숫자, ROUND(876.567, 1)
    FROM dual; --소수점 이후 2번째 자리(6)에서 반올림
    
SELECT '876.567' as 숫자, ROUND(876.567, 2)
    FROM dual;  
    
SELECT '876.567' as 숫자, ROUND(876.567, -1)
    FROM dual;  

SELECT '876.567' as 숫자, ROUND(876.567, -2)
    FROM dual;  
    
SELECT '876.567' as 숫자, ROUND(876.567, 0)
    FROM dual;
SELECT '876.567' as 숫자, ROUND(876.567)
    FROM dual; 


--24. 숫자를 버리고 출력하기(TRUNC)
SELECT '876.567' as 숫자, TRUNC(876.567, 1)
    FROM dual; --소수점 두 번째 자리인 6과 그 이후 숫자 버림
    
SELECT '876.567' as 숫자, TRUNC(876.567, 2)
    FROM dual;    
    
SELECT '876.567' as 숫자, TRUNC(876.567, -1)
    FROM dual;    
    
SELECT '876.567' as 숫자, TRUNC(876.567, -2)
    FROM dual;    
    
SELECT '876.567' as 숫자, TRUNC(876.567, 0)
    FROM dual;    
SELECT '876.567' as 숫자, TRUNC(876.567)
    FROM dual;   --위와 동일 결과


--25. 나눈 나머지 값 출력하기(MOD)
SELECT MOD(10, 3)
    FROM DUAL;
    
SELECT empno, MOD(empno,2)
    FROM emp;
    
SELECT empno, ename
    FROM emp
    WHERE MOD(empno,2) = 0;
    
SELECT FLOOR(10/3)
    FROM DUAL; 
    
    
--26. 날짜 간 개월 수 출력하기(MONTHS_BETWEEN)
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate)
    FROM emp;

SELECT TO_DATE('2019-06-01', 'RRRR-MM-DD') - TO_DATE('2018-10-01', 'RRRR-MM-DD')
    FROM dual; 

SELECT ROUND((TO_DATE('2019-06-01', 'RRRR-MM-DD')-TO_DATE('2018-10-01', 'RRRR-MM-DD'))/7) 
    AS "총 주수"
    FROM dual;


--27. 개월 수 더한 날짜 출력하기(ADD_MONTHS)
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100)
    FROM DUAL; 
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100
    FROM DUAL; 
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '100' month
    FROM DUAL;
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '1-3' year(1) to month
    FROM DUAL;
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '3' year
    FROM DUAL; 
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + TO_YMINTERVAL('03-05') as 날짜
    FROM dual;


--28. 특정 날짜 뒤에 오는 요일 날짜 출력하기(NEXT_DAY) 
SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22', '월요일')
    FROM DUAL; 
    
SELECT SYSDATE as "오늘 날짜"
    FROM DUAL; 
    
SELECT NEXT_DAY(SYSDATE, '화요일') as "다음 날짜"
    FROM DUAL; 
    
SELECT NEXT_DAY(ADD_MONTHS('2019/05/22', 100), '화요일') as "다음 날짜"
    FROM DUAL; 
    
SELECT NEXT_DAY(ADD_MONTHS(sysdate, 100), '월요일') as "다음 날짜"
    FROM DUAL; 


--29. 특정 날짜가 있는 달의 마지막 날짜 출력하기(LAST_DAY)
SELECT '2019/05/22' as 날짜, LAST_DAY('2019/05/22') as "마지막 날짜" 
    FROM DUAL; 
    
SELECT LAST_DAY(SYSDATE) - SYSDATE as "남은 날짜"
    FROM DUAL; 
    
SELECT ename, hiredate, LAST_DAY(hiredate)
    FROM emp
    WHERE ename='KING'; 
    

--30. 문자형으로 데이터 유형 변환하기(TO_CHAR)
SELECT ename, TO_CHAR(hiredate, 'DAY') as 요일, TO_CHAR(sal, '999,999') as 월급
    FROM emp
    WHERE ename='SCOTT';

SELECT hiredate, TO_CHAR(hiredate,'RRRR') as 연도, TO_CHAR(hiredate, 'MM') as 달,
                TO_CHAR(hiredate, 'DD') as 일, TO_CHAR(hiredate, 'DAY') as 요일
        FROM emp
        WHERE ename='KING';
        
SELECT ename, hiredate
    FROM emp
    WHERE TO_CHAR(hiredate, 'RRRR') = '1981';
    
--EXTRACT: 날짜 컬럼에서 연도/월/일/시간/분/초 추출
SELECT ename as 이름, EXTRACT(year from hiredate) as 연도,
                    EXTRACT(MONTH from hiredate) as 달,
                    EXTRACT(day from hiredate) as 요일
    FROM emp;
    
SELECT ename as 이름, TO_CHAR(sal, '999,999') as 월급
    FROM emp;
    
SELECT ename as 이름, TO_CHAR(sal*200, '999,999,999') as 월급
    FROM emp;
    
--알파뱃 L: 화폐 단위 \(원화)
SELECT ename as 이름, TO_CHAR(sal*200, 'L999,999,999') as 월급
    FROM emp;


--31. 날짜형으로 데이터 유형 변환하기(TO_DATE)
SELECT ename, hiredate 
    FROM emp
    WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');
    
--현재 접속한 세션의 날짜 형식을 확인하는 쿼리
SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE parameter='NLS_DATE_FORMAT';
   
SELECT ename, hiredate
    FROM emp
    WHERE hiredate = '81/11/17';
    
--날짜 형식이 DD/MM/RR일 때
SELECT ename, hiredate
    FROM emp
    WHERE hiredate = '17/11/81';
    
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/RR';

SELECT eName, hiredate
        FROM emp
        WHERE hiredate = '17/11/81';
        
SELECT eName, hiredate
        FROM emp
        WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';    


--32. 암시적 형 변환 이해하기
SELECT ename, sal  
    FROM emp
    WHERE sal = '3000';

CREATE TABLE EMP32
(ENAME VARCHAR2(10),
SAL VARCHAR2(10));

INSERT INTO EMP32 VALUES('SCOTT', '3000');
INSERT INTO EMP32 VALUES('SMITH', '1200');
COMMIT;

SELECT ename, sal
    FROM emp32
    WHERE sal = '3000'; --문자형 = 문자열
    
SELECT ename, sal
    FROM emp32
    WHERE sal = 3000; --문자형 = 숫자형 (암시적 형변환)
    
SELECT ename, sal
    FROM emp32
    WHERE TO_NUMBER(SAL) = 3000;
    
--SET AUTOUT ON
SET AUTOT ON

SELECT ename, sal
    FROM emp32
    WHERE SAL = 3000;


--33. NULL 값 대신 다른 데이터 출력하기(NVL, NVL2)
SELECT ename, comm, NVL(comm, 0)
    FROM emp;
    
SELECT ename, sal, comm, sal+comm
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST');
    
SELECT ename, sal, comm, NVL(comm, 0), sal+NVL(comm,0)
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST');
    
 --NVL2 함수 이용
 SELECT ename, sal, comm, NVL2(comm, sal+comm, sal)
    FROM emp
    WHERE job IN ('SALESMAN', 'ANALYST');


--34. IF문을 SQL로 구현하기 1 (DECODE)
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) as 보너스
    FROM emp;

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
    WHERE job IN ('SALESMAN', 'ANALYST');

SELECT ename, job, comm, CASE WHEN comm is null THEN 500
                        ELSE 0 END BONUS
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST');
    
SELECT ename, job, CASE WHEN job in('SALESMAN', 'ANALYST') THEN 500
                        WHEN job in('CLERK', 'MANAGER') THEN 400
                    ELSE 0 END as 보너스
    FROM emp;


--36. 최대값 출력하기(Max)
SELECT MAX(sal)
    FROM emp;

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
    GROUP BY deptno;


--37. 최소값 출력하기(MIN)
SELECT MIN(sal)
    FROM emp
    WHERE job = 'SALESMAN';
    
SELECT job, MIN(sal) 최소값
    FROM emp
    GROUP BY job
    ORDER BY 최소값 DESC;
    
SELECT MIN(sal)
    FROM emp
    WHERE 1 = 2; -- NULL
    
SELECT NVL(MIN(sal),0)
    FROM emp
    WHERE 1 = 2; -- 0
    
SELECT job, MIN(sal)
    FROM emp
    WHERE job != 'SALESMAN'
    GROUP BY job
    ORDER BY MIN(sal) DESC;


--38. 평균값 출력하기(AVG)
SELECT AVG(comm)
    FROM emp; --NULL이 아닌 숫자들만 합계
    
SELECT ROUND(AVG(NVL(comm,0)))
    FROM emp; --0이 합계 연산에 포함 된다  


--39. 토탈값 출력하기(SUM)
SELECT deptno, SUM(sal)
    FROM emp
    GROUP BY deptno;
    
SELECT job, SUM(sal)
    FROM emp
    GROUP BY job
    ORDER BY sum(sal) DESC;
    
SELECT job, SUM(sal)
    FROM emp
    WHERE sum(sal) >= 4000
    GROUP BY job; --ERROR!
    
SELECT job, SUM(sal)
    FROM emp
    GROUP BY job
    HAVING sum(sal) >= 4000;
    
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
    FROM emp;
    
SELECT COUNT(*)
    FROM emp;

SELECT COUNT(COMM)
    FROM emp;
    

--41. 데이터 분석 함수로 순위 출력하기 1 (RANK)
SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) 순위
    FROM emp
    WHERE job in('ANALYST', 'MANAGER');

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
                    
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위
    FROM emp;
    
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위
    FROM emp;


--43. 데이터 분석 함수로 등급 출력하기(NTILE)
SELECT ename, job, sal,
    NTILE(4) over (order by sal desc nulls last) 등급
  FROM emp
  WHERE job in ('ANALYST', 'MANAGER', 'CLERK');
  
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
    
SELECT job, ename, sal, RANK() over (partition by job
                                    order by sal desc) as RANK,
                        CUME_DIST() over (partition by job
                                    order by sal desc) as CUM_DIST
    FROM emp;


--45. 데이터 분석 함수로 데이터를 가로로 출력하기(LISTAGG)
SELECT deptno, LISTAGG(ename, ',') within group (order by ename) as EMPLOYEE
    FROM emp
    GROUP BY deptno;

SELECT job, LISTAGG(ename, ',') within group(ORDER BY ename asc) as employee
    FROM emp
    GROUP BY job;
    
SELECT job,
LISTAGG(ename||'('||sal||')', ',') within group(ORDER BY ename asc) as employee
    FROM emp
    GROUP BY job;


--46. 데이터 분석 함수로 바로 전 행과 다음 행 출력하기(LAG, LEAD)
SELECT empno, ename, sal,
    LAG(sal, 1) over (order by sal asc) "전 행",
    LEAD(sal, 1) over (order by sal asc) "다음 행"
  FROM emp
  WHERE job in ('ANALYST', 'MANAGER');

SELECT empno, ename, hiredate,
        LAG(hiredate, 1) over (order by hiredate asc) "전 행",
        LEAD(hiredate, 1) over (order by hiredate asc) "다음 행"
    FROM emp
    WHERE job in ('ANALYST', 'MANAGER');
    
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
    FROM emp;
    
--1) 
SELECT deptno, DECODE(deptno, 10, sal) as "10"
    FROM emp; 

--2)
SELECT SUM(DECODE(deptno, 10, sal)) as "10"
    FROM emp; 
    
--3)
SELECT SUM(DECODE(deptno, 10, sal)) as "10",
        SUM(DECODE(deptno, 20, sal)) as "20",
        SUM(DECODE(deptno, 30, sal)) as "30"
    FROM emp;
    
--4)
SELECT SUM(DECODE(job, 'ANALYST', sal)) as "ANALYST",
        SUM(DECODE(job, 'CLERK', sal)) as "CLERK",
        SUM(DECODE(job, 'MANAGER', sal)) as "MANAGER",
        SUM(DECODE(job, 'SALESMAN', sal)) as "SALESMAN"
    FROM emp;
    

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

SELECT *
    FROM (select job, sal from emp)
    PIVOT (sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));

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

--UNPIVOT
SELECT *
    FROM order2
    UNPIVOT(건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));
    
 SELECT *
    FROM order2
    UNPIVOT (건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));


UPDATE ORDER2 SET NOTEBOOK = NULL WHERE ENAME='SMITH'; -- NULL값으로 변경

--INCLUDE NULL
SELECT *
    FROM order2
    UNPIVOT INCLUDE NULLS(건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C',
                                             NOTEBOOK as 'N'));


--50. 데이터 분석 함수로 누적 데이터 출력하기(SUM OVER)
SELECT empno, ename, sal, SUM(SAL) OVER (ORDER BY empno ROWS
                                        BETWEEN UNBOUNDED PRECEDING
                                        AND CURRENT ROW) 누적치
        FROM emp
        WHERE job in('ANALYST', 'MANAGER');


--51. 데이터 분석 함수로 비율 출력하기 (RATIO_TO_REPORT)
SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER () as 비율
    FROM emp
    WHERE deptno = 20;
    
SELECT empno, ename, sal, RATIO_TO_REPORT(sal) OVER() as 비율,
                            SAL/SUM(sal) OVER () as "비교 비율"
        FROM emp
        WHERE deptno = 20; 


--52. 데이터 분석 함수로 집계 결과 출력하기 1 (ROLLUP)
SELECT job, sum(sal)
    FROM emp
    GROUP BY job; --ROLLUP 추가X

SELECT job, sum(sal)
    FROM emp
    GROUP BY ROLLUP(job); 


SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY ROLLUP(deptno, job); 


--53. 데이터 분석 함수로 집계 결과 출력하기 2 (CUBE)
SELECT job, sum(sal)
    FROM emp
    GROUP BY job; --CUBE(X)

SELECT job, sum(sal)
    FROM emp
    GROUP BY CUBE(job);
    

SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY CUBE(deptno, job);


--54. 데이터 분석 함수로 집계 결과 출력하기 3 (GROUPING SETS)
SELECT deptno, job, sum(sal)
    FROM emp
    GROUP BY GROUPING SETS((deptno), (job), ());

--ROLLUP 사용
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY ROLLUP(deptno);

--GROUPING SETS를 사용
SELECT deptno, sum(sal)
    FROM emp
    GROUP BY GROUPING
SETS((deptno), () );


--55. 데이터 분석 함수로 출력 결과 넘버링 하기(ROW_NUMBER)
SELECT empno, ename, sal, RANK() OVER (ORDER BY sal DESC) RANK,
                        DENSE_RANK() OVER (ORDER BY sal DESC) DENSE_RANK,
                        ROW_NUMBER() OVER (ORDER BY sal DESC) 번호
    FROM emp
    WHERE deptno = 20;   

SELECT empno, ename, sal, ROW_NUMBER() OVER ()번호
    FROM emp
    WHERE deptno = 20; -- ERROR! (윈도우 지정에 ORDER BY 표현식이 없습니다)
    
SELECT deptno, ename, sal, ROW_NUMBER() OVER(PARTITION BY deptno
                                        ORDER BY sal DESC) 번호
        FROM emp
        WHERE deptno in (10, 20);       