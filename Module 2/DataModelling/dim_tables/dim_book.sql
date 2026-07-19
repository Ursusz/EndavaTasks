CREATE TABLE Dim_Book(
	book_key NUMBER PRIMARY KEY,
	isbn varchar2(17 char),
	title varchar2(32 char),
	author_name varchar2(64 char),
	publisher_name varchar2(64 char)
);

INSERT INTO Dim_Book(
	book_key,
	isbn,
	title,
	author_name,
	publisher_name
)
SELECT b.book_id, b.isbn, b.title, a.name, p.name
FROM bs_book b JOIN bs_author a ON b.author_id = a.author_id
JOIN bs_publisher p ON b.publisher_id = p.publisher_id;
