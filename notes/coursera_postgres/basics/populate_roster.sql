insert into course (title) values ('si106'); -- id 1
insert into course (title) values ('si110'); -- id 2
insert into course (title) values ('si206'); -- id 3

insert into student (name) values ('Agatha'); -- id 1
insert into student (name) values ('Kalin'); -- id 2
insert into student (name) values ('Kellen'); -- id 3
insert into student (name) values ('Maeya'); -- id 4
insert into student (name) values ('Nyla'); -- id 5
insert into student (name) values ('Usman'); -- id 6
insert into student (name) values ('Annalise'); -- id 7
insert into student (name) values ('Halley'); -- id 8
insert into student (name) values ('Mykie'); -- id 9
insert into student (name) values ('Rihab'); -- id 10
insert into student (name) values ('Alexander'); -- id 11
insert into student (name) values ('Abby'); -- id 12
insert into student (name) values ('Bowen'); -- id 13
insert into student (name) values ('Cherith'); -- id 14
insert into student (name) values ('Daisy'); -- id 15

-- Agatha, si106, Instructor
-- Kalin, si106, Learner
-- Kellen, si106, Learner
-- Maeya, si106, Learner
-- Nyla, si106, Learner
-- Usman, si110, Instructor
-- Annalise, si110, Learner
-- Halley, si110, Learner
-- Mykie, si110, Learner
-- Rihab, si110, Learner
-- Alexander, si206, Instructor
-- Abby, si206, Learner
-- Bowen, si206, Learner
-- Cherith, si206, Learner
-- Daisy, si206, Learner

-- Learner is role 0
-- instructor role 1

-- Agatha, si106, Instructor
insert into roster (student_id, course_id, role) values (1, 1, 1);
-- Kalin, si106, Learner
insert into roster (student_id, course_id, role) values (2, 1, 0);
-- Kellen, si106, Learner
insert into roster (student_id, course_id, role) values (3, 1, 0);
-- Maeya, si106, Learner
insert into roster (student_id, course_id, role) values (4, 1, 0);
-- Nyla, si106, Learner
insert into roster (student_id, course_id, role) values (5, 1, 0);
-- Usman, si110, Instructor
insert into roster (student_id, course_id, role) values (6, 2, 1);
-- Annalise, si110, Learner
insert into roster (student_id, course_id, role) values (7, 2, 0);
-- Halley, si110, Learner
insert into roster (student_id, course_id, role) values (8, 2, 0);
-- Mykie, si110, Learner
insert into roster (student_id, course_id, role) values (9, 2, 0);
-- Rihab, si110, Learner
insert into roster (student_id, course_id, role) values (10, 2, 0);
-- Alexander, si206, Instructor
insert into roster (student_id, course_id, role) values (11, 3, 1);
-- Abby, si206, Learner
insert into roster (student_id, course_id, role) values (12, 3, 0);
-- Bowen, si206, Learner
insert into roster (student_id, course_id, role) values (13, 3, 0);
-- Cherith, si206, Learner
insert into roster (student_id, course_id, role) values (14, 3, 0);
-- Daisy, si206, Learner
insert into roster (student_id, course_id, role) values (15, 3, 0);
