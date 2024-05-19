-----------------------------------------------------------------------------------------
 Data Types and Their Conversions, Conditions and Basic Operators, Aggregate Functions
-----------------------------------------------------------------------------------------

SELECT
FROM
WHERE
ORDER BY
LIMIT
;
SELECT *
FROM TEROR
WHERE REGION_TXT = 'South America'
ORDER BY NWOUND DESC NULLS LAST
LIMIT 700
;
---------------------------------------------------------
-- CAST -  DATA TYPE CASTING
---------------------------------------------------------
SELECT
    *
FROM TEROR
LIMIT 100;
-- describe the table - data types
DESC TABLE TEROR; -- column type
SHOW COLUMNS IN TABLE TEROR; -- column data_type
-- Data type casting, we will use the CAST function
-- SYNTAX, two possible, they do the same thing:
-- CAST (column_name AS target_data_type)
-- column_name::target_data_type
-- Data type casting - number
SELECT 1 as Cislo;
SELECT '1' as Text;  
SELECT CAST('1' AS INT);
SELECT CAST('tohle neni cislo' AS INT);
-- Another notation using two colons (::)
SELECT '1'::INT;
SELECT 'tohle neni cislo'::INT;
-- FLOAT
SELECT '1'::FLOAT;
-- Data type casting - text string
SELECT 1::VARCHAR ; -- STRING
-- Data type- date
SELECT '2021-03-13'::DATE; -- YYYY-MM-DD by default

SELECT current_date();

SELECT '13.3.2021'::DATE;
SELECT '13/3/2021'::DATE;
SELECT '3/13/2021'::DATE;
SELECT '2021-03-13'::DATETIME;



---------------------------------------------------------
-- Basic operators
---------------------------------------------------------
a = b
a is equal to b.


a <> b
a != b
a is not equal to b. --both work the same, <> is universal



a > b
a is greater than b.

a >= b
a is greater than or equal to b.

a < b
a is less than b.

a <= b
a is less than or equal to b.

-- example TEXT
SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY = 'Prague';


SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE CITY <> 'Prague';


-- example numbers
SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL = 0;


SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL < 1;


SELECT CITY, IYEAR, NKILL
FROM TEROR 
WHERE NKILL >= 50;
-- Testing with conditions SELECT


SELECT 'Podmínka platí'
WHERE 1=1
;
-- testing, if '2' = 2
SELECT 'Podmínka platí'
WHERE '2' = 2
;
-- testing, if 1 + 4 - 2 / 2 is smaller than 2 * 2
SELECT 'Podmínka platí'
WHERE 1 + 4 - 2 / 2 < 2 * 2  --not correct
;
-- testing, if 5 is smaller or equal 10
SELECT 'Podmínka platí'
WHERE 5 <= 10
;
-- testing, if 500 is not equal to 10 
SELECT 'Podmínka platí'
WHERE 500::varchar != 10
;
     
-- Task. Display only the columns GNAME, COUNTRY_TXT, NKILL, and all rows (sorted by the number of deaths in descending order) where there are more than 340 deaths (the number of deaths is in the column NKILL), rename the columns to ORGANIZATION, COUNTRY, NUMBER_OF_DEATHS.


SELECT
    GNAME AS ORGANIZACE
  , COUNTRY_TXT AS ZEME
  , NKILL AS POCET_MRTVYCH
FROM TEROR
WHERE NKILL > 340
ORDER BY POCET_MRTVYCH DESC
;

---------------------------------------------------------
-- Comparing multiple values - numbers and text strings
 IYEAR IN (1990, 1998, 1999)
 CITY IN ('Prague', 'Brno', 'Bratislava')
 ;

 SELECT *
 FROM TEROR
 WHERE CITY IN ('Prague', 'Brno', 'Bratislava')

 


-- Task: Select columns IYEAR and EVENTID from the table TERROR for records that occurred in the years 2016 and 2017.
SELECT IYEAR, EVENTID
FROM TEROR
WHERE IYEAR IN (2016, 2017)
;
---------------------------------------------------------
-- AND, OR and ()
---------------------------------------------------------
SELECT 'Podmínka platí'
WHERE 1=1 AND 2=2
;
SELECT 'Podmínka platí'
WHERE 1=1 OR 2=2
;
-- Add the condition: Both are true: 5 is less than or equal to 6 and 3 multiplied by 10 equals 30.
SELECT 'Podmínka platí'
WHERE 5 <= 6 AND 3*10 = 30
;

