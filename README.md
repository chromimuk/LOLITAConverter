LOLITAConverter
===============

### Converting HTML pages and SQL scripts to PL/SQL Web Toolkit standards

Java program made to generate PL/SQL code quickly, from HTML pages or SQL scripts. HTML pages are converted in a very simple way, using direct equivalence between the two languages. Generation from SQL uses the "CREATE TABLE" script to know all the attributes of the table, and provides pages to realise CRUD operations (Create, Read, Update and Delete).

The generated pages use Bootstrap from Twitter to look a little bit better. 



### Outputs of the program

* takes a HTML page and converts it to PL/SQL (*very* simple conversion, <code>&lt;br/> to htp.br;</code>, <code>&lt;h1>Hello&lt;/h1> to htp.header(1, 'Hello');</code>, etc.)
* takes a SQL *CREATE TABLE* script, and generates (with *name* being the name of the table):
  * a procedure to **print** all the elements of the table (afft_*name*)
  * three procedures to **insert** data in the table (the SQL query in pa\_add\_*name*, the execution of the query in ui\_execadd\_*name* and the form of insertion ui\_frmadd\_*name*)
  * three procedures to **edit** data of the table (the SQL query in pa\_edit\_*name*, the execution of the query in ui\_execedit\_*name* and the form of edition ui\_frmedit\_*name*)
  * two procedures to **delete** data from the table (the SQL query in pa\_del\_*name* and the execution of the query in ui\_execdel\_*name*)



### TODO

* SQL: improve the INSERT procedures
* HTML: improve the way the existing tags are managed (especially the ones without direct equivalence), (really) take care of the tags with attributes, add more tags in Resource.java 

