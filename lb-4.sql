ALTER SESSION SET "_oracle_script" = TRUE; 
/*1*/
select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;
/*2*/
select FILE_NAME, TABLESPACE_NAME, STATUS from DBA_TEMP_FILES;
/*4 журналы повтора*/
select * from v$logfile;
/*3*/
select GROUP#, STATUS, MEMBERS from V$LOG;
/*5*/
alter system switch logfile;
/*6-Создайте дополнительную группу журналов повтора с тремя файлами журнала*/
alter database add logfile group 4 'C:\APP\REDO00411.LOG'
SIZE 50m blocksize 512;

alter database add logfile member 'C:\APP\REDO041111.LOG' to group 4;
alter database add logfile member 'C:\APP\REDO042111.LOG' to group 4;
alter database add logfile member 'C:\APP\REDO043111.LOG' to group 4;

select GROUP#, STATUS, MEMBERS, FIRST_CHANGE# from V$LOG 
where GROUP#=4;

select * from V$LOG;
/*7*/
alter database drop logfile member 'C:\APP\REDO04111.LOG';
alter database drop logfile member 'C:\APP\REDO04211.LOG';
alter database drop logfile member 'C:\APP\REDO04311.LOG';
alter database drop logfile member 'C:\APP\REDO0041.LOG';
alter database drop logfile group 4;
/*8*/
select NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;
/*9*/
SELECT MAX(sequence#) AS "Last Archive Log#"
FROM v$log;
/*10-СКРИН*/
/*11*/
ALTER SYSTEM ARCHIVE LOG CURRENT

select * from V$ARCHIVED_LOG;
/*13*/
select NAME from V$CONTROLFILE;
/*14*/
select TYPE, RECORD_SIZE, RECORDS_TOTAL from V$CONTROLFILE_RECORD_SECTION;