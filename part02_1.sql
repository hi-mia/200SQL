--16. 대소문자 변환 함수 배우기 (UPPER, LOWER, INITCAP)
SELECT UPPER(ename), LOWER(ename), INITCAP(ename)
    FROM emp;

SELECT ENAME, SAL
    FROM emp
    WHERE LOWER(ename)='scott';

/*
결과: KING / king / King

upper 함수: 대문자 출력
lower 함수: 소문자 출력
initcap 함수: 첫 번재 철자만 대문자, 나머지는 소문자

함수(function): 다양한 데이터 검색을 위해 필요한 기능

함수의 종류: 단일행 함수 / 다중 행 함수
-단일행 함수: 하나의 행을 입력받아 하나의 행을 반환하는 함수
ex) 문자함수, 숫자함수, 날짜함수, 변환함수, 일반함수

-다중 행 함수: 여러 개의 행을 입력받아 하나의 행을 반환하는 함수
ex) 그룹함수

문자함수: UPPER, LOWER, INICAP, SUBSTR, LENGTH, CONCAT, INSTR, TRIM, LPAD, RPAD 등
*/


--17. 문자에서 특정 철자 추출하기(SUBSTR)
SELECT SUBSTR('SMITH', 1,3)
    FROM DUAL;              --SMI
--SUBSTR 함수: 문자에서 특정 위치의 문자열을 추출, 1부터 시작


--18. 문자열의 길이를 출력하기(LENGTH)
SELECT ename, LENGTH(ename)
    FROM emp;

SELECT LENGTH('가나다라마')
    FROM DUAL;              --5
--LENGTH 함수: 문자열의 길이를 출력하는 함수 / 한글도 마찬가지로 문자길이 출력

SELECT LENGTHB('가나다라마')
    FROM DUAL;              --15
--LENGTHB: 바이트의 길이를 반환 / 한글은 한글자에 3바이트


--19. 문자에서 특정 철자의 위치 출력하기(INSTR)
SELECT INSTR('SMITH', 'M')
    FROM DUAL;              --2
--INSTR 함수: 문자에서 특정 철자의 위치를 출력하는 함수

--이메일에서 naver.com만 추출하기: INSTR, SUBSTR
SELECT INSTR('abcdefg@naver.com', '@')
    FROM DUAL; --@의 위치 추출: 8

SELECT SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1)
    FROM DUAL;        --naver.com

--naver만 출력
SELECT RTRIM(SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1), '.com')
    FROM DUAL; --RTRIM: 오른쪽에 있는 .com을 잘라냄


--20. 특정 철자를 다른 철자로 변경하기(REPLACE)
SELECT ename, REPLACE(sal, 0, '*') -- 0을 *로 변환 (5***)
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
    FROM test_ename;        --김*호, 안*수, 최*희


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

/*
LTRIM('smith', 's'): smith를 출력하는데 왼쪽 철자인 s를 잘라서 출력
RTRIM('smith', 'h'): smith를 출력하는데 오른쪽 절차인 h를 잘라서 출력
TRIM('s' from 'smiths'): smiths를 출력하는데 양쪽의 s를 잘라서 출력 
*/

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
    FROM dual; --소수점 이후 2번째 자리(6)에서 반올림: 876.6
    
SELECT '876.567' as 숫자, ROUND(876.567, 2)
    FROM dual;  --소수점 이후 3번째 자리 반올림: 876.57
    
SELECT '876.567' as 숫자, ROUND(876.567, -1)
    FROM dual;  --소수점 이전 일의 자리: 880

SELECT '876.567' as 숫자, ROUND(876.567, -2)
    FROM dual;  --소수점 이전 십의 자리: 900
    
SELECT '876.567' as 숫자, ROUND(876.567, 0)
    FROM dual;  --0의 자리는 소수점자리, 0의 자리 기준으로 두고 소수점 이후 첫번재 자리에서 반올림: 877
SELECT '876.567' as 숫자, ROUND(876.567)
    FROM dual; --위와 동일 결과

/*
숫자    8   7   6   .   5   6   7
자리   -3  -2  -1   0   1   2   3
*/


--24. 숫자를 버리고 출력하기(TRUNC)
SELECT '876.567' as 숫자, TRUNC(876.567, 1)
    FROM dual; --소수점 두 번째 자리인 6과 그 이후 숫자 버림: 876.5
    
SELECT '876.567' as 숫자, TRUNC(876.567, 2)
    FROM dual;  --876.56
    
SELECT '876.567' as 숫자, TRUNC(876.567, -1)
    FROM dual;  --870
    
SELECT '876.567' as 숫자, TRUNC(876.567, -2)
    FROM dual;  --800
    
