CREATE TABLE Dim_Customer(
	customer_key NUMBER PRIMARY KEY,
	first_name varchar2(64 char),
	last_name varchar2(64 char),
	country_name varchar2(64 char)
);

INSERT INTO Dim_Customer(
	customer_key,
	first_name,
	last_name,
	country_name
)
SELECT c.customer_id, c.first_name, c.last_name, ct.name
FROM bs_customer c JOIN bs_country ct ON c.country_id = ct.country_id;
