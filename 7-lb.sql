commit;
rollback;
ALTER SESSION SET "_oracle_script" = TRUE;

/*1-Определите общий размер области SGA.*/
SELECT SUM(value) FROM v$sga;

/*2-Определите текущие размеры основных пулов SGA.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components;

/*3-Определите размеры гранулы для каждого пула.*/
SELECT component, min_size, current_size, granule_size FROM v$sga_dynamic_components;

/*4-Определите объем доступной свободной памяти в SGA.*/
SELECT SUM(bytes) FROM v$sgastat WHERE name='free memory';

/*5-Определите максимальный и целевой размер области SGA.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components;

/*6-Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.*/
SELECT component, min_size, current_size FROM v$sga_dynamic_components
WHERE component in('DEFAULT buffer cache', 'KEEP buffer cache', 'RECYCLE buffer cache');

/*7-Создайте таблицу, которая будет помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.*/
CREATE TABLE KEEPTABLE (ID NUMBER) 
STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS;

SELECT * FROM dba_segments WHERE tablespace_name = 'USERS';

/*8-Создайте таблицу, которая будет кэшироваться в пуле DEFAULT. Продемонстрируйте сегмент таблицы. */
CREATE TABLE DEFAULTTABLE (ID NUMBER) 
STORAGE(BUFFER_POOL DEFAULT) TABLESPACE USERS;

SELECT * FROM dba_segments WHERE tablespace_name = 'USERS';

/*9-Найдите размер буфера журналов повтора*/
SHOW PARAMETER log_buffer;

/*10-Найдите размер свободной памяти в большом пуле.*/
SELECT * FROM v$sgastat WHERE NAME = 'free memory' AND pool = 'large pool';

/*11-Определите режимы текущих соединений с инстансом (dedicated, shared).*/
SELECT username, service_name, server FROM v$session WHERE username is not null;

/*12.-Получите полный список работающих в настоящее время фоновых процессов.*/
SELECT * FROM v$session WHERE type = 'background';

/*13-Получите список работающих в настоящее время серверных процессов.*/
SELECT    s.username,s.module,s.osuser,p.program,s.logon_time,s.terminal, p.spid
FROM v$session s, v$process p WHERE s.paddr = p.addr;

/*14-Определите, сколько процессов DBWn работает в настоящий момент.*/
SELECT COUNT(*) FROM v$bgprocess WHERE name like 'DBWn%';
SELECT * FROM v$bgprocess WHERE name like 'DBWn%';

/*15-Определите сервисы (точки подключения экземпляра).*/
SELECT NAME, NETWORK_NAME, PDB FROM V$SERVICES;
SELECT USERNAME, SERVICE_NAME, SERVER FROM V$SESSION WHERE USERNAME IS NOT NULL;

/*16-Получите известные вам параметры диспетчеров.*/
SHOW parameter dispatcher;

/*17*/
/*18*/
/*19*/
/*20*/