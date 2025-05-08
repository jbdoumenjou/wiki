-- make	model
-- BMW	M235i Convertible
-- BMW	M235i xDrive
-- BMW	M235i xDrive Convertible
-- Ford	F150 2WD FFV BASE PAYLOAD LT TIRE
-- Ford	F150 3.5L 2WD GVWR>7599 LBS


-- 1) Insert into 'make' table
INSERT INTO make (name)
VALUES
    ('BMW'),
    ('Ford');

-- 2) Insert into 'model' table
INSERT INTO model (name, make_id)
VALUES
    ('M235i Convertible', 1),
    ('M235i xDrive', 1),
    ('M235i xDrive Convertible', 1),
    ('F150 2WD FFV BASE PAYLOAD LT TIRE', 2),
    ('F150 3.5L 2WD GVWR>7599 LBS', 2);

-- How to test:
-- SELECT make.name, model.name
--     FROM model
--     JOIN make ON model.make_id = make.id
--     ORDER BY make.name LIMIT 5;
--  name |               name
-- ------+-----------------------------------
--  BMW  | M235i Convertible
--  BMW  | M235i xDrive
--  BMW  | M235i xDrive Convertible
--  Ford | F150 2WD FFV BASE PAYLOAD LT TIRE
--  Ford | F150 3.5L 2WD GVWR>7599 LBS