SELECT '876.567' as 숫자, TRUNC(876.567, 0)
    FROM dual;  --876
SELECT '876.567' as 숫자, TRUNC(876.567)
    FROM dual;   --위와 동일 결과

/*
숫자    8   7   6   .   5   6   7
자리   -3  -2  -1   0   1   2   3
*/    


--25. 나눈 나머지 값 출력하기(MOD)
SELECT MOD(10, 3)
    FROM DUAL; --10을 3으로 나눈 나머지 값: 1
    
SELECT empno, MOD(empno,2)
    FROM emp; --사원 번호가 홀수이면 1, 짝수이면 0 출력
    
SELECT empno, ename
    FROM emp
    WHERE MOD(empno,2) = 0; --사원 번호가 짝수인 사원들의 사원 번호와 이름을 출력
    
SELECT FLOOR(10/3)
    FROM DUAL; --10을 3으로 나눈 몫
--FLOOR(10/3): 3과 4 사이에서 가장 바닥에 해당하는 값인 출력(3)
    
    
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
    FROM dual; --2018.10.1에서 2019.6.1 사이의 총 일수: 243

--TO_DATE함수: 연도,달,일 명시(RRRR-MM-DD)

SELECT ROUND((TO_DATE('2019-06-01', 'RRRR-MM-DD')-TO_DATE('2018-10-01', 'RRRR-MM-DD'))/7) 
    AS "총 주수"
    FROM dual; --2018.10.1에서 2019.6.1 사이의 총 주(week) 수 출력: 35


--27. 개월 수 더한 날짜 출력하기(ADD_MONTHS)
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100)
    FROM DUAL; -- 2019.5.1일로부터 100달 뒤의 날짜 (27/09/01)
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100
    FROM DUAL; --100일 뒤의 날짜 (19/08/09)
    
--달의 기준 30일? 31일? : ADD_MONTH함수 or interval 함수
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '100' month
    FROM DUAL;   --27/09/01
    
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '1-3' year(1) to month
    FROM DUAL;   --20/08/01
    
--INTERVAL 표현식: year, month, day, hour, minute, second까지 다양하게 지정 가능
--INTERVAL 사용시 연도가 한 자리인 경우는 YEAR 사용, 연도가 3자리인 경우는 YEAR(3)을 사용

SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + interval '3' year
    FROM DUAL; --2019.5.1일에서 3년 후의 날짜 반환(22/05/01)
    
--TO_YMINTERVAL: 2019.5.1일부터 3년 개월 후의 날짜를 출력할 수 있음 
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + TO_YMINTERVAL('03-05') as 날짜
    FROM dual;  --22/10/01

/*
INTERVAL 표현식
-INTERVAL '4' YEAR              An interval of 4 years 0 months
-INTERVAL '123' YEAR(3)         An interval of 123 years 0 months
-INTERVAL '6' MONTHS            An interval of 6 months
-INTERVAL '600' MONTHS(3)       An interval of 600 months
-INTERVAL '400' DAY(3)          400 days
-INTERVAL '10' HOUR             10 hours
-INTERVAL '10' MINUTE           10 minutes
-INTERVAL '4' DAY               4 days
-INTERVAL '25' HOUR             25 hours
-INTERVAL '40' MINUTE           40 minutes
-INTERVAL '120' HOUR(3)         120 hours
*/


--28. 특정 날짜 뒤에 오는 요일 날짜 출력하기(NEXT_DAY) 
SELECT '2019/05/22' as 날짜, NEXT_DAY('2019/05/22', '월요일')
    FROM DUAL; -- 2019년 5월 22일로부터 바로 돌아올 월요일의 날짜 (19/05/27)
    
SELECT SYSDATE as "오늘 날짜"
    FROM DUAL; --오늘 날짜 출력
    
SELECT NEXT_DAY(SYSDATE, '화요일') as "다음 날짜"
    FROM DUAL; --오늘부터 앞으로 돌아올 화요일의 날짜 출력

--함수 중첩 사용 가능
SELECT NEXT_DAY(ADD_MONTHS('2019/05/22', 100), '화요일') as "다음 날짜"
    FROM DUAL; --2019.5.22일부터 100달 뒤에 돌아오는 화요일의 날짜 (27/09/28)
    
SELECT NEXT_DAY(ADD_MONTHS(sysdate, 100), '월요일') as "다음 날짜"
    FROM DUAL; --오늘부터 100달 뒤에 돌아오는 월요일 날짜


--29. 특정 날짜가 있는 달의 마지막 날짜 출력하기(LAST_DAY)
SELECT '2019/05/22' as 날짜, LAST_DAY('2019/05/22') as "마지막 날짜" 
    FROM DUAL; --2019년 5월의 말일 출력(19/05/31)
    
