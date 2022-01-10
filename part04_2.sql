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
/*
밑수와 지수를 각각 입력하여 지수 함수를 구현하는 PL/SQL
입력한 밑수를 지수만큼 반복하여 계속 곱할 수 있도록 LOOP문 사용
(여기서 밑수 2 / 지수 3 입력)

1번 라인에서 v_result에 할당된 숫자 1과 v_num2에 할당된 숫자 2를 곱해서 v_result에 할당함
루프문이 반복되면서 v_result의 2와 v_num2의 2가 곱해지며 v_result의 값이 2, 4, 8 순으로 할당됨

1씩 증가되고 있는 v_count 변수의 값이 3이 될 때 루프문 종료
*/


--155. 수학식 구현하기 4 (로그 함수)
set serveroutput on
set verify off
accept p_num1 prompt '밑수를 입력하세요 ~ '
accept p_num2 prompt '진수를 입력하세요 ~ '

declare 
        v_num1      number(10) := &p_num1;   --밑수 입력받은 p_num1의 값을 할당할 변수 선언
        v_num2      number(10) := &p_num2;   --진수 입력받은 p_num2의 값을 할당할 변수 선언
        v_count     number(10) := 0;         --loop문 반복을 종료할 변수를 0을 할당하여 선언
        v_result    number(10) := 1;         --숫자형 변수로 선언, 숫자1 할당
begin
    loop
        v_count := v_count + 1;               --변수의 값 1씩 증가
        v_result := v_result * v_num1;
        exit when v_result = v_num2;          --v_result가 진수값인 v_num2와 같아질 때 루프문 종료
    end loop;
        dbms_output.put_line(v_count);
end;
/
--밑수와 진수를 각각 물어보게 하고 계산된 로그 함수의 결과가 출력되게 하는 PL/SQL


--156. 수학식 구현하기 5 (순열)
create table sample
( num  number(10),
 fruit   varchar2(10) );

insert into sample values (1, '사과');
insert into sample values (2, '바나나');
insert into sample values (3, '오렌지');
commit;

select * from sample; 

--순열 구현
set serveroutput on
set verify off
declare
    v_name1     sample.fruit%type; --v_name1 변수를 sample 테이블의 fruit 컬럼의 데이터 타입으로 선언

    v_name2     sample.fruit%type;
begin
    for i in 1 .. 3 loop
        for j in 1 .. 3 loop
            select fruit into v_name1 from sample where num = i;
            select fruit into v_name2 from sample where num = j;
            if i != j then
                dbms_output.put_line(v_name1 || ', ' || v_name2);
            end if;
        end loop;
    end loop;
end;
/

/*
순열: 서로 다른 n개 중에서 r개를 택하여 일렬로 배열하는 것

바깥쪽 루프문을 1부터 3까지 반복하면서 과일 이름이 1번부터 3번까지의 이름을 각각 v_name1 변수에 입력
안쪽 루프문을 1부터 3까지 반복하면서 과일 이름이 1번부터 3번까지의 이름을 각각 v_name2 변수에 입력

i와 j가 서로 같지 않을 때 v_name1과 v_name2를 출력
*/


--157. 수학식 구현하기 6 (조합)
set serveroutput on
declare
    v_name1     sample.fruit%type;
    v_name2     sample.fruit%type;

begin
    for i in 1 .. 3 loop
        for j in 1 .. 3 loop
            select fruit into v_name1 from sample where num = i;
            select fruit into v_name2 from sample where num = j;
            dbms_output.put_line(v_name1 || ',' || v_name2);
        end loop;
    end loop;
end;
/

/*
조합: 서로 다른 n개의 원소 중에서 r개를 선택하여 조를 만들 때, 각각 조들의 모임
combination / 조직하여 모은다

여기서는 i가 1,2,3 일때 각각 j를 1,2,3으로 총 9번을 반복하여 결과 출력
*/


--158. 기초 통계 구현하기 1 (평균값)
set serveroutput on
set verify off
accept p_arr prompt '숫자를 입력하세요 ~ ';

declare
   type arr_type is varray(5) of number(10); --숫자형 데이터 배열 변수 선언(size 5)
   v_num_arr   arr_type := arr_type(&p_arr);
   v_sum  number(10)  := 0; 
   v_cnt  number(10) := 0; 
begin
    for i in 1 .. v_num_arr.count loop
         v_sum :=  v_sum  + v_num_arr(i) ;
         v_cnt  := v_cnt + 1;
    end loop;

dbms_output.put_line( v_sum / v_cnt); 

end;
/

