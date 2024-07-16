create database md2_session02_05;
use md2_session02_05;

create table vat_tu (
	ma_vt int auto_increment primary key,
    ten_vt varchar(100) unique not null
);

create table phieu_xuat(
	so_px int auto_increment primary key,
    ngay_xuat datetime not null
);

create table phieu_xuat_chi_tiet (
	so_px int,
    foreign key (so_px) references phieu_xuat(so_px),
    ma_vt int,
    foreign key (ma_vt) references vat_tu (ma_vt),
    primary key(so_px, ma_vt),
    don_gia_xuat double check (don_gia_xuat > 0),
    so_luong_xuat int check(so_luong_xuat >= 0)
);

CREATE TABLE phieu_nhap (
    so_pn INT AUTO_INCREMENT PRIMARY KEY,
    ngay_nhap DATETIME NOT NULL
);

create table phieu_nhap_chi_tiet(
	so_pn int not null,
    foreign key (so_pn) references phieu_nhap(so_pn),
    ma_vt int not null,
    foreign key (ma_vt) references vat_tu(ma_vt),
    don_gia_nhap double default 1 check( don_gia_nhap > 0),
    so_luong_nhap int check (so_luong_nhap >= 0)
);

create table nha_cung_cap (
	ma_ncc int auto_increment primary key,
    ten_ncc varchar(255) not null,
    address varchar(255) not null,
    phone varchar(11) unique not null
);

create table don_hang_dat(
	so_dh int auto_increment primary key,
    ma_ncc int not null,
    foreign key (ma_ncc) references nha_cung_cap(ma_ncc),
    ngay_dh datetime not null
);

create table chi_tiet_don_dat_hang (
	ma_vt int not null,
    foreign key (ma_vt) references vat_tu(ma_vt),
    so_dh int not null,
    foreign key (so_dh) references don_hang_dat(so_dh)
);

insert into vat_tu(ten_vt) values 
('gạch men'),
('ngói'),
('cát'),
('sỏi'),
('thước đo');
insert into phieu_xuat (ngay_xuat) values
(current_date()),
(current_date()),
(current_date()),
(current_date()),
(current_date());
insert into phieu_xuat_chi_tiet(so_px, ma_vt, don_gia_xuat, so_luong_xuat) values 
(1, 1, 200000, 4),
(2, 1, 1800000, 10),
(3, 3, 400000, 8),
(5, 2, 100000, 3),
(4, 5, 90000, 1);
insert into phieu_nhap (ngay_nhap) values 
('2024-7-14'),
('2024-7-13'),
('2024-7-12'),
('2024-7-11'),
('2024-7-14');
insert into phieu_nhap_chi_tiet (so_pn, ma_vt, don_gia_nhap, so_luong_nhap) values 
(1, 1, 170000, 4),
(2, 1, 1750000, 10),
(3, 3, 360000, 8),
(5, 2, 80000, 3),
(4, 5, 70000, 1);
insert into nha_cung_cap(ten_ncc, address, phone) values
('Nguyễn Trường Sơn', 'Văn Giang-Hưng Yên', '0987654321'),
('Nguyễn Thị Hải Vân', 'Hà Nội' , '0987654322'),
('Nguyễn Thị Hải Anh', 'Hưng Yên', '0971836395'),
('Nguyễn Thị Kim Anh', 'Hải Dương', '0987654343'),
('Nguyễn Thị Hải Hậu', 'Bắc Ninh', '0987654324');
insert into don_hang_dat (ma_ncc, ngay_dh) values 
(1, current_date()),
(2, current_date()),
(3, current_date()),
(5, current_date()),
(4, current_date());
insert into chi_tiet_don_dat_hang (ma_vt, so_dh) values 
(1, 2),
(2, 4),
(4, 1),
(2, 5),
(4, 1);


select * from vat_tu;
select * from phieu_xuat;
select * from phieu_xuat_chi_tiet;
select * from phieu_nhap;
select * from phieu_nhap_chi_tiet;
select * from nha_cung_cap;
select * from don_hang_dat;
select * from chi_tiet_don_dat_hang;


#Tìm danh sách vật tư bán chạy nhất
SELECT ten_vt, SUM(so_luong_xuat) AS total_sold
FROM vat_tu vt
JOIN phieu_xuat_chi_tiet pxct ON vt.ma_vt = pxct.ma_vt
GROUP BY vt.ten_vt
ORDER BY total_sold DESC;

#Tìm danh sách vật tư có trong kho nhiều nhất
select ten_vt , SUM(so_luong_nhap) - SUM(so_luong_xuat) AS inventory from vat_tu vt
left join phieu_nhap_chi_tiet pnct on vt.ma_vt = pnct.ma_vt 
left join phieu_xuat_chi_tiet pxct on vt.ma_vt = pxct.ma_vt
group by vt.ten_vt
order by inventory desc;

#Tìm ra danh sách nhà cung cấp có đơn hàng từ ngày 12/2/2024 đến 22/2/2024
select ten_ncc from nha_cung_cap ncc inner join don_hang_dat dhd 
on ncc.ma_ncc = dhd.ma_ncc
where dhd.ngay_dh between  '2024-01-11' AND '2024-07-15';

#Tìm ra danh sách vật tư đươc mua ở nhà cung cấp từ ngày 11/1/2024 đến 22/2/2024
select ten_vt from vat_tu vt inner join phieu_nhap_chi_tiet pnct on vt.ma_vt = pnct.ma_vt
inner join phieu_nhap pn on pnct.so_pn = pn.so_pn
where pn.ngay_nhap between  '2024-01-11' AND '2024-07-15';



-- Hiển thị tất cả vật tự dựa vào phiếu xuất có số lượng lớn hơn 10
select * from vat_tu vt join phieu_xuat_chi_tiet pxct on vt.ma_vt = pxct.ma_vt where pxct.so_luong_xuat > 5;

-- Hiển thị tất cả vật tư mua vào ngày 12/2/2023
select * from vat_tu vt join chi_tiet_don_dat_hang ctddh on ctddh.ma_vt = vt.ma_vt join don_hang_dat dhd on dhd.so_dh =  ctddh.so_dh where ngay_dh = '2024-07-15';
-- Hiển thị tất cả vật tư được nhập vào với đơn giá lớn hơn 1.200.000
select vt.ten_vt , sum(pnct.don_gia_nhap) as don_gia from vat_tu vt
join phieu_nhap_chi_tiet pnct on vt.ma_vt = pnct.ma_vt
where pnct.don_gia_nhap > 1200000
group by vt.ten_vt;

-- Hiển thị tất cả vật tư được dựa vào phiếu xuất có số lượng lớn hơn 5
select vt.ten_vt , count(pxct.so_luong_xuat) as so_luong from vat_tu vt
join phieu_xuat_chi_tiet pxct on vt.ma_vt = pxct.ma_vt
where pxct.so_luong_xuat > 5
group by vt.ten_vt;
-- Hiển thị tất cả nhà cung cấp ở long biên có SoDienThoai bắt đầu với 09
select ten_ncc , address, phone from nha_cung_cap ncc
where address = 'Hưng Yên'
 and phone LIKE '09%';