--111. SQL로 알고리즘 문제 풀기 1 (구구단 2단 출력)

WITH LOOP_TABLE as (SELECT LEVEL as NUM
                        FROM DUAL
                        CONNECT BY LEVEL <= 9)
    SELECT '2' || 'x' || NUM || '=' || 2 * NUM AS "2단"
        FROM LOOP_TABLE;

/*
계층형 질의문을 이용하면 루프(LOOP) 문 SQL 구현 가능
1) 숫자 1번부터 9번까지 출력한 결과를 WITH절을 이용하여 LOOP_TABLE로 저장
2) LOOP_TALBE에서 숫자를 불러와 연결 연산자를 이용하여 구구단 2단 문자열을 구성
*/

--WITH절의 TEMP 테이블인 계층형 질의문만 따로 실행한 결과
SELECT LEVEL as NUM
    FROM DUAL
    CONNECT BY LEVEL <= 9; --CONNECT BY절 LEVEL 조건에 명시한 숫자 9까지 1부터 출력됨


--112. SQL로 알고리즘 문제 풀기 2 (구구단 1단 ~ 9단 출력)
WITH LOOP_TABLE AS (SELECT LEVEL AS NUM
                                FROM DUAL
                                CONNECT BY LEVEL <= 9),
      GUGU_TABLE AS (SELECT LEVEL + 1 AS GUGU
                                FROM DUAL
                                CONNECT BY LEVEL <= 8)
    SELECT TO_CHAR(A.NUM) || 'X' || TO_CHAR(B.GUGU) || ' = ' ||
            TO_CHAR(B.GUGU * A.NUM) as 구구단
    FROM LOOP_TABLE A, GUGU_TABLE B;

/*
WITH절 + 계층형 질의문 -> 이중 루프(LOOP)문 구현 가능

1) 계층형 질의문을 이용하여 숫자 1번부터 9번까지 출력한 결과를 WITH절을 이용하여 LOOP_TABLE로 저장
2) 계층형 질의문을 이용하여 숫자 2번부터 9번까지 출력한 결과를 WITH절을 이용하여 GUGU_TABLE로 저장
3) LOOP_TABLE과 GUGU_TABLE에서 숫자를 각각 불러와 구구단 전체를 출력하는 문장을 연결 연산자로 만듦
WHERE절에 조인 조건절이 없는 조인이므로 전체를 다 조인해서 결과를 출력함
*/

--1단만 출력
SELECT LEVEL as NUM
    FROM DUAL
    CONNECT BY LEVEL <= 9; --1~9
    
SELECT LEVEL+1 as NUM
    FROM DUAL
    CONNECT BY LEVEL <=8; --2~9


--113. SQL로 알고리즘 문제 풀기 3 (직각삼각형 출력)
WITH LOOP_TABLE as (SELECT LEVEL as NUM
                    FROM DUAL
                    CONNECT BY LEVEL <=8)
SELECT LPAD('★', num, '★') as STAR
    FROM LOOP_TABLE;

/*
계층형 질의문과 LPAD를 이용하면 SQL로 직각삼각형을 그릴 수 있음

1)계층형 질의문을 이용하여 숫자 1번부터 8번까지 출력한 결과를 WITH절을 이용하여 LOOP_TABLE로 저장
2)LPAD를 이용하여 NUM에서 출력되는 숫자만큼 별(★)을 채워 넣어 출력함
LAPD의 두번째 인자의 숫자만큼 자릿수를 잡고 첫 번째 인자 값인 별(★)을 먼저 출력하고
나머지 자리에 별(★)을 채워 넣음
*/

--전체 10자리를 잡고 별(★) 하나를 출력한 후 나머지 9자리에 별(★)을 채워넣음
SELECT LPAD('★', 10, '★') as STAR
    FROM DUAL;


--114. SQL로 알고리즘 문제 풀기 4 (삼각형 출력)
WITH LOOP_TABLE as ( SELECT LEVEL   as NUM
                                 FROM DUAL
                                 CONNECT BY LEVEL <= 8 )
  SELECT LPAD(' ',  10-num, ' ')  ||  LPAD('★',  num, '★') as "Triangle"
    FROM LOOP_TABLE ;

