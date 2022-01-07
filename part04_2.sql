--152. 수학식 구현하기 1 (절대값)
set serveroutput on
accept p_num    prompt '숫자를 입력하세요 ~ '

declare
    v_num number(10) := &p_num;

begin
    if v_num >= 0 then
        dbms_output.put_line(v_num);
    else
        dbms_output.put_line(-1 * v_num);
    end if;
end;
/


--153. 수학식 구현하기 2 (직각삼각형)
set serveroutput on
set verify off
accept p_num1 prompt ' 밑변을 입력하세요 ~ '
accept p_num2 prompt ' 높이를 입력하세요 ~ '
accept p_num3 prompt ' 빗변을 입력하세요 ~ '

begin

    if power(&p_num1, 2) + power(&p_num2, 2) = power(&p_num3, 2)
    then
        dbms_output.put_line('직각삼각형입니다. ');

    else
        dbms_output.put_line('직각삼각형이 아닙니다.');
    end if;
end;
/
--밑변과 높이와 빗변을 각각 물어보게 하고 직각삼각형이 맞는지 출력되게 하는 PL/SQL


--154. 수학식 구현하기 3 (지수 함수)
set serveroutput on --dbms.output.put_line을 실행하기 위한 SQL*PLUS 명령어
set verify off
accept p_num1 prompt '밑수를 입력하세요 ~'
accept p_num2 prompt '지수를 입력하세요 ~'

declare 
    v_result number(10) := 1;
    v_num2 number(10) := &p_num1;
    v_count number(10) := 0;
begin
        loop
            v_count := v_count + 1;
            v_result := v_result * v_num2;
            exit when v_count = &p_num2;
        end loop;
            dbms_output.put_line(v_result);
end;
/
--밑수와 지수를 각각 물어보게 하고 계산된 지수 함수의 결과가 출력되게 하는 PL/SQL 작성
/*
밑수와 지수를 각각 입력하여 지수 함수를 구현하는 PL/SQL
입력한 밑수를 지수만큼 반복하여 계속 곱할 수 있도록 LOOP문 사용
(여기서 밑수 2 / 지수 3 입력)

1번 라인에서 v_result에 할당된 숫자 1과 v_num2에 할당된 숫자 2를 곱해서 v_result에 할당함
루프문이 반복되면서 v_result의 2와 v_num2의 2가 곱해지며 v_result의 값이 2, 4, 8 순으로 할당됨

1씩 증가되고 있는 v_count 변수의 값이 3이 될 때 루프문 종료
*/