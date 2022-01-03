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
    
    