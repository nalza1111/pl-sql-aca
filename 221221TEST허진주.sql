--1

--2
create or replace procedure p_emp
    (   p_id  in  employees.employee_id%type)
is
    v_deptname  varchar2(20);
    v_job_id    varchar2(20);
    v_sal       varchar2(20);
    v_ysal      varchar2(20);
begin
    select d.department_name, e.job_id, e.salary,
                    (e.salary+(e.salary*nvl(commission_pct,0)))*12
        into v_deptname, v_job_id, v_sal, v_ysal
        from departments d, employees e
        where d.department_id = e.department_id
        and e.employee_id = p_id;
    DBMS_OUTPUT.PUT_LINE(p_id||'의 부서이름: '||v_deptname||' job_id: '
        ||v_job_id||' 급여: '||v_sal||' 연간 총수입: '||v_ysal );  
    EXCEPTION
    when no_data_found then
        dbms_output.put_line('없는 사원입니다.');
end p_emp;
/
execute p_emp(200);
--3
create or replace procedure p_emphire
    (   p_id  in  employees.employee_id%type)
is
    v_date employees.hire_date%type;
begin
    select hire_date into v_date
        from employees
        where employee_id = p_id;
    if(to_char(v_date,'yyyy')>2005) then
        dbms_output.put_line('New employee');
    else
        dbms_output.put_line('Career employee');
    end if;
    EXCEPTION   
    when no_data_found then
       dbms_output.put_line('없는 사원입니다.');
end p_emphire;
/
execute p_emphire(201);
--4
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
--5
create or replace procedure p_dept
    (      p_pid employees.department_id%type      )
is
    cursor emp_list_cursor
    is
        select employee_id, first_name, salary
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
        DBMS_OUTPUT.PUT_LINE( emp_rec.employee_id||
                              emp_rec.first_name||
                              emp_rec.salary
                            );
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
end p_dept;
/
execute p_dept(340); 
execute p_dept(90);
execute p_dept(300);
--6
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
--7
create or replace procedure y_agesex
    (   f_number varchar2    )
is
    v_agesex varchar2(50);
    execp exception;
begin
    if substr(f_number, 7, 1) < 3 then
        v_agesex := (1||substr(to_char(sysdate, 'yyyy'), 3, 2))
            - substr(f_number, 1, 2) + 1;
    elsif (substr(f_number, 7, 1) between 3 and 4)
        and substr(f_number, 1, 6)
        <= to_char(sysdate, 'yyMMdd') then--21세기
        v_agesex := substr(to_char(sysdate, 'yyyy'), 3, 2)
                 - substr(f_number, 1, 2) + 1;
    else
        raise execp;
    end if;
    if mod(substr(f_number, 7, 1), 2) = 0 then
        v_agesex := v_agesex||' 여자';
    else
        v_agesex := v_agesex||' 남자';
    end if;
    DBMS_OUTPUT.PUT_line(v_agesex);
    EXCEPTION
        when execp then
            DBMS_OUTPUT.PUT_line('올바르지 않은 주민등록번호');
end y_agesex;
/
execute y_agesex(200304380711);
--8
create or replace function y_empdate  
    (  p_id employees.employee_id%type  )
     return varchar2
    is
        v_date      employees.hire_date%type;
        v_datezero      varchar2(20);
        nullex exception;
    begin
        --사원검색
        select hire_date
            into v_date
            from employees
            where employee_id = p_id;
           
        v_datezero := to_char(sysdate, 'yyyy')
                      - to_char(v_date, 'yyyy')||'년 근무';
        if to_char(v_date, 'yyyy') = 2022 then
            v_datezero := '1년미만 근무';
        end if;
        return v_datezero;
    EXCEPTION
        when no_data_found then
            return '사원이 없습니다.';
    end y_empdate;
    /
select * from employees where employee_id=250;
execute DBMS_OUTPUT.PUT_line(y_empdate(200));
execute DBMS_OUTPUT.PUT_line(y_empdate(250));
execute DBMS_OUTPUT.PUT_line(y_empdate(1));
--9                          
create or replace procedure y_deptname
    (
        p_deptname    departments.department_name%type
    )
is
    v_name employees.first_name%type;
    v_man employees.employee_id%type;
    e_noid exception; --매니저없음
begin
    select manager_id into v_man
                    from departments
                    where department_name = p_deptname;
    if v_man is null then          
        raise e_noid;
    end if;
    select first_name
        into v_name
        from employees
        where employee_id = (select manager_id
                                from departments
                                where department_name = p_deptname);
    
    DBMS_OUTPUT.PUT_line(p_deptname||'부서의 매니저 이름은: '||v_name);
exception
    when no_data_found then
        DBMS_OUTPUT.PUT_line('No search department_name!!');
    when e_noid then
        DBMS_OUTPUT.PUT_line('해당 부서에 매니저가 없습니다.');
end y_deptname;
/
execute y_deptname('Administration');
execute y_deptname('A');
execute y_deptname('Purchasing');
--10
select *
    from user_source
        where type in ('PROCEDURE', 'FUNCTION', 'PACKAGE BODY')
        order by name, line;
--11
declare
    v_star  varchar2(1000);
begin
    for i in 1..9
    loop
        v_star := '';
        for n in i..9
        loop
            v_star := v_star||'-';
        end loop;
        
        for m in 1..i
        loop
            v_star := v_star||'*';
        end loop;
        DBMS_OUTPUT.PUT_LINE(v_star);
    end loop;
end;
/