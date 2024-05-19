------------------------------------------------------------------------------------------------------------------
--INSERT, DELETE, CREATE, ALTER A IMPORT DAT
------------------------------------------------------------------------------------------------------------------


--> 1. Vyberte 10 řádků z tabulky TEROR.


---------------------------------------------------------
-- CREATE TABLE
---------------------------------------------------------
-- NOVA_TABULKA
CREATE TABLE KOSTRICKA (
   SLOUPEC1 INT
  ,SLOUPEC2 VARCHAR
);
SELECT * FROM NOVA_TABULKA;
SELECT * FROM NOVA_TABULKA;
DESC TABLE NOVA_TABULKA;
DROP TABLE NOVA_TABULKA;



---------------------------------------------------------
-- DROP TABLE (smazání tabulky), UNDROP (restore tabulky)
-- CREATE OR REPLACE TABLE (přepis již existující tabulky)
---------------------------------------------------------

-- DROP & UNDROP NOVA_TABULKA
DROP TABLE NOVA_TABULKA;

UNDROP TABLE NOVA_TABULKA; -- default 24 hodin, zalezi na data travel feature

SELECT * FROM NOVA_TABULKA;

-- DROP & CREATE TABLE

CREATE TABLE NOVA_TABULKA (
    ID INT
  , JMENO VARCHAR(255)
  , DATUM_NAROZENI DATE
  , MESTO_NAROZENI VARCHAR(255)
);

-- DROP TABLE NOVA_TABULKA;

-- CREATE OR REPLACE

CREATE TABLE NOVA_TABULKA (
    ID INT
  , JMENO VARCHAR(255)
  , DATUM_NAROZENI DATE
  , MESTO_NAROZENI VARCHAR(255)
  , VELIKOST_NOHY INT
);

DESC TABLE NOVA_TABULKA;

SELECT * FROM NOVA_TABULKA;

---------------------------------------------------------                        
-- INSERT INTO TABULKA (SLOUPEC1, SLOUPEC2) ... VALUES
---------------------------------------------------------                        
-- vložení jednotlivých řádků do tabulky

DESC TABLE NOVA_TABULKA;

INSERT INTO NOVA_TABULKA (ID, JMENO, DATUM_NAROZENI, MESTO_NAROZENI, VELIKOST_NOHY)
VALUES
      (1,'Oliver Potůček','1954-11-03','Rychnov u Jablonce nad Nisou',44)
    , (2,'Žaneta Kousalová','1978-02-27','Ústí nad Labem',36)
    , (3,'Věra Podešvová','1992-04-04','Nasavrky',39)
    , (4,'Petr Mička','1992-08-22','Kaplice',43)
;

SELECT * FROM NOVA_TABULKA;




------------------------------------------------------------------

-- Co když budeme vkládat nevalidní data? (např. datum)
INSERT INTO MOJE_PRVNI_TABULKA (ID, JMENO_ZAKAZNIKA, DATUM_NAROZENI, SLEVA)
VALUES
(3, 'Jmeno Prijmeni', '1.1.2003', 5.3);


SELECT * FROM NOVA_TABULKA;

------------------------------------------------------------------
-- Pro zajímavost
INSERT OVERWRITE INTO NOVA_TABULKA (ID, JMENO, DATUM_NAROZENI, MESTO_NAROZENI, VELIKOST_NOHY)
VALUES
      (111,'Lucie Kočičková','1993-08-11','Zlín',36)
    , (222,'František Švestka','1985-01-15','Pardubice',43)
    ;

---------------------------------------------------------                        
-- TEROR PŘÍKLAD - CREATE TABLE + INSERT
--------------------------------------------------------- 

CREATE TABLE NEW_TEROR (
  ID INT,
  GNAME VARCHAR(255),
  NKILL INT,
  NWOUND INT
); 

SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;

INSERT INTO NEW_TEROR (ID, GNAME, NKILL, NWOUND) 
  VALUES 
    (1, 'Žoldáci', 10, 1), 
    (2, 'Nosiči smrti', 15, 2), 
    (3, 'Nějací další teroristi', 155, 5);

SELECT * FROM NEW_TEROR;

-- AUTOINCREMENT & PK VE SNOWFLAKE