/*
계층형 질의문과 LPAD 2개를 연결 연산자로 연결하여 SQL로 삼각형 그리기

1) 계층형 질의문을 이용하여 숫자 1번부터 8번까지 출력한 결과를 WITH절을 이용하여 LOOP_TABLE로 저장
2) 첫 번째 LPAD는 10-num만큼 자릿수를 잡고 그 중 하나를 공백('')으로 출력하고 나머지 자리에
공백('')을 채워 넣음. 그리고 연결 연산자(||)로 별표(★)를 출력할 LPAD를 작성함
두 번째 LPAD는 NUM만큼 전체 자릿수를 잡고 별표 하나를 출력한 후 나머지 자리를 별표로 채워넣음
첫 번째 LPAD는 전체 자리를 잡는 숫자가 점점 줄어들면서 공백이 줄어들고
두 번째 LPAD는 별표가 늘어나면서 점점 삼각형 모양의 형태를 띄게 됨
*/

--치환변수(&)을 이용하면 입력받은 숫자만큼 삼각형 출력 가능
undefine 숫자1 --숫자 1, 2 치환 변수의 값을 초기화
undefine 숫자2

WITH LOOP_TABLE as ( SELECT LEVEL   as NUM
                            FROM DUAL
                            CONNECT BY LEVEL <= &숫자1)
    SELECT LPAD(' ', &숫자2-num, ' ') || LPAD('★', num, '★') as "Triangle"
        FROM LOOP_TABLE; --치환변수 &숫자1/&숫자2에 숫자를 입력


--115. SQL로 알고리즘 문제 풀기 5 (마름모 출력)
undefine p_num
ACCEPT p_num prompt '숫자 입력 : '

SELECT LPAD(' ', &p_num-level, ' ') || RPAD('★', level, '★') as star
            FROM dual
            CONNECT by level <&p_num+1
UNION ALL
SELECT LPAD(' ', level, ' ') || RPAD('★', (&p_num)-level, '★') as star
            FROM dual
            CONNECT BY level < &p_num;
            
/*
p_num: 호스트(HOST) 변수 or 외부 변수
undefine 명령어로 변수에 담겨 있는 내용을 지움

accept: 값을 받아 p_num 변수에 담겠다는 SQL*PLUS 명령어
prompt로 '숫자 입력'을 화면에 출력하고 숫자 입력 옆에 입력한 숫자를 p_num에 입력

lpad('', &p_num-level, ''): p_num에 입력한 숫자에서 LEVEL에 입력되는 숫자만큼 차감해서 공백을 채움
처음엔 공백이 5개 채워졌다가 다음 라인부터 1씩 차감되며 채워짐

바로 옆에 연결 연산자로 연결함 rpad('★', level, '★')는 별(★)을 LEVEL 수만큼 채워 출력함
두개의 함수를 이어붙임 - UNION ALL 집합 연산자를 사용하여 하나의 결과 집합으로 출력함

LPAD('', level, ''): level 수만큼 공백을 채워 출력 / level 수 점점 증가하므로 공백 점점 증가
rpad('★', (&p_num)-level, '★')는 입력받은 숫자 p_num에서 level 수를 차감해 별('★')을 채워 넣음
level 수가 점점 증가하므로 별('★')은 점점 줄어듦
*/


--116. SQL로 알고리즘 문제 풀기 6 (사각형 출력)
undefine p_n1
undefine p_n2
ACCEPT p_n1 prompt '가로 숫자를 입력하세요~';
ACCEPT p_n2 prompt '세로 숫자를 입력하세요~';

WITH LOOP_TABLE as (SELECT LEVEL as NUM
                                FROM DUAL
                                CONNECT BY LEVEL <= &p_n2)
SELECT LPAD('★', &p_n1, '★') as STAR
    FROM LOOP_TABLE;


