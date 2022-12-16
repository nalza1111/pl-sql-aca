--사원번호를 입력(치환변수사용&)할 경우
--사원들 중 2000년 이후(2000년 포함)에 입사한 사원의 사원번호,
--사원이름, 입사일을 test01 테이블에 입력하고, 2000년 이전에
--입사한 사원의 사원번호, 사원이름, 입사일을 test02 테이블에 입력하시오.
--힌트)
--1. 사원번호를 입력할 경우 사원정보를 가져온다. (select)
--2. 조건에 맞는 테이블에 가져온 사원정보를 입력한다. (insert)
declare
    v_id employees.employee_id%type;
    v_name employees.first_name%type;
    v_date employees.hire_date%type;
begin
    select employee_id, first_name, hire_date
        into v_id, v_name, v_date
        from employees
        where employee_id =&employee_id;
    if to_char(v_date, 'yyyy') < '2000' then
        insert into test02 values(v_id, v_name, v_date);
    else
        insert into test01 values(v_id, v_name, v_date);
    end if;
end;
/
--2번문제
create table emp50
as
  select *
  from   employees
  where  employee_id = 0;

declare
    v_id employees.employee_id%type;
    v_name employees.first_name%type;
    v_date employees.hire_date%type;
begin
    select employee_id, first_name, hire_date
        into v_id, v_name, v_date
        from employees
        where employee_id =&employee_id;
    if to_char(v_date, 'yyyy') < '2000' then
        insert into test02 values(v_id, v_name, v_date);
    else
        insert into test01 values(v_id, v_name, v_date);
    end if;
end;
/
declare
    v_dept employees.department_id%type;
    v_name employees.first_name%type;
    v_date employees.hire_date%type;
begin
    select employee_id, first_name, hire_date
        into v_id, v_name, v_date
        from employees
        where employee_id =&employee_id;
    if to_char(v_date, 'yyyy') < '2000' then
        insert into test02 values(v_id, v_name, v_date);
    else
        insert into test01 values(v_id, v_name, v_date);
    end if;
end;
/
select * from emp10;
declare
    v_EMPLOYEE_ID   employees.EMPLOYEE_ID%type;
    v_FIRST_NAME    employees.FIRST_NAME%type;
    v_LAST_NAME     employees.LAST_NAME%type;
    v_EMAIL         employees.EMAIL%type;
    v_PHONE_NUMBER  employees.PHONE_NUMBER%type;
    v_HIRE_DATE     employees.HIRE_DATE%type;
    v_JOB_ID        employees.JOB_ID%type;
    v_SALARY        employees.SALARY%type;
    v_COMMISSION_PCT employees.COMMISSION_PCT%type;
    v_MANAGER_ID    employees.MANAGER_ID%type;
    v_DEPARTMENT_ID employees.DEPARTMENT_ID%type;
begin
    select *
        into    v_EMPLOYEE_ID, v_FIRST_NAME, v_LAST_NAME,
                v_EMAIL, v_PHONE_NUMBER, v_HIRE_DATE,
                v_JOB_ID, v_SALARY, v_COMMISSION_PCT,
                v_MANAGER_ID, v_DEPARTMENT_ID
        from employees
        where employee_id =&employee_id;
        
    if v_DEPARTMENT_ID = 20 then
        insert into emp20 values(v_EMPLOYEE_ID, v_FIRST_NAME, v_LAST_NAME,
                                v_EMAIL, v_PHONE_NUMBER, v_HIRE_DATE,
                                v_JOB_ID, v_SALARY, v_COMMISSION_PCT,
                                v_MANAGER_ID, v_DEPARTMENT_ID);
    elsif v_DEPARTMENT_ID = 30 then
        insert into emp30 values(v_EMPLOYEE_ID, v_FIRST_NAME, v_LAST_NAME,
                                v_EMAIL, v_PHONE_NUMBER, v_HIRE_DATE,
                                v_JOB_ID, v_SALARY, v_COMMISSION_PCT,
                                v_MANAGER_ID, v_DEPARTMENT_ID);
    elsif v_DEPARTMENT_ID = 40 then
        insert into emp40 values(v_EMPLOYEE_ID, v_FIRST_NAME, v_LAST_NAME,
                                v_EMAIL, v_PHONE_NUMBER, v_HIRE_DATE,
                                v_JOB_ID, v_SALARY, v_COMMISSION_PCT,
                                v_MANAGER_ID, v_DEPARTMENT_ID);  
    else
        insert into emp10 values(v_EMPLOYEE_ID, v_FIRST_NAME, v_LAST_NAME,
                                v_EMAIL, v_PHONE_NUMBER, v_HIRE_DATE,
                                v_JOB_ID, v_SALARY, v_COMMISSION_PCT,
                                v_MANAGER_ID, v_DEPARTMENT_ID);
    end if;
end;
/
--5
declare
    v_salary employees.salary%type;
    v_name employees.first_name%type;
    v_newsal employees.salary%type;
begin
    select salary, first_name
        into v_salary, v_name
        from employees
        where employee_id =&employee_id;
    if      v_salary <= 5000 then
            v_newsal := v_salary*1.2;
    elsif   v_salary <= 10000 then
            v_newsal := v_salary*1.15;
    elsif   v_salary <= 15000 then
            v_newsal := v_salary*1.1;
    else
        v_newsal := v_salary;
    end if;
    DBMS_OUTPUT.PUT_LINE(v_salary ||'+'|| v_name ||'+'|| v_newsal);
end;
/
select * from employees;
--6
declare
    v_id employees.employee_id%type;
    v_cur varchar2(30);