-- Add the condition: Either 5 is less than 4 or 5 is greater than 5. (Or both are true.)
SELECT 'Podmínka platí'
WHERE 5<4 OR 5>5
;
--Task: Select from the table TERROR attacks in Germany where at least one terrorist died (NKILLter).  
SELECT *
FROM TEROR
WHERE  NKILLTER > 0
       AND COUNTRY_TXT = 'Germany'
;
-- Let's take a look at how parentheses work.
SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND CITY='Delina' OR CITY='Bara';


SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND CITY='Prague' OR CITY='Bara';

SELECT DISTINCT COUNTRY_TXT, CITY   
FROM TEROR 
WHERE COUNTRY_TXT = 'India' AND CITY='Bara' OR CITY='Delina';

SELECT DISTINCT COUNTRY_TXT, CITY
FROM TEROR
WHERE COUNTRY_TXT = 'India' AND (CITY='Delina' OR CITY='Bara');
-- Example of conditions and simultaneously using the COUNT() function:
-- Count the number of records in the TERROR table,
-- where more than 1000 people were injured or more than 10 terrorists were killed (in any year) or
-- where either more than 100 people were killed and the attack occurred in 2016 or
-- where more than or equal to 110 people were killed and the attack occurred in 2017

SELECT COUNT (*)
FROM TEROR
WHERE 1=1
      AND NWOUND > 1000 OR NKILL > 10
      OR NKILL > 100 AND IYEAR = 2016
      OR NKILL >= 110 AND IYEAR = 2017;




SELECT COUNT(*)
FROM TEROR
WHERE 1=1
    AND NWOUND > 1000 OR NKILLTER > 10
    OR NKILL > 100 AND IYEAR = 2016
    OR NKILL >= 110 AND IYEAR = 2017
;
---------------------------------------------------------
-- Agregation function
---------------------------------------------------------
---------------------------------------------------------                        
-- COUNT() 
---------------------------------------------------------                        
SELECT 
    COUNT(*) 
FROM TEROR;
SELECT 
    COUNT(EVENTID)
FROM TEROR;
-- COUNT(DISTINCT x)
SELECT 
    COUNT(DISTINCT COUNTRY_TXT)
FROM TEROR;
---------------------------------------------------------                        
-- SUM() 
---------------------------------------------------------
SELECT 
    SUM(NKILL) AS pocet_mrtvych
FROM TEROR;
---------------------------------------------------------                        
-- AVG() 
---------------------------------------------------------  
SELECT 
    AVG(NKILL) AS prumerny_pocet_mrtvych 
FROM TEROR;
---------------------------------------------------------                        
-- MAX() 
---------------------------------------------------------                         
-- vwill show the same number
SELECT 
    MAX(NKILL) AS max_pocet_mrtvych
FROM TEROR;
-- the same
SELECT 
    NKILL AS max_pocet_mrtvych
    , *
FROM TEROR 
WHERE NKILL IS NOT NULL 
ORDER BY NKILL DESC 
LIMIT 1; 
---------------------------------------------------------                        
-- MIN() 
---------------------------------------------------------                         
                          
SELECT 
    MIN(NKILL) AS min_pocet_mrtvych
FROM TEROR
;
-- Exercise: Write a query that returns from the TERROR Table:
-- The number of different cities in the CITY column
-- The minimum (earliest) date in the IDATE column
-- The maximum number of terrorists killed in one attack in the NKILLTER column
-- The average number of wounded per attack from the NWOUND column
-- The total number of killed individuals in the table - NKILL column

  
SELECT
      COUNT(DISTINCT CITY)
    , MIN(IDATE)
    , MAX(NKILLTER)
    , AVG(NWOUND)
    , SUM(NKILL)
FROM TEROR
;
---------------------------------------------------------                        
-- GROUP BY 
---------------------------------------------------------                         
-- List of the countries
SELECT DISTINCT COUNTRY_TXT
FROM TEROR
;
-- grouped countries
SELECT COUNTRY_TXT
FROM TEROR
GROUP BY COUNTRY_TXT
;
-- how many values in the table
SELECT COUNTRY_TXT, COUNT(*)
FROM TEROR
GROUP BY COUNTRY_TXT
;

--select all the regions (REGION_TXT)  and count how many in each region 
SELECT REGION_TXT, COUNT (*)
FROM TEROR
GROUP BY REGION_TXT



SELECT REGION_TXT, COUNT(*)
FROM TEROR
GROUP BY REGION_TXT
;
-- count killed  GNAME (TERORisticke organizace)
SELECT GNAME, SUM (NKILL)
FROM TEROR
GROUP BY GNAME