CREATE OR REPLACE TABLE NEW_TEROR ( --> DATA SE SMAŽOU
  ID INT AUTOINCREMENT NOT NULL, -- ID se automaticky doplní a navýší o 1 s každou další řádkou v insertu
  GNAME VARCHAR(250),
  NKILL INT,
  NWOUND INT,
  CONSTRAINT id_pk PRIMARY KEY (id) -- přidávám constraint = primarni klic
);


SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;
SHOW PRIMARY KEYS IN TABLE NEW_TEROR;

INSERT INTO NEW_TEROR (GNAME, NKILL, NWOUND) -- ID se doplni samo při každém insertu
  VALUES 
    ('Žoldáci', 10, 1), 
    ('Nosiči smrti', 15, 2), 
    ('Nějácí další teroristi', 155, 5);

SELECT * FROM NEW_TEROR;

-- unikátnost PK není ve SF vynucovaná

INSERT INTO NEW_TEROR (ID, GNAME, NKILL, NWOUND) -- ID se doplni samo při každém insertu
  VALUES 
    (1, 'Žoldáci', 10, 1);

SELECT * 
FROM NEW_TEROR
ORDER BY ID;


---------------------------------------------------------                        
-- INSERT INTO TABULKA(SLOUPEC1, SLOUPEC2) SELECT
---------------------------------------------------------                        

;
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

INSERT INTO NEW_TEROR (GNAME, NKILL, NWOUND)
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

SELECT * FROM NEW_TEROR;
---------------------------------------------------------                        
-- CREATE TABLE TABULKA AS SELECT
---------------------------------------------------------                        

-- tabulku NEW_TEROR můžeme vytvořit přímo ze SELECT příkazu (nemusíme nejdřív vytvářet prázdnou tabulku)

-- CREATE TABLE NEW_TEROR_SELECT AS SELECT (bez ID)

CREATE TABLE NEW_TEROR_SELECT AS
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

SELECT * FROM NEW_TEROR_SELECT;

--> muzeme zde menit i datove typy

CREATE OR REPLACE TABLE NEW_TEROR_SELECT AS
SELECT 
    GNAME:: VARCHAR(255) --AS GNAME
    , NKILL
    , NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2015 AND GNAME = 'Muslim extremists' AND (NKILL>0 OR NWOUND>0)
;

DESC TABLE NEW_TEROR_SELECT;

-- dá se do ní i dále insertovat

INSERT INTO NEW_TEROR_SELECT (GNAME, NKILL, NWOUND)
SELECT GNAME, NKILL, NWOUND
FROM SCH_TEROR.TEROR
WHERE IYEAR = 2016 AND GNAME = 'Taliban' AND (NKILL>0 OR NWOUND>0)
;



---------------------------------------------------------                        
-- TRVALÁ vs. DOČASNÁ tabulka
--------------------------------------------------------- 

-- Vytvoříme si tabulku UDALOSTI_JEN_V_CESKU, kde budou sloupečky GNAME, CITY, NKILL A NWOUND, útoky jen z 'Czech Republic'

-- CREATE TABLE = trvalá tabulka
CREATE TABLE UDALOSTI_JEN_V_CESKU AS
SELECT 
    GNAME
    ,CITY
    ,NKILL
    ,NWOUND
FROM SCH_TEROR.TEROR
WHERE COUNTRY_TXT = 'Czech Republic'
;


-- CREATE TEMPORARY TABLE = dočasná tabulka, zanikne, když se odhlásíme
CREATE OR REPLACE TEMPORARY TABLE UDALOSTI_JEN_V_CESKU AS
SELECT 
    GNAME
    ,CITY
    ,NKILL
    ,NWOUND
    ,CITY as MESTO
FROM SCH_TEROR.TEROR
WHERE COUNTRY_TXT = 'Czech Republic'
;


-- Jakto, že tento příkaz nevrátil error, že už tabulka existuje?



DROP TABLE UDALOSTI_JEN_V_CESKU;

SELECT * FROM UDALOSTI_JEN_V_CESKU;

/*
CREATE TABLE TEMPORARY_TEROR AS 
SELECT * FROM UDALOSTI_JEN_V_CESKU;
*/

---------------------------------------------------------   
-- DELETE FROM TABULKA WHERE .. (smazání dat z tabulky na základě podmínky)
-- TRUNCATE TABLE (smazání dat z tabulky)
---------------------------------------------------------   

