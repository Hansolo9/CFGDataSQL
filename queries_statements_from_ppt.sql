
###VIEW WITH ANY TYPE OF JOIN##

create view staff_namelocs AS
SELECT S_grp_id, S_FName, S_LName, S_loc
FROM staff s
INNER JOIN production_teams pt
ON s.ProdT_ID = pt.S_grp_id;

select * from staff_namelocs;

create view total_members AS
SELECT count(S_FName) as noOfStaff
FROM staff s
INNER JOIN production_teams pt
ON s.ProdT_ID = pt.S_grp_id
WHERE s.ProdT_ID = 8;

select * from total_members;

### STORED FUNCTION###

DELIMITER //
CREATE FUNCTION isBudgetHigh(
    budget INT
) RETURNS varchar(50)
DETERMINISTIC
BEGIN
    DECLARE clientPriority VARCHAR(50);
    IF budget >= 10000 THEN
        SET clientPriority = 'YES';
	ELSEIF budget < 10000 THEN
        SET clientPriority = 'NO';
        END IF;
		RETURN (clientPriority);
END//
DELIMITER ; 


### CALL STORED FUNCTION ###

SELECT G_Name, 
isBudgetHigh(G_Budget)
FROM games
ORDER BY 
G_Name; 

### QUERY WITH A SUBQUERY ###
SELECT * FROM production_teams
WHERE S_grp_id in (

SELECT DISTINCT PT_assigned
FROM games
WHERE G_Budget < 10000);

### ALL TRIGGERS CLEARLY MARKED IN TABLE DROP DOWNS ON WORKBENCH### 
### PLEASE VIEW WHEN YOU RESTORE FROM BACKUP ###

SELECT e1.G_Name, count(e2.S_grp_id) AS total_teams
FROM games AS e1 LEFT JOIN production_teams AS e2
ON e1.PT_assigned = e2.S_grp_id
GROUP BY e1.G_Name
HAVING total_teams > 0;

### names of staff who are currently working on projects ###

CREATE VIEW noReassign AS
SELECT s.* , g.*, pt.*
FROM staff s
RIGHT OUTER JOIN production_teams pt
ON s.ProdT_ID = pt.S_grp_id
INNER JOIN games g
on pt.S_grp_id = g.PT_assigned 
WHERE g.G_Status = "IN PRODUCTION";

select * from noReassign;

### RANDOM ##
SELECT G_Name, S_loc
FROM games g
INNER JOIN production_teams pt 
ON pt.S_grp_id = g.PT_assigned
WHERE g.G_Status = "IN PRODUCTION";



