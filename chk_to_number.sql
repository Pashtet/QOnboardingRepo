--объявление спецификации пакета
CREATE OR REPLACE PACKAGE test_to_number AS

	FUNCTION chk_to_number(str IN VARCHAR2) RETURN VARCHAR2;
	FUNCTION xx_to_number(str IN VARCHAR2) RETURN VARCHAR2;

END test_to_number;

--объявление тела пакета
CREATE OR REPLACE PACKAGE BODY test_to_number AS
	
FUNCTION chk_to_number (str IN VARCHAR2) RETURN VARCHAR2 IS 

	invalid_string_to_number EXCEPTION;
	PRAGMA EXCEPTION_INIT (invalid_string_to_number, -6502); 

	BEGIN
	dbms_output.put_line(TO_NUMBER(str));

	RETURN('S');

	EXCEPTION
		WHEN invalid_string_to_number
		THEN
			dbms_output.put_line(str);
			RETURN('Err');
			RAISE;
	END chk_to_number;
	
FUNCTION xx_to_number (str IN VARCHAR2) RETURN VARCHAR2 IS 
	
	string_is_number BOOLEAN;
	number_contains_comma BOOLEAN;
	
	BEGIN
	string_is_number := REGEXP_LIKE(TRIM(str), '^([+-]?)\d+\.?\d*$');
	number_contains_comma := REGEXP_LIKE(TRIM(str), '^([+-]?)\d+\,?\d*$');
	
	IF string_is_number
	THEN
	    dbms_output.put_line('Number');
	    dbms_output.put_line(TO_NUMBER(str));
		RETURN('S');

	ELSE IF number_contains_comma
	    THEN 
		    dbms_output.put_line('Number contains comma');
		    dbms_output.put_line(TO_NUMBER(REPLACE(str,',','.')));
			RETURN('S');
		ELSE 
			dbms_output.put_line(str);
		    RETURN('Err');		    
		END IF;
		
	END IF;

END xx_to_number;
	
END test_to_number;

--проверка chk_to_number
BEGIN
--ok
dbms_output.put_line(test_to_number.chk_to_number('100'));
dbms_output.put_line(test_to_number.chk_to_number('100.10'));
dbms_output.put_line(test_to_number.chk_to_number('-100.10'));
dbms_output.put_line(test_to_number.chk_to_number(' 100.10'));
dbms_output.put_line(test_to_number.chk_to_number(' 100.10 '));
dbms_output.put_line(test_to_number.chk_to_number('+100.10'));
dbms_output.put_line(test_to_number.chk_to_number('00100.10'));
--notOk
dbms_output.put_line(test_to_number.chk_to_number(' 100 .10 '));
dbms_output.put_line(test_to_number.chk_to_number('жопа'));
dbms_output.put_line(test_to_number.chk_to_number('100,10'));
dbms_output.put_line(test_to_number.chk_to_number('00100,10'));
END;
--проверка xx_to_number
BEGIN
--ok
dbms_output.put_line(test_to_number.xx_to_number('100'));
dbms_output.put_line(test_to_number.xx_to_number('100.10'));
dbms_output.put_line(test_to_number.xx_to_number('-100.10'));
dbms_output.put_line(test_to_number.xx_to_number(' 100.10'));
dbms_output.put_line(test_to_number.xx_to_number(' 100.10 '));
dbms_output.put_line(test_to_number.xx_to_number('+100.10'));
dbms_output.put_line(test_to_number.xx_to_number('00100.10'));
--notOk
dbms_output.put_line(test_to_number.xx_to_number(' 100 .10 '));
dbms_output.put_line(test_to_number.xx_to_number('жопа'));
--ok
dbms_output.put_line(test_to_number.xx_to_number('100,10'));
dbms_output.put_line(test_to_number.xx_to_number('00100,10'));
END;
