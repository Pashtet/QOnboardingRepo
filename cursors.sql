DROP TABLE pt_temp;

CREATE TABLE pt_temp (
number1 NUMBER,
number2 NUMBER,
number3 NUMBER);

INSERT ALL 
    INTO pt_temp (number1,number2,number3) values (1, 1, 1)
    INTO pt_temp (number1,number2,number3) values (2, 2, 2)
    INTO pt_temp (number1,number2,number3) values (3, 3, 3)
    INTO pt_temp (number1,number2,number3) values (4, 4, 4)
    INTO pt_temp (number1,number2,number3) values (5, 5, 5)
SELECT * FROM dual;

create or replace package pt_rec is

  -- Author  : P.TROFIMOV
  -- Created : 08.02.2022 14:28:24
  -- Purpose : работа с курсорами

  PROCEDURE explicit_cur;
  PROCEDURE implicit_cur_for_all_rows;
  PROCEDURE explicit_cur_with_param(num_row_in IN PLS_INTEGER);
  PROCEDURE explicit_cur_for_update(num_for_update IN PLS_INTEGER);
  PROCEDURE ref_cur;

end pt_rec;

create or replace package body pt_rec is

  --явный курсор
  PROCEDURE explicit_cur IS
    CURSOR cur IS
      SELECT * FROM pt_temp;
  
    cur_rec cur%ROWTYPE;
  BEGIN
    OPEN cur;
    LOOP
      FETCH cur
        INTO cur_rec;
      EXIT WHEN cur%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(cur_rec.number1 || ' ' || cur_rec.number2 || ' ' ||
                           cur_rec.number3);
    END LOOP;
    -----------------------------------------------------
    -----------------------------------------------------
    --значения параметров после цикла
    DBMS_OUTPUT.PUT_LINE('Parameter cursor''s:');
    --%FOUND
    IF cur%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('%FOUND: TRUE');
    ELSIF NOT cur%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('%FOUND: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%FOUND: NULL');
    END IF;
  
    --%NOTFOUND
    IF cur%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: TRUE');
    ELSIF NOT cur%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: NULL');
    END IF;
  
    --%ROWCOUNT
    DBMS_OUTPUT.PUT_LINE('%ROWCOUNT: ' || cur%ROWCOUNT);
  
    --%ISOPEN
    IF cur%ISOPEN THEN
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: TRUE');
    ELSIF NOT cur%ISOPEN THEN
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: NULL');
    END IF;
    --конец показа значений параметров
    -----------------------------------------------------------
    -----------------------------------------------------------
    CLOSE cur;
  END explicit_cur;
  -------------------------------------------------------------------------------------------------------
  --
  --явный курсор с параметрами - выбор первых num_row_in строк из таблицы
  --курсор не выдает ошибку при превышении количества запрашиваемых столбцов
  PROCEDURE explicit_cur_with_param(num_row_in IN PLS_INTEGER) IS
  
    CURSOR cur(num_cur_row IN PLS_INTEGER) IS
      SELECT * FROM pt_temp FETCH FIRST num_cur_row ROWS ONLY;
    cur_rec cur%ROWTYPE;
  
  BEGIN
  
    OPEN cur(num_row_in);
    LOOP
      FETCH cur
        INTO cur_rec;
      EXIT WHEN cur%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(cur_rec.number1 || ' ' || cur_rec.number2 || ' ' ||
                           cur_rec.number3);
    END LOOP;
  
    CLOSE cur;
  
  END explicit_cur_with_param;
  -----------------------------------------------------------------------------------------------
  --перебор всех строк таблицы с неявным курсором
  PROCEDURE implicit_cur_for_all_rows IS
  
  BEGIN
  
    FOR rec IN (SELECT * FROM pt_temp) LOOP
    
      DBMS_OUTPUT.PUT_LINE(rec.number1 || ' ' || rec.number2 || ' ' ||
                           rec.number3);
    END LOOP;
    -----------------------------------------------------
    -----------------------------------------------------
    --значения параметров после цикла
    DBMS_OUTPUT.PUT_LINE('Parameter cursor''s:');
    --%FOUND
    IF SQL%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('%FOUND: TRUE');
    ELSIF NOT SQL%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('%FOUND: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%FOUND: NULL');
    END IF;
  
    --%NOTFOUND
    IF SQL%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: TRUE');
    ELSIF NOT SQL%NOTFOUND THEN
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%NOTFOUND: NULL');
    END IF;
  
    --%ROWCOUNT
    DBMS_OUTPUT.PUT_LINE('%ROWCOUNT: ' || SQL%ROWCOUNT);
  
    --%ISOPEN
    IF SQL%ISOPEN THEN
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: TRUE');
    ELSIF NOT SQL%ISOPEN THEN
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: FALSE');
    ELSE
      DBMS_OUTPUT.PUT_LINE('%ISOPEN: NULL');
    END IF;
    --конец показа значений параметров
    -----------------------------------------------------------
    -----------------------------------------------------------
  
  END implicit_cur_for_all_rows;

  ---явный курсор с конструкцией FOR UPDATE и изменение записи с WHERE CURRENT OF
  PROCEDURE explicit_cur_for_update(num_for_update IN PLS_INTEGER) IS
  
    CURSOR cur IS
      SELECT * FROM pt_temp WHERE number1 = 1 FOR UPDATE OF number2;
    cur_rec cur%ROWTYPE;
  
  BEGIN
    OPEN cur;
    FETCH cur
      INTO cur_rec;
    DBMS_OUTPUT.PUT_LINE('Выбран столбец с number1=1: ' || ' ' ||
                         cur_rec.number1 || ' ' || cur_rec.number2 || ' ' ||
                         cur_rec.number3);
    UPDATE pt_temp SET number2 = num_for_update WHERE CURRENT OF cur;
    COMMIT;
    SELECT * INTO cur_rec FROM pt_temp WHERE number1 = 1;
    DBMS_OUTPUT.PUT_LINE('Столбец после изменения с number1=1: ' || ' ' ||
                         cur_rec.number1 || ' ' || cur_rec.number2 || ' ' ||
                         cur_rec.number3);
    CLOSE cur;
  END explicit_cur_for_update;

  ----курсорные переменные
  PROCEDURE ref_cur IS
    TYPE curvar_type IS REF CURSOR;
    curvar1    curvar_type;
    curvar2    curvar_type;
    curvar_rec pt_temp%ROWTYPE;
  
  BEGIN
    OPEN curvar1 FOR
      SELECT * FROM pt_temp;
    FETCH curvar1
      INTO curvar_rec;
    DBMS_OUTPUT.PUT_LINE('Первая запись с первой переменной: ' ||
                         curvar_rec.number1 || ' ' || curvar_rec.number2 || ' ' ||
                         curvar_rec.number3);
    curvar2 := curvar1;
    FETCH curvar2
      INTO curvar_rec;
    DBMS_OUTPUT.PUT_LINE('Первая запись со второй переменной: ' ||
                         curvar_rec.number1 || ' ' || curvar_rec.number2 || ' ' ||
                         curvar_rec.number3);
    /*close curvar1;
    DBMS_OUTPUT.PUT_LINE('Закрыли первую переменную');
    --не работает
    FETCH curvar2
      INTO curvar_rec;*/
    close curvar2;
    
/*    DBMS_OUTPUT.PUT_LINE('Закрыли вторую переменную');
    FETCH curvar1
      INTO curvar_rec;*/
   --при закрытии курсора по любой переменной закрывается сам объект - т.е. становится недоступным по любой присвоенной переменной
    --close curvar1;
  end ref_cur;
end pt_rec;
