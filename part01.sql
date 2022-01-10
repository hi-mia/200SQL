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
SELECT ename || '의 직업은 ' || job || '입니다 ' as 직업정보
    FROM emp;


--05. 중복된 데이터를 제거해서 출력하기(DISTINCT)
SELECT DISTINCT job
    FROM emp;

--DISTINCT 대신 UNIQUE를 사용해도 됨
SELECT UNIQUE job
    FROM emp;


--06. 데이터를 정렬해서 출력하기(ORDER BY)
-- 오름차순: ASCENDING, ASC / 내림차순: DESCENDING, DESC
SELECT ename, sal  
    FROM emp
    ORDER BY sal asc;

--컬럼 별칭도 사용 가능, 컬럼 여러개 작성 가능
SELECT ename, sal as 월급
    FROM emp
    ORDER BY 월급 asc;

SELECT ename, deptno, sal
    FROM emp
    ORDER BY deptno asc, sal desc;

--ORDER BY 절에 컬럼명 대신 숫자 적기 가능(숫자는 SELECT절 컬럼의 순서)    
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

--컬럼 별칭인 월급을 WHERE절 검색 조건에 사용하면 에러가 난다(실행 순서: FROM -> WHERE -> SELECT)
SELECT ename as 이름, sal as 월급
    FROM emp
    WHERE 월급 >= 3000; --ERROR!

/* 
비교 연산자: >, <
기타 비교 연산자
BETWEEN AND : ~사이에 있는
LIKE : 일치하는 문자 패턴 검색
>=, <=, =
!=, ^=, <> : 같지 않다
IS NULL : NULL 값인지 여부
IN : 값 리스트 중 일치하는 값 검색
*/


--08. WHERE절 배우기 2 (문자와 날짜 검색)
--문자와 날짜를 검색할 땐 싱글 따옴표 (더블X)
SELECT ename, sal, job, hiredate, deptno
    FROM emp
    WHERE ename='SCOTT';

SELECT ename, hiredate
    FROM emp
    WHERE hiredate = '81/11/17'; 
    
/* 나라마다 날짜형식 다르기 때문에 현재 접속한 세션(session)의 날짜형식 확인 필요
현재 접속한 세션(session)의 날짜 형식은 NSL_SESSION_PARAMETERS를 조회
*세션: 데이터베이스 유저로 로그인해서 로그아웃할 때까지의 한 단위 */
SELECT *
    FROM NLS_SESSION_PARAMETERS
    WHERE PARAMETER = 'NLS_DATE_FORMAT';

/*
날짜 형식에 대한 정의
    YYYY / YY 또는 RR / MM / MON / DD / DAY / DY / D
    HH24 / MI / SS / WW / IW / W / YEAR / MONTH

    YYYY: 연도 4자리
    YY / RR: 연도 2자리
    MM: 달의 2자리 값
    MON: 달의 영문 약어
    DD: 숫자 형식의 일
    DAY: 요일
    DY: 요일 약어
    D: 요일의 숫자
    HH24: 시간(0~24)
    MI: 분(0~59)
    SS: 초(0~59)
    WW: 연의 주
    IW: ISO 표준에 따른 년의 주
    W: 월의 주
    YEAR: 영어 철자로 표기된 년도
    MONTH: 영어 철자로 표기된 달
*/

--YY와 RR은 다르다!
ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD'; --내가 접속한 세션의 파라미터를 변경

SELECT ename, sal
    FROM emp
    WHERE hiredate = '81/11/17'; --출력 결과 없음 / YY: 2081, RR: 1981

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';


--09. 산술 연산자 배우기 (*, /, +, -)
SELECT ename, sal*12 as 연봉
    FROM emp
    WHERE sal*12 >= 36000; --산술 연산자에는 우선순위가 있다(필요하면 괄호 사용)

SELECT ename, sal, comm, sal + comm
    FROM emp
    WHERE deptno = 10; --comm값이 NULL값이므로 comm, (sal+comm) 모두 NULL 출력

--NULL 데이터 처리: NVL 함수 사용 (여기선 NULL -> 숫자)
SELECT sal + NVL(comm, 0)
    FROM emp
    WHERE ename = 'KING'; -- 5000 출력


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
    WHERE (sal >= 1000 AND sal <= 3000); --동일한 결과

