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
alter table employee add (birthday date); --()�ѷ��θ� �������� �÷� �߰� ����? �����?

--8
insert into department values (1001, '�ѹ���', '��101ȣ', '053-777-8777');
insert into department values (1002, 'ȸ����', '��102ȣ', '053-888-9999');
insert into department values (1003, '������', '��103ȣ', '053-222-3333');
insert into employee values (20121945, '�ڹμ�', to_date('20120302', 'YYYYMMDD'), '�뱸', '010-1111-1234', 1001, '');
insert into employee values (20101817, '���ؽ�', '2010-09-01', '���', '010-2222-1234', 1003, '');
insert into employee values (20122245, '���ƶ�', '2012-03-02', '�뱸', '010-3333-1222', 1002, '');
insert into employee values (20121729, '�̹���', '2011-03-02', '����', '010-3333-4444', 1001, '');
insert into employee values (20121646, '������', '2012-09-01', '�λ�', '010-1234-2222', 1003, '');
--9
alter table employee  modify(empname not null);
--10
--����Ŭ����
select empname, hiredate, deptname 
    from employee, department
    where employee.deptid = department.deptid
    and deptname='�ѹ���';
---�Ƚ�����
select empname, hiredate, deptname
    from employee join department
        on (employee.deptid = department.deptid)
        where deptname='�ѹ���';

--11
delete employee where addr = '%�뱸%'; --truncate(�ѹ�Ұ�)
--12
update employee set deptid=(select deptid from department  where deptname = 'ȸ����')
                where deptid=(select deptid from department  where deptname = '������');
--13
select  empid, empname, hiredate, deptname  from employee, department
        where employee.deptid = department.deptid
        and hiredate > (select hiredate from employee where empid = 20121729);
        
--�Ƚ�
select  empid, empname, hiredate, deptname  from employee join department
        on (employee.deptid = department.deptid)
        where hiredate > (select hiredate from employee where empid = 20121729);
--14
create view dept_view2 as select empname, addr, deptname
                            from employee, department
                            where employee.deptid = department.deptid
                            and deptname='�ѹ���';
create view dept_view2 as select empname, addr, deptname
                            from employee join department
                            on(employee.deptid = department.deptid)
                            where deptname='�ѹ���';
--
select * from department;
select * from employee;
select * from dept_view2;
