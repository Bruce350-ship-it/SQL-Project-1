-- This is a simple SQL project, created by BRUCE BAINOMUGISHA using Microsoft SQL Server Management Studio, and these queries can be useful in handling employee data for various organizations.

-- A quick look at the summary of the employee demographics and salaries
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS FullName, d.DepartmentName, s.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;

-- Assessing employee salaries based on average salary
SELECT e.FirstName, e.LastName,
       CASE 
           WHEN s.Salary < 60000 THEN 'Below Average'
           WHEN s.Salary BETWEEN 60000 AND 70000 THEN 'Average'
           ELSE 'Above Average'
       END AS SalaryRange
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;

-- Ranking employees within each department based on their salaries
SELECT e.FirstName, e.LastName, s.Salary,
       ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY s.Salary DESC) AS RowNum
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;

-- Employees who participated in the Project Alpha, which id ProjectID = 1
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.EmployeeID IN (SELECT EmployeeID FROM EmployeeProjects WHERE ProjectID = 1);

-- Utilizing a view for use in Exel, Tableau or PowerBI
CREATE VIEW EmployeeSalaryView AS
SELECT e.FirstName, e.LastName, s.Salary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;
SELECT * FROM EmployeeSalaryView;

-- Temporary tables are used for Storing Intermediate Results, Breaking Down Complex Queries, Data Transformation and ETL Processes, Handling Recursive Queries, and Isolation of Data.
-- For this specific case, it is being used to Isolating only the employees' salaries by their ID's.
CREATE TABLE #TempEmployeeSalaries (
    EmployeeID INT,
    Salary DECIMAL(18, 2)
);
INSERT INTO #TempEmployeeSalaries (EmployeeID, Salary)
SELECT e.EmployeeID, s.Salary
FROM Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;
SELECT * FROM #TempEmployeeSalaries;

-- Utilizing a CTE to determine how many projects each customer is working on
WITH EmployeeProjectCounts AS (
    SELECT e.EmployeeID, COUNT(ep.ProjectID) AS ProjectCount
    FROM Employees e
    JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    GROUP BY e.EmployeeID
)
SELECT e.FirstName, e.LastName, ep.ProjectCount
FROM Employees e
JOIN EmployeeProjectCounts ep ON e.EmployeeID = ep.EmployeeID;

-- Using a Stored Procedure to summarize employee salaries
CREATE PROCEDURE GetEmployeeSalaries
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, s.Salary
    FROM Employees e
    JOIN Salaries s ON e.EmployeeID = s.EmployeeID;
END;
EXEC GetEmployeeSalaries;