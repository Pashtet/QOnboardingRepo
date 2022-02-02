CREATE TABLE v ( 
	val VARCHAR(30));
	
INSERT ALL 
    INTO v (val) values ('П. Н. Наумов')
	INTO v (val) values ('Ал. C. Колесников')
	INTO v (val) values ('З. Пт. Шталь')
	SELECT * FROM dual;
	
DECLARE 

    CURSOR v_cur 
    IS
        SELECT val FROM v;
    
    l_v v_cur%ROWTYPE;
    l_v_val l_v.val%TYPE;
    l_substr1 l_v.val%TYPE;
    l_substr2 l_v.val%TYPE;
    substr1_pattern VARCHAR2(40):='^\w+\. \w+\. ';
    substr2_pattern VARCHAR2(40):='\w*$';
BEGIN

    FOR rec IN v_cur
    LOOP
        l_v:=rec;
        l_v_val := l_v.val;
        l_substr1 := REGEXP_SUBSTR(l_v_val, substr1_pattern);
        l_substr2 := REGEXP_SUBSTR(l_v_val, substr2_pattern);
        DBMS_OUTPUT.PUT_LINE('1 строка: ' || l_substr1 || 'вторая строка: ' || l_substr2);
    END LOOP;
    
END;