USE QuanLySinhVien;

-- 1. Sinh viên có tên bắt đầu bằng h
SELECT *
FROM Student
WHERE StudentName LIKE 'h%';

-- 2. Lớp bắt đầu vào tháng 12
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- 3. Môn có credit từ 3 đến 5
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- 4. Đổi mã lớp của Hung thành 2
UPDATE Student
SET ClassId = 2
WHERE StudentName = 'Hung';

-- 5. Điểm giảm dần, trùng điểm thì tên tăng dần
SELECT S.StudentName, Sub.SubName, M.Mark
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
JOIN Subject Sub ON M.SubId = Sub.SubId
ORDER BY M.Mark DESC, S.StudentName ASC;
