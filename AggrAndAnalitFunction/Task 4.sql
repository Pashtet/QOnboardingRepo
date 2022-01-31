CREATE TABLE t ( 
	name varchar(20),
	year number,
	point number);

INSERT ALL 
    INTO t (name,year,point) values ('Сережа', 2011, 23)
	  INTO t (name,year,point) values ('Паша', 2009, 13)
	  INTO t (name,year,point) values ('Сережа', 2001, 10)
SELECT * FROM dual;

select name, sum(point)
from t WHERE name = (SELECT name FROM t WHERE year = 2011)
GROUP BY name;

SELECT name, s FROM 
  (SELECT name, year, sum(point) OVER (PARTITION BY name) AS s 
  FROM t)
WHERE year = 2011
ORDER BY name;