--117. SQL로 알고리즘 문제 풀기 7 (1부터 10까지 숫자의 합)
undefine p_n
ACCEPT p_n prompt '숫자에 대한 값 입력:~';

SELECT SUM(LEVEL) as 합계
    FROM DUAL
    CONNECT BY LEVEL <= &p_n;


--118. SQL로 알고리즘 문제 풀기 8 (1부터 10까지 숫자의 곱)
undefine p_n
ACCEPT p_n prompt '숫자에 대한 값 입력:~';

SELECT ROUND(EXP(SUM(LN(LEVEL)))) 곱
    FROM DUAL
    CONNECT BY LEVEL <= &p_n;

/*
ln 함수: 밑수가 자연상수(e)인 로그 함수
log1 + log2 + ... + log10 = log(1*2* ... *10)
위의 식을 자연상수의 제곱으로 만들어줌: exp 함수 - Exp(sum(ln(level)))
숫자(1+2+3+...+10)와 자연상수 e는 서로 자리를 바꿀 수 있음
*/


--119. SQL로 알고리즘 문제 풀기 9 (1부터 10까지 짝수만 출력)
undefine p_n
ACCEPT p_n prompt '숫자에 대한 값 입력:';

SELECT LISTAGG(LEVEL, ', ') as 짝수 --level에서 출력되는 숫자 가로로 출력
    FROM DUAL
    WHERE MOD(LEVEL, 2) = 0
    CONNECT BY LEVEL <= &p_n;
 -- DUAL은 결과값만을 보기 위해 사용하는 가상의 테이블


 --120. SQL로 알고리즘 문제 풀기 10 (1부터 10까지 소수만 출력)
undefine p_n
ACCEPT p_n prompt '숫자에 대한 값 입력:';

WITH LOOP_TABLE as (SELECT LEVEL AS NUM
                        FROM DUAL
                        CONNECT BY LEVEL <= &p_n)
                        
SELECT L1.NUM as 소수
    FROM LOOP_TABLE L1, LOOP_TABLE L2
    WHERE MOD(L1.NUM, L2.NUM) = 0
    GROUP BY L1.NUM
    HAVING COUNT(L1.NUM) = 2;

/*
소수는 1과 자기 자신의 수로만 나눌 수 있는 수이므로 자기 자신의 수로 나누기 위해 self join을
수행함. self join 시 모든 숫자와 조인하기 위해 조건을 where절에 작성하지 않음

자기 자신의 수와 나눈 나머지 값이 0이 되는 수로 검색을 제한하며 조인 조건이 없이 셀프조인
-> 건수가 2개씩 출력되는 행을 검색
*/

--소수는 1과 자신의 수로 나눠지므로 다음의 쿼리에서 카운트 되는 건수 2개라면 소수(1로 나눔, 자기자신 나눔)
WITH LOOP_TABLE as ( SELECT LEVEL AS NUM
                        FROM DUAL
                        CONNECT BY LEVEL <= 10)
SELECT L1.NUM, COUNT(L1.NUM)
    FROM LOOP_TABLE L1, LOOP_TABLE L2
    WHERE MOD(L1.NUM, L2.NUM) = 0
    GROUP BY L1.NUM;


--121. SQL로 알고리즘 문제 풀기 11 (최대 공약수)
ACCEPT p_n1 prompt ' 첫 번재 숫자를 입력하세요.';
ACCEPT p_n2 prompt ' 두 번째 숫자를 입력하세요.';

WITH NUM_D AS (SELECT &p_n1 as NUM1, &p_n2 as NUM2
                FROM DUAL)
SELECT MAX(LEVEL) AS "최대 공약수"
    FROM NUM_D
    WHERE MOD(NUM1, LEVEL) = 0
        AND MOD(NUM2, LEVEL) = 0
    CONNECT BY LEVEL <= NUM2;


--122. SQL로 알고리즘 문제 풀기 12 (최소 공배수)
ACCEPT p_N1 prompt ' 첫 번재 숫자를 입력하세요.';
ACCEPT p_N2 prompt ' 두 번째 숫자를 입력하세요.';

