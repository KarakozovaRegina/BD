/*1-1.	Получите список объектов БД*/
SELECT name FROM sqlite_master;

/*2.1-Представление, которое содержите сведения о покупателях, у которых есть заказы выше определенной суммы.*/
select * from CUSTOMERS;
select * from ORDERS;


CREATE VIEW Rich_purchases as 
select c.COMPANY, o.AMOUNT from CUSTOMERS c
inner join orders o on o.CUST = c.CUST_NUM
where o.AMOUNT > 20000;

select * from Rich_purchases;


/*2.2-	Представление, которое содержите сведения о сотрудниках и их офисах.*/
select * from SALESREPS;
select * from OFFICES;

create view Empls_offices as
select s.NAME,o.city, o.REGION
from OFFICES o
inner join SALESREPS s on o.OFFICE = s.REP_OFFICE;

select * from Empls_offices;

/*2.3-Представление, которое содержите сведения о заказах, оформленных в 2008 году.*/
create view ordrs_2008 as
select * from ORDERS
where ORDER_DATE like '2008%'

select * from ordrs_2008;

/*2.4.-Представление, которое содержите сведения о сотрудниках, которые не оформили ни одного заказа.*/
CREATE view no_orders_empls as
SELECT *
FROM SALESREPS
WHERE EMPL_NUM NOT IN (
    SELECT DISTINCT REP
    FROM ORDERS
);

select * from no_orders_empls;

/*2.5-Представление, которое содержите сведения о самых популярных товарах.*/
CREATE view Products_popularity as
select p.DESCRIPTION, count(p.DESCRIPTION) as 'Ordered_count' from orders o inner join 
PRODUCTS p  on o.PRODUCT = p.PRODUCT_ID
GROUP by p.DESCRIPTION;

select * from Products_popularity;

/*3-Создайте временную таблицу, добавьте в нее данные. Продемонстрируйте время существования временной таблицы.*/
create TEMPORARY TABLE myTable
(id int);

insert into myTable
VALUES(3);

select * from myTable;


/*4-4.	Создайте временное представление, продемонстрируйте время существования */
CREATE TEMPORARY view myView as
select * from orders;

select * from myView;

--5
--запрос 3.14
explain query plan

SELECT ORDERS.PRODUCT, PRODUCTS.PRICE
FROM PRODUCTS JOIN ORDERS ON PRODUCTS.PRODUCT_ID = ORDERS.PRODUCT
JOIN CUSTOMERS ON CUSTOMERS.CUST_NUM = ORDERS.CUST
WHERE PRODUCTS.PRICE > 2000;


create index 'idx_names' on 'PRODUCTS'(
'PRICE'
) where PRODUCTS.PRICE > 20000;

drop index 'idx_names' ;

--запрос 3.16
create index 'idx_products' on 'PRODUCTS'(
'DESCRIPTION');

SELECT DESCRIPTION, PRODUCT_ID, PRICE
FROM PRODUCTS WHERE price = (SELECT MAX(PRICE) 
               FROM PRODUCTS p 
               WHERE p.DESCRIPTION = PRODUCTS.DESCRIPTION);
			   
drop index 'idx_products' ;
--запрос 3.19
explain QUERY PLAN
SELECT *
FROM SALESREPS
WHERE AGE IN (
    SELECT AGE
    FROM SALESREPS
    GROUP BY AGE
    HAVING COUNT(*) > 1
);

CREATE INDEX idx_age ON SALESREPS (AGE);

drop index 'idx_age' ;

--Запрос 3.20
explain QUERY plan
CREATE INDEX idx_company ON CUSTOMERS (company);
	
CREATE INDEX idx_cust ON ORDERS (CUST);

SELECT CUSTOMERS.COMPANY,ORDERS.ORDER_NUM 
FROM ORDERS JOIN CUSTOMERS ON CUSTOMERS.CUST_NUM = ORDERS.CUST 
WHERE CUSTOMERS.COMPANY='First Corp.';

drop index 'idx_company' ;
drop index 'idx_cust' ;
--Запрос 3.24
explain query plan

SELECT SALESREPS.EMPL_NUM, SUM(PRODUCTS.PRICE) AS SHAREDSUM
		FROM SALESREPS 
		JOIN ORDERS ON SALESREPS.EMPL_NUM = ORDERS.REP 
		JOIN PRODUCTS ON ORDERS.PRODUCT = PRODUCTS.PRODUCT_ID
		GROUP BY SALESREPS.EMPL_NUM
		ORDER BY SHAREDSUM DESC;
		

create index idx_product_id on PRODUCTS(PRODUCT_ID);
CREATE INDEX idx_rep ON ORDERS (rep);

DROP index idx_product_id;
DROP index idx_rep;


--Запрос 3.35
explain QUERY plan
SELECT c.COMPANY
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUST_NUM = o.CUST
WHERE strftime('%Y', o.ORDER_DATE) = '2008'
      AND c.COMPANY IN (
          SELECT c2.COMPANY
          FROM CUSTOMERS c2
          JOIN ORDERS o2 ON c2.CUST_NUM = o2.CUST
          WHERE strftime('%Y', o2.ORDER_DATE) = '2007'
      )
GROUP BY c.COMPANY;

CREATE INDEX idx_order_date ON ORDERS (ORDER_DATE);

/*6-6.	Создайте таблицу и триггер, который запишет дату изменения и предыдущие данные в таблицу AUDIT 
при изменении в таблице SALESREPS.*/
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

/*7.	Создайте триггер, который при добавлении данных в представление, 
созданное вами в п.1.2, записывает данные в таблицы SALESREPS и OFFICES.*/

CREATE TRIGGER triggeFor INSTEAD OF INSERT ON Empls_offices
BEGIN

INSERT INTO OFFICES (OFFICE, CITY, REGION, MGR, TARGET, SALES)
  SELECT 31, NEW.CITY, NEW.REGION, 106, 888888, 777777;
  
  INSERT INTO SALESREPS (EMPL_NUM, NAME, AGE, REP_OFFICE, TITLE, HIRE_DATE, MANAGER, QUOTA, SALES)
  SELECT 202, NEW.NAME, 35, 23, 'Sales Rep', date('now'), 106, 200000, 188000;
END;

INSERT INTO Empls_offices (NAME, CITY, REGION)
VALUES ('regina', 'Minsk', 'Eastern');

drop TRIGGER triggeFor


/*8-8.	Продемонстрируйте применение транзакций в SQLite: 
в одной транзакции добавьте заказ и пересчитайте поле SALES для соответствующего сотрудника.*/

BEGIN TRANSACTION;
INSERT INTO ORDERS VALUES (33,date('now'),2117,106,'REI','2A44L',7,31500.00);
UPDATE  SALESREPS SET sales = sales + 1 WHERE SALESREPS.EMPL_NUM = 106;

COMMIT;
/*9-9.	Продемонстрируйте применение вложенных транзакций в SQLite: 
во внешней транзакции добавьте сотрудника, во внутренней транзакции – несколько его заказов.*/
begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
begin TRANSACTION B;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
COMMIT TRANSACTION B;
COMMIT TRANSACTION A;

/*10-Продемонстрируйте применение точек сохранения.*/
begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
SAVEPOINT A;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
RELEASE SAVEPOINT A
COMMIT TRANSACTION A;

begin TRANSACTION A;
UPDATE ORDERS set CUST = 2111 where ORDER_NUM = 112961;
SAVEPOINT A;
update orders  set CUST = 2111 where ORDER_NUM = 112963;
ROLLBACK to SAVEPOINT A
COMMIT TRANSACTION A;