--нужно изменить параметры сессии/бд
alter session set nls_numeric_characters ='. ';
BEGIN
DBMS_OUTPUT.PUT_LINE(TO_CHAR(123456.789,'999G999D99'));
END;