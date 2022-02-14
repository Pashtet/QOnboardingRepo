-- Created on 14.02.2022 by P.TROFIMOV 
-- работа с varray
declare

  v_array_test pt_work_with_v_array.v_array := pt_work_with_v_array.v_array();
  i            PLS_INTEGER;
begin

  DBMS_OUTPUT.PUT_LINE('Create v_array from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    v_array_test.EXTEND;
    v_array_test(i) := i;
  END LOOP;

  pt_work_with_v_array.display_direct_v_array(v_array_test);
  pt_work_with_v_array.display_reverse_v_array(v_array_test);

  DBMS_OUTPUT.PUT_LINE('Display number of elements v_array: ' ||
                       v_array_test.COUNT);
  DBMS_OUTPUT.PUT_LINE('Display limit of elements v_array: ' ||
                       v_array_test.LIMIT);

  /*--с помощью DELETE можно удалить только весь массив v_array
  DBMS_OUTPUT.PUT_LINE('Delete first element in v_array!');
  v_array_test.DELETE(v_array_test.FIRST);*/

  DBMS_OUTPUT.PUT_LINE('Is element 10 exist in v_array?!');
  IF v_array_test.EXISTS(10) THEN
    DBMS_OUTPUT.PUT_LINE('YES!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No!');
  END IF;
  /*--с помощью DELETE можно удалить только весь массив v_array
    DBMS_OUTPUT.PUT_LINE('Delete last element in v_array!');
  v_array_test.DELETE(v_array_test.LAST);*/

  DBMS_OUTPUT.PUT_LINE('TRIM last element in v_array');
  v_array_test.TRIM;
  pt_work_with_v_array.display_direct_v_array(v_array_test);

  --добавить новый элемент можно только в конец с EXTEND, если не превысили количество возможных элементов
  DBMS_OUTPUT.PUT_LINE('Add last element 1 with EXTEND in v_array');
  IF v_array_test.LIMIT > v_array_test.COUNT THEN
    v_array_test.EXTEND;
    v_array_test(v_array_test.LAST) := 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('COUNT = LIMIT');
  END IF;
  pt_work_with_v_array.display_direct_v_array(v_array_test);

  DBMS_OUTPUT.PUT_LINE('Try add element with element number > LIMIT in v_array');
  IF v_array_test.LIMIT > v_array_test.COUNT THEN
    v_array_test.EXTEND;
    v_array_test(v_array_test.LAST) := 1;
  ELSE
    DBMS_OUTPUT.PUT_LINE('COUNT = LIMIT');
  END IF;
  pt_work_with_v_array.display_direct_v_array(v_array_test);

end;


create or replace package pt_work_with_v_array is

  -- Author  : P.TROFIMOV
  -- Created : 14.02.2022 12:32:46
  -- Purpose : work with varray

  TYPE v_array IS VARRAY(10) of PLS_INTEGER;

  PROCEDURE display_direct_v_array(in_v_array IN v_array);
  PROCEDURE display_reverse_v_array(in_v_array IN v_array);

end pt_work_with_v_array;

create or replace package body pt_work_with_v_array is

  PROCEDURE display_direct_v_array(in_v_array IN v_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display direct v_array');
    i := in_v_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_v_array(i));
      i := in_v_array.NEXT(i);
    END LOOP;
  
  END display_direct_v_array;

  PROCEDURE display_reverse_v_array(in_v_array IN v_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
  
    DBMS_OUTPUT.PUT_LINE('Display reverse v_array');
    i := in_v_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_v_array(i));
      i := in_v_array.PRIOR(i);
    END LOOP;
  
  END display_reverse_v_array;

end pt_work_with_v_array;
