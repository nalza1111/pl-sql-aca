--6
create table department (deptid number(10) primary key,
                         deptname varchar2(10),
                         location varchar2(10),
                         tel varchar2(15));
create table employee ( empid number(10) primary key,
                        empname varchar2(10),
                        hiredate date,
                        addr varchar2(15),
                        tel varchar2(15),
                        deptid number(10) references department(deptid));
                        --primary key(deptid)
                        --foreign key(deptid) refernces department(deptid)
--7
alter table employee add (birthday date); --()µÑ·¯½Î¸é ¿©·¯°³ÀÇ ÄÃ·³ Ãß°¡ °¡´É? µå¶ø¸¸?

--8
insert into department values (1001, 'ÃÑ¹«ÆÀ', 'º»101È£', '053-777-8777');
insert into department values (1002, 'È¸°èÆÀ', 'º»102È£', '053-888-9999');
insert into department values (1003, '¿µ¾÷ÆÀ', 'º»103È£', '053-222-3333');
insert into employee values (20121945, '¹Ú¹Î¼ö', to_date('20120302', 'YYYYMMDD'), '´ë±¸', '010-1111-1234', 1001, '');
insert into employee values (20101817, '¹ÚÁØ½Ä', '2010-09-01', '°æ»ê', '010-2222-1234', 1003, '');
insert into employee values (20122245, '¼±¾Æ¶ó', '2012-03-02', '´ë±¸', '010-3333-1222', 1002, '');
insert into employee values (20121729, 'ÀÌ¹ü¼ö', '2011-03-02', '¼­¿ï', '010-3333-4444', 1001, '');
insert into employee values (20121646, 'ÀÌÀ¶Èñ', '2012-09-01', 'ºÎ»ê', '010-1234-2222', 1003, '');
--9
alter table employee  modify(empname not null);
--10
--¿À¶óÅ¬Á¶ÀÎ
select empname, hiredate, deptname 
    from employee, department
    where employee.deptid = department.deptid
    and deptname='ÃÑ¹«ÆÀ';
---¾È½ÃÁ¶ÀÎ
select empname, hiredate, deptname
    from employee join department
        on (employee.deptid = department.deptid)
        where deptname='ÃÑ¹«ÆÀ';

--11
delete employee where addr = '%´ë±¸%'; --truncate(·Ñ¹éºÒ°¡)
--12
update employee set deptid=(select deptid from department  where deptname = 'È¸°èÆÀ')
                where deptid=(select deptid from department  where deptname = '¿µ¾÷ÆÀ');
--13
select  empid, empname, hiredate, deptname  from employee, department
        where employee.deptid = department.deptid
        and hiredate > (select hiredate from employee where empid = 20121729);
        
--¾È½Ã
select  empid, empname, hiredate, deptname  from employee join department
        on (employee.deptid = department.deptid)
        where hiredate > (select hiredate from employee where empid = 20121729);
--14
create view dept_view2 as select empname, addr, deptname
                            from employee, department
                            where employee.deptid = department.deptid
                            and deptname='ÃÑ¹«ÆÀ';
create view dept_view2 as select empname, addr, deptname
                            from employee join department
                            on(employee.deptid = department.deptid)
                            where deptname='ÃÑ¹«ÆÀ';
--
select * from department;
select * from employee;
select * from dept_view2;
