--1
CREATE USER PAV IDENTIFIED BY Bstu2019;

GRANT CREATE SESSION TO PAV;
GRANT CREATE TABLE TO PAV;
GRANT CREATE TABLESPACE TO PAV;
GRANT CREATE SEQUENCE TO PAV;
ALTER USER PAV QUOTA 10M ON USERS;
GRANT CREATE CLUSTER TO PAV;
GRANT CREATE SYNONYM TO PAV;
GRANT CREATE PUBLIC SYNONYM TO PAV;
GRANT DROP PUBLIC SYNONYM TO PAV;
GRANT CREATE VIEW TO PAV;
GRANT CREATE MATERIALIZED VIEW TO PAV;
GRANT QUERY REWRITE TO PAV;
GRANT CREATE DATABASE LINK TO PAV;
--2
CREATE GLOBAL TEMPORARY TABLE SOMETABLE 
(
IDL NUMBER,
NAMEL VARCHAR2(50)
) ON COMMIT PRESERVE ROWS;

INSERT INTO SOMETABLE VALUES (1, 'BOBR');
--3
CREATE SEQUENCE S1
INCREMENT BY 10
START WITH 1000
NOMINVALUE
NOMAXVALUE
NOCYCLE
NOCACHE
NOORDER
/

SELECT S1.NEXTVAL FROM DUAL;
SELECT S1.CURRVAL FROM DUAL;
DROP SEQUENCE S1;
--4
CREATE SEQUENCE S2
INCREMENT BY 10
START WITH 10
MAXVALUE 100
NOCYCLE
/

SELECT S2.NEXTVAL FROM DUAL;
DROP SEQUENCE S2;
--5
CREATE SEQUENCE S3
INCREMENT BY -10
START WITH -10
MINVALUE -100
NOMAXVALUE
NOCYCLE
ORDER
/

SELECT S3.NEXTVAL FROM DUAL;
DROP SEQUENCE S3;
--6
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
--7
SELECT * FROM SYS.USER_SEQUENCES;
--8
CREATE TABLE T1 
(
N1 NUMBER(20),
N2 NUMBER(20),
N3 NUMBER(20),
N4 NUMBER(20)
) STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS CACHE;

DROP TABLE T1;

INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
SELECT * FROM T1;
--9
CREATE CLUSTER ABC 
(
X NUMBER(10),
V VARCHAR2(12)
) HASHKEYS 200; 

DROP CLUSTER ABC;
--10
CREATE TABLE A
(
XA NUMBER(10),
VA VARCHAR2(12),
VAN VARCHAR2(20)
)

DROP TABLE A;
--11
CREATE TABLE B
(
XB NUMBER(10),
VB VARCHAR2(12),
VBN VARCHAR2(20)
)

DROP TABLE B;
--12
CREATE TABLE C
(
XC NUMBER(10),
VC VARCHAR2(12),
VCN VARCHAR2(20)
)

DROP TABLE C;
--13
SELECT CLUSTER_NAME, OWNER, TABLESPACE_NAME, CLUSTER_TYPE, CACHE FROM DBA_CLUSTERS;
SELECT * FROM DBA_TABLES WHERE OWNER = 'PAV';
--14
CREATE SYNONYM SY1 FOR PAV.C;
SELECT * FROM C;
DROP SYNONYM SY1;
--15
CREATE PUBLIC SYNONYM SY2 FOR PAV.B;
SELECT * FROM B;
DROP PUBLIC SYNONYM SY2;
--16
CREATE TABLE A 
(
ID_A NUMBER,
NAME_A VARCHAR2(20),
CONSTRAINT PKA
PRIMARY KEY (ID_A)
);
CREATE TABLE B
(
ID_B NUMBER,
NAME_B VARCHAR2(20),
ID_A NUMBER,
CONSTRAINT PKB
PRIMARY KEY (ID_B),
CONSTRAINT FKA
FOREIGN KEY (ID_A)
REFERENCES A(ID_A)
);

INSERT INTO A VALUES (1, 'Alice');
INSERT INTO B VALUES (1, 'Mark', 1);

DROP TABLE A;
DROP TABLE B;

CREATE VIEW V1 AS 
SELECT A.ID_A, NAME_A, NAME_B, ID_B FROM A INNER JOIN B ON A.ID_A = B.ID_A;

SELECT * FROM V1;
--17
CREATE MATERIALIZED VIEW MV1 
REFRESH COMPLETE ON DEMAND 
NEXT SYSDATE + NUMTODSINTERVAL(2, 'MINUTE') AS 
SELECT A.ID_A, NAME_A, NAME_B, ID_B FROM A INNER JOIN B ON A.ID_A = B.ID_A;

SELECT * FROM MV1;
--18
CREATE DATABASE LINK pdb_kia
CONNECT TO system
IDENTIFIED BY Qwerty123
USING 'pdb_kia';

DROP DATABASE LINK pdb_kia;
SELECT * FROM DBA_TABLES@pdb_kia;