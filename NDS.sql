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

create or replace package pt_dynamic_sql is

  -- Author  : P.TROFIMOV
  -- Created : 09.02.2022 15:27:22
  -- Purpose : Динамический SQL к таблице pt_temp

  PROCEDURE type_1_dyn_sql;
  PROCEDURE type_2_dyn_sql(num_col_in IN PLS_INTEGER,
                           num_row_in IN PLS_INTEGER,
                           val_in     IN PLS_INTEGER);
  PROCEDURE type_3_dyn_sql(num_col_in IN PLS_INTEGER,
                           num_row_in IN PLS_INTEGER);
  PROCEDURE type_4_dyn_sql_with_DBMS_SQL;
  PROCEDURE type_4_dyn_sql_with_dyn_PL_SQL(table_in        IN VARCHAR2,
                                           where_in        IN VARCHAR2 DEFAULT NULL,
                                           colname_like_in IN VARCHAR2 := '*');
end pt_dynamic_sql;


create or replace package body pt_dynamic_sql is

  --------------------------------
  -- первая категория динамического SQL EXECUTE IMMEDIATE без секций USING и INTO
  PROCEDURE type_1_dyn_sql IS
  
    index_already_exist EXCEPTION;
    PRAGMA EXCEPTION_INIT(index_already_exist, -00955);
  
  BEGIN
  
    DBMS_OUTPUT.put_line('Создание индекса!');
    EXECUTE IMMEDIATE 'CREATE INDEX index_of_1 ON pt_temp (number1)';
    DBMS_OUTPUT.put_line('ОК');
  
  EXCEPTION
    WHEN index_already_exist THEN
      DBMS_OUTPUT.put_line('Индекс уже существует! Удаляем...');
      EXECUTE IMMEDIATE 'DROP INDEX index_of_1';
      DBMS_OUTPUT.put_line('ОК');
    
  END type_1_dyn_sql;

  ------------------------------------
  --вторая категория динамического SQL EXECUTE IMMEDIATE с секцией USING
  ------------------------------------

  PROCEDURE type_2_dyn_sql(num_col_in IN PLS_INTEGER,
                           num_row_in IN PLS_INTEGER,
                           val_in     IN PLS_INTEGER) IS
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Второй тип SQL - обновление значения в таблице с параметрами num_col: ' ||
                         num_col_in || ' и num_row: ' || num_row_in ||
                         ', значение:' || val_in);
    EXECUTE IMMEDIATE 'UPDATE pt_temp 
                              SET number' ||
                      num_row_in || ' = :val WHERE number1 = :nc'
      USING val_in, num_col_in;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Ok!');
  
  END type_2_dyn_sql;

  ---------------------------------------
  --третья категория динамического SQL EXECUTE IMMEDIATE с секциями USING и INTO
  ---------------------------------------

  PROCEDURE type_3_dyn_sql(num_col_in IN PLS_INTEGER,
                           num_row_in IN PLS_INTEGER) IS
  
    val PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Третий тип SQL - выборка из таблицы с параметрами num_col: ' ||
                         num_col_in || ' и num_row: ' || num_row_in);
    EXECUTE IMMEDIATE 'SELECT number' || num_col_in ||
                      ' FROM pt_temp 
  WHERE number1 = :nr'
      INTO val
      USING num_row_in;
    DBMS_OUTPUT.PUT_LINE('Получили значение: ' || val);
  
  END type_3_dyn_sql;

  ---------------------------------------
  --четвертая категория динамического SQL через DBMS_SQL, когда неизвестно количество? запрашиваемой информации 
  ---------------------------------------

  PROCEDURE type_4_dyn_sql_with_DBMS_SQL IS
  
    cur   PLS_INTEGER := DBMS_SQL.OPEN_CURSOR;
    cols  DBMS_SQL.DESC_TAB;
    ncols PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Четвертый тип динамического SQL через встроенный пакет DBMS_SQL.');
  
    DBMS_SQL.PARSE(cur, 'SELECT * FROM pt_temp', DBMS_SQL.NATIVE);
    DBMS_SQL.DESCRIBE_COLUMNS(cur, ncols, cols);
  
    FOR colind in 1 .. ncols LOOP
      DBMS_OUTPUT.PUT_LINE(cols(colind).col_name);
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(cur);
  
    DBMS_OUTPUT.PUT_LINE('Выводим все названия столбцов.');
  
  END type_4_dyn_sql_with_DBMS_SQL;

  ---------------------------------------
  --четвертая категория динамического SQL через динамический PL/SQL, когда неизвестно количество запрашиваемой информации 
  ---------------------------------------

  PROCEDURE type_4_dyn_sql_with_dyn_PL_SQL(table_in        IN VARCHAR2,
                                           colname_like_in IN VARCHAR2 := '*') IS
  TYPE query_curtype IS REF CURSOR;                                         
  TYPE l_row IS table_in%ROWTYPE;
  
  BEGIN
    
  DBMS_OUTPUT.PUT_LINE('Четвертый тип динамического SQL через динамический PL/SQL.');
  
  EXECUTE IMMEDIATE 'SELECT ' || colname_like_in || ' FROM ' || table_in || ' WHERE ' || where_in INTO l_row;
    DBMS_OUTPUT.PUT_LINE('Четвертый тип динамического SQL через динамический PL/SQL.');
  
  END type_4_dyn_sql_with_dyn_PL_SQL;

end pt_dynamic_sql;
