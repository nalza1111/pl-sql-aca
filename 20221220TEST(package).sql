create or replace function y_age
    (   f_number number    )
    return number
is
    v_age number; 
begin
    v_age := to_char(sysdate, 'yyyy)
            - substr(f_number, 1, 2);
    if v_age < 0
    return v_age
end y_age;