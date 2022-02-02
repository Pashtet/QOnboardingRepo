DECLARE 
    CURSOR gen_date_cur IS 
        select add_months(trunc(sd, 'mm'),level-1) AS gen_date
        from (SELECT sysdate sd from dual) cc
        connect by add_months(sysdate, level-1)<add_months(trunc(sysdate, 'yyyy'), 12);
    l_timestamp TIMESTAMP;
    l_row gen_date_cur%ROWTYPE;
    l_str l_row.gen_date%TYPE;
    
BEGIN
    FOR rec IN gen_date_cur
        LOOP
            l_str := rec.gen_date;
            l_timestamp := TO_TIMESTAMP(l_str);
            DBMS_OUTPUT.PUT_LINE('Строка: ' || l_str);
            DBMS_OUTPUT.PUT_LINE('Дата начала месяца: '  || TO_CHAR(l_timestamp, 'dd.mm.yyyy'));
            DBMS_OUTPUT.PUT_LINE('Первый день следующего месяца: '  || TO_CHAR(ADD_MONTHS(l_timestamp,1), 'dd.mm.yyyy'));
            DBMS_OUTPUT.PUT_LINE('Последний день месяца: '  || TO_CHAR(TO_TIMESTAMP(ADD_MONTHS(l_timestamp,1)) - INTERVAL '1 0:0:0' DAY TO SECOND, 'dd.mm.yyyy'));
            DBMS_OUTPUT.PUT_LINE('Дата на день меньше указанной: '  || TO_CHAR(l_timestamp - INTERVAL '1 0:0:0' DAY TO SECOND, 'dd.mm.yyyy'));
            DBMS_OUTPUT.PUT_LINE(chr(10));
        END LOOP;
END;