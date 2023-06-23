/*1*/
select * from dba_tablespaces;
/*2*/
CREATE TABLESPACE KRV_QDATA 
    DATAFILE 'KRV_qdata.dbf' 
    SIZE 10M 
    OFFLINE;
    
ALTER TABLESPACE KRV_QDATA ONLINE;

ALTER SESSION SET "_oracle_script" = TRUE;

CREATE USER KRVCORE IDENTIFIED BY 12345
DEFAULT TABLESPACE KRV_QDATA

drop USER KRVCORE

ALTER USER KRVCORE QUOTA 2M ON KRV_QDATA;

CREATE ROLE RL_KRV;

GRANT CREATE SESSION,
CREATE TABLE,
CREATE VIEW,
CREATE PROCEDURE TO KRVCORE;

CREATE TABLE KRV_T1 (
   id NUMBER(10) PRIMARY KEY,
   name VARCHAR2(50),
   age NUMBER(3),
   address VARCHAR2(100)
) TABLESPACE KRV_QDATA;

CREATE TABLE KRV_T1_1 (
   id NUMBER(10) PRIMARY KEY,
   name VARCHAR2(50)
) TABLESPACE KRV_QDATA;

INSERT INTO KRV_T1 (ID, NAME) VALUES (1, 'JON');
INSERT INTO KRV_T1 (ID, NAME) VALUES (2, 'RON');
INSERT INTO KRV_T1 (ID, NAME) VALUES (3, 'I');

DROP TABLE KRV_T1_1
/*3*/
SELECT segment_name, segment_type
FROM user_segments
WHERE tablespace_name = 'KRV_QDATA';

/*4*/
SELECT segment_name, segment_type
FROM user_segments
WHERE segment_name = 'KRV_T1';

/*5*/
SELECT segment_name, segment_type
FROM user_segments

/*6*/
DROP TABLE KRV_T1_1

/*7*/
SELECT segment_name, segment_type
FROM user_segments
WHERE tablespace_name = 'KRV_QDATA';

SELECT segment_name, segment_type
FROM user_segments
WHERE segment_name = 'KRV_T1';


SELECT * FROM USER_RECYCLEBIN;
--OBJECT_NAME: имя объекта, который был удален.
--ORIGINAL_NAME: первоначальное имя объекта.
--OPERATION: операция, которая была выполнена с объектом (DROP или TRUNCATE).
--TYPE: тип объекта (TABLE, INDEX, VIEW и т.д.).
--CREATION_TIME: время создания объекта.
--DROP_TIME: время удаления объекта.
--PURGE_TIME: время, после которого объект будет удален окончательно из корзины, если он не будет восстановлен или очищен (по умолчанию 7 дней).
--CAN_PURGE: флаг, указывающий, может ли объект быть очищен из корзины или нет (например, если он используется внешним ключом другой таблицы, то он не может быть очищен).


/*8*/
FLASHBACK TABLE KRV_T1_1 TO BEFORE DROP;

SELECT segment_name, segment_type
FROM user_segments
WHERE tablespace_name = 'KRV_QDATA';

/*9 -------------------------------------------------------------------------------------------------------------------------*/
BEGIN
  FOR loopIndex IN 0..9999
  LOOP
    INSERT INTO  KRV_T1_1 VALUES (loopIndex + 20, 'NAME'); -- здесь нужно указать имена столбцов и их значения
  END LOOP;
  COMMIT;
END;

SELECT * FROM KRV_T1_1

/*10--------------------------------------------------------------------------------------------------------------------------*/
SELECT COUNT(*) AS EXTENT_COUNT
FROM DBA_EXTENTS
WHERE SEGMENT_NAME = 'KRV_T1';

SELECT *
FROM DBA_EXTENTS
WHERE SEGMENT_NAME = 'KRV_T1';
/*11--------------------------------------------------------------------------------------------------------------------------*/
SELECT *
FROM DBA_EXTENTS

/*12*/
SELECT ROWID,id, name,age
FROM KRV_T1;


--AAAAAAAA - 6-байтовый идентификатор файла сегмента данных;
--a - 1-байтовый номер файла сегмента данных (в пределах идентификатора);
--B - 1-байтовый номер блока сегмента данных;
--CCCCCCCC - 8-байтовый смещение строки в блоке.
--Значения ROWID в Oracle могут быть использованы для оптимизации выполнения запросов,
--таких как поиск или удаление конкретных строк. Однако, обычно, 
--использование ROWID не рекомендуется в прикладных программах, 
--так как они могут изменяться при выполнении операций обновления или удаления.

/*13*/
SELECT ora_ROWSCN,ID, NAME
FROM KRV_T1_1


/*16*/
DROP TABLESPACE KRV_QDATA 