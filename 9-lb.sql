ALTER SESSION SET "_oracle_script" = TRUE; 
/*1*/
CREATE USER KVR_USER_1 IDENTIFIED BY 123;

GRANT CREATE SESSION TO KVR_USER_1;
GRANT CREATE TABLE TO KVR_USER_1;
GRANT CREATE TABLESPACE TO KVR_USER_1;
GRANT CREATE SEQUENCE TO KVR_USER_1;
ALTER USER KVR_USER_1 QUOTA 10M ON USERS;
GRANT CREATE CLUSTER TO KVR_USER_1;
GRANT CREATE SYNONYM TO KVR_USER_1;
GRANT CREATE PUBLIC SYNONYM TO KVR_USER_1;
GRANT DROP PUBLIC SYNONYM TO KVR_USER_1;
GRANT CREATE VIEW TO KVR_USER_1;
GRANT CREATE MATERIALIZED VIEW TO KVR_USER_1;
GRANT QUERY REWRITE TO KVR_USER_1;
GRANT CREATE DATABASE LINK TO KVR_USER_1;

/*2*/
CREATE GLOBAL TEMPORARY TABLE SOMETABLE 
(
IDL NUMBER,
NAMEL VARCHAR2(50)
) ON COMMIT PRESERVE ROWS;

INSERT INTO SOMETABLE VALUES (1, 'Regina');
INSERT INTO SOMETABLE VALUES (2, 'Nasty');
INSERT INTO SOMETABLE VALUES (3, 'Julia');

select * FROM SOMETABLE;

/*3*/
CREATE SEQUENCE S1
INCREMENT BY 10
START WITH 1000
NOMINVALUE
NOMAXVALUE
NOCYCLE
NOCACHE
NOORDER

SELECT S1.NEXTVAL FROM DUAL;
SELECT S1.CURRVAL FROM DUAL;

DROP SEQUENCE S1;

/*4*/
CREATE SEQUENCE S2
INCREMENT BY 10
START WITH 10
MAXVALUE 100
NOCYCLE

SELECT S2.NEXTVAL - ROWNUM as seq_value
FROM dual;


DROP SEQUENCE S2;

/*5*/
CREATE SEQUENCE S3
INCREMENT BY -10
START WITH -10
MINVALUE -100
NOMAXVALUE
NOCYCLE
ORDER
/
SELECT S3.NEXTVAL - ROWNUM as seq_value
FROM dual;

SELECT S3.NEXTVAL FROM DUAL;
DROP SEQUENCE S3;

/*6*/
CREATE SEQUENCE S4
INCREMENT BY 1
START WITH 1
MAXVALUE 10
CYCLE
CACHE 5
NOORDER 
/

SELECT S4.NEXTVAL FROM DUAL;
DROP SEQUENCE S4;

/*7*/
SELECT * FROM SYS.USER_SEQUENCES;

/*8*/
CREATE TABLE T1 
(
N1 NUMBER(20),
N2 NUMBER(20),
N3 NUMBER(20),
N4 NUMBER(20)
) STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS CACHE;

DROP TABLE T1;

INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
SELECT * FROM T1;

/*9*/
CREATE CLUSTER ABC 
(
X NUMBER(10),
V VARCHAR2(12)
) HASHKEYS 200; 

DROP CLUSTER ABC;

/*10*/
CREATE TABLE A
(
XA NUMBER(10),
VA VARCHAR2(12),
VAN VARCHAR2(20)
)CLUSTER ABC(XA,VA);

DROP TABLE A;

/*11*/
CREATE TABLE B
(
XB NUMBER(10),
VB VARCHAR2(12),
VBN VARCHAR2(20)
)CLUSTER ABC(XB,VB);

DROP TABLE B;

/*12*/
CREATE TABLE C
(
XC NUMBER(10),
VC VARCHAR2(12),
VCN VARCHAR2(20)
)CLUSTER ABC(XC,VC);

DROP TABLE C;

/*13*/
--as system--
SELECT CLUSTER_NAME, OWNER, TABLESPACE_NAME, CLUSTER_TYPE, CACHE FROM DBA_CLUSTERS;
SELECT * FROM DBA_TABLES WHERE OWNER = 'SYS';

/*14*/
CREATE SYNONYM SYN_C FOR KVR_USER_1.C;
SELECT * FROM SYN_C;
DROP SYNONYM SYN_C;

/*15*/
CREATE PUBLIC SYNONYM SY2 FOR KVR_USER_1.B;
SELECT * FROM B;
DROP PUBLIC SYNONYM SY2;

/*16*/
CREATE TABLE A (
   Column1 NUMBER(3,0) primary KEY,
   Column2 VARCHAR2 (50)
);

INSERT INTO A (column1, column2) VALUES(1, 'A1');
INSERT INTO A (column1, column2) VALUES(2, 'A2');
INSERT INTO A (column1, column2) VALUES(3, 'A3');

SELECT * FROM A;

CREATE TABLE  B
(
   Column1 NUMBER(3,0),
   Column2 VARCHAR2 (50),
   --Col3 
   --FOREIGN KEY REFERENCES KAV_t(Column1)
   CONSTRAINT Column3
   FOREIGN KEY (Column1)
    REFERENCES A(Column1)   
);

1
INSERT INTO B (column1, column2)VALUES(2, 'B2');

SELECT * FROM B;

--�� ������ �������� ������:
--ALTER TABLE B
--DROP CONSTRAINT Column3;
--DROP TABLE  A;
--DROP TABLE B;

--������������� V1
CREATE VIEW V1 AS SELECT A.column1, B.column2
FROM A
INNER JOIN B
ON A.column1 = B.column1;

SELECT * FROM V1;

/*17*/
CREATE MATERIALIZED VIEW MV1 
REFRESH COMPLETE ON DEMAND 
NEXT SYSDATE + NUMTODSINTERVAL(2, 'MINUTE') AS 
SELECT A.Column1,B.Column2 FROM A INNER JOIN B ON A.Column1 = B.Column1;

SELECT * FROM MV1;


CREATE MATERIALIZED VIEW MV_KRV
BUILD IMMEDIATE 
REFRESH COMPLETE START WITH SYSDATE NEXT SYSDATE+1/2880 AS 
SELECT  A.column1, B.column2
FROM A
INNER JOIN B
ON A.column1 = B.column1;

SELECT * FROM MV_KRV;
/*18*/
CREATE DATABASE LINK pdb_kia
CONNECT TO system
IDENTIFIED BY Qwerty123
USING 'pdb_kia';

DROP DATABASE LINK pdb_kia;
SELECT * FROM DBA_TABLES@pdb_kia;
/*19*/
GRANT CREATE DATABASE LINK TO KVR_USER_1
GRANT CREATE PUBLIC DATABASE LINK,DROP PUBLIC DATABASE LINK TO KVR_USER_1
---dblink ���� user1-user2
CREATE DATABASE LINK anotherdb 
   CONNECT TO system
   IDENTIFIED BY 1403
   USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=host1)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';
'INST_B' - ������� ��� ��� ��������� �� ���������� Oracle Net


CREATE DATABASE LINK link_name  
   CONNECT TO system IDENTIFIED BY 1403  
   USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=host1)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))'; 
--dblink ���� global
CREATE PUBLIC DATABASE LINK public_anotherdb 
   USING 'INST_B';
drop PUBLIC DATABASE LINK public_anotherdb ;



/*20*/