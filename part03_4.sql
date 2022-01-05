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
