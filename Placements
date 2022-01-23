SELECT Name1 FROM (SELECT s.ID, s.Name AS Name1, p.Salary, f.Friend_ID, s1.Name AS Name2, p1.Salary 
FROM Students s, Packages p, Friends f, Students s1, Packages p1 
WHERE s.ID = p.ID 
AND s.ID=f.ID 
AND f.Friend_ID = s1.ID 
AND s1.ID=p1.ID
AND p1.Salary>p.Salary 
ORDER BY 6);
