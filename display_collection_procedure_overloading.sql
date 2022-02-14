--проверка с перегруженными функциями вывода коллекций pt_work_with_collections
declare

  a_array_test pt_work_with_collections.a_array;
  n_t_test     pt_work_with_collections.n_table := pt_work_with_collections.n_table();
  v_array_test pt_work_with_collections.v_array := pt_work_with_collections.v_array();
  i            PLS_INTEGER;

begin

  DBMS_OUTPUT.PUT_LINE('Create assoсiative array from 1 to 10.');
  FOR i IN 1 .. 10 LOOP
    a_array_test(i) := i;
  END LOOP;

  pt_work_with_collections.display_direct(a_array_test);

  pt_work_with_collections.display_reverse(a_array_test);

  DBMS_OUTPUT.PUT_LINE('Create nested table from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    n_t_test.EXTEND;
    n_t_test(i) := i;
  END LOOP;

  pt_work_with_collections.display_direct(n_t_test);
  pt_work_with_collections.display_reverse(n_t_test);
  
  DBMS_OUTPUT.PUT_LINE('Create v_array from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    v_array_test.EXTEND;
    v_array_test(i) := i;
  END LOOP;

  pt_work_with_collections.display_direct(v_array_test);
  pt_work_with_collections.display_reverse(v_array_test);
  
  DBMS_OUTPUT.PUT_LINE('It work!');

end;



create or replace package pt_work_with_collections is

  -- Author  : P.TROFIMOV
  -- Created : 14.02.2022 13:46:06
  -- Purpose : work with collections

  TYPE a_array IS TABLE of PLS_INTEGER INDEX BY PLS_INTEGER;
  TYPE n_table IS TABLE of PLS_INTEGER;
  TYPE v_array IS VARRAY(10) of PLS_INTEGER;

  PROCEDURE display_direct(in_a_array IN a_array);
  PROCEDURE display_reverse(in_a_array IN a_array);

  PROCEDURE display_direct(in_n_table IN n_table);
  PROCEDURE display_reverse(in_n_table IN n_table);

  PROCEDURE display_direct(in_v_array IN v_array);
  PROCEDURE display_reverse(in_v_array IN v_array);

end pt_work_with_collections;


create or replace package body pt_work_with_collections is

  PROCEDURE display_direct(in_a_array IN a_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display direct array:');
    i := in_a_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_a_array(i));
      i := in_a_array.NEXT(i);
    END LOOP;
  
  END display_direct;

  PROCEDURE display_reverse(in_a_array IN a_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display reverse array:');
    i := in_a_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_a_array(i));
      i := in_a_array.PRIOR(i);
    END LOOP;
  
  END display_reverse;

  PROCEDURE display_direct(in_n_table IN n_table) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display direct nested table:');
    i := in_n_table.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_n_table(i));
      i := in_n_table.NEXT(i);
    END LOOP;
  END display_direct;

  PROCEDURE display_reverse(in_n_table IN n_table) IS
    i PLS_INTEGER;
  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Display reverse nested table:');
    i := in_n_table.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_n_table(i));
      i := in_n_table.PRIOR(i);
    END LOOP;
  END display_reverse;

  PROCEDURE display_direct(in_v_array IN v_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display direct v_array');
    i := in_v_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_v_array(i));
      i := in_v_array.NEXT(i);
    END LOOP;
  
  END display_direct;

  PROCEDURE display_reverse(in_v_array IN v_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display reverse v_array');
    i := in_v_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_v_array(i));
      i := in_v_array.PRIOR(i);
    END LOOP;
  
  END display_reverse;

end pt_work_with_collections;
