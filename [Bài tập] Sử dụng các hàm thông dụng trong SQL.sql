create database quanlysinhvien;
use quanlysinhvien;

create table Classes (
class_id int auto_increment primary key,
class_name varchar(255) unique not null,
start_date date not null,
status bit(1) default 1
);

create table Student (
student_id int auto_increment primary key,
student_name varchar(100) unique not null,
address varchar(255) not null,
phone varchar(11) unique not null,
status bit ,
class_id int not null,
foreign key (class_id) references Classes (class_id)
);

create table Subjects (
sub_id int auto_increment primary key,
sub_name varchar(255) unique not null,
credit int default 1 check (credit >= 1),
status bit(1) default 1
);

create table Mark (
mark_id int auto_increment primary key,
subject_id int not null,
foreign key (subject_id) references Subjects (sub_id),
student_id int not null,
foreign key (student_id) references Student (student_id),
mark double default 0 check(mark between 0 and 100),
examtime int default 1
);

insert into Classes(class_name,start_date, status) values
('HN-JV231103', str_to_date('03/11/2023' , '%d/%m/%Y'),1),
('HN-JV231229', str_to_date('29/12/2023' , '%d/%m/%Y'), 1),
('HN-JV230615', str_to_date('15/06/2023' , '%d/%m/%Y'), 1);

select * from Classes;

insert into Student(student_name, address, phone, status, class_id) values
('Hồ Gia Hùng', 'Hà Nội', '0987654321', 1, 1),
('Phan Văn Giang', 'Đã Nẵng', '0967811255', 1, 1),
('Hoàng Minh Hiếu', 'Nghệ An', '0964425633', 1, 2),
('Nguyễn Vịnh', 'Hà nội', '0975123552', 1, 3),
('Nam Cao', 'Hà Tĩnh', '0919191919', 1, 1),
('Nguyễn Du', 'Nghệ An', '0353535353', 1, 3),
('Dương Mỹ Duyên', 'Hà Nội' ,'0385546611', 1, 2);

insert into Subjects (sub_name, credit, status) values
('Toán', 3, 1),
('Văn', 3, 1),
('Anh', 2, 1);

insert into Mark (subject_id, student_id, mark, examtime) values
(1, 1, 7, str_to_date('12/05/2024' , '%d/%m/%Y')),
(1, 1, 7, str_to_date('15/03/2024' , '%d/%m/%Y')),
(2, 2, 8, str_to_date('15/05/2024' , '%d/%m/%Y')),
(2, 3, 9, str_to_date('08/03/2024' , '%d/%m/%Y')),
(3, 3, 10, str_to_date('11/02/2024' , '%d/%m/%Y'));

-- Hiển thị tất cả lớp học được sắp xếp theo tên giảm dần
select * from Classes order by class_name desc;
-- Hiển thị tất cả học sinh có address ở “Hà Nội”
select * from Student where address = 'Hà Nội';
-- Hiển thị tất cả học sinh thuộc lớp HN-JV231103
select student_name from Classes c inner join Student s on s.class_id = c.class_id where c.class_name = 'HN-JV231103';
-- Hiển thị tát cả các môn học có credit trên 2
select * from Subjects where credit > 2;
-- Hiển thị tất cả học sinh có phone bắt đầu bằng số 09
select * from Student where phone like '09%';


-- Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.
select COUNT(address) from Student where address = 'Hà Nội';


-- Hiển thị các thông tin môn học có điểm thi lớn nhất.
select * from Mark where mark = (select MAX(mark) from Mark);
-- select * from Mark order by mark desc limit 1;


-- Tính điểm trung bình các môn học của từng học sinh.
SELECT student_name, AVG(m.mark) AS điểm_trung_bình
FROM Student s
JOIN Mark m ON s.student_id = m.student_id
GROUP BY s.student_name
ORDER BY điểm_trung_bình DESC;



-- Hiển thị những bạn học viên có điểm trung bình các môn học nhỏ hơn bằng 7.
SELECT student_name, AVG(m.mark) AS điểm_trung_bình
FROM Student s
JOIN Mark m ON s.student_id = m.student_id
GROUP BY s.student_name
HAVING AVG(m.mark) <= 7
ORDER BY điểm_trung_bình DESC;


-- Hiển thị thông tin học viên có điểm trung bình các môn lớn nhất.
SELECT student_name, AVG(m.mark) AS điểm_trung_bình
FROM Student s
JOIN Mark m ON s.student_id = m.student_id
GROUP BY s.student_name
ORDER BY điểm_trung_bình DESC
LIMIT 1;


-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
SELECT student_name, AVG(m.mark) AS điểm_trung_bình
FROM Student s
JOIN Mark m ON s.student_id = m.student_id
GROUP BY s.student_name
ORDER BY điểm_trung_bình DESC;