/*
BETWEEN 하한값 AND 상한값 (O)
BETWEEN 상한값 AND 하한값 (X)
BETWEEN을 사용하는 것이 가독성이 더 좋다
*/

SELECT ename, sal
    FROM emp
    WHERE sal NOT BETWEEN 1000 AND 3000; --월급이 1000에서 3000사이가 '아닌' 사원들

SELECT ename, sal
    FROM emp
    WHERE (sal < 1000 OR sal > 3000); --위와 동일한 결과, '='이 붙지 않는다!

--날짜 + BETWEEN
SELECT ename, hiredate
    FROM emp
    WHERE hiredate BETWEEN '1982/01/01' AND '1982/12/31';


--12. 비교 연산자 배우기 3 (LIKE)
SELECT ename, sal
    FROM emp
    WHERE ename LIKE 'S%'; --이름의 첫글자가 S로 시작하는 사원들

SELECT ename
    FROM emp
    WHERE ename LIKE '_M%'; --이름의 두 번째 철자가 M인 사원

SELECT ename
    FROM emp
    WHERE ename LIKE '%T'; --이름 끝 글자가 T로 끝나는 사원

SELECT ename
    FROM emp
    WHERE ename LIKE '%A%'; --이름이 A가 포함된 사원들

/*
%, _는 와일드 카드
와일드 카드(Wild Card): 이 자리에 어떠한 철자가 와도 상관없고 철자의 개수가 몇 개가 되든 상관 없음
와일드 카드가 되려면 이퀄 연산자(=)가 아닌 LIKE 연산자 사용

%: 0개 이상의 임의 문자와 일치
_: 하나의 문자와 일치
*/


--13. 비교 연산자 배우기 4 (IS NULL)
SELECT ename, comm
    FROM emp
    WHERE comm is null;

/*
NULL: 데이터가 할당되지 않은 상태, 알 수 없는 값
NULL 검색: is null 연산자 / =, != 연산자 사용 불가
*/


--14. 비교 연산자 배우기 5 (IN)
SELECT ename, sal, job
    FROM emp
    WHERE job in ('SALESMAN', 'ANALYST', 'MANAGER');

SELECT ename, sal, job
    FROM emp
    WHERE (job = 'SALESMAN' or job = 'ANALYST' or job = 'MANAGER'); --동일 결과    

--이퀄 연산자는 하나의 값만 조회할 수 있는 반면 IN 연산자는 여러 리스트 값 조회 가능

SELECT ename, sal, job
    FROM emp
    WHERE job NOT in('SALESMAN', 'ANALYST', 'MANAGER'); -- '아닌' 사원들

SELECT ename, sal, job
   FROM emp
   WHERE (job != 'SALESMAN' or job != 'ANALYST' or job != 'MANAGER'); --동일 결과


--15. 논리 연산자 배우기 (AND, OR, NOT)
SELECT ename, sal, job
    FROM emp
    WHERE job='SALESMAN' AND sal >= 1200; --데이터 반환(O)

SELECT ename, sal, job
    FROM emp
    WHERE job='ABCDEFG' AND sal >= 1200; --데이터 반환(X)

/*
WHERE TRUE 조건 AND TRUE 조건: 데이터 검색(O)
둘 중 하나라도 조건이 FALSE이면 데이터는 반환되지 않는다

TRUE AND TRUE => TRUE
TRUE AND FALSE => FALSE
TRUE OR FALSE => TRUE (둘 중 하나만 TRUE여도 TRUE를 반환)
TRUE AND NULL => NULL

<AND 연산자 진리 연산표>

    AND     TRUE        FALSE       NULL
   TRUE     TRUE        FALSE       NULL
   FALSE    FALSE       FALSE       FALSE
   NULL     NULL        FALSE       NULL


<OR 연산자 진리 연산표>

    OR      TRUE        FALSE       NULL
   TRUE     TRUE        TRUE        TRUE
   FALSE    TRUE        FALSE       NULL
   NULL     TRUE        NULL        NULL


<NOT 연산자 진리 연산표>

    NOT     TRUE        FALSE       NULL
   TRUE     FALSE       TRUE        NULL

*/    