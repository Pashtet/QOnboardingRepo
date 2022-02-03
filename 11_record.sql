CREATE TABLE temp (
number1 NUMBER,
number2 NUMBER,
number3 NUMBER);

INSERT ALL 
    INTO temp (number1,number2,number3) values (1, 1, 1)
    INTO temp (number1,number2,number3) values (2, 2, 2)
    INTO temp (number1,number2,number3) values (3, 3, 3)
    INTO temp (number1,number2,number3) values (4, 4, 4)
    INTO temp (number1,number2,number3) values (5, 5, 5)
SELECT * FROM dual;

CREATE OR REPLACE PACKAGE rec
IS
PROCEDURE proc_1;
PROCEDURE proc_2(rec_in IN temp%ROWTYPE);
END rec;

CREATE OR REPLACE PACKAGE BODY rec
IS
    PROCEDURE proc_1
    IS
    BEGIN
        FOR rec IN (SELECT * FROM temp)
            LOOP
            proc_2(rec);
            END LOOP;
    END proc_1;

    PROCEDURE proc_2 (rec_in IN temp%ROWTYPE)
    IS
        v_rec temp%ROWTYPE := rec_in;
	    v_sum_num_in_temp NUMBER;
    BEGIN
	    v_sum_num_in_temp := v_rec.number1+v_rec.number2+v_rec.number3;
        DBMS_OUTPUT.PUT_LINE(v_sum_num_in_temp);
    END proc_2;
END rec;

BEGIN
rec.proc_1;
END;