

CREATE TABLE Students (
    student_id INT ,  
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT,
    capacity INT
);

CREATE TABLE Enrollments (
    enrollment_id INT ,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


INSERT INTO Students (student_id, name, age, gender) VALUES
(1, 'Aymen', 21, 'Male'),
(2, 'Sarah', 22, 'Female'),
(3, 'John', 23, 'Male'),
(4, 'Emma', 20, 'Female'),
(5, 'Liam', 24, 'Male');

INSERT INTO Courses (course_id, course_name, credits, capacity) VALUES
(101, 'Mathematics', 4, 30),
(102, 'Computer Science', 3, 25),
(103, 'History', 3, 40),
(104, 'Physics', 4, 30);


INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 101),
(2, 101),
(3, 101),
(4, 101),
(5, 101);  

-- Inscritions pour le cours "Computer Science"
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 102),
(2, 102),
(3, 102),
(4, 102);  


INSERT INTO Enrollments (student_id, course_id) VALUES
(2, 103),
(3, 103),
(4, 103),
(5, 103);  

-- Inscritions pour le cours "Physics"
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 104),
(2, 104),
(3, 104),
(4, 104),
(5, 104); 

--Query 1
SELECT s.name AS student_name, c.course_name, c.credits
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

--Query 2
SELECT s.name AS student_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

--Query 3

SELECT c.course_name, COUNT(e.student_id) AS number_of_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

--Query 4
SELECT c.course_name, COUNT(e.student_id) AS number_of_students, c.capacity
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name, c.capacity
HAVING COUNT(e.student_id) > c.capacity / 2; 

--Query 5
SELECT s.name AS student_name, COUNT(e.course_id) AS number_of_courses
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) = (
    SELECT MAX(course_count)
    FROM (
        SELECT COUNT(course_id) AS course_count
        FROM Enrollments
        GROUP BY student_id
    ) AS course_counts
);

--Query6
SELECT s.name AS student_name, SUM(c.credits) AS total_credits
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.student_id; 

-- query 7
SELECT c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- task 6
DELIMITER //

CREATE TRIGGER prevent_enrollment_if_full
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE current_enrollment_count INT;
    DECLARE course_capacity INT;

    -- Obtenir le nombre actuel d'inscriptions pour le cours
    SELECT COUNT(*) INTO current_enrollment_count
    FROM Enrollments
    WHERE course_id = NEW.course_id;

    -- Obtenir la capacité du cours
    SELECT capacity INTO course_capacity
    FROM Courses
    WHERE course_id = NEW.course_id;

    -- Vérifier si le nombre d'inscriptions atteint ou dépasse la capacité
    IF current_enrollment_count >= course_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot enroll: course capacity reached';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER limit_enrollments_per_student
BEFORE INSERT ON Enrollments
FOR EACH ROW
BEGIN
    DECLARE current_enrollment_count INT;

    -- Obtenir le nombre actuel d'inscriptions pour l'étudiant
    SELECT COUNT(*) INTO current_enrollment_count
    FROM Enrollments
    WHERE student_id = NEW.student_id;

    -- Vérifier si l'étudiant est déjà inscrit à 5 cours
    IF current_enrollment_count >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot enroll: student already enrolled in 5 courses';
    END IF;
END //

DELIMITER ;

--task 7
DELETE FROM Enrollments
WHERE course_id = 101;  

DELETE FROM Students
WHERE student_id NOT IN (
    SELECT DISTINCT student_id
    FROM Enrollments
);

