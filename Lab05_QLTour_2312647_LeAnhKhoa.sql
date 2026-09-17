/*--------------------------------------------
	Học phần: Cơ sở dữ liệu
	Họ và tên sinh viên: Lê Anh Khoa
	Mã số sinh viên: 2312647
	Lớp: CTK47A
	Ngày thực hiện: 27/02/2025 - 20/03/2025
--------------------------------------------*/

--Lệnh tạo CSDL
CREATE DATABASE Lab05_QLTour
GO

--Lệnh sử dụng CSDL
USE Lab05_QLTour
GO

--Nhập các bảng
CREATE TABLE Tour
(
	MaTour char(4) PRIMARY KEY,
	TongSoNgay tinyint check (TongSoNgay>0)
)
GO

CREATE TABLE ThanhPho
(
	MaTP char(2) PRIMARY KEY,
	TenTP nvarchar(20) not null unique
)
GO

CREATE TABLE Tour_TP
(
	MaTour char(4) references Tour(MaTour),
	MaTP char (2) references ThanhPho(MaTP),
	SoNgay tinyint check (SoNgay>0),
	PRIMARY KEY(MaTour, MaTP, SoNgay)
)
GO

CREATE TABLE Lich_TourDL
(
	MaTour char(4) references Tour(MaTour),
	NgayKH datetime not null,
	TenHDV nvarchar(10) not null,
	SoNguoi tinyint check (SoNguoi>0),
	TenKH nvarchar(30),
	PRIMARY KEY(MaTour, NgayKH)
)
GO

--Xem các bảng
SELECT * FROM Tour
SELECT * FROM ThanhPho
SELECT * FROM Tour_TP
SELECT * FROM Lich_TourDL

--Nhập các bảng
--Nhập bảng Tour
INSERT INTO Tour VALUES ('T001', 3)
INSERT INTO Tour VALUES ('T002', 4)
INSERT INTO Tour VALUES ('T003', 5)
INSERT INTO Tour VALUES ('T004', 7)

--Nhập bảng ThanhPho
INSERT INTO ThanhPho VALUES ('01', N'Đà Lạt')
INSERT INTO ThanhPho VALUES ('02', N'Nha Trang')
INSERT INTO ThanhPho VALUES ('03', N'Phan Thiết')
INSERT INTO ThanhPho VALUES ('04', N'Huế')
INSERT INTO ThanhPho VALUES ('05', N'Đà Nẵng')

--Nhập bảng Tour_TP
INSERT INTO Tour_TP VALUES ('T001', '01', 2)
INSERT INTO Tour_TP VALUES ('T001', '03', 1)
INSERT INTO Tour_TP VALUES ('T002', '01', 2)
INSERT INTO Tour_TP VALUES ('T002', '02', 2)
INSERT INTO Tour_TP VALUES ('T003', '02', 2)
INSERT INTO Tour_TP VALUES ('T003', '01', 1)
INSERT INTO Tour_TP VALUES ('T003', '04', 2)
INSERT INTO Tour_TP VALUES ('T004', '02', 2)
INSERT INTO Tour_TP VALUES ('T004', '05', 2)
INSERT INTO Tour_TP VALUES ('T004', '04', 2)

--Nhập bảng Lich_TourDL
SET DATEFORMAT dmy
GO

