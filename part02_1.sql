--16. 대소문자 변환 함수 배우기 (UPPER, LOWER, INITCAP)
SELECT UPPER(ename), LOWER(ename), INITCAP(ename)
    FROM emp;

SELECT ENAME, SAL
    FROM emp
    WHERE LOWER(ename)='scott';

/*
upper 함수: 대문자 출력
lower 함수: 소문자 출력
initcap 함수: 첫 번재 철자만 대문자, 나머지는 소문자

함수(function): 다양한 데이터 검색을 위해 필요한 기능
*/


--17. 문자에서 특정 철자 추출하기(SUBSTR)
SELECT SUBSTR('SMITH', 1,3)
    FROM DUAL;
--SUBSTR 함수: 문자에서 특정 위치의 문자열을 추출, 1부터 시작


--18. 문자열의 길이를 출력하기(LENGTH)
SELECT ename, LENGTH(ename)
    FROM emp;

SELECT LENGTH('가나다라마')
    FROM DUAL;
--LENGTH 함수: 문자열의 길이를 출력하는 함수 / 한글도 마찬가지로 문자길이 출력

SELECT LENGTHB('가나다라마')
    FROM DUAL;
--LENGTHB: 바이트의 길이를 반환 / 한글은 한글자에 3바이트


--19. 문자에서 특정 철자의 위치 출력하기(INSTR)
SELECT INSTR('SMITH', 'M')
    FROM DUAL;
--INSTR 함수: 문자에서 특정 철자의 위치를 출력하는 함수

--이메일에서 naver.com만 추출하기: INSTR, SUBSTR
SELECT INSTR('abcdefg@naver.com', '@')
    FROM DUAL; --@의 위치 추출

SELECT SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1)
    FROM DUAL;
ㅠ
--naver만 출력
SELECT RTRIM(SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1), '.com')
    FROM DUAL; --RTRIM: 오른쪽에 있는 .com을 잘라냄


--20. 특정 철자를 다른 철자로 변경하기(REPLACE)
SELECT ename, REPLACE(sal, 0, '*') -- 0을 *로 변환
    FROM emp;

SELECT ename, REGEXP_REPLACE(sal, '[0-3]', '*') as SALARY -- 0~3까지를 *로 변환
    FROM emp;    
--REPLACE 함수: 특정 철자를 다른 철자로 변경하는 문자 함수

--REGEXP_REPLACE 함수: 정규식 함수(더 복잡한 형태의 검색패턴으로 데이터 조회 가능)
CREATE TABLE TEST_ENAME
(ENAME VARCHAR2(10));

INSERT INTO TEST_ENAME VALUES('김인호');
INSERT INTO TEST_ENAME VALUES('안상수');
INSERT INTO TEST_ENAME VALUES('최영희');
COMMIT;

--이름의 두 번째 자리의 한글을 *로 출력
SELECT REPLACE(ENAME, SUBSTR(ENAME, 2, 1), '*') as "전광판_이름"
    FROM test_ename;


--21. 특정 철자를 N개 만큼 채우기(LPAD, RPAD)
SELECT ename, LPAD(sal, 10, '*') as salary1, RPAD(sal, 10, '*') as salary2
    FROM emp; --월급 컬럼 자릿수 10자리, 월급 출력하고 남은 나머지 자리 별표(*)

SELECT ename, sal, lpad('■', round(sal/100), '■') as bar_chart
    FROM emp;

/*
LPAD: 왼쪽(left)으로 채워 넣다(PAD)
RPAD: 오른쪽으로 채워 넣음
SQL로 데이터를 시각화하기에 유용
*/   


--22. 특정 절차 잘라내기 (TRIM, RTRIM, LTRIM)
SELECT 'smith', LTRIM('smith', 's'), RTRIM('smith', 'h'), TRIM('s' from 'smiths')
FROM dual;

/*LTRIM('smith', 's'): smith를 출력하는데 왼쪽 철자인 s를 잘라서 출력
RTRIM('smith', 'h'): smith를 출력하는데 오른쪽 절차인 h를 잘라서 출력
TRIM('s' from 'smiths'): smiths를 출력하는데 양쪽의 s를 잘라서 출력 */

insert into emp(empno, ename, sal, job, deptno) values(8291, 'JACK  ', 3000,
                'SALESMANE', 30); --공백을 넣어 데이터 입력
commit;

SELECT ename, sal
    FROM emp
    WHERE ename = 'JACK'; --결과 출력(X)
    
SELECT ename, sal
    FROM emp
    WHERE RTRIM(ename)='JACK'; --결과 출력(O)
    
DELETE FROM EMP WHERE TRIM(ENAME)='JACK'; --실습 데이터 지우기
COMMIT;


--23. 반올림해서 출력하기(ROUND)
SELECT '876.567' as 숫자, ROUND(876.567, 1)
    FROM dual; --소수점 이후 2번째 자리(6)에서 반올림
    
