commit;
rollback;
ALTER SESSION SET "_oracle_script" = TRUE;

/*1-���������� ����� ������ ������� SGA.*/
SELECT SUM(value) FROM v$sga;

/*2-���������� ������� ������� �������� ����� SGA.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components;

/*3-���������� ������� ������� ��� ������� ����.*/
SELECT component, min_size, current_size, granule_size FROM v$sga_dynamic_components;

/*4-���������� ����� ��������� ��������� ������ � SGA.*/
SELECT SUM(bytes) FROM v$sgastat WHERE name='free memory';

/*5-���������� ������������ � ������� ������ ������� SGA.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components;

/*6-���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components
WHERE component in('DEFAULT buffer cache', 'KEEP buffer cache', 'RECYCLE buffer cache');

/*7-�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.*/
CREATE TABLE KEEPTABLE (ID NUMBER) 
STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS;

SELECT * FROM dba_segments WHERE tablespace_name = 'USERS';

/*8-�������� �������, ������� ����� ������������ � ���� DEFAULT. ����������������� ������� �������. */
CREATE TABLE DEFAULTTABLE (ID NUMBER) 
STORAGE(BUFFER_POOL DEFAULT) TABLESPACE USERS;

SELECT * FROM dba_segments WHERE tablespace_name = 'USERS';

/*9-������� ������ ������ �������� �������*/
SHOW PARAMETER log_buffer;

/*10-������� ������ ��������� ������ � ������� ����.*/
SELECT * FROM v$sgastat WHERE NAME = 'free memory' AND pool = 'large pool';

/*11-���������� ������ ������� ���������� � ��������� (dedicated, shared).*/
SELECT username, service_name, server FROM v$session WHERE username is not null;

/*12.-�������� ������ ������ ���������� � ��������� ����� ������� ���������.*/
SELECT * FROM v$session WHERE type = 'background';

/*13-�������� ������ ���������� � ��������� ����� ��������� ���������.*/
SELECT    s.username,s.module,s.osuser,p.program,s.logon_time,s.terminal, p.spid
FROM v$session s, v$process p WHERE s.paddr = p.addr;

/*14-����������, ������� ��������� DBWn �������� � ��������� ������.*/
SELECT COUNT(*) FROM v$bgprocess WHERE name like 'DBWn%';
SELECT * FROM v$bgprocess WHERE name like 'DBWn%';

/*15-���������� ������� (����� ����������� ����������).*/
SELECT NAME, NETWORK_NAME, PDB FROM V$SERVICES;
SELECT USERNAME, SERVICE_NAME, SERVER FROM V$SESSION WHERE USERNAME IS NOT NULL;

/*16-�������� ��������� ��� ��������� �����������.*/
SHOW parameter dispatcher;

/*17*/
/*18*/
/*19*/
/*20*/