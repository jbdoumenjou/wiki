
* www.pg4e.com

# PostgreSQL

## Use Docker to run PostgreSQL

```bash
docker run --name pg-test \                                                                                                ✔ 
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=testuser \
  -e POSTGRES_DB=testdb \
  -p 5432:5432 \
  -d postgres:15
```

```bash
docker exec -it pg-test psql -U testuser -d testdb                                                                     127 ✘ 

psql (15.5 (Debian 15.5-1.pgdg120+1))
Type "help" for help.

testdb=# \l
                                                List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    | ICU Locale | Locale Provider |   Access privileges   
-----------+----------+----------+------------+------------+------------+-----------------+-----------------------
 postgres  | testuser | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | 
 template0 | testuser | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/testuser          +
           |          |          |            |            |            |                 | testuser=CTc/testuser
 template1 | testuser | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | =c/testuser          +
           |          |          |            |            |            |                 | testuser=CTc/testuser
 testdb    | testuser | UTF8     | en_US.utf8 | en_US.utf8 |            | libc            | 
(4 rows)


testdb=# CREATE USER pq4e WITH PASSWORD 'secret';
CREATE ROLE
testdb=# CREATE DATABASE people WITH OWNER 'pg4e';
ERROR:  role "pg4e" does not exist
testdb=# CREATE USER pg4e WITH PASSWORD 'secret';
CREATE ROLE
testdb=# CREATE DATABASE people WITH OWNER 'pg4e';
CREATE DATABASE
testdb=# \q
```


```bash
docker exec -it pg-test psql -U pg4e -d people                                                                     ✔  34s  

psql (15.5 (Debian 15.5-1.pgdg120+1))
Type "help" for help.

people-> \dt
Did not find any relations.

people=> CREATE TABLE users(
name VARCHAR(128),
email VARCHAR(128)
);
CREATE TABLE
people=> \dt
       List of relations
 Schema | Name  | Type  | Owner 
--------+-------+-------+-------
 public | users | table | pg4e
(1 row)

people=> \d+ users
                                                  Table "public.users"
 Column |          Type          | Collation | Nullable | Default | Storage  | Compression | Stats target | Description 
--------+------------------------+-----------+----------+---------+----------+-------------+--------------+-------------
 name   | character varying(128) |           |          |         | extended |             |              | 
 email  | character varying(128) |           |          |         | extended |             |              | 
Access method: heap


```

## Install psql

Under manjaro, you can install psql with the following command:

```bash
sudo pacman -S postgresql
```

The client is installed with the server. You can check the version with the following command:

```bash
psql --version
```