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