CREATE TABLE MAZACI_TABULKA (
  ID INT
  , TEXT VARCHAR(255)
);

INSERT INTO MAZACI_TABULKA(ID, TEXT)
    VALUES
    (1, 'TEXT1'),
    (2, 'TEXT2'),
    (3, 'TEXT3');

SELECT * FROM MAZACI_TABULKA;

-- DELETE s WHERE
DELETE FROM MAZACI_TABULKA
WHERE ID = 1;

-- DELETE bez WHERE
DELETE FROM MAZACI_TABULKA;

-- opět vložíme hodnoty
INSERT INTO MAZACI_TABULKA(ID, TEXT)
    VALUES
    (1, 'TEXT1'),
    (2, 'TEXT2'),
    (3, 'TEXT3');

-- TRUNCATE

TRUNCATE TABLE MAZACI_TABULKA;


---------------------------------------------------------                        
-- ALTER TABLE TABULKA ALTER COLUMN ...
---------------------------------------------------------                        

SELECT * FROM NEW_TEROR;
DESC TABLE NEW_TEROR;

-- Změna datového typu - pouze některé změny povoleny
ALTER TABLE NEW_TEROR ALTER COLUMN GNAME VARCHAR(350); -- můžeme pouze přidávat

---------------------------------------------------------                        
-- ALTER TABLE TABULKA RENAME TO
---------------------------------------------------------
ALTER TABLE NEW_TEROR RENAME TO NEW_TEROR2;

SELECT * FROM NEW_TEROR2;

--COLUMN
ALTER TABLE NEW_TEROR2 RENAME COLUMN GNAME TO TEROR_ORG;

--pro dalsi priklady to vratime zpet
ALTER TABLE NEW_TEROR2 RENAME TO NEW_TEROR;
ALTER TABLE NEW_TEROR RENAME COLUMN TEROR_ORG TO GNAME;

---------------------------------------------------------                        
-- ALTER TABLE TABULKA ADD/DROP COLUMN ..
---------------------------------------------------------

-- ADD
ALTER TABLE NEW_TEROR ADD CONTINENT VARCHAR(255); -- musíme opět definovat datový typ
SELECT * FROM NEW_TEROR;

-- DROP
ALTER TABLE NEW_TEROR DROP COLUMN CONTINENT;
SELECT * FROM NEW_TEROR;

---------------------------------------------------------                        
-- UPDATE TABULKA SET SLOUPEC = X WHERE PODMINKA
---------------------------------------------------------   

-- NEW_TEROR - NWOUND NULL nahradit 0
SELECT * FROM NEW_TEROR 
ORDER BY NWOUND DESC;

UPDATE NEW_TEROR SET NWOUND = 0
WHERE NWOUND IS NULL;
 
-- Příkaz projde i bez podmínky!

-- Upravit se dá i několik sloupců v jednom příkazu
UPDATE NEW_TEROR SET NKILL = 50, NWOUND = 60
WHERE GNAME = 'Žoldáci'
;


CREATE OR REPLACE TABLE xx_prycsemnou AS
SELECT
    gname
    ,city
    ,SUM(nkill) killed
    ,SUM(nwound) wounded
FROM SCH_TEROR.TEROR
WHERE iyear=2016
GROUP BY gname, city;
 
SELECT * FROM xx_prycsemnou;

 SELECT CURRENT_TIMESTAMP(); --2024-03-25 08:47:09.777 -0700

UPDATE xx_prycsemnou SET killed = 0; -- TADY NAM TROCHU CHYBI PODMINKA

-- jak to spravit?

SELECT * FROM xx_prycsemnou AT(OFFSET => -30);
SELECT * FROM xx_prycsemnou AT(STATEMENT => ''); --> query id selectu, kdy tabulka byla ok
SELECT * FROM xx_prycsemnou AT(TIMESTAMP => ''::TIMESTAMP); --> timestamp, kdy tabulka byla ok (CAS V UTC)


CREATE OR REPLACE TABLE xx_prycsemnou_zdrava AS
SELECT * FROM xx_prycsemnou BEFORE(STATEMENT => ''); --> query id selectu, ktery to zkazil

SELECT * FROM xx_prycsemnou_zdrava;

DROP TABLE xx_prycsemnou;
