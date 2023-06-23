select * from Rich_purchases;


create view Empls_offices as
select s.NAME,o.city, o.REGION
from OFFICES o
inner join SALESREPS s on o.OFFICE = s.REP_OFFICE;

select * from Empls_offices;

create view ordrs_2008 as
select * from ORDERS
where ORDER_DATE like '2008%'

select * from ordrs_2008;

CREATE view no_orders_empls as
SELECT *
FROM SALESREPS
WHERE EMPL_NUM NOT IN (
    SELECT DISTINCT REP
    FROM ORDERS
);

select * from no_orders_empls;

CREATE view Products_popularity as
select p.DESCRIPTION, count(p.DESCRIPTION) as 'Ordered_count' from orders o inner join 
PRODUCTS p  on o.PRODUCT = p.PRODUCT_ID
GROUP by p.DESCRIPTION;

select * from Products_popularity;

create TEMPORARY TABLE myTable
(id int);

insert into myTable
VALUES(3);

select * from myTable;

CREATE TEMPORARY view myView as
select * from orders;

select * from myView;

CREATE TABLE AUDIT (
  AUDIT_ID INTEGER PRIMARY KEY,
  TABLE_NAME TEXT NOT NULL,
  CHANGE_DATE DATETIME NOT NULL,
  PREVIOUS_DATA TEXT
);

CREATE TRIGGER triggerForAudit AFTER UPDATE ON SALESREPS
BEGIN
  INSERT INTO AUDIT (TABLE_NAME, CHANGE_DATE, PREVIOUS_DATA)
  VALUES ('SALESREPS', DATETIME('now'), (SELECT old.NAME FROM SALESREPS AS old WHERE old.EMPL_NUM = NEW.EMPL_NUM));
END;


drop TRIGGER triggerForAudit;

UPDATE SALESREPS
SET NAME = 'xatake kakashi'
WHERE EMPL_NUM = 101;

select * from AUDIT;
drop TABLE AUDIT;

CREATE TRIGGER triggeForSO INSTEAD OF INSERT ON Empls_offices
BEGIN

INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES)
  SELECT 23, NEW.CITY, NEW.REGION, 106, 888888, 777777;
  
  INSERT INTO SALESREPS (EMPL_NUM, NAME, AGE, REP_OFFICE, TITLE, HIRE_DATE, MANAGER, QUOTA, SALES)
  SELECT 199, NEW.NAME, 35, 23, 'Sales Rep', date('now'), 106, 200000, 188000;
END;

INSERT INTO Empls_offices (NAME, CITY, REGION)
VALUES ('Denis', 'Minsk', 'Eastern');