create database research_project ;

        USE RESEARCH_PROJECT ;
	
         create table station (
                       ID INT NOT NULL ,
                      CITY char(20) ,
                      STATE CHAR(2),
                      LAT_N int ,
                      LONG_W INT,
                 PRIMARY KEY (ID) ) ;
        
        
 SELECT * FROM STATION;
 
 INSERT  INTO  STATION ( ID, CITY , STATE , LAT_N , LONG_W ) 
  VALUES ( 13, "Phoenix"  , "AZ", 33 , 112),
         (44 , "Denver" ,  "CO " ,40 , 105 ),
         ( 66 , "Caribou" , "ME" ,  47 , 68) ;
 
 /* Execute a  query to look at table STATION in undefined order.   */
 
 SELECT * FROM station ;
 
 /*  Execute a query to select Northern stations (Northern latitude > 39.7). */
 
 select *
 from station 
 where lat_n > 39.7 ;
 
 
 /*   					ID Number must match some STATION table ID(so name & location 
will be known). 
MONTH Number Range between 1 and 12 
TEMP_F Number in Fahrenheit degrees,Range between -80 and 150, 
RAIN_I Number in inches, Range between 0 and 100, 
  */
 
 
 CREATE TABLE STATS
(ID INTEGER REFERENCES STATION(ID),
MONTH INTEGER CHECK (MONTH BETWEEN 1 AND 12),
TEMP_F REAL CHECK (TEMP_F BETWEEN -80 AND 150),
RAIN_I REAL CHECK (RAIN_I BETWEEN 0 AND 100),
PRIMARY KEY (ID, MONTH));

INSERT INTO STATS ( ID, MONTH , TEMP_F ,RAIN_I)
VALUES ( 13,1,57.4,.31),
       (  13,7,91.7,5.15),
       (44,1 ,27.3,.18) ,
       (44,7,74.8,2.11),
       ( 66,1,6.7,2.1),
       (66,7,65.8,4.52);

SELECT* FROM STATS ;

/* . Execute a query to display temperature stats (from STATS table) for each city (from Station
table). */

SELECT S.CITY , ST.TEMP_F
FROM STATION S , STATS ST
WHERE S.ID = ST.ID
GROUP BY CITY ;

/* Execute a query to look at the table STATS, ordered by month and greatest rainfall, with
columns rearranged. It should also show the corresponding cities.   */


SELECT S.CITY , ST.MONTH,ST.RAIN_I
FROM STATION S , STATS ST
WHERE S.ID= ST.ID
GROUP BY CITY
ORDER BY MONTH , RAIN_I DESC ;

/*
 Execute a query to look at temperatures for July from table STATS, lowest temperatures first,
picking up city name and latitude */


SELECT S.CITY ,S.LAT_N , ST.TEMP_F ,ST.MONTH
FROM STATION S JOIN STATS st
ON S.ID= ST.ID
WHERE MONTH=7 
ORDER BY TEMP_F ;


/* Execute a query to show MAX and MIN temperatures as well as average rainfall for each city */


SELECT  S.CITY,MAX(TEMP_F) AS MAXIMUM_TEMP , MIN(TEMP_F) AS MINIMUM_TEMP , ROUND(AVG(RAIN_I),3) AS AVGRAIN
FROM STATION S JOIN STATS st
WHERE S.ID=ST.ID 
GROUP BY CITY ;


/* Execute a query to display each city’s monthly temperature in Celcius and rainfall in
Centimeter. */


CREATE VIEW metric_stats ( ID ,MONTH , TEMP_C , RAIN_C) AS 
SELECT ID ,MONTH , 
(TEMP_F-32) * 5 /9 , 
(RAIN_I * 0.3937) 
FROM STATS ;

SELECT * FROM METRIC_STATS ;




/* Update all rows of table STATS to compensate for faulty rain gauges known to read 0.01
inches low. */

SET SQL_SAFE_UPDATES = 0 ;

UPDATE STATS 
SET RAIN_I = RAIN_I + 0.01 ;
 
 SELECT * FROM STATS ;


/* Update Denver's July temperature reading as 74.9 */

SET SQL_SAFE_UPDATES = 0 ;

UPDATE STATS 
SET TEMP_F = 74.9
WHERE  ID =  44 AND  MONTH = 7 ;

SELECT * FROM STATS ;