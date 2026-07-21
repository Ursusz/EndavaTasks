CREATE TABLE dim_date(
	date_key number(8) PRIMARY KEY,
	full_date DATE NOT NULL,
	day_number number(2) NOT NULL,
	day_name varchar2(20 char) NOT NULL,
	month_number number(2) NOT NULL,
	month_name varchar2(20 char) NOT NULL,
	quarter_number number(1) NOT NULL,
	year_number number(4) NOT NULL,
	week_number number(2) NOT NULL,
	is_weekend char(1) NOT null
);

INSERT INTO dim_date(
	date_key,
	full_date,
	day_number,
	day_name,
	month_number,
	month_name,
	quarter_number,
	year_number,
	week_number,
	is_weekend
)
SELECT
	to_number(to_char(generated_date, 'YYYYMMDD')),
	generated_date,
	to_number(to_char(generated_date, 'DD')),
	trim(to_char(generated_date, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH')),
	to_number(to_char(generated_date, 'MM')),
	trim(to_char(generated_date, 'MONTH', 'NLS_DATE_LANGUAGE=ENGLISH')),
	to_number(to_char(generated_date, 'Q')),
	to_number(to_char(generated_date, 'YYYY')),
	to_number(to_char(generated_date, 'IW')),
	CASE
		WHEN to_char(generated_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN')
		THEN 'Y' ELSE 'N'
	END
FROM (
	SELECT DATE '2020-01-01' + LEVEL - 1 AS generated_date
	FROM dual
	CONNECT BY LEVEL <= DATE '2030-12-31' - DATE '2020-01-01' + 1
);