SELECT GNAME, -- group
       SUM(NKILL) -- aggregation
FROM TEROR
GROUP BY GNAME;
--  GNAME a COUNTRY_TXT
SELECT GNAME, -- skupina
       COUNTRY_TXT, -- skupina 
       SUM(NKILL), -- agregace
       COUNT(NKILL) -- agregace
FROM TEROR
GROUP BY GNAME, COUNTRY_TXT;

// A // Find the number of victims and injured by years and months
// B // Find the number of victims and injured in Western Europe by years and months
// C // Find the number of attacks by countries. Sort them by the number of attacks in descending order
// D // Find the number of attacks by countries and years, sort them by the number of attacks in descending order
// E // How many attacks each organization carried out with incendiary weapons (weaptype1_txt = 'Incendiary'),
-- how many victims they killed in total, how many terrorists died, and how many people were wounded (NKILL, NKILLter, nwound)

--A
SELECT IYEAR 
    , IMONTH 
    , SUM(NKILL) AS KILLED 
    , SUM(NWOUND) AS WOUNDED 
FROM TEROR 
GROUP BY IYEAR, IMONTH 
ORDER BY IYEAR, IMONTH; 


SELECT IYEAR
     , IMONTH
       ,  SUM (NKILL) AS KILLED
       , SUM (NWOUND) AS WOUNDED
FROM TEROR
WHERE REGION_TXT = 'Western Europe'
GROUP BY IYEAR, IMONTH
ORDER BY IYEAR, IMONTH




--B
SELECT IYEAR
    , IMONTH
    , SUM(NKILL) AS KILLED
    , SUM(NWOUND) AS WOUNDED
FROM TEROR
WHERE REGION_TXT = 'Western Europe'
GROUP BY IYEAR, IMONTH
ORDER BY IYEAR, IMONTH;
--C

SELECT COUNTRY_TXT,
    COUNT(*)
FROM TEROR
GROUP BY 1
ORDER BY COUNT(*) DESC;
--D
SELECT COUNTRY_TXT,
    IYEAR,
    COUNT(*)
FROM TEROR
GROUP BY COUNTRY_TXT,
    IYEAR
ORDER BY COUNT(*) DESC;
--E
SELECT GNAME,
    COUNT(EVENTID),
    SUM(NKILL),
    SUM(NKILLTER),
    SUM(NWOUND) 
FROM TEROR 
WHERE WEAPTYPE1_TXT = 'Incendiary' 
GROUP BY GNAME;
------------------------------------------------------------------------------
---------------------------------------------------------                        
-- HAVING - the ability to specify conditions for groups (GROUP BY)
---------------------------------------------------------                         
-- SQL query order:
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
-- number of deaths by terrorist organization where the number of victims is greater than zero


SELECT GNAME, SUM(NKILL)
FROM TEROR
GROUP BY GNAME
HAVING SUM(NKILL) > 0





SELECT 
      GNAME
    , SUM(NKILL) AS pocet_mrtvych 
    , COUNT(EVENTID) AS pocet_utoku
FROM TEROR 
GROUP BY GNAME 
HAVING SUM(NKILL) > 0 
ORDER BY pocet_mrtvych DESC; 
-- vs jother example
SELECT 
      GNAME
    , SUM(NKILL) AS pocet_mrtvych 
    , COUNT(EVENTID) AS pocet_utoku
FROM TEROR 
WHERE (NKILL) > 0
GROUP BY GNAME 
ORDER BY pocet_mrtvych DESC; 
-- number of deaths by terrorist organization where the number of victims and the number of dead terrorists is greater than zero
SELECT 
    GNAME
    , SUM(NKILL) AS pocet_mrtvych
    , SUM(NKILLter) AS pocet_mrtvych_TERORistu 
FROM TEROR 
GROUP BY GNAME 
HAVING SUM(NKILL) > 0 
   AND SUM(NKILLter) >= 1 
ORDER BY SUM(NKILL) DESC; 

--F
SELECT GNAME,
    COUNT(EVENTID) AS UTOKU,
    SUM(NKILL) AS MRTVI,
    SUM(NKILLTER) AS MRTVYCH_TERORISTU,
    SUM(NWOUND) AS RANENYCH
FROM TEROR
WHERE WEAPTYPE1_TXT = 'Incendiary'
GROUP BY GNAME
HAVING SUM(NKILL) > 10;
 