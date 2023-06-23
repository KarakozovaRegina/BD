/*#1*/
/* 1.Получите список всех существующих PDB в рамках экземпляра ORA12W*/
SELECT name, open_mode FROM v$pdbs;
/*#3*/
/*табличное пространство для постоянных данных*/
CREATE TABLESPACE TS_KRVV
    DATAFILE 'TS_KRVV.DBF' 
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 30M;
    
DROP TABLESPACE TS_KRV;

CREATE TEMPORARY TABLESPACE TS_KRV_TEMP
TEMPFILE 'TS_KRV_TEMP.DBF'
SIZE 5M
AUTOEXTEND ON NEXT 3M
MAXSIZE 20M;
/*Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии*/
alter session set "_ORACLE_SCRIPT"=true;

create role KRV_R_PDB;

grant create session,
      create table, drop any table,
      create view, drop any view,
      create procedure, drop any procedure
to KRV_R_PDB;

DROP role KRV_R_PDB

create profile KRV_PROFILE_PDB limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    PASSWORD_GRACE_TIME DEFAULT
    connect_time 180
    idle_time 30;
    
DROP profile KRV_PROFILE_PDB   
    
create user U1_KRV_PDB identified by 12345
  default tablespace  TS_KRVV quota unlimited on  TS_KRVV
  temporary tablespace TS_KRV_TEMP
  profile KRV_PROFILE_PDB
  account unlock
  password expire
  
DROP user U1_KRV_PDB

/*#5 FROM U1_KRV_PDB */
GRANT KRV_R_PDB TO U1_KRV_PDB

CREATE TABLE KRV_table
( customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50)
);

INSERT INTO KRV_table VALUES (1, 'Jon','London')
INSERT INTO KRV_table VALUES (2, 'Jeksen','Minsk')
INSERT INTO KRV_table VALUES (3, 'Ron','Rome')

select * from KRV_table

/*#6*/
/*AS U1_KRV_PDB*/
SELECT owner, object_name, object_type
FROM all_objects
WHERE object_name LIKE '%KRV%'

/*7*/
create user c##KRV identified by pass;

grant create session to c##KRV;
/*8*/
grant create table to c##KRV;