WITH NUM_D AS (SELECT &P_N1 NUM1, &P_N2 NUM2
                    FROM DUAL)
SELECT NUM1, NUM2,
        (NUM1/MAX(LEVEL))*(NUM2/MAX(LEVEL))*MAX(LEVEL) AS "최소 공배수"
    FROM NUM_D
    WHERE MOD(NUM1, LEVEL) = 0
        AND MOD(NUM2, LEVEL) = 0
    CONNECT BY LEVEL <= NUM2;


--123. SQL로 알고리즘 문제 풀기 13 (피타고라스의 정리)
ACCEPT NUM1 PROMPT '밑변의 길이를 입력하세요 ~ '
ACCEPT NUM2 PROMPT '높이를 입력하세요 ~ '
ACCEPT NUM3 PROMPT '빗변의 길이를 입력하세요 ~ '

SELECT CASE WHEN
        ( POWER(&NUM1, 2) + POWER(&NUM2, 2)  ) = POWER(&NUM3, 2)
            THEN '직각삼각형이 맞습니다'
            ELSE '직각삼각형이 아닙니다' END AS "피타고라스의 정리"
    FROM DUAL;


--124. SQL로 알고리즘 문제 풀기 14 (몬테카를로 알고리즘)
SELECT SUM(CASE WHEN (POWER(NUM1,2) + POWER(NUM2,2)) <= 1  THEN 1
                ELSE 0 END ) / 100000 * 4 as "원주율"
 FROM ( 
           SELECT DBMS_RANDOM.VALUE(0,1) AS NUM1,
                  DBMS_RANDOM.VALUE(0,1) AS NUM2
             FROM DUAL
             CONNECT BY LEVEL < 100000
        ) ; 
/*
몬테카를로 알고리즘을 이용한 원주율 출력
몬테카를로 알고리즘: 난수를 이용하여 알고자 하는 값을 확률적으로 계산해 내는 알고리즘

[정사각형의 넓이 : 빨간색 부채꼴의 넓이 = 정사각형 안에 들어가는 전체 점의 개수 : 빨간 점의 개수]
부채꼴 안에 들어가는 빨간색 점의 개수 = x²+y² <= 1 조건에 만족하는 x와 y의 개수
POWER함수: 지수함수

DMBS_RANDOM: 난수를 생성하는 패키지
0에서 1사이의 난수 출력: DBMS_RANDOM.VALUE(0,1)
X축에 해당하는 난수 NUM1과 Y축에 해당하는 난수 NUM2를 각각 100,000개 생성

1 : X = 100000 : 빨간색 점의 개수

-> 정사각형 넓이 1 / 부채꼴의 넓이 X / 정사각형의 넓이 100000 / 빨간색 점의 개수 = 빨간색 부채꼴

X = 빨간색 점의 개수 / 100000

부채꼴 한 변의 길이 = 1
X(부채꼴의 넓이) * 4 = 원의 넓이 = 1 * 1 * 𝝅
*/


--125. SQL로 알고리즘 문제 풀기 15 (오일러 상수 자연상수 구하기)
WITH LOOP_TABLE AS (SELECT LEVEL AS NUM FROM DUAL
                        CONNECT BY LEVEL <= 1000000
                    )
SELECT RESULT
        FROM (
            SELECT NUM, POWER((1+1/NUM) , NUM) AS RESULT
                    FROM LOOP_TABLE
                )
        WHERE NUM = 1000000;

/*
몬테카를로 알고리즘을 이용하여 자연상수 e 값을 출력

최대한 극한값을 표현하기 위해 계층형 질의문으로 1부터 1000000까지의 숫자를 만들어
LOOP_TABLE이라는 WITH절용 임시테이블에 저장

자연상수를 도출하는 식을 POWER 함수로 작성, 
POWER 함수에 매개변수로 LOOP_TABLE에서 만든 숫자를 제공함
숫자가 커질수록 점점 자연상수(e) 값에 근사해짐

가장 마지막으로 제공되는 숫자인 1000000으로 출력을 제한함
*/