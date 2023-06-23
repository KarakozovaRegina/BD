/*табличное пространство для постоянных данных*/
CREATE TABLESPACE TS_KRV
    DATAFILE 'C:\Users\regin\AppData\Roaming\TS_KRV.dbf' 
    SIZE 7 m
    AUTOEXTEND ON NEXT 5 m
    MAXSIZE 30 m
    EXTENT MANAGEMENT LOCAL;
    
DROP TABLESPACE TS_KRV;