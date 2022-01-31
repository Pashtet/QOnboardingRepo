--исходня таблица
select name, sum(point)
from (
select 'Серёжа' name , '2011' year, '23' point
from dual
union all
select 'Паша' name , '2009' year, '13' point
from dual
union all
select 'Серёжа' name , '2001' year, '10' point
from dual)c
GROUP BY name;

/*задание

Нужно получить сумму за все года только по тому мальчику который запись которого содержит 2011 год.
Т.е. должно получится Серёжа 33 (сумма за 2011 и 2001 года)
Пашу выводить не надо, т.к. у него нет достижений в 2011 годе.

ЗАДВАИВАТЬ таблицу "С"(Делать подзапрос из этой таблицы) не стоит. Так она ОЧЕНЬ больная. 
*/

--создаем таблицу отдельную для работы
CREATE TABLE t ( 
	name varchar(20),
	year number,
	point number);
	
--вставляем данные по отдельности
INSERT INTO t (name,year,point) VALUES ('Сережа', 2001, 10);
INSERT INTO t (name,year,point) VALUES ('Паша', 2009, 13);
INSERT INTO t (name,year,point) VALUES ('Сережа', 2001, 10);

--вставляем с помощью INSERT ALL
INSERT ALL 
    INTO t (name,year,point) values ('Сережа', 2011, 23)
	INTO t (name,year,point) values ('Паша', 2009, 13)
	INTO t (name,year,point) values ('Сережа', 2001, 10);
	
--выбор с подзапросом по таблице
select name, sum(point)
from t WHERE name = (SELECT name FROM t WHERE year = 2011)
GROUP BY name;

--выбор с помощью оконной функции
SELECT name, s FROM (
SELECT name, year, sum(point) OVER (PARTITION BY name) AS s FROM t)
WHERE year = 2011
ORDER BY name;



