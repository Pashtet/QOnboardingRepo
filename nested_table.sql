-- работа с вложенной таблицей

declare

  n_t_test pt_work_with_nested_table.n_table := pt_work_with_nested_table.n_table();
  i        PLS_INTEGER;
  
begin

  DBMS_OUTPUT.PUT_LINE('Create nested table from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    n_t_test.EXTEND;
    n_t_test(i) := i;
  END LOOP;

  pt_work_with_nested_table.display_direct_n_table(n_t_test);
  pt_work_with_nested_table.display_reverse_n_table(n_t_test);

  DBMS_OUTPUT.PUT_LINE('Display number of elements nested table: ' ||
                       n_t_test.COUNT);
                       
  DBMS_OUTPUT.PUT_LINE('Delete first element in nested table!');
  n_t_test.DELETE(n_t_test.FIRST);

  pt_work_with_nested_table.display_direct_n_table(n_t_test);
  
  DBMS_OUTPUT.PUT_LINE('Is element 10 exist in nested table?!');
  IF n_t_test.EXISTS(10) THEN
    DBMS_OUTPUT.PUT_LINE('YES!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No!');
  END IF;
  
    DBMS_OUTPUT.PUT_LINE('Delete last element in a_array!');
  n_t_test.DELETE(n_t_test.LAST);
  pt_work_with_nested_table.display_direct_n_table(n_t_test);
  
  DBMS_OUTPUT.PUT_LINE('Is element 10 still exist in nested table?!');
  IF n_t_test.EXISTS(10) THEN
    DBMS_OUTPUT.PUT_LINE('YES!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No!');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Display number of elements a_array: ' ||
                       n_t_test.COUNT);

end;


create or replace package pt_work_with_nested_table is

  -- Author  : P.TROFIMOV
  -- Created : 11.02.2022 14:50:12
  -- Purpose : Work with nested table

  TYPE n_table IS TABLE of PLS_INTEGER;

  PROCEDURE display_direct_n_table(in_n_table IN n_table);
  PROCEDURE display_reverse_n_table(in_n_table IN n_table);

end pt_work_with_nested_table;


create or replace package body pt_work_with_nested_table is

  PROCEDURE display_direct_n_table(in_n_table IN n_table) IS
    i PLS_INTEGER;
  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Display direct nested table:');
    i := in_n_table.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_n_table(i));
      i := in_n_table.NEXT(i);
    END LOOP;
  END display_direct_n_table;

  PROCEDURE display_reverse_n_table(in_n_table IN n_table) IS
    i PLS_INTEGER;
  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Display reverse nested table:');
    i := in_n_table.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_n_table(i));
      i := in_n_table.PRIOR(i);
    END LOOP;
END display_reverse_n_table;
end pt_work_with_nested_table;
