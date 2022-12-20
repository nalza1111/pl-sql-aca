create or replace function y_age
    (   f_number varchar2    )
    return varchar2
is
    v_age varchar2(50); 
begin
    if substr(f_number, 7, 1) < 3 then--20세기
        v_age := (1||substr(to_char(sysdate, 'yyyy'), 3, 2))
            - substr(f_number, 1, 2) + 1;
    else
        v_age := substr(to_char(sysdate, 'yyyy'), 3, 2)
                 - substr(f_number, 1, 2) + 1;
    end if;
    return v_age;
end y_age;
/
execute dbms_output.put_line(y_age(2103044810711));
--
create or replace function y_sex 
    (   f_number varchar2    )
    return varchar2
is
begin
    if mod(substr(f_number, 7, 1), 2) = 0 then
        return '여자';
    else
        return '남자';
    end if;
end y_sex;
/
execute dbms_output.put_line(y_sex(2003041830711));

--
drop function yd_pkg;

--패키지 명세 만들기
create or replace package yd_pkg
is
    function y_age
        (   f_number varchar2    )
        return varchar2;
    function y_sex
        (   f_number varchar2    )
        return varchar2;
end yd_pkg;
/
--패키지바디
create or replace package body yd_pkg
is
    function y_age
        (   f_number varchar2    )
        return varchar2
    is
        v_age varchar2(50); 
    begin
    if substr(f_number, 7, 1) < 3 then--20세기
        v_age := (1||substr(to_char(sysdate, 'yyyy'), 3, 2))
            - substr(f_number, 1, 2) + 1;
    else
        v_age := substr(to_char(sysdate, 'yyyy'), 3, 2)
                 - substr(f_number, 1, 2) + 1;
    end if;
    return v_age;
    end y_age;
    function y_sex 
        (   f_number varchar2    )
        return varchar2
    is
    begin
        if mod(substr(f_number, 7, 1), 2) = 0 then
            return '여자';
        else
            return '남자';
        end if;
    end y_sex;
end yd_pkg;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(yd_pkg.y_age('8912011676666'));
EXECUTE DBMS_OUTPUT.PUT_LINE(yd_pkg.y_sex('8912011676666'));