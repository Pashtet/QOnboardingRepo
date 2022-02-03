SELECT date1, TRUNC(date1, 'MM') AS First_day, LAST_DAY(date1) AS Last_day,
ADD_MONTHS(TRUNC(date1, 'MM'), 1) AS First_day_next_month,
TRUNC(date1, 'dd')-1 AS Previous_day
FROM (select sd+LEVEL-1 date1
from (SELECT TRUNC(SYSDATE) sd from dual) cc
connect by SYSDATE + level-1< SYSDATE + 366) v;