/*
여러 개의 숫자들을 입력받은 후 입력받은 숫자들의 평균값을 출력하는 PL/SQL문

5개의 숫자를 입력 받아 계산하려면 변수가 5개는 필요함,
그런데 여러 개의 값을 한 번에 받아 저장해야하므로 배열 변수가 필요

v_num_arr는 v_num_arr 배열 변수 안의 값 개수인 5를 출력하는 키워드 / 배열 안에 있는 개수만큼
1부터 5까지 다섯 번 루프문을 반복하며 배열의 숫자를 제공
*/


--159. 기초 통계 구현하기 2 (중앙값)
accept p_arr prompt '숫자를 입력하세요 ~ ';
declare
type arr_type is varray(10) of number(10); --10개의 숫자형 데이터 담을 수 있는 배열 변수 타입
    v_num_arr   arr_type    := arr_type(&p_arr); --선언과 동시에 입력받은 숫자들을 배열 변수에 할당받음
    v_n     number(10);
    v_medi      number(10,2);
begin
    v_n := v_num_arr.count;
    if mod(v_n, 2) = 1 then --입력 받은 값의 개수가 홀수라면
        v_medi := v_num_arr((v_n+1)/2);
    else                    --짝수라면
        v_medi := (v_num_arr(v_n/2) + v_num_arr((v_n/2)+1))/2;
    end if;
    dbms_output.put_line(v_medi);
end;
/

/*
여러 개의 숫자들을 입력받은 후 입력받은 숫자들 중에서 중앙값을 출력하는 PL/SQL문 작성

1) 1,2,3,4,5,6,7,8,9 입력
2) 1,2,3,4,5,6,7,8 입력
중앙값 출력은 입력되는 숫자들의 개수가 짝수 개인지 홀수 개인지에 따라 구하는 방법이 달라짐
홀수 개: 가운데 값만 출력 됨 (1)의 경우, 5를 출력)
짝수 개: 가운데 값들의 평균값 출력 (2)의 경우, 4와 5의 평균값 출력)
*/


--160. 기초 통계 구현하기 3 (최빈값)
accept p_num1 prompt '데이터를 입력하세요 ~ '
declare
    type array_t is varray(10) of varchar2(10);
    v_array array_t := array_t(&p_num1);
    v_cnt number(10);
    v_tmp number(10);
    v_max number(10) := 0;
    v_tmp2 number(10);
begin
    for i in 1 .. v_array.count loop
        v_cnt := 1;
        for j in i+1 .. v_array.count loop --변수에 입력된 숫자만큼 루프문 반복
            if v_array(i) = v_array(j) then
                v_tmp := v_array(i);
                v_cnt := v_cnt+1;
            end if;
        end loop;

        if v_max <= v_cnt then --새로운 최빈값이 나타나면 이 값으로 변경하는 코드
            v_max := v_cnt;
            v_tmp2 := v_tmp;
        end if;
    end loop;
dbms_output.put_line('최빈값은 ' || v_tmp2 || '이고 ' || v_max || '개입니다');
end;
/

/*
여러 개의 숫자들을 입력받은 후 입력받은 숫자들 중에서 최빈값을 출력하는 PL/SQL문 작성

최빈값: 데이터들 중 가장 빈도수가 높은 데이터 / 데이터의 중심 성향을 파악하는데 사용하는 통계치
최빈값을 출력하기 위해서는 데이터들을 메모리에 저장하고 저장된 데이터를 하나씩 카운트하여 그중에
가장 빈도수가 높은 데이터가 무엇인지 비교하여 출력

인접한 2개의 숫자를 서로 비교하기 위해 j 값을 담는 루프문을 구현
v_array(i) = v_array(j)는 v_array(i) = v_array(i+1)과 같음

v_num_arr(1) | v_num_arr(2) | v_num_arr(3) | ... | v_num_arr(8)
    1               2           2           ...     5

인접한 두 개 배열의 숫자가 동일하다면 v_tm에 숫자값을 할당하고 v_cnt를 1 증가시킴

v_cnt가 v_max보다 크다면 v_max에 v_cnt값을 할당함
(새로운 최빈값이 나타나면 이 값으로 변경하는 코드 - v_tmp2에 v_tmp의 값을 할당함)

최종적으로 담은 v_max 값을 최빈값으로 출력함
*/


--161. 기초 통계 구현하기 4 (분산과 표준편차)
set serveroutput on
set verify off
accept p_arr prompt '숫자를 입력하세요 ~ ';

declare
    type    arr_type is varray(10) of number(10);
    v_num_arr   arr_type := arr_type(&p_arr);
    v_sum       number(10, 2) := 0;   --선언하면서 숫자 0을 할당함
    v_cnt       number(10, 2) := 0;
    v_avg       number(10, 2) := 0;
    v_var       number(10, 2) := 0;

