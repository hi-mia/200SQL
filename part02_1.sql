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

--naver만 출력
SELECT RTRIM(SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com', '@')+1), '.com')
    FROM DUAL; --RTRIM: 오른쪽에 있는 .com을 잘라냄


--20. 특정 철자를 다른 철자로 변경하기(REPLACE)
SELECT ename, REPLACE(sal, 0, '*')
    FROM emp;
