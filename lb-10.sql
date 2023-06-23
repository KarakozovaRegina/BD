--user--
ALTER SESSION SET "_oracle_script" = TRUE;

CREATE TABLESPACE TS_lb10
    DATAFILE 'TS_lb10.DBF' 
    SIZE 10M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 30M;
  
CREATE TABLESPACE TS_h
    DATAFILE 'TS_h.DBF' 
    SIZE 10M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 30M;
    
DROP TABLESPACE TS_lb10;

CREATE ROLE ROLE_lb10;

GRANT ALL PRIVILEGES TO ROLE_lb10;

CREATE PROFILE PROFILE_lb10 LIMIT PASSWORD_LIFE_TIME UNLIMITED;

CREATE USER CORE_lb10 IDENTIFIED BY 123
PROFILE PROFILE_lb10
ACCOUNT UNLOCK
PASSWORD EXPIRE

ALTER USER CORE_lb10 IDENTIFIED BY 123;
ALTER USER CORE_lb10 QUOTA 30m ON TS_lb10;

GRANT ROLE_lb10 TO CORE_lb10;
GRANT DBA TO CORE_lb10;


--1-Создайте таблицу T_RANGE c диапазонным секционированием. 
----Используйте ключ секционирования типа NUMBER.--
CREATE TABLE T_RANGE (
  id NUMBER,
  value VARCHAR2(150)
)
PARTITION BY RANGE (id)
(
  PARTITION p1 VALUES LESS THAN (10),
  PARTITION p2 VALUES LESS THAN (20),
  PARTITION p3 VALUES LESS THAN (30)
);

--2-Создайте таблицу T_INTERVAL c интервальным секционированием. 
----Используйте ключ секционирования типа DATE.--
CREATE TABLE T_INTERVAL (
  id NUMBER,
  value DATE
)
PARTITION BY RANGE (value) INTERVAL (INTERVAL '1' MONTH)
(
  PARTITION t1 VALUES LESS THAN (TO_DATE('01-01-2022')),
  PARTITION t2 VALUES LESS THAN (TO_DATE('01-02-2022')),
  PARTITION t3 VALUES LESS THAN (TO_DATE('01-03-2022'))
);
DROP TABLE T_INTERVAL;
--3-Создайте таблицу T_HASH c хэш-секционированием.. 
----Используйте ключ секционирования типа VARCHAR2.--
CREATE TABLE T_HASH (
  id NUMBER,
  value VARCHAR2(100)
)
PARTITION BY HASH (value)
PARTITIONS 3;

CREATE TABLE T_HASH2 (
  id NUMBER,
  value VARCHAR2(100)
)


DROP TABLE T_HASH2;

--4-Создайте таблицу T_LIST со списочным секционированием. 
----Используйте ключ секционирования типа CHAR.--
CREATE TABLE T_LIST (
  prod_id NUMBER,
  group_id CHAR(10)
)
PARTITION BY LIST (group_id)
(
  PARTITION l1 VALUES ('1', '2'),
  PARTITION l2 VALUES ('4', '5'),
  PARTITION l3 VALUES (DEFAULT)
);
--5--
INSERT INTO T_RANGE (id, value) VALUES (1, '9');
INSERT INTO T_RANGE (id, value) VALUES (2, '19');
INSERT INTO T_RANGE (id, value) VALUES (3, '29');

INSERT INTO T_INTERVAL (id,value) VALUES (1, '01-01-2022');
INSERT INTO T_INTERVAL (id,value) VALUES (2, '23-01-2022');
INSERT INTO T_INTERVAL (id,value) VALUES (3, '04-02-2022');

INSERT INTO T_HASH (id, value) VALUES (1, 'John');
INSERT INTO T_HASH (id, value) VALUES (2, 'Mary');
INSERT INTO T_HASH (id, value) VALUES (3, 'Steve');

INSERT INTO T_LIST (prod_id,group_id) VALUES (1, '1');
INSERT INTO T_LIST (prod_id,group_id) VALUES (2, '4');
INSERT INTO T_LIST (prod_id,group_id) VALUES (3, '6');

SELECT * FROM T_RANGE;
SELECT * FROM T_INTERVAL;
SELECT * FROM T_HASH;
SELECT * FROM T_LIST;

--6-Продемонстрируйте для всех таблиц процесс перемещения строк между
--секциями, при изменении (оператор UPDATE) ключа секционирования.
ALTER TABLE T_RANGE ENABLE ROW MOVEMENT;
UPDATE T_RANGE PARTITION(p1) SET id = id+11;

ALTER TABLE T_INTERVAL ENABLE ROW MOVEMENT;
UPDATE T_INTERVAL PARTITION(t2) SET value = '04-02-2022';

/*ALTER TABLE T_HASH ENABLE ROW MOVEMENT;
SELECT partition_name, count(*) 
FROM user_tab_partitions WHERE table_name = 'T_HASH' 
GROUP BY partition_name;

ALTER TABLE T_HASH MOVE PARTITION SYS_P1262 TABLESPACE TS_h;

*/

ALTER TABLE T_LIST ENABLE ROW MOVEMENT;
UPDATE T_LIST PARTITION(l1) SET group_id = '4';

--7 ALTER TABLE MERGE PARTITION---
ALTER TABLE T_RANGE MERGE PARTITIONS p1, p2 INTO PARTITION p12;

SELECT partition_name, count(*) 
FROM user_tab_partitions WHERE table_name = 'T_RANGE' 
GROUP BY partition_name;

--8 ALTER TABLE SPLIT---
ALTER TABLE T_RANGE SPLIT PARTITION p12 AT (2) INTO (PARTITION p1, PARTITION p2);

SELECT partition_name, count(*) 
FROM user_tab_partitions WHERE table_name = 'T_RANGE' 
GROUP BY partition_name;

--9 ALTER TABLE EXCHANGE---
ALTER TABLE T_HASH EXCHANGE PARTITION SYS_P1263 WITH TABLE T_HASH2 WITHOUT VALIDATION;

--10--
--список всех секционированных таблиц
SELECT table_name, partitioned FROM all_tables where partitioned = 'YES';
--список всех секций какой-либо таблицы;
SELECT partition_name, count(*) 
FROM user_tab_partitions WHERE table_name = 'T_HASH' 
GROUP BY partition_name;

SELECT partition_name, count(*) 
FROM user_tab_partitions WHERE table_name = 'T_LIST' 
GROUP BY partition_name;
--список всех значений из какой-либо секции по имени секции;
SELECT * FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'T_LIST';