begin
    for i in 1 .. v_num_arr.count loop
        v_sum := v_sum + v_num_arr(i);
        v_cnt := v_cnt + 1;
    end loop;

    v_avg := v_sum / v_cnt;

    for i in 1 .. v_num_arr.count loop
        v_var := v_var + power(v_num_arr(i) - v_avg, 2);
    end loop;

    v_var := v_var / v_cnt;

    dbms_output.put_line('분산값은: ' || v_var);
    dbms_output.put_line('표준편차는: ' || round(sqrt(v_var)));
end;
/

/*
여러 개의 숫자들을 입력받은 후 그 숫자들의 분산과 표준편차를 출력하는 PL/SQL문

분산: 데이터의 흩어진 정도를 나타내는 지표, 편차 제곱의 합
분산이 크면 평균에서 벗어난 데이터가 많은 것, 작으면 평균 주위의 데이터가 몰려 있는 것 의미

표준편차: 분산의 제곱근, 평균으로부터 원래 데이터에 대한 오차 범위의 근사값
분산은 편차에 제곱을 하여 실제 값과는 차이가 많이 나므로 데이터의 흩어진 정도를 파악하기 위해서는
분산을 사용하지 않고 분산에 제곱근을 씌운 표준편차를 사용함

*/


--162. 기초 통계 구현하기 5 (공분산)
accept p_arr1 prompt '키를 입력하세요 ~ ';
accept p_arr2 prompt '체중을 입력하세요 ~ ';

declare
    type arr_type is varray(10) of number(10, 2);
    v_num_arr1      arr_type := arr_type(&p_arr1);
    v_sum1          number(10, 2) := 0;
    v_avg1          number(10, 2) := 0;

    v_num_arr2      arr_type := arr_type(&p_arr2);
    v_sum2          number(10, 2) := 0;
    v_avg2          number(10, 2) := 0;

    v_cnt           number(10, 2);
    v_var           number(10, 2) := 0;

begin

    v_cnt := v_num_arr1.count;

    for i in 1 .. v_num_arr1.count loop
        v_sum1 := v_sum1 + v_num_arr1(i);
    end loop;
    
      v_avg1 := v_sum1 / v_cnt;
    
    for i in 1 .. v_num_arr2.count loop
            v_sum2 := v_sum2 + v_num_arr2(i);
    end loop;

    v_avg2 := v_sum2 / v_cnt;

    for i in 1 .. v_cnt loop
        v_var := v_var + (v_num_arr1{i) - v_avg1) * (v_num_arr2(i) - v_avg2) / v_cnt;
    end loop;

    dbms_output.put_line('공분산 값은: ' || v_var);
end;
/

/*
5명의 키와 체중 데이터를 각각 입력받은 후 공분산 값을 출력하는 PL/SQL문 작성

공분산: 두 개의 다른 변량 사이의 상관관계를 수치화하여 나타내는 방법
양의 상관관계: 하나의 값이 크면 다른 하나의 변량도 큰 값을 나타내는 상관관계
공분산 값이 0보다 크면 양의 상관 / 0보다 작으면 음의 상관관계 / 0에 근사하면 상관관계가 없음
*/


--163. 기초 통계 구현하기 6 (상관계수)
set serveroutput on
set verify off

accept p_arr1 prompt'키를 입력하세요 ~ ';
accept p_arr2 prompt '체중을 입력하세요 ~ ';

declare
    type arr_type is varray(10) of number(10,2);
    v_num_arr1    arr_type := arr_type(&p_arr1);
    v_sum1   number(10,2)  := 0; 
    v_avg1   number(10,2) := 0;

    v_num_arr2    arr_type := arr_type(&p_arr2);
    v_sum2   number(10,2)  := 0; 
    v_avg2   number(10,2) := 0;

    v_cnt    number(10,2);
    cov_var    number(10,2) := 0;

    v_num_arr1_var  number(10,2) := 0;
    v_num_arr2_var  number(10,2) := 0;
    v_corr   number(10,2) ;
    
