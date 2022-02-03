SELECT val, 
SUBSTR(val,1, (INSTR(val, ' ',1,2))) AS str1, 
SUBSTR(val,INSTR(val, ' ',1,2)) AS str2
FROM (select 'П. Н. Наумов' val
from dual
union all
select 'Ал. C. Колесников' val
from dual
union all
select 'З. Пт. Шталь' val
from dual) v;