begin
    select employee_id
        into v_id
        from employees
        where employee_id = &employee_id;
    if      v_id is null then
            DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다');
    else
        delete from employees
            where employee_id = v_id;
        v_cur := v_id||'(사원번호)'|| sql%rowcount || '삭제됨';
    end if;
    DBMS_OUTPUT.PUT_LINE(v_cur);
end;
/
--6(2) 이게 정답
declare
    v_id employees.employee_id%type;
    v_cur varchar2(30);
begin
    delete from employees
        where employee_id = &employee_id;
        v_cur := sql%rowcount;
    if      v_cur = 0 then
            DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다');
    else
        DBMS_OUTPUT.PUT_LINE(v_cur||'건 삭제됨');
    end if;
end;
/
--7
declare
    v_insertsal number(20);
    v_id employees.employee_id%type;
    v_sal employees.salary%type;
begin
    select employee_id, salary
        into v_id, v_sal
        from employees
        where employee_id =&employee_id;
     
    if  v_id is null then
        DBMS_OUTPUT.PUT_LINE('No search employee');
    else
        v_sal := v_sal+(v_sal*(&v_insertsal/100));
        DBMS_OUTPUT.PUT_LINE('employee_id'||':'||v_id||' new salary : '||v_sal);
    end if;
end;
/
select * from employees;
--7(2)
declare
    --v_insertsal number(20); 밑에 들어가면 없어도 됨
    --v_insertsal number(20) := &v_insertsal; 이렇게도 가능
    v_id employees.employee_id%type;
    v_cur varchar2(30);
begin
    update employees
        set salary = (salary+(salary*(&v_insertsal/100)))
        where employee_id = &employee_id;
        v_cur := sql%rowcount;
    if  v_cur = 0 then
        DBMS_OUTPUT.PUT_LINE('No search employee');
    else
        DBMS_OUTPUT.PUT_LINE('변경완료');
    end if;
end;
/
select * from employees;
--loop1
declare
    v_star  varchar2(20);
begin
    for i in 1..5
    loop
        v_star := '';
        for n in 1..i
        loop
            v_star := v_star||'*';
        end loop;
        DBMS_OUTPUT.PUT_LINE(v_star);
    end loop;
end;
/
declare
  v_star varchar2(10) := '';
begin
  for i in 1..5
    loop
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
  end loop;
end;
/

--loop2
declare
    num number(5):= &num; 
begin
    for i in 1..9
    loop
        DBMS_OUTPUT.PUT_LINE(num ||'*'||i ||'='|| num*i );
    end loop;
end;
/
--loop3
begin
    for i in 2..9
    loop
        for n in 1..9
        loop
        DBMS_OUTPUT.PUT_LINE( i ||'*'|| n ||'='|| i * n);
        end loop;
    end loop;
end;
/
--loop4
begin
    for i in 1..9
    loop
        for n in 1..9
        loop
            if mod(i, 2) = 1 then
                DBMS_OUTPUT.PUT_LINE( i ||'*'|| n ||'='|| i * n);
            end if;
        end loop;
    end loop;
end;
/
--제어문 문제2
create table aaa
(a number(3));

create table bbb
(b number(3));

--###
select * from aaa;
select * from bbb;
delete from aaa;
delete from bbb;
--1
begin
    for i in 1..10
    loop
        insert into aaa values(i);
    end loop;
end;
/
--2
declare
    v_sum number(10) := 0;
    s_sum number(10) := 0;
begin
    for i in 1..10
    loop
        v_sum := v_sum + i;
    end loop;
    
end;
/
--3
begin
    for i in 1..10
    loop
        if mod(i, 2) = 0 then
            insert into aaa values(i);
        end if;
    end loop;
end;
/
--4
declare
    v_sum number(10) := 0;
    s_sum number(10) := 0;
begin
    for i in 1..10
    loop
        if mod(i, 2) = 0 then
            v_sum := v_sum + i;
            insert into bbb values(v_sum);
        end if;
    end loop;
end;
/
--5
declare
    --짝수 합계
    v_sum number(10) := 0; 
    --홀수 합계
    v2_sum number(10) := 0;
begin
    for i in 1..10
    loop
        if mod(i, 2) = 0 then
            v_sum := v_sum + i;
        else
            v2_sum := v2_sum + i;
        end if;
    end loop;
    insert into aaa values(v_sum);
    insert into bbb values(v2_sum);
end;
/

--
--레코드 이용
select * from emp10;
declare
    v_emp_rec   employees%rowtype;
begin
    select *
            into    v_emp_rec
            from    employees
            where   employee_id = &employee_id;
        
    if      v_emp_rec.DEPARTMENT_ID = 20 then
            insert into emp20 values v_emp_rec;
    elsif   v_emp_rec.DEPARTMENT_ID = 30 then
            insert into emp30 values v_emp_rec;
    elsif   v_emp_rec.DEPARTMENT_ID = 40 then
            insert into emp40 values v_emp_rec;  
    else
            insert into emp10 values v_emp_rec;
    end if;
end;
/
select * from emp20;
select * from emp30;
select * from emp40;
select * from emp10;
select * from employees;

--커서후
truncate table test01;
truncate table test02;
--1
declare
    cursor c_emp_cursor is
        select employee_id, first_name, hire_date
            from employees;
    v_emp_record    c_emp_cursor%rowtype;
begin
    open c_emp_cursor;
    loop
        fetch c_emp_cursor into v_emp_record;
        exit when c_emp_cursor%notfound;
        if to_char(v_emp_record.hire_date, 'yyyy') >= 2000 then
            insert into test01 values v_emp_record;
        else
            insert into test02 values v_emp_record;
        end if;
    end loop;
    
    close c_emp_cursor;
end;
/
select * from test01;















