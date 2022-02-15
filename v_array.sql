-- работа с varray
declare
  TYPE v_array IS VARRAY(10) of PLS_INTEGER;
  v_array_test v_array := v_array();
  i            PLS_INTEGER;

  PROCEDURE pl(in_text IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(in_text);
  END pl;

  PROCEDURE display_direct(in_v_array IN v_array) IS
  BEGIN
    pl('Display direct v_array');
    i := in_v_array.FIRST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_v_array(i));
      i := in_v_array.NEXT(i);
    END LOOP;
  END display_direct;

  PROCEDURE display_reverse(in_v_array IN v_array) IS
  BEGIN
    pl('Display reverse v_array');
    i := in_v_array.LAST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_v_array(i));
      i := in_v_array.PRIOR(i);
    END LOOP;
  END display_reverse;

begin

  pl('Create v_array from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    v_array_test.EXTEND;
    v_array_test(i) := i;
  END LOOP;

  display_direct(v_array_test);
  display_reverse(v_array_test);

  pl('Display number of elements v_array: ' || v_array_test.COUNT);
  pl('Display limit of elements v_array: ' || v_array_test.LIMIT);

  /*--с помощью DELETE можно удалить только весь массив v_array
  pl('Delete first element in v_array!');
  v_array_test.DELETE(v_array_test.FIRST);*/

  pl('Is element 10 exist in v_array?!');
  IF v_array_test.EXISTS(10) THEN
    pl('YES!');
  ELSE
    pl('No!');
  END IF;
  /*--с помощью DELETE можно удалить только весь массив v_array
    pl('Delete last element in v_array!');
  v_array_test.DELETE(v_array_test.LAST);*/

  pl('TRIM last element in v_array');
  v_array_test.TRIM;
  display_direct(v_array_test);

  --добавить новый элемент можно только в конец с EXTEND, если не превысили количество возможных элементов
  pl('Add last element 1 with EXTEND in v_array');
  IF v_array_test.LIMIT > v_array_test.COUNT THEN
    v_array_test.EXTEND;
    v_array_test(v_array_test.LAST) := 1;
  ELSE
    pl('COUNT = LIMIT');
  END IF;
  display_direct(v_array_test);

  pl('Try add element with element number > LIMIT in v_array');
  IF v_array_test.LIMIT > v_array_test.COUNT THEN
    v_array_test.EXTEND;
    v_array_test(v_array_test.LAST) := 1;
  ELSE
    pl('COUNT = LIMIT');
  END IF;
  display_direct(v_array_test);

end;
