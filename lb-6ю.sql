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
--OBJECT_NAME: ��� �������, ������� ��� ������.
--ORIGINAL_NAME: �������������� ��� �������.
--OPERATION: ��������, ������� ���� ��������� � �������� (DROP ��� TRUNCATE).
--TYPE: ��� ������� (TABLE, INDEX, VIEW � �.�.).
--CREATION_TIME: ����� �������� �������.
--DROP_TIME: ����� �������� �������.
--PURGE_TIME: �����, ����� �������� ������ ����� ������ ������������ �� �������, ���� �� �� ����� ������������ ��� ������ (�� ��������� 7 ����).
--CAN_PURGE: ����, �����������, ����� �� ������ ���� ������ �� ������� ��� ��� (��������, ���� �� ������������ ������� ������ ������ �������, �� �� �� ����� ���� ������).


/*8*/
FLASHBACK TABLE KRV_T1_1 TO BEFORE DROP;

SELECT segment_name, segment_type
FROM user_segments
WHERE tablespace_name = 'KRV_QDATA';

/*9 -------------------------------------------------------------------------------------------------------------------------*/
BEGIN
  FOR loopIndex IN 0..9999
  LOOP
    INSERT INTO  KRV_T1_1 VALUES (loopIndex + 20, 'NAME'); -- ����� ����� ������� ����� �������� � �� ��������
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


--AAAAAAAA - 6-�������� ������������� ����� �������� ������;
--a - 1-�������� ����� ����� �������� ������ (� �������� ��������������);
--B - 1-�������� ����� ����� �������� ������;
--CCCCCCCC - 8-�������� �������� ������ � �����.
--�������� ROWID � Oracle ����� ���� ������������ ��� ����������� ���������� ��������,
--����� ��� ����� ��� �������� ���������� �����. ������, ������, 
--������������� ROWID �� ������������� � ���������� ����������, 
--��� ��� ��� ����� ���������� ��� ���������� �������� ���������� ��� ��������.

/*13*/
SELECT ora_ROWSCN,ID, NAME
FROM KRV_T1_1


/*16*/
DROP TABLESPACE KRV_QDATA 