grant alter any table to c##KRV;
ALTER USER C##KRV QUOTA 2M ON USERS;
CREATE TABLE KRV_table
( customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50)
);

INSERT INTO KRV_table VALUES (1, 'Jon','London')

INSERT INTO KRV_table VALUES (2, 'Jeksen','Minsk')
INSERT INTO KRV_table VALUES (3, 'Ron','Rome')

SELECT owner, object_name, object_type
FROM all_objects
WHERE object_name LIKE '%KRV%'