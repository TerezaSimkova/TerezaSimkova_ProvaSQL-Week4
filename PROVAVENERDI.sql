--CREATE DATABASE NEGOZIO_DI_DISCHI

/*
1. B
2. TRAMITE LA TABELLA DI SUPPORTO CON LE FOREIGN KEY
3. B
4. B
5. B

*/


CREATE TABLE BAND(
	ID_BAND INT IDENTITY (1,1) NOT NULL,
	CONSTRAINT PK_ID_BAND PRIMARY KEY(ID_BAND),
	NOME NVARCHAR(40) NOT NULL,
	NUMERO_COMPONENTI INT NOT NULL,
);

CREATE TABLE ALBUM(
	ID_ALBUM INT IDENTITY (1,1) NOT NULL,
	CONSTRAINT PK_ID_ALBUM PRIMARY KEY(ID_ALBUM),
	TITOLO VARCHAR(30)NOT NULL,
	ANNO_DI_USICTA DATE,
	CASA_DISCOGRAFICA NVARCHAR(30) NOT NULL,
	GENERE NVARCHAR(10)NOT NULL,
	CONSTRAINT CHK_GENERE 
	CHECK(GENERE='CLASSICO' OR GENERE='JAZZ' OR GENERE='POP' OR GENERE='ROCK' OR GENERE='METAL'),
	SUP_DISTRIBUZIONE NVARCHAR(15) NOT NULL,
	CONSTRAINT CHK_SUP_DISTRIBUZIONE 
	CHECK(SUP_DISTRIBUZIONE='CD' OR SUP_DISTRIBUZIONE='VINILE'OR SUP_DISTRIBUZIONE='STREAMING'),
	ID_BAND INT,
	CONSTRAINT FK_band FOREIGN KEY(ID_BAND)
	REFERENCES BAND(ID_BAND)
	
);
ALTER TABLE ALBUM
ADD CONSTRAINT UN_ALBUM UNIQUE(TITOLO,ANNO_DI_USICTA,CASA_DISCOGRAFICA,GENERE,SUP_DISTRIBUZIONE)



CREATE TABLE BRANO(
	ID_BRANO INT IDENTITY(1,1) NOT NULL,
	CONSTRAINT PK_ID_BRANO PRIMARY KEY(ID_BRANO),
	TITOLO NVARCHAR(40) NOT NULL,
	DURATA INT NOT NULL
);

CREATE TABLE ALBUM_BRANO(
	ID_BRANO INT NOT NULL,
	ID_ALBUM INT NOT NULL,
	CONSTRAINT FK_Brano FOREIGN KEY(ID_BRANO)
	REFERENCES BRANO(ID_BRANO),
	CONSTRAINT FK_Album FOREIGN KEY(ID_ALBUM)
	REFERENCES ALBUM(ID_ALBUM)
);

----INSERIMENTO DATI---------------------------------------------------------------


----BAND----

INSERT INTO BAND VALUES('883',2);
INSERT INTO BAND VALUES('THE GIORNALISTI',3);
INSERT INTO BAND VALUES('THE ROLLING STONES',5);
INSERT INTO BAND VALUES('GOGO PENGUIN',3);
INSERT INTO BAND VALUES('METALLICA',4);
INSERT INTO BAND VALUES('MANESKIN',4);

---BRANO----

INSERT INTO BRANO VALUES('GLI ANNI',180);
INSERT INTO BRANO VALUES('COME MAI',240);
INSERT INTO BRANO VALUES('RICCIONE',120);
INSERT INTO BRANO VALUES('COMPLETAMENTE',180);
INSERT INTO BRANO VALUES('SCARLET',180);
INSERT INTO BRANO VALUES('WINDOW',240);
INSERT INTO BRANO VALUES('NOTHING ELSE MATTERS',120);
INSERT INTO BRANO VALUES('TORNA A CASA',180);
INSERT INTO BRANO VALUES('ZITTI E BUONI',180);
INSERT INTO BRANO VALUES('IMAGINE',120);
INSERT INTO BRANO VALUES('YESTERDAY',120);

---ALBUM-----

