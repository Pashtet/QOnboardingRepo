-- работа с ассоциативным массивом

declare

  TYPE a_array IS TABLE of PLS_INTEGER INDEX BY PLS_INTEGER;
  a_array_test a_array;
  i            PLS_INTEGER;

  PROCEDURE pl(in_text IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(in_text);
  END pl;

  PROCEDURE display_direct(in_a_array IN a_array) IS
  BEGIN
    pl('Display direct array:');
    i := in_a_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_a_array(i));
      i := in_a_array.NEXT(i);
    END LOOP;
  END display_direct;

  PROCEDURE display_reverse(in_a_array IN a_array) IS
  BEGIN
    pl('Display reverse array:');
    i := in_a_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_a_array(i));
      i := in_a_array.PRIOR(i);
    END LOOP;
  END display_reverse;

begin

  pl('Create assoсiative array from 1 to 10.');
  FOR i IN 1 .. 10 LOOP
    a_array_test(i) := i;
  END LOOP;

  display_direct(a_array_test);

  display_reverse(a_array_test);

  pl('Display number of elements a_array: ' || a_array_test.COUNT);

  pl('Delete first element in a_array!');
  a_array_test.DELETE(a_array_test.FIRST);
  display_direct(a_array_test);

  pl('Is element 10 exist in a_array?');
  IF a_array_test.EXISTS(10) THEN
    pl('YES!');
  ELSE
    pl('No!');
  END IF;

  pl('Delete last element in a_array!');
  a_array_test.DELETE(a_array_test.LAST);
  display_direct(a_array_test);

  pl('Is element 10 still exist in a_array?');
  IF a_array_test.EXISTS(10) THEN
    pl('YES!');
  ELSE
    pl('No!');
  END IF;

  pl('Display number of elements a_array: ' || a_array_test.COUNT);

  pl('Add first element 10 in a_array');
  a_array_test(a_array_test.FIRST - 1) := 10;
  display_direct(a_array_test);

  pl('Add last element 1 in a_array');
  a_array_test(a_array_test.LAST + 1) := 1;
  display_direct(a_array_test);

  -- TRIM only to nested table or VARRAY
  /* pl('Trim a_array');
  a_array_test.TRIM;
  display_direct(a_array_test);*/

end;
