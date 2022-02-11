-- работа с ассоциативным массивом

declare

  a_array_test pt_work_with_a_array.a_array;
  i            PLS_INTEGER;

begin
  
  DBMS_OUTPUT.PUT_LINE('Create assoсiative array from 1 to 10.');
  FOR i IN 1 .. 10 LOOP
    a_array_test(i) := i;
  END LOOP;

  pt_work_with_a_array.display_direct_a_array(a_array_test);

  pt_work_with_a_array.display_reverse_a_array(a_array_test);

  DBMS_OUTPUT.PUT_LINE('Display number of elements a_array: ' ||
                       a_array_test.COUNT);

  DBMS_OUTPUT.PUT_LINE('Delete first element in a_array!');
  a_array_test.DELETE(a_array_test.FIRST);
  pt_work_with_a_array.display_direct_a_array(a_array_test);

  DBMS_OUTPUT.PUT_LINE('Is element 10 exist in a_array?!');
  IF a_array_test.EXISTS(10) THEN
    DBMS_OUTPUT.PUT_LINE('YES!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No!');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Delete last element in a_array!');
  a_array_test.DELETE(a_array_test.LAST);
  pt_work_with_a_array.display_direct_a_array(a_array_test);

  DBMS_OUTPUT.PUT_LINE('Is element 10 still exist in a_array?!');
  IF a_array_test.EXISTS(10) THEN
    DBMS_OUTPUT.PUT_LINE('YES!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No!');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Display number of elements a_array: ' ||
                       a_array_test.COUNT);

end;


create or replace package pt_work_with_a_array is

  -- Author  : P.TROFIMOV
  -- Created : 11.02.2022 11:39:29
  -- Purpose : Work with associative array

  -- Public type declarations
  TYPE a_array IS TABLE of PLS_INTEGER INDEX BY PLS_INTEGER;

  PROCEDURE display_direct_a_array(in_a_array IN a_array);
  PROCEDURE display_reverse_a_array(in_a_array IN a_array);

end pt_work_with_a_array;

create or replace package body pt_work_with_a_array is

  PROCEDURE display_direct_a_array(in_a_array IN a_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Display direct array:');
    i := in_a_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_a_array(i));
      i := in_a_array.NEXT(i);
    END LOOP;
  
  END display_direct_a_array;

  PROCEDURE display_reverse_a_array(in_a_array IN a_array) IS
  
    i PLS_INTEGER;
  
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Display reverse array:');
    i := in_a_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      DBMS_OUTPUT.PUT_LINE(in_a_array(i));
      i := in_a_array.PRIOR(i);
    END LOOP;
  
  END display_reverse_a_array;

end pt_work_with_a_array;