INSERT INTO ALBUM VALUES('GLI ANNI','1998-01-01','FRI RECORDS','POP','CD',1);
INSERT INTO ALBUM VALUES('GRAZIE MILLE','1999-01-01','SONY MUSIC','POP','CD',1);
INSERT INTO ALBUM VALUES('LOVE','2018-01-01','CAROSELLO','POP','STREAMING',2);
INSERT INTO ALBUM VALUES('SUMMER','2020-01-01','CARCAR','POP','CD',2); --5ID
INSERT INTO ALBUM VALUES('DOMANI TORNO','2021-01-01','CARCAR','JAZZ','VINILE',4); 
INSERT INTO ALBUM VALUES('MOON','2020-01-01','SONY MUSIC','ROCK','VINILE',4); 
INSERT INTO ALBUM VALUES('MANESKIN','2020-01-01','YES MUSIC','ROCK','STREAMING',6); 


--UPDATE ALBUM SET ANNO_DI_USICTA='2018' WHERE TITOLO='MANESKIN'

---ALBUM_BRANO----

INSERT INTO ALBUM_BRANO VALUES(1,1); 
INSERT INTO ALBUM_BRANO VALUES(1,2); 
INSERT INTO ALBUM_BRANO VALUES(2,1); 
INSERT INTO ALBUM_BRANO VALUES(3,3); 
INSERT INTO ALBUM_BRANO VALUES(4,3); 
INSERT INTO ALBUM_BRANO VALUES(8,7);
INSERT INTO ALBUM_BRANO VALUES(9,7);
INSERT INTO ALBUM_BRANO VALUES(10,6);
INSERT INTO ALBUM_BRANO VALUES(11,NULL);

-------------QUERY----------------------------------------------------------------------

SELECT * FROM ALBUM
SELECT * FROM BAND
SELECT * FROM BRANO
SELECT * FROM ALBUM_BRANO

--#1---
SELECT A.TITOLO
FROM ALBUM A
WHERE ID_BAND=1
GROUP BY TITOLO

--#2---
SELECT *
FROM ALBUM A
WHERE A.ANNO_DI_USICTA='2020-01-01' AND CASA_DISCOGRAFICA='SONY MUSIC'

--#3---
SELECT B.TITOLO
FROM BRANO B
JOIN ALBUM_BRANO O ON O.ID_BRANO=B.ID_BRANO
JOIN ALBUM A ON A.ID_ALBUM=O.ID_ALBUM
JOIN BAND BA ON BA.ID_BAND=A.ID_BAND
WHERE BA.NOME='MANESKIN' AND A.TITOLO='MANESKIN' AND A.ANNO_DI_USICTA='2018-01-01'--TODO NON FUNZIONA

--#4----
SELECT * 
FROM ALBUM A 
JOIN ALBUM_BRANO O ON O.ID_ALBUM=A.ID_ALBUM
JOIN BRANO B ON B.ID_BRANO=O.ID_BRANO
WHERE B.TITOLO='IMAGINE'

--#5---
SELECT COUNT(B.ID_BRANO) AS [NUMERO CANZONI]
FROM BRANO B
JOIN ALBUM_BRANO O ON O.ID_BRANO=B.ID_BRANO
JOIN ALBUM A ON A.ID_ALBUM=O.ID_ALBUM
JOIN BAND D ON D.ID_BAND=A.ID_BAND
WHERE NOME='THE GIORNALISTI'


--#6---TODO PERCH? NON FA IL CONTO UNICO
SELECT SUM(B.DURATA) AS [TOTALE DURATA]
FROM BRANO B 
JOIN ALBUM_BRANO O ON O.ID_BRANO=B.ID_BRANO
JOIN ALBUM A ON A.ID_ALBUM=O.ID_ALBUM
JOIN BAND D ON D.ID_BAND=A.ID_BAND
GROUP BY B.DURATA


--#7---
SELECT DISTINCT *
FROM BRANO WHERE DURATA>180

--#8---
SELECT * 
FROM BAND WHERE NOME LIKE 'M%N'

--#9---
SELECT A.TITOLO,
CASE
	WHEN A.ANNO_DI_USICTA < '1980-01-01' THEN 'VERY OLD'
	WHEN A.ANNO_DI_USICTA ='2021-01-01' THEN 'NEW ENTRY'
	WHEN A.ANNO_DI_USICTA BETWEEN '2010-01-01' AND '2020-01-01' THEN 'RECENTE'
	ELSE 'OLD'
END AS 'ALBUM'
FROM ALBUM A;

--#10--- TODO- NON TROVA NIENTE ANCHE SE CE UNA CANZONE CHE NON ? ASSEGNATA AD UN ALBUM
SELECT* 
FROM BRANO B
JOIN ALBUM_BRANO O ON O.ID_BRANO=B.ID_BRANO
JOIN ALBUM A ON A.ID_ALBUM=O.ID_ALBUM
WHERE A.ID_ALBUM IS NULL

