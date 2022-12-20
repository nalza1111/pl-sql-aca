--1
create or replace function ydsum
    (   p_num number    )
    return number
    is
        v_num number(30) := 0;
    begin
        for i in 1..p_num
        loop
            v_num := v_num + i;
        end loop;
        return v_num;
    end ydsum;
    /
EXECUTE DBMS_OUTPUT.PUT_LINE(ydsum(10));
--2
create or replace function ydinc 
    (   p_id    employees.employee_id%type     )
    return employees.salary%type
    is
        p_sal   employees.salary%type;
    begin
        select salary into p_sal
            from employees
            where employee_id = p_id;
        if p_sal <= 5000 then
            return p_sal*1.2;
        elsif p_sal <= 10000 then
            return p_sal*1.15;
        elsif p_sal <= 20000 then
            return p_sal*1.1;
        else 
            return p_sal;
        end if;
    end ydinc;
    /
SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;    
--3
create or replace function yd_func
    (   p_id    employees.employee_id%type     )
     return employees.salary%type
    is
        p_sal   employees.salary%type;
        p_com   employees.commission_pct%type;
    begin
        select salary, commission_pct
        into p_sal, p_com
        from employees
        where employee_id = p_id;
        return (p_sal+(p_sal*nvl(p_com,0)))*12;
    end yd_func;
    /
 SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
--4
create or replace function subname
    (   p_name    employees.last_name%type     )
     return employees.last_name%type
    is
    begin
        return rpad(substr(p_name,1,1),length(p_name),'*');
    end subname;
    /
SELECT last_name, subname(last_name)
FROM   employees;
--5
create or replace function inc_sal 
    (   p_id    employees.employee_id%type,
        p_upsal number     )
     return employees.salary%type
    is
        v_sal  employees.salary%type;
    begin
        select salary into v_sal
            from employees
            where employee_id = p_id;
        return v_sal*(1+(p_upsal/100));
    end inc_sal;
    /
SELECT last_name, salary, inc_sal(employee_id, 10)
FROM   employees;    

--Function2########################
--1
create or replace function y_yedam 
    (  p_id employees.employee_id%type  )
     return employees.first_name%type
    is
        v_fname    employees.first_name%type;
        v_lname    employees.last_name%type;
    begin
        select first_name, last_name
        into v_fname, v_lname
        from employees
        where employee_id = p_id;
        return v_fname ||' '|| v_lname;
    end y_yedam;
    /
SELECT employee_id, y_yedam(employee_id)
FROM   employees;    

--2
create or replace function y_dept  
    (  p_id employees.employee_id%type  )
     return varchar2
    is
        v_dept      departments.department_name%type:='';
        v_empid     employees.employee_id%type;
        nullex exception;
    begin
        --사원검색
        select employee_id
            into v_empid
            from employees
            where employee_id = p_id;
            
        --부서검색
        select d.department_name, e.department_id
        into v_dept, v_empid
        from employees e, departments d
        where e.department_id = d.department_id(+)
        and e.employee_id = p_id;
        DBMS_OUTPUT.PUT_LINE('안에서'||v_dept);
        if v_dept is null then 
            raise nullex;
        end if;
        
        return v_dept;
    EXCEPTION
        when no_data_found then
        return '사원이 없습니다.';
        when nullex then
        return '소속 부서가 없습니다';
    end y_dept ;
    /
EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(250));

select * from employees;
insert into employees(employee_id, first_name, last_name, email, hire_date,job_id) values(251,'Fay','Fay','av','2022-12-20','IT_PROG');

--3
create or replace function y_test  
    (   p_deptid    employees.department_id%type     )
     return varchar2
    is
        cursor emp_list_cursor
        is  
            select e.first_name as "A", d.department_name as "B"
                from employees e, departments d
                where e.department_id = d.department_id
                and e.department_id = p_deptid;   
        emp_rec emp_list_cursor%rowtype;
        emp_str varchar(1000) := '';
        e_no exception;
    begin
        open emp_list_cursor;
        loop
            fetch emp_list_cursor into emp_rec;
            exit when emp_list_cursor%notfound;
            emp_str :=  emp_str ||' '||emp_rec.A||' '||emp_rec.B;
        end loop;
        if emp_list_cursor%rowcount = 0 then
            raise e_no;
        end if;
        close emp_list_cursor;
        return emp_str;
    EXCEPTION
    when e_no then
        return '소속된 사원이 없습니다.';
    end y_test;
    /
EXECUTE DBMS_OUTPUT.PUT_LINE(y_test(90));
EXECUTE DBMS_OUTPUT.PUT_LINE(y_test(300));



    
    
    