begin

   v_cnt :=  v_num_arr1.count ;

    for i in 1 .. v_num_arr1.count loop
         v_sum1 :=  v_sum1  + v_num_arr1(i) ;
    end loop;
    
    v_avg1 := v_sum1 / v_cnt;

   for i in 1 .. v_num_arr2.count loop
         v_sum2 :=  v_sum2  + v_num_arr2(i) ;
    end loop;

   v_avg2 := v_sum2 / v_cnt; 

  for i in 1 .. v_cnt loop
   cov_var:= cov_var+  (v_num_arr1(i) - v_avg1) * ( v_num_arr2(i) - v_avg2) / v_cnt;
   v_num_arr1_var := v_num_arr1_var  +  power(v_num_arr1(i) - v_avg1,2);
   v_num_arr2_var := v_num_arr2_var  +  power(v_num_arr2(i) - v_avg2,2);
  end loop;

       v_corr := cov_var /  sqrt( v_num_arr1_var * v_num_arr2_var ) ;
        dbms_output.put_line('상관관계는: ' || v_corr);
end;
/

/*
키와 체중 데이터를 각각 입력받은 후 키와 체중 간의 상관관계가 있는지 PL/SQL문으로 구현

상관관계 분석: 한 변수의 변화에 따른 다른 변수의 변화 정도와 방향을 예측하는 분석
상관계수: 공분산과 마찬가지로 두 개의 다른 변량 사이의 상관관계를 수치화하여 나타내는 방법
        + 공분산에서 측정할 수 없었던 상관의 정도까지 측정할 수 있는 지표
상관계수: -1 이상 1이하의 수 / 1에 가까울수록 강한 양의 상관관계, -1에 가까울수록 강한 음의 상관관계
            0에 가까우면 상관관계 없음
*/


--164. 기초 통계 구현하기 7 (확률)
set serveroutput on
set verify off

declare
    v_loop number(10) := 10000;
    v_coin number(10) ;
    v_0  number(10) := 0 ;
    v_1  number(10) := 0 ; 

begin
    for i in 1..v_loop loop    

        select  round(dbms_random.value(1,2)) into v_coin
              from dual;

        if  v_coin = 1 then 
            v_0 := v_0 + 1;

        else  
            v_1 := v_1+1;
     
        end if;
    end loop;

    dbms_output.put_line('동전이 앞면이 나올 확률: ' || round((v_0/v_loop),2));
    dbms_output.put_line('동전이 뒷면이 나올 확률: ' || round((v_1/v_loop),2));  

end;
/

/*
하나의 동전을 여러 번 던졌을 때 앞면과 뒷면이 나올 확률이 각각 50%임을 확인하는 PL/SQL

동전던지기 10000번 반복
dbms_random 패키지로 1 또는 2의 숫자를 랜덤으로 생성하여 v_coin에 입력
v_coin에 1이 담기면 동전 뒷면 나타내는 v_0의 개수 증가
v_coin에 2가 담기면 동전 앞면 나타내는 v_1의 개수 증가

동전 뒷면/앞면이 나온 개수를 전체 반복수인 10000으로 나누어 확률 구함
*/


--165. 기초 통계 구현하기 8 (확률)
set serveroutput on
set verify off

declare
    v_loop number(10) := 10000;
    v_coin1 number(10);
    v_coin2 number(10);
    v_0 number(10) := 0;
    v_1 number(10) := 0;
    v_2 number(10) := 0;

begin
    for i in 1..v_loop loop
        select round(dbms_random.value(0,1)), round(dbms_random.value(0,1))
                            into v_coin1, v_coin2
                from dual;
        
        if v_coin1 = 0 and v_coin2 = 0 then
            v_0 := v_0 + 1;

        elsif v_coin1 = 1 and v_coin2 = 1 then
            v_1 := v_1+1;
        else
            v_2 := v_2+1;
        end if;
    end loop;

    dbms_output.put_line('동전 둘 다 앞면이 나올 확률: ' || round((v_0/v_loop),2));
    dbms_output.put_line('동전 둘중 하나가 앞면, 다른 하나는 뒷면이 나올 확률: ' || round((v_2/v_loop),2));
    dbms_output.put_line('동전 둘 다 뒷면이 나올 확률: ' || round((v_1/v_loop),2));
end;
/    

/*
동전 두 개를 동시에 던져 둘 다 앞면이 나올 확률과 둘 다 뒷면이 나올 확률, 하나는 앞면 하나는 뒷면이
나올 확률 각각 출력 PL/SQL
*/


--166. 기초 통계 구현하기 9 (이항 분포)
create or replace function mybin
(p_h in number)
return number
is
    v_h number(10) := p_h;
    v_sim number(10) := 100000;
    v_cnt number(10) := 0;
    v_cnt2 number(10) := 0;
    v_res number(10,2); 

begin
     for n in 1..v_sim loop
     v_cnt := 0;
          for i in 1..10 loop
               if dbms_random.value<0.5 then
                      v_cnt := v_cnt+1;
              end if;
          end loop;
          if v_cnt=v_h then
                v_cnt2 := v_cnt2+1;
 end if;
    end loop;

    v_res := v_cnt2/v_sim;

 return v_res;
