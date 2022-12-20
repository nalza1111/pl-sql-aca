--1
create or replace procedure j_number
    (  p_number in varchar2)
is
    p_number2  varchar2(38);
    numleng exception;
begin
    if length(p_number)<>13 then
        raise numleng;
    end if;
    p_number2:= substr(p_number,1,6)||'-'||substr(p_number,7,1)||
               '******';
    DBMS_OUTPUT.PUT_LINE(p_number2); -- 바로 출력하면 number2를 안써도 되는 듯
exception
        when numleng then
        DBMS_OUTPUT.PUT_LINE('길이가 안맞음');
end j_number;
/
execute j_number(9303042830711);
--2
create or replace procedure test_pro
    (p_id in employees.employee_id%type)
is  
    e_child exception;
    PRAGMA EXCEPTION_INIT (e_child, -02292);
    e_noid exception;
begin
    delete from employees
        where employee_id=p_id;
    if sql%notfound then
        raise e_noid; 
    end if;
    DBMS_OUTPUT.PUT_LINE(sql%rowcount||'건 삭제');
exception
      when e_child then
      DBMS_OUTPUT.PUT_line('child record 있어 삭제x');
      when e_noid then
      DBMS_OUTPUT.PUT_line('해당사원이 없습니다');
      when other then
      DBMS_OUTPUT.PUT_line('알 수 없는 오류발생');
end TEST_PRO;
/
execute test_pro(&id);
select employee_id from employees;
--3
create or replace procedure p_emp
    (   p_id in employees.employee_id%type) 
is
    v_name varchar2(20);
begin
    select last_name into v_name
        from employees
        where employee_id = p_id;
    v_name:=rpad(substr(v_name,1,1),length(v_name),'*');
    DBMS_OUTPUT.PUT_LINE(v_name);
EXCEPTION
    when no_data_found then
        dbms_output.put_line('없는 사원입니다.');
    when too_many_row then
        dbms_output.put_line('해당 사원이 둘이상입니다.');    
end p_emp;
/
EXECUTE p_emp(&id);

--1
create or replace procedure get_emp
    (   p_id employees.employee_id%type  )
is
    cursor emp_list_cursor
        is  
            select employee_id, last_name
                from employees
                where department_id = p_id;
    emp_rec  emp_list_cursor%rowtype;
    e_noid exception;
begin
    open emp_list_cursor;
    loop
        fetch emp_list_cursor into emp_rec;
        exit when emp_list_cursor%notfound;
        DBMS_OUTPUT.PUT_line(emp_rec.employee_id||' '||emp_rec.last_name);
    end loop;
    DBMS_OUTPUT.PUT_line(emp_list_cursor%rowcount||'건');
    if emp_list_cursor%rowcount=0 then
        raise e_noid;
    end if;
    close emp_list_cursor;
    exception
    when e_noid then
        DBMS_OUTPUT.PUT_line('해당 부서에는 사원이 없습니다.');
end get_emp;
/
EXECUTE get_emp(110);

--2
create or replace procedure y_update
    (
        p_id    employees.employee_id%type,
        p_sal   number
    )
is
    e_noid exception;
begin
    update employees
        set salary = salary*(1+(p_sal/100))
        where employee_id = p_id;
    if sql%notfound then
        raise e_noid;
    end if;
exception
    when e_noid then
        DBMS_OUTPUT.PUT_line('No search employee!!');
end y_update;
/
EXECUTE y_update(2010,10);
select employee_id, salary from employees where employee_id=200;

--3
create table yedam01
(y_id number(10),
 y_name varchar2(20));
create table yedam02
(y_id number(10),
 y_name varchar2(20));
 select * from yedam01;
 select * from yedam02;
 truncate table yedam01;
 truncate table yedam02;
 --3-1
create or replace procedure y_proc
    (      p_pid employees.department_id%type      )
is
    cursor emp_list_cursor
    is
        select employee_id, first_name, hire_date
        from employees
        where department_id = p_pid;
    dept_id     employees.department_id%type; 
    emp_rec     emp_list_cursor%rowtype;
    e_noid      exception; 
begin
    select department_id into dept_id
        from departments
        where department_id = p_pid;
    open emp_list_cursor;
    loop
        fetch emp_list_cursor into emp_rec;
        exit when emp_list_cursor%notfound;
        if(to_char(emp_rec.hire_date,'yyyy')<2000) then
            insert into yedam01
                values(emp_rec.employee_id,
                        emp_rec.first_name);
        else
            insert into yedam02
                values(emp_rec.employee_id,
                        emp_rec.first_name);
        end if;
    end loop;
    if emp_list_cursor%rowcount = 0 then
            raise e_noid;
    end if;
    close emp_list_cursor;
exception
    when e_noid then
       DBMS_OUTPUT.PUT_line('해당부서에 사원이 없습니다.');
    when no_data_found then
       DBMS_OUTPUT.PUT_line('해당부서가 없습니다.');
end y_proc;
/
execute y_proc(0);    
select * from departments;
select * from employees;
select * from employees where department_id=300;









