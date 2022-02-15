-- работа с вложенной таблицей

declare
  TYPE n_table IS TABLE of PLS_INTEGER;
  n_t_test n_table := n_table();
  i        PLS_INTEGER;

  PROCEDURE pl(in_text IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(in_text);
  END pl;

  PROCEDURE display_direct(in_n_table IN n_table) IS
  BEGIN
    pl('Display direct nested table:');
    i := in_n_table.FIRST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_n_table(i));
      i := in_n_table.NEXT(i);
    END LOOP;
  END display_direct;

  PROCEDURE display_reverse(in_n_table IN n_table) IS
  BEGIN
    pl('Display reverse nested table:');
    i := in_n_table.LAST;
    WHILE (i IS NOT NULL) LOOP
      pl(in_n_table(i));
      i := in_n_table.PRIOR(i);
    END LOOP;
  END display_reverse;

begin

  pl('Create nested table from 1 to 10.');

  FOR i IN 1 .. 10 LOOP
    n_t_test.EXTEND;
    n_t_test(i) := i;
  END LOOP;

  display_direct(n_t_test);
  display_reverse(n_t_test);

  pl('Display number of elements nested table: ' || n_t_test.COUNT);
  
  --для вложенных таблиц похоже лучше не вставлять в середину, начало, только в конец с EXTEND 
  --и удаление желательно через TRIM - т.е. только с конца
  pl('Delete first element in nested table!');
  n_t_test.DELETE(n_t_test.FIRST);

  display_direct(n_t_test);

  pl('Is element 10 exist in nested table?!');
  IF n_t_test.EXISTS(10) THEN
    pl('YES!');
  ELSE
    pl('No!');
  END IF;

  pl('Delete last element in nested table!');
  n_t_test.DELETE(n_t_test.LAST);
  display_direct(n_t_test);

  pl('Is element 10 still exist in nested table?!');
  IF n_t_test.EXISTS(10) THEN
    pl('YES!');
  ELSE
    pl('No!');
  END IF;

  pl('Display number of elements nested table: ' || n_t_test.COUNT);
  
  --так как удаляли последний элемент методом DELETE, то место с индексом сохранилось под значение
  --если TRIM, то надо снова выделять EXTEND
  pl('Add first element 10 in nested table');
  n_t_test(n_t_test.FIRST - 1) := 10;
  display_direct(n_t_test);

  pl('Add last element 1 in nested table');
  n_t_test(n_t_test.LAST + 1) := 1;
  display_direct(n_t_test);
  
  pl('TRIM 1 element');
  n_t_test.TRIM;
  display_direct(n_t_test);
  pl('Display number of elements nested table: ' || n_t_test.COUNT);
  
  pl('Add element 11 in nested table with EXTEND');
  n_t_test.EXTEND;
  n_t_test(n_t_test.LAST) := 11;
  display_direct(n_t_test);

end;
