---------------------------------------------------------------------------
--JOINY 2.0
---------------------------------------------------------------------------

--New tables: teror2, attacktype, country, region, weaptype

SELECT *
FROM teror2
LIMIT 10;


SELECT *
FROM attacktype
LIMIT 10; -- column ID a NAME

SELECT *
FROM country
    LIMIT 10; -- column ID a NAME

SELECT *
FROM weaptype
LIMIT 10; -- scolumn ID a NAME

---------------------------------------------------------------------------
--INNER JOIN
--------------------------------------------------------------------------
-- in Snowflak in query INNER JOIN = JOIN

SELECT *
FROM teror2
JOIN attacktype 
    ON attacktype1 = id
LIMIT 10; -- contains all the columns from both tables 

--  If the columns in one of the tables we are joining had the same names, Snowflake wouldn't know which column we mean and would throw an error. That's why aliases (the keyword AS) are used.
-- Aliases can be used for abbreviation, as table names can be as long as a song in real life.SELECT *
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
LIMIT 10;

SELECT 
    a.*
    ,t.*
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
LIMIT 10; --again we see all the columns, first from the table attacktype and then from teror2


SELECT 
    t.eventid
    ,t.IDATE
    ,a.name
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
LIMIT 10; -- We can select only specific columns that we want to display, and they don't have to be the columns we used for joining.






-- we can show from the normal terror, that is possible to use the function in klauzuli ON

SELECT 
    t.attacktype1_txt
    ,a.name
FROM teror AS t
JOIN attacktype AS a
    ON LOWER(t.attacktype1_txt) = LOWER(a.name)
;

SELECT 
    t.country_txt
    ,c.name
FROM teror AS t
JOIN country AS c
    ON t.country_txt ILIKE c.name
;

SELECT *
FROM TABULKA1 AS t1
JOIN TABULKA2 AS t2
    ON t1.DATUM BETWEEN t2.VALID_FROM AND t2.VALID_TO;

-- Again, we can also layer other keywords and functions.
SELECT 
    t.IDATE
    ,c.name
    ,t.nkill
    ,t.approxdate
FROM teror2 AS t
JOIN country AS c
    ON t.country = c.id
WHERE t.approxdate IS NOT NULL AND c.name ILIKE '%republic%'
ORDER BY nkill DESC NULLS LAST
--LIMIT 10
;

-- including GROUP BY
SELECT 
    a.name AS attack_type
    ,COUNT(*) AS pocet_utoku
FROM teror2 AS t
JOIN attacktype AS a
    ON t.attacktype1 = a.id
GROUP BY attack_type
HAVING attack_type ILIKE 'u%' OR attack_type ILIKE 'h%'
ORDER BY pocet_utoku DESC;



-- more JOINs in one
SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
INNER JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
INNER JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
INNER JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 449 rows


---------------------------------------------------------------------------
--LEFT JOIN
---------------------------------------------------------------------------

SELECT *
FROM teror2
LEFT JOIN attacktype 
    ON attacktype1 = id
LIMIT 10;


SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
LEFT JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
LEFT JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
LEFT JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 84341 řádků

-- vs INNER JOIN. Jaký je rozdíl?
SELECT
    t.EVENTID
    ,a1.NAME
    ,a2.NAME
    ,a3.NAME
FROM TEROR2 AS t
INNER JOIN ATTACKTYPE AS a1 
    ON t.ATTACKTYPE1 = a1.ID
INNER JOIN ATTACKTYPE AS a2
    ON t.ATTACKTYPE2 = a2.ID
INNER JOIN ATTACKTYPE AS a3 
    ON t.ATTACKTYPE3 = a3.ID
; -- 449 řádků


--------------------------------------------------------------------
-- Types of joins can be combined as needed in a single SELECT statement.
SELECT c.name as country, 
       atyp1.name as attack_type1, 
       atyp2.name as attack_type2, 
       atyp3.name as attack_type3
FROM teror2 as t2
LEFT JOIN country as c 
ON t2.country = c.id
JOIN attacktype as atyp1 
ON t2.attacktype1 = atyp1.id
JOIN attacktype as atyp2
ON t2.attacktype2 = atyp2.id
JOIN attacktype as atyp3 
ON t2.attacktype3 = atyp3.id; 


-------------------------------------------------------------------------
-- RIGHT JOIN
-------------------------------------------------------------------------

SELECT *
FROM teror2
RIGHT JOIN attacktype 
    ON attacktype1 = id;
--LIMIT 10;



SELECT 
    t.COUNTRY
    ,c.NAME AS COUNTRY_NAME
    ,t.IDATE
    ,a.NAME AS ATTACKTYPE1_TXT
FROM teror2 AS t
RIGHT JOIN country AS c
    ON t.country = c.id
RIGHT JOIN ATTACKTYPE AS A
    ON t.ATTACKTYPE1=A.ID
WHERE c.name = 'Czech Republic'
  AND t.iyear IN (2015, 2016)
  AND a.NAME = 'Facility/Infrastructure Attack'
;




-------------------------------------------------------------------------
-- FULL OUTER JOIN
-------------------------------------------------------------------------
-- Returns records that find a match plus the remaining records from both tables, used rarely
-- TABLE_OLD contains (1, 'Jan Smutný'), (2, 'Jana Červená'), (3, 'Monika Broučková'), (4, 'Pavel Obr')
-- TABLE_NEW contains (1, 'Jan Smutný'), (4, 'Pavel Obr'), (5, 'Tereza Okatá')
SELECT * FROM COURSES.SCH_CZECHITA_HRISTE.TABULKA_OLD AS o
FULL OUTER JOIN COURSES.SCH_CZECHITA_HRISTE.TABULKA_NEW AS n
ON o.id = n.id
;

-------------------------------------------------------------------------
-- CROSS JOIN
-------------------------------------------------------------------------
-- Cartesian product
-- Returns combinations of all rows from both tables without any match between any columns

SELECT count(*)
FROM teror2; -- 84341

SELECT count(*)
FROM attacktype; -- 9

SELECT *
FROM teror2 AS t
CROSS JOIN attacktype AS a
;--759 069

SELECT 9 * 84341; --759 069

-- Be cautious with CROSS JOIN on large tables
SELECT *
FROM teror2 AS t1
CROSS JOIN teror2 AS t2
;--

SELECT 84341 * 84341; --507 177

-- Be cautious with CROSS JOIN
SELECT *
FROM teror2 AS t
JOIN attacktype AS a
--ON 1=1
; --507 177


