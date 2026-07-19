# Module 2 

## Data Modelling
Task: You are designing the data model for a new online bookstore. The store sells books to customers across multiple countries.
Customers can browse, order books, and leave reviews. Books are written by authors and pubished by publishing houses.  

Design a data model that satisfies the following:  
* Identity the entities involved.  
    > [Book](/Module%202/DataModelling/bsbook.sql)  
    > [Author](/Module%202/DataModelling/bsauthor.sql)   
    > [Publisher](/Module%202/DataModelling/bspublisher.sql)  
    > [Customer](/Module%202/DataModelling/bscustomer.sql)  
    > [Order](/Module%202/DataModelling/bsorder.sql)  
    > [OrderItem](/Module%202/DataModelling/bsorderitem.sql)  
    > [Country](/Module%202/DataModelling/bscountry.sql)  
    > [Review](/Module%202/DataModelling/bsreview.sql)    
* Define the attributes for each entity.  
* Establish the relationship between entities.  
![data modelling erd](/Module%202/static/data_modelling_erd.png)
* Draw or describe a conceptal model.  
    > A customer can place orders.  
    > A customer belongs to a country.  
    > A customer writes some reviews.  
    > A review is about a book.  
    > A order contains some order items.  
    > A order item refers to a book.  
    > A book is written by a author.  
    > A book is published by a publisher.  

The cardinalities are as following:  
```text
-> Country      1 -- M      Customer  
-> Customer     1 -- M      Order  
-> Order        1 -- M      OrderItem  
-> Book         1 -- M      OrderItem  
-> Author       1 -- M      Book  
-> Publisher    1 -- M      Book  
-> Customer     1 -- M      Review  
-> Book         1 -- M      Review
```

* Normalize the data to 3rd Normal Form (3NF).  
    > First Normal FORM - 1NF. The model satisfies 1NF because each table has a primary key, each column contains atomic values and there are no repeating groups of multivalued columns.  
    > Second Normal FORM - 2NF. The model satisfies 2NF because it already satisfies 1NF, every non-key attribute depends on the complete primary key and there are no partial dependencies.  
    > Third Normal FORM - 3NF. THe model satisfies 3NF because it already satisfies 2NF, every non-key attribute depends only on the primary key and there are no tranzitive dependencies between non-key attributes.  
* Extend the model for reporting purposes using a dimensional schema (Star Schema).
    > [Dim Tables](/Module%202/DataModelling/dim_tables/)  
    > [Fact](/Module%202/DataModelling/fact_book_sales.sql)  

![fact png](/Module%202/static/facts.png)