end;
/


SELECT level-1 grade, mybin(level-1) 확률, lpad('■', mybin(level-1)*100, '■') "막대그래프"
  FROM dual
  CONNECT BY level < 12;

/*
동전 던지기의 이항 확률 분포를 PL/SQL문으로 구현

이항 확률 분포: 한번 이상 반복 실시한 베르누이 시행 결과의 합을 변수의 값으로 하는 확률변수의 분포

이항 분포: 동전을 던져 앞면이 나오면 성공으로, 뒷면이 나오면 실패로 하는 동전 던지기를 n번 하였을 경우,
얻을 수 있는 결과값들의 합을 변수 값으로 하는 확률변수의 분포

-mybin이라는 사용자 정의 함수 생성
-함수를 실행할 때 입력받을 데이터를 위해 p_h 매개변수 생성
-함수를 실행했을 때 출력되는 데이터의 유형을 숫자형으로 지정
-동전을 10번 던졌을 때 뒷면이 몇 번 나왔는지를 확인하기 위해 뒷면의 개수를 입력받은 변수를 v_h로 선언
-동전 던지기를 십만 번 수행하기 위해 v_sim 변수에 100000를 할당하여 선언
-동전을 10번 던졌을 때 뒷면이 몇 번 나왔는지 뒷면이 나오는 횟수를 저장하기 위해 v_cnt 변수를
선언하고 숫자 0으로 초기화
-동전을 10번 던졌을 때 뒷면이 나온 개수가 몇 번 나왔는지 세기 위해 v_cnt2 변수를 선언
-동전을 10번 던졌을 때 뒷면이 나오는 횟수인 0부터 10까지의 확률을 저장할 변수 v_res를 선언
-동전 던지기를 십만 번 반복하기 위해 루프문 100000번 수행
-v_cnt 변수에 0을 할당
-동전을 10번 던짐
-한쪽 면이 나오면 v_cnt를 1 증가시킴
-v_cnt가 매개변수에 입력된 숫자(동전 뒷면의 개수)와 동일하다면 v_cnt2를 1 증가시킴
-동전을 10번 던졌을 때 출력되는 뒷면 개수의 확률을 계산함 / v_cnt2를 십만으로 나누어 확률을 계산하여
v_res에 할당
-v_res 변수에 담긴 확률 값을 리턴
*/


--167. 기초 통계 구현하기 10 (정규분포)
set serveroutput on

create or replace procedure probn
 ( p_mu in number,
   p_sig in number,
   p_bin in number)
is

   type arr_type is varray(9) of number(30);

  v_sim number(10) := 10000;
  v_rv number(20,7);
  v_mu number(10) := p_mu;
  v_sig number(10) := p_sig;
  v_nm arr_type := arr_type('',0,0,0,0,0,0,0,'');
  v_cnt arr_type := arr_type(0,0,0,0,0,0,0,0);
  v_rg arr_type := arr_type(-power(2,31),-3,-2,-1,0,1,2,3,power(2,32));

begin
   for i in v_nm.first+1..v_nm.last-1 loop
       v_nm(i) := v_mu-3*p_bin+(i-2)*p_bin;
   end loop;

  for i in 1..v_sim loop
      v_rv := dbms_random.normal*v_sig+v_mu;

        for i in 2..v_rg.count loop
             if v_rv >= v_mu+v_rg(i-1)*p_bin and v_rv < v_mu+v_rg(i)*p_bin then
                    v_cnt(i-1) := v_cnt(i-1)+1;
             end if;
        end loop;
  end loop;

  for i in 1..v_cnt.count loop
dbms_output.put_line(rpad(v_nm(i)||'~'||v_nm(i+1), 10, ' ')||lpad('■',trunc((v_cnt(i)/v_sim)*100),'■'));
  end loop;
end;
/

/*
초등학생 십만 명의 키 숫자 데이터를 랜덤으로 생성하여 십만 명의 키 데이터가 정규분포를 이루는지 PL/SQL문

정규분포: 좌우대칭 종 모양의 연속확률분포
평균값에 가장 많은 데이터가 분포되어 있고 평균과 떨어질수록 데이터가 적게 분포하는 특징
평균과 표준편차로 그 성질 설명 가능
평균: 분포의 중심 / 표준편차: 분포가 흩어진 정도
분포의 표준편차가 클수록 종모양 분포는 옆으로 퍼진 모양 / 표준편차가 작을수록 평균에 집중된 종모양
*/