INSERT INTO Lich_TourDL VALUES ('T001', '14/02/2017', N'Vân', 20, N'Nguyễn Hoàng')
INSERT INTO Lich_TourDL VALUES ('T002', '14/02/2017', N'Nam', 30, N'Lê Ngọc')
INSERT INTO Lich_TourDL VALUES ('T002', '06/03/2017', N'Hùng', 20, N'Lý Dũng')
INSERT INTO Lich_TourDL VALUES ('T003', '18/02/2017', N'Dũng', 20, N'Lý Dũng')
INSERT INTO Lich_TourDL VALUES ('T004', '18/02/2017', N'Hùng', 30, N'Dũng Nam')
INSERT INTO Lich_TourDL VALUES ('T003', '10/03/2017', N'Nam', 45, N'Nguyễn An')
INSERT INTO Lich_TourDL VALUES ('T002', '28/04/2017', N'Vân', 25, N'Ngọc Dung')
INSERT INTO Lich_TourDL VALUES ('T004', '29/04/2017', N'Dũng', 35, N'Lê Ngọc')
INSERT INTO Lich_TourDL VALUES ('T001', '30/04/2017', N'Nam', 25, N'Trần Nam')
INSERT INTO Lich_TourDL VALUES ('T003', '15/06/2017', N'Vân', 20, N'Trịnh Bá')

----------------------TRUY VẤN DỮ LIỆU----------------------
--a) Cho biết các tour du lịch có tổng số ngày của tour từ 3 đến 5 ngày.
SELECT MaTour, TongSoNgay
FROM Tour
WHERE TongSoNgay BETWEEN 3 AND 5

--b) Cho biết thông tin các tour được tổ chức trong tháng 2 năm 2017.
SELECT MaTour, CONVERT(char(10), NgayKH, 103) as NgayKH, TenHDV, SoNguoi, TenKH
FROM Lich_TourDL
WHERE MONTH(NgayKH) = 2 AND YEAR(NgayKH) = 2017

--c) Cho biết các tour không đi qua thành phố 'Nha Trang'.
SELECT *
FROM Tour
WHERE MaTour NOT IN (SELECT MaTour
				     FROM ThanhPho A, Tour_TP B
					 WHERE A.MaTP=B.MaTP and A.TenTP = N'Nha Trang'
					)

--d) Cho biết số lượng thành phố mà mỗi tour du lịch đi qua.
SELECT MaTour, COUNT(MaTP) as SoLuongThanhPho
FROM Tour_TP
GROUP BY MaTour

--e) Cho biết số lượng tour du lịch mỗi hướng dẫn viên hướng dẫn.
SELECT TenHDV, COUNT(MaTour) as SoLuongTour
FROM Lich_TourDL
GROUP BY TenHDV

--f) Cho biết tên thành phố có nhiều tour du lịch đi qua nhất.
SELECT TenTP
FROM ThanhPho A, Tour_TP B
WHERE A.MaTP = B.MaTP
GROUP BY TenTP
HAVING COUNT(MaTour) >= all (SELECT COUNT(MaTour)
							 FROM Tour_TP
							 GROUP BY MaTP
							)

--g) Cho biết thông tin của tour du lịch đi qua tất cả các thành phố.
SELECT MaTour
FROM Tour_TP
GROUP BY MaTour
HAVING COUNT(MaTP) = (SELECT COUNT(MaTP) 
					  FROM ThanhPho
					 )

--h) Lập danh sách các tour đi qua thành phố 'Ðà Lạt', thông tin cần hiển thị bao gồm: Mã tour, Songay.
SELECT MaTour, soNgay
FROM ThanhPho A, Tour_TP B
WHERE A.MaTP=B.MaTP and A.TenTP = N'Đà Lạt'

--i) Cho biết thông tin của tour du lịch có tổng số lượng khách tham gia nhiều nhất.
SELECT MaTour, SUM(SoNguoi) as TongSoLuongKhach
FROM Lich_TourDL
GROUP BY MaTour
HAVING SUM(SoNguoi) >= all (SELECT SUM(SoNguoi)
							FROM Lich_TourDL
							GROUP BY MaTour
						   )

--j) Cho biết tên thành phố mà tất cả các tour du lịch đều đi qua.
SELECT TenTP
FROM ThanhPho A, Tour_TP B
WHERE A.MaTP = B.MaTP
GROUP BY TenTP
HAVING COUNT(B.MaTour) = (SELECT COUNT(MaTour) 
						  FROM Tour
						 )