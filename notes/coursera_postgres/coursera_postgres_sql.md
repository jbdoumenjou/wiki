# Basic commands for PostgreSQL

## Access db

```bash
psql -h pg.pg4e.com -p 5432 -U pg4e_13cf4eeef6 pg4e_13cf4eeef6
```

## List the tables
```
\dt+
```

## Execute a query from a file.
Connect the psql command then
```
\i filename.sql
```

## Copy from a csv file to a table
```sql
\copy track_raw(title,artist,album,count,rating,len) FROM 'library.csv' WITH DELIMITER ',' CSV;
```

Select  specific columns from a table
```sql
SELECT title, album FROM track_raw ORDER BY title LIMIT 3;
```

# Design

## Start

* Keep the information in the database normalized.
* Never use a logical key as the primary key.
* Logical keys can and do change, albeit slowly.
* Relationships that are based on matching strings are less efficient than integers.
* Lot of database theory
* Do no replicate Data. Instead, reference data.
* Use integers for keys
* Add a special key column to each table


references:

* Coursera. Database Design and Basic SQL in PostgreSQL, University of Michigan
* https://en.wikipedia.org/wiki/Database_normalization