SELECT LAST_DAY(SYSDATE) - SYSDATE as "남은 날짜"
    FROM DUAL; --오늘부터 이번달 말일까지 총 며칠이 남았는지 출력
    
SELECT ename, hiredate, LAST_DAY(hiredate)
    FROM emp
    WHERE ename='KING'; --KING 사원 이름, 입사일, 입사한 달의 마지막 날짜
    

--30. 문자형으로 데이터 유형 변환하기(TO_CHAR)
SELECT ename, TO_CHAR(hiredate, 'DAY') as 요일, TO_CHAR(sal, '999,999') as 월급
    FROM emp
    WHERE ename='SCOTT'; --사원 이름, 입사한 요일, 월급에 천단위 구분 컴마(3,000)
    
/*
TO_CHAR함수: 숫자형 데이터 유형 -> 문자형 변환 OR 날짜형 데이터 유형 -> 문자형 변환
TO_CHAR(hiredate, 'DAY'): 입사일을 요일로 출력
TO_CHAR(sal, '999,999'): 월급을 출력할 때 천 단위를 표시하여 출력
*/

SELECT hiredate, TO_CHAR(hiredate,'RRRR') as 연도, TO_CHAR(hiredate, 'MM') as 달,
                TO_CHAR(hiredate, 'DD') as 일, TO_CHAR(hiredate, 'DAY') as 요일
        FROM emp
        WHERE ename='KING';
        
/*
날짜를 문자로 출력할 때 사용할 수 있는 날짜 포맷
    연도: RRRR, YYYY, RR, YY
    월: MM, MON
    일: DD
    요일: DAY, DY
    주: WW, IW, W
    시간: HH, HH24
    분: MI
    초: SS
*/


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
--숫자9는 자릿수 / 이 자리에 0~9까지 어떤 숫자가 와도 관계 없음 / 쉼표(,)는 천 단위를 나타내는 표시
    
SELECT ename as 이름, TO_CHAR(sal*200, '999,999,999') as 월급
    FROM emp; --천단위와 백만단위를 표시 예제
    
--알파뱃 L: 화폐 단위 \(원화) 붙여 출력 가능
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
/*
sal은 숫자형 데이터 칼럼인데 '3000'을 문자형으로 비교
-> 숫자형=문자형 비교(X) / 숫자형=숫자형 비교(O)
오라클이 알아서 숫자형=숫자형으로 암시적 형변환 하기 때문
오라클은 문자형과 숫자형 두 개를 비교할 때는 문자형을 숫자형으로 변환함
*/

CREATE TABLE EMP32
(ENAME VARCHAR2(10),
SAL VARCHAR2(10)); --여기서 SAL 데이터는 문자형

INSERT INTO EMP32 VALUES('SCOTT', '3000');
INSERT INTO EMP32 VALUES('SMITH', '1200');
COMMIT;

SELECT ename, sal
    FROM emp32
    WHERE sal = '3000'; --문자형 = 문자열
    
SELECT ename, sal
    FROM emp32
    WHERE sal = 3000; --문자형 = 숫자형 (암시적 형변환) / 오라클이 내부적 숫자형=숫자형 비교
    
SELECT ename, sal
    FROM emp32
    WHERE TO_NUMBER(SAL) = 3000; --SAL을 TO_NUMBER(SAL)로 변환
    
/*
SET AUTOUT ON: SQL을 실행할 때 출력되는 결과와 SQL을 실행하는 실행 계획을 한번 보여달라는 SQLPLUS 명령어
계획: 오라클이 SQL을 실행할 때 어떠한 방법으로 데이터를 검색하겠다는 계획서

이 계획서를 보면 오라클이 암시적으로 문자형을 숫자형으로 변환했음 알 수 있음
(filter(TO_NUMBER("SAL")=3000))
*/

SET AUTOT ON

SELECT ename, sal
    FROM emp32
    WHERE SAL = 3000;


--33. NULL 값 대신 다른 데이터 출력하기(NVL, NVL2)
SELECT ename, comm, NVL(comm, 0)
    FROM emp; --커미션이 NULL인 사원들은 0으로 출력
    
SELECT ename, sal, comm, sal+comm
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST');
    
SELECT ename, sal, comm, NVL(comm, 0), sal+NVL(comm,0)
    FROM emp
    WHERE job IN('SALESMAN', 'ANALYST'); --NULL값 0 처리
    
 --NVL2 함수 이용
 SELECT ename, sal, comm, NVL2(comm, sal+comm, sal)
    FROM emp
    WHERE job IN ('SALESMAN', 'ANALYST'); --NULL(X): sal+comm / NULL(O): sal 출력
   