SELECT '876.567' as 숫자, ROUND(876.567, 2)
    FROM dual;  --소수점 이후 3번째 자리  
    
SELECT '876.567' as 숫자, ROUND(876.567, -1)
    FROM dual;  --소수점 이전 일의 자리

SELECT '876.567' as 숫자, ROUND(876.567, -2)
    FROM dual;  --소수점 이전 십의 자리
    
SELECT '876.567' as 숫자, ROUND(876.567, 0)
    FROM dual;
SELECT '876.567' as 숫자, ROUND(876.567)
    FROM dual; --위와 동일 결과


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
    FROM DUAL; --10을 3으로 나눈 나머지 값
    
SELECT empno, MOD(empno,2)
    FROM emp; --사원 번호가 홀수이면 1, 짝수이면 0 출력
    
SELECT empno, ename
    FROM emp
    WHERE MOD(empno,2) = 0; --사원 번호가 짝수인 사원들의 사원 번호와 이름을 출력
    
SELECT FLOOR(10/3)
    FROM DUAL; --10을 3으로 나눈 몫
--FLOOR(10/3): 3과 4 사이에서 가장 바닥에 해당하는 값인 3을 출력
    
    
--26. 날짜 간 개월 수 출력하기(MONTHS_BETWEEN)
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate)
    FROM emp; --입사한 날짜부터 오늘까지

/*
SYSDATE: 오늘 날짜 확인
MONTHS_BETWEEN: 날짜 값을 입력받아 숫자 값을 출력함 / 날짜와 날짜 사이 개월 수 정확 계산
MONTHS_BETWEEN(최신 날짜, 예전 날짜)

MONTHS_BETWEEN 함수를 이용하지 않고 날짜만 가지고 연산: 날짜와 산술 연산만을 사용, 산술식
*/   

SELECT TO_DATE('2019-06-01', 'RRRR-MM-DD') - TO_DATE('2018-10-01', 'RRRR-MM-DD')
    FROM dual; --2018.10.1에서 2019.6.1 사이의 총 일수

--TO_DATE함수: 연도,달,일 명시(RRRR-MM-DD)

SELECT ROUND((TO_DATE('2019-06-01', 'RRRR-MM-DD')-TO_DATE('2018-10-01', 'RRRR-MM-DD'))/7) 
    AS "총 주수"
    FROM dual; --2018.10.1에서 2019.6.1 사이의 총 주(week) 수 출력


--27. 개월 수 더한 날짜 출력하기(ADD_MONTHS)
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100)
    FROM DUAL; -- 2019.5.1일로부터 100달 뒤의 날짜
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100
    FROM DUAL; --100일 뒤의 날짜
    
--달의 기준 30일? 31일? : ADD_MONTH함수 or interval 함수
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '100' month
    FROM DUAL;
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '1-3' year(1) to month
    FROM DUAL;
    
--INTERVAL 표현식: year, month, day, hour, minute, second까지 다양하게 지정 가능
--INTERVAL 사용시 연도가 한 자리인 경우는 YEAR 사용, 연도가 3자리인 경우는 YEAR(3)을 사용

SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '3' year
    FROM DUAL; --2019.5.1일에서 3년 후의 날짜 반환
    
--TO_YMINTERVAL: 2019.5.1일부터 3년 개월 후의 날짜를 출력할 수 있음
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + TO_YMINTERVAL('03-05') as 날짜
    FROM dual;


--28. 특정 날짜 뒤에 오는 요일 날짜 출력하기(NEXT_DAY) 
SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22', '월요일')
    FROM DUAL; -- 2019년 5월 22일로부터 바로 돌아올 월요일의 날짜
    
SELECT SYSDATE as "오늘 날짜"
    FROM DUAL; --오늘 날짜 출력
    
SELECT NEXT_DAY(SYSDATE, '화요일') as "다음 날짜"
    FROM DUAL; --다음 날짜
    
SELECT NEXT_DAY(ADD_MONTHS('2019/05/22', 100), '화요일') as "다음 날짜"
    FROM DUAL; --2019.5.22일부터 100달 뒤에 돌아오는 화요일의 날짜
    
SELECT NEXT_DAY(ADD_MONTHS(sysdate, 100), '월요일') as "다음 날짜"
    FROM DUAL; --오늘부터 100달 뒤에 돌아오는 월요일 날짜


--29. 특정 날짜가 있는 달의 마지막 날짜 출력하기(LAST_DAY)
SELECT '2019/05/22' as 날짜, LAST_DAY('2019/05/22') as "마지막 날짜" 
    FROM DUAL; --5월의 말일 출력
    
SELECT LAST_DAY(SYSDATE) - SYSDATE as "남은 날짜"
    FROM DUAL; --오늘부터 이번달 말일까지 총 며칠이 남았는지 출력
    
SELECT ename, hiredate, LAST_DAY(hiredate)
    FROM emp
    WHERE ename='KING'; --KING 사원 이름, 입사일, 입사한 달의 마지막 날짜
    
    