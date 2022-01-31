--������� �������
select name, sum(point)
from (
select '�����' name , '2011' year, '23' point
from dual
union all
select '����' name , '2009' year, '13' point
from dual
union all
select '�����' name , '2001' year, '10' point
from dual)c
GROUP BY name;

/*�������

����� �������� ����� �� ��� ���� ������ �� ���� �������� ������� ������ �������� �������� 2011 ���.
�.�. ������ ��������� ����� 33 (����� �� 2011 � 2001 ����)
���� �������� �� ����, �.�. � ���� ��� ���������� � 2011 ����.

���������� ������� "�"(������ ��������� �� ���� �������) �� �����. ��� ��� ����� �������. 
*/

--������� ������� ��������� ��� ������
CREATE TABLE t ( 
	name varchar(20),
	year number,
	point number);
	
--��������� ������ �� �����������
INSERT INTO t (name,year,point) VALUES ('������', 2001, 10);
INSERT INTO t (name,year,point) VALUES ('����', 2009, 13);
INSERT INTO t (name,year,point) VALUES ('������', 2001, 10);

--��������� � ������� INSERT ALL
INSERT ALL 
    INTO t (name,year,point) values ('������', 2011, 23)
	INTO t (name,year,point) values ('����', 2009, 13)
	INTO t (name,year,point) values ('������', 2001, 10);
	
--����� � ����������� �� �������
select name, sum(point)
from t WHERE name = (SELECT name FROM t WHERE year = 2011)
GROUP BY name;

--����� � ������� ������� �������
SELECT name, s FROM (
SELECT name, year, sum(point) OVER (PARTITION BY name) AS s FROM t)
WHERE year = 2011
ORDER BY name;



