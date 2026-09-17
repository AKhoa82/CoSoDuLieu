/*	Học phần: Cơ sở dữ liệu
	Lab07: Quản lý sinh viên
	SV thực hiện: Lê Anh Khoa
	Mã SV: 2312647
	Lớp: CTK47A
	Thời gian: 14/03/2025 - 23/03/2025
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab07_QLSinhVien
GO

USE Lab07_QLSinhVien
GO

CREATE TABLE Khoa
(
	MSKhoa char(2) PRIMARY KEY,
	TenKhoa nvarchar(40),
	TenTat varchar(10)
)
GO

CREATE TABLE Lop
(
	MSLop char(4) PRIMARY KEY,
	TenLop varchar(50),
	MSKhoa char(2) REFERENCES Khoa(MSKhoa),
	NienKhoa int
)
GO

CREATE TABLE TINH
(
	MSTinh char(2) PRIMARY KEY,
	TenTinh varchar(20)
)
GO

CREATE TABLE MonHoc
(
	MSMH char(4) PRIMARY KEY,
	TenMH varchar(40),
	HeSo tinyint
)
GO

CREATE TABLE SinhVien
(	
	MSSV char(7) PRIMARY KEY,
	Ho varchar(30),
	Ten varchar(10),
	NgaySinh Datetime,
	MSTinh char(2) REFERENCES TINH(MSTinh),
	NgayNhapHoc Datetime,
	MSLop char(4) REFERENCES Lop(MSLop),
	Phai varchar(5),
	DiaChi varchar(50),
	DienThoai varchar(13)
)
GO

CREATE TABLE BangDiem
(
	MSSV char(7) REFERENCES SinhVien(MSSV),
	MSMH char(4) REFERENCES MonHoc(MSMH),
	LanThi tinyint,
	Diem float check(Diem between 0 and 10),
	PRIMARY KEY(MSSV, MSMH, LanThi)
)
GO

SELECT * FROM Khoa
SELECT * FROM Lop
SELECT * FROM TINH
SELECT * FROM MonHoc
SELECT * FROM BangDiem
SELECT * FROM SinhVien

INSERT INTO Khoa values('01', N'Công nghệ thông tin', 'CNTT')
INSERT INTO Khoa values('02', N'Điện tử viễn thông', 'DTVT')
INSERT INTO Khoa values('03', N'Quản trị kinh doanh', 'QTKD')
INSERT INTO Khoa values('04', N'Công nghệ sinh học', 'CNSH')

INSERT INTO Lop values('98TH', 'Tin hoc khoa 1998', '01', 1998)
INSERT INTO Lop values('98VT', 'Vien thong khoa 1998', '02', 1998)
INSERT INTO Lop values('99TH', 'Tin hoc khoa 1999', '01', 1999)
INSERT INTO Lop values('99VT', 'Vien thong khoa 1999', '02', 1999)
INSERT INTO Lop values('99QT', 'Quan tri khoa 1999', '03', 1999)

INSERT INTO TINH values('01', 'An Giang')
INSERT INTO TINH values('02', 'TPHCM')
INSERT INTO TINH values('03', 'Dong Nai')
INSERT INTO TINH values('04', 'Long An')
INSERT INTO TINH values('05', 'Hue')
INSERT INTO TINH values('06', 'Ca Mau')

INSERT INTO MonHoc values('TA01', 'Nhap mon tin hoc', 2)
INSERT INTO MonHoc values('TA02', 'Lap trinh co ban', 3)
INSERT INTO MonHoc values('TB01', 'Cau truc du lieu', 2)
INSERT INTO MonHoc values('TB02', 'Co so du lieu', 2)
INSERT INTO MonHoc values('QA01', 'Kinh te vi mo', 2)
INSERT INTO MonHoc values('QA02', 'Quan tri chat luong', 3)
INSERT INTO MonHoc values('VA01', 'Dien tu co ban', 2)
INSERT INTO MonHoc values('VA02', 'Mach so', 3)
INSERT INTO MonHoc values('VB01', 'Truyen so lieu', 3)
INSERT INTO MonHoc values('XA01', 'Vat ly dai cuong', 2)

SET DATEFORMAT dmy
INSERT INTO SinhVien values('98TH001', 'Nguyen Van', 'An', '06/08/80', '01', '03/09/98', '98TH', 'Yes', '12 Tran Hung Dao, Q.1', '8234512')
INSERT INTO SinhVien values('98TH002', 'Le Thi', 'An', '17/10/79', '01', '03/09/98', '98TH', 'No', '23 CMT8, Q. Tan Binh', '0303234342')
INSERT INTO SinhVien values('98VT001', 'Nguyen Duc', 'Binh', '25/11/81', '02', '03/09/98', '98VT', 'Yes', '245 Lac Long Quan, Q.11', '8654323')
INSERT INTO SinhVien values('98VT002', 'Tran Ngoc', 'Anh', '19/08/80', '02', '03/09/98', '98VT', 'No', '242 Tran Hung Dao, Q.1', NULL)
INSERT INTO SinhVien values('99TH001', 'Ly Van Hung', 'Dung', '27/09/81', '03', '05/10/99', '99TH', 'Yes', '178 CMT8, Q. Tan Binh', '7563213')
INSERT INTO SinhVien values('99TH002', 'Van Minh', 'Hoang', '01/01/81', '04', '05/10/99', '99TH', 'Yes', '272 Ly Thuong Kiet, Q.10', '8341234')
INSERT INTO SinhVien values('99TH003', 'Nguyen', 'Tuan', '12/01/80', '03', '05/10/99', '99TH', 'Yes', '162 Tran Hung Dao, Q.5', NULL)
INSERT INTO SinhVien values('99TH004', 'Tran Van', 'Minh', '25/06/81', '04', '05/10/99', '99TH', 'Yes', '147 Dien Bien Phu, Q.3', '7236754')
INSERT INTO SinhVien values('99TH005', 'Nguyen Thai', 'Minh', '01/01/80', '04', '05/10/99', '99TH', 'Yes', '345 Le Dai Hanh, Q.11', NULL)
INSERT INTO SinhVien values('99VT001', 'Le Ngoc', 'Mai', '21/06/82', '01', '05/10/99', '99VT', 'No', '129 Tran Hung Dao, Q.1', '0903124534')
INSERT INTO SinhVien values('99QT001', 'Nguyen Thi', 'Oanh', '19/08/73', '04', '05/10/99', '99QT', 'No', '76 Hung Vuong, Q.5', '0901656324')
INSERT INTO SinhVien values('99QT002', 'Le My', 'Hanh', '20/05/76', '04', '05/10/99', '99QT', 'No', '12 Pham Ngoc Thach, Q.3', NULL)

INSERT INTO BangDiem values('98TH001', 'TA01', 1, 8.5)
INSERT INTO BangDiem values('98TH001', 'TA02', 1, 8)
INSERT INTO BangDiem values('98TH002', 'TA01', 1, 4)
INSERT INTO BangDiem values('98TH002', 'TA01', 2, 5.5)
INSERT INTO BangDiem values('98TH001', 'TB01', 1, 7.5)
INSERT INTO BangDiem values('98TH002', 'TB01', 1, 8)
INSERT INTO BangDiem values('98VT001', 'VA01', 1, 4)
INSERT INTO BangDiem values('98VT001', 'VA01', 2, 5)
INSERT INTO BangDiem values('98VT002', 'VA02', 1, 7.5)
INSERT INTO BangDiem values('99TH001', 'TA01', 1, 4)
INSERT INTO BangDiem values('99TH001', 'TA01', 2, 6)
INSERT INTO BangDiem values('99TH001', 'TB01', 1, 6.5)
INSERT INTO BangDiem values('99TH002', 'TB01', 1, 10)
INSERT INTO BangDiem values('99TH002', 'TB02', 1, 9)
INSERT INTO BangDiem values('99TH003', 'TA02', 1, 7.5)
INSERT INTO BangDiem values('99TH003', 'TB01', 1, 3)
INSERT INTO BangDiem values('99TH003', 'TB01', 2, 6)
INSERT INTO BangDiem values('99TH003', 'TB02', 1, 8)
INSERT INTO BangDiem values('99TH004', 'TB02', 1, 2)
INSERT INTO BangDiem values('99TH004', 'TB02', 2, 4)
INSERT INTO BangDiem values('99TH004', 'TB02', 3, 3)
INSERT INTO BangDiem values('99QT001', 'QA01', 1, 7)
INSERT INTO BangDiem values('99QT001', 'QA02', 1, 6.5)
INSERT INTO BangDiem values('99QT002', 'QA01', 1, 8.5)
INSERT INTO BangDiem values('99QT002', 'QA02', 1, 9)

----------------------TRUY VẤN ĐƠN GIẢN----------------------
--1) Liệt kê MSSV, Họ, Tên, Địa chỉ của tất cả các sinh viên
SELECT MSSV, Ho, Ten, DiaChi
FROM SinhVien

--2) Liệt kê MSSV, Họ, Tên, MSTinh của tất cả sinh viên. Sắp xếp theo MSTinh, HoTen
SELECT MSSV, Ho, Ten, MSTinh
FROM SinhVien
ORDER BY MSTinh, Ho, Ten

--3) Liệt kê các sinh viên nữ của tỉnh Long An
SELECT MSSV, Ho, Ten, NgaySinh, A.MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi, DienThoai
FROM SinhVien A, TINH B
WHERE A.MSTinh = B.MSTinh and Phai = 'No' and TenTinh = 'Long An'

--4) Liệt kê các sinh viên có sinh nhật trong tháng giêng.
SELECT *
FROM SinhVien
WHERE MONTH(NgaySinh) = 1

--5) Liệt kê các sinh viên có sinh nhật nhầm ngày 1/1.
SELECT *
FROM SinhVien
WHERE DAY(NgaySinh) = 1 and MONTH(NgaySinh) = 1

--6) Liệt kê các sinh viên có số điện thoại.
SELECT *
FROM SinhVien
WHERE DienThoai is not null

--7) Liệt kê các sinh viên có số điện thoại di động.
SELECT *
FROM SinhVien
WHERE DienThoai like '0%'

--8) Liệt kê các sinh viên tên Minh học lớp '99TH'
SELECT *
FROM SinhVien
WHERE Ten = 'Minh' and MSLop = '99TH'

--9) Liệt kê các sinh viên có địa chỉ ở đường 'Tran Hung Dao'
SELECT *
FROM SinhVien
WHERE DiaChi like '%Tran Hung Dao%'

--10) Liệt kê các sinh viên có tên lót chữ 'Van' (không liệt kê người họ 'Van')
SELECT *
FROM SinhVien
WHERE Ho like '% Van%'

--11) Liệt kê MSSV, Ho, Ten (ghép họ và tên thành một cột), tuổi của các sinh viên ở tỉnh Long An
SELECT MSSV, Ho +' '+ Ten as HoTen, YEAR(GETDATE())-YEAR(NgaySinh) as Tuoi
FROM SinhVien A, TINH B
WHERE A.MSTinh = B.MSTinh and TenTinh = 'Long An'

--12) Liệt kê các sinh viên nam từ 23 đến 28 tuổi
SELECT MSSV, Ho +' '+ Ten as HoTen, YEAR(GETDATE())-YEAR(NgaySinh) as Tuoi
FROM SinhVien
WHERE Phai = 'Yes' and YEAR(GETDATE())-YEAR(NgaySinh) between 23 and 28

--13) Liệt kê các sinh viên nam từ 32 tuổi trở lên và các sinh viên nữ từ 27 tuổi trở lên
SELECT MSSV, Ho +' '+ Ten as HoTen, YEAR(GETDATE())-YEAR(NgaySinh) as Tuoi, Phai
FROM SinhVien
WHERE Phai = 'Yes' and YEAR(GETDATE())-YEAR(NgaySinh) >= 32
		OR Phai = 'No' and YEAR(GETDATE())-YEAR(NgaySinh) >= 27

--14) Liệt kê các sinh viên khi nhập học còn dưới 18 tuổi, hoặc đã trên 25 tuổi
SELECT MSSV, Ho +' '+ Ten as HoTen, YEAR(NgayNhapHoc)-YEAR(NgaySinh) as TuoiKhiNhapHoc, Phai
FROM SinhVien
WHERE YEAR(NgayNhapHoc)-YEAR(NgaySinh) < 18 or YEAR(NgayNhapHoc)-YEAR(NgaySinh) > 25

--15) Liệt kê danh sách các sinh viên của khóa 99 (MSSV có 2 kí tự đầu là '99')
SELECT *
FROM SinhVien
WHERE MSSV like '99%'

--16) Liệt kê MSSV, Điểm thi lần 1 môn 'Co so du lieu' của lớp '99TH'
SELECT A.MSSV, Diem, LanThi, TenMH, MSLop
FROM SinhVien A, BangDiem B, MonHoc C
WHERE A.MSSV = B.MSSV and B.MSMH = C.MSMH and LanThi = 1 and TenMH = 'Co so du lieu' and MSLop = '99TH'

--17) Liệt kê MSSV, Họ tên của các sinh viên lớp '99TH' thi không đạt lần 1 môn 'Co so du lieu'
SELECT A.MSSV, Ho +' '+ Ten as HoTen, Diem, LanThi, TenMH
FROM SinhVien A, BangDiem B, MonHoc C
WHERE A.MSSV = B.MSSV and B.MSMH = C.MSMH and LanThi = 1 and TenMH = 'Co so du lieu' and MSLop = '99TH' and Diem < 4

--18) Liệt kê tất cả các điểm thi của sinh viên có mã số '99TH001'
SELECT A.MSMH, TenMH as N'Tên MH', LanThi as N'Lần thi', Diem as N'Điểm'
FROM BangDiem A, MonHoc B
WHERE A.MSMH = B.MSMH and MSSV = '99TH001'

--19) Liệt kê MSSV, họ tên, MSLop của các sinh viên có điểm thi lần 1 môn 'Co so du lieu' từ 8 điểm trở lên
SELECT A.MSSV, Ho +' '+ Ten as HoTen, MSLop
FROM SinhVien A, BangDiem B, MonHoc C
WHERE A.MSSV = B.MSSV and B.MSMH = C.MSMH and LanThi = 1 and TenMH = 'Co so du lieu' and Diem >= 8

--20) Liệt kê các tỉnh không có sinh viên theo học
SELECT *
FROM TINH
WHERE MSTinh NOT IN(SELECT MSTinh
					FROM SinhVien)

--21) Liệt kê sinh viên hiện chưa có điểm môn thi nào
SELECT *
FROM SinhVien
WHERE MSSV NOT IN(SELECT MSSV
				  FROM BangDiem)

----------------------TRUY VẤN GOM NHÓM----------------------
--22) Thống kê số lượng sinh viên ở mỗi lớp theo mẫu sau: MSLop, TenLop, SoLuongSV
SELECT A.MSLop, TenLop, COUNT(MSSV) as SoLuongSV
FROM SinhVien A, Lop B
WHERE A.MSLop = B.MSLop
GROUP BY A.MSLop, TenLop

--23) Thống kê số lượng sinh viên ở mỗi tỉnh theo mẫu sau: MSTinh, TenTinh, SoSVNam, SoSVNu, TongCong
SELECT A.MSTinh, A.TenTinh as N'Tên tỉnh', COUNT(CASE WHEN Phai = 'Yes' THEN 1 END) as N'Số SV Nam', COUNT(CASE WHEN Phai = 'No' THEN 1 END) as N'Số SV Nữ', COUNT(MSSV) as N'Tổng cộng'
FROM TINH A, SinhVien B
WHERE A.MSTinh = B.MSTinh
GROUP BY A.MSTinh, A.TenTinh

--24) Thống kê kết quả thi lần 1 môn 'Co so du lieu' ở các lớp theo mẫu sau: MSLop, TenLop, Số SV đạt, Tỉ lệ đạt (%), Số SV không đạt, Tỉ lệ không đạt
SELECT 
	A.MSLop, 
    A.TenLop, 
    COUNT(CASE WHEN Diem >= 5 THEN 1 END) as N'Số SV đạt', 
    FORMAT(ROUND(100.0 * COUNT(CASE WHEN Diem >= 5 THEN 1 END) / COUNT(*), 2),'N2') as N'Tỉ lệ đạt (%)',
    COUNT(CASE WHEN Diem < 5 THEN 1 END) as N'Số SV không đạt', 
    FORMAT(ROUND(100.0 * COUNT(CASE WHEN Diem < 5 THEN 1 END) / COUNT(*), 2),'N2') as N'Tỉ lệ không đạt'
FROM Lop A, SinhVien B, BangDiem C, MonHoc D
WHERE A.MSLop = B.MSLop and B.MSSV = C.MSSV and C.MSMH = D.MSMH and TenMH = 'Co so du lieu' and LanThi = 1
GROUP BY A.MSLop, A.TenLop

--25) Lọc ra điểm cao nhất trong các lần thi cho các sinh viên theo mẫu sau (điểm in ra của mỗi môn là điểm cao nhất trong các lần thi của môn đó): MSSV, MSMH, Tên MH, Hệ số, Điểm, Điểm x hệ số
SELECT MSSV, A.MSMH, TenMH as N'Tên MH', HeSo as N'Hệ số', MAX(Diem) as N'Điểm', MAX(Diem)*HeSo as N'Điểm x hệ số'
FROM BangDiem A, MonHoc B
WHERE A.MSMH = B.MSMH
GROUP BY MSSV, A.MSMH, TenMH, HeSo

--26) Lập bảng tổng kết theo mẫu: MSSV, Họ, Tên, ĐTB
SELECT A.MSSV, Ho as N'Họ', Ten as N'Tên', ROUND(SUM(Diem*HeSo)/SUM(HeSo),1) as N'ĐTB'
FROM SinhVien A, BangDiem B, MonHoc C
WHERE A.MSSV = B.MSSV and B.MSMH = C.MSMH
GROUP BY A.MSSV, Ho, Ten

--27) Thống kê số lượng sinh viên tỉnh 'Long An' đang theo học ở các khoa, theo mẫu sau: Năm học, MSKhoa, TenKhoa, Số lượng SV
SELECT NienKhoa as N'Năm học', C.MSKhoa, C.TenKhoa, COUNT(A.MSSV) as N'Số lượng SV'
FROM SinhVien A, Lop B, Khoa C, TINH D
WHERE A.MSLop = B.MSLop and B.MSKhoa = C.MSKhoa and A.MSTinh = D.MSTinh and TenTinh = 'Long An'
GROUP BY NienKhoa, C.MSKhoa, C.TenKhoa

----------------------Hàm và thủ tục----------------------
--28) Nhập vào MSSV, in ra bảng điểm của sinh viên đó theo mẫu sau (điểm in ra lấy điểm cao nhất trong các lần thi): MSMH, Tên MH, Hệ số, Điểm
ALTER PROC usp_InBangDiemSV
	@MSSV char(7)
As 
	If not exists(SELECT * FROM SinhVien WHERE MSSV = @MSSV)
		print N'Sinh viên có mã ' +@MSSV+ N' không tồn tại trong CSDL!'
	Else
		Begin
			SELECT B.MSMH, TenMH as N'Tên MH', HeSo, MAX(Diem) as N'Điểm'
			FROM BangDiem A, MonHoc B
			WHERE A.MSMH = B.MSMH and A.MSSV = @MSSV
			GROUP BY B.MSMH, TenMH, HeSo
		End
go

exec usp_InBangDiemSV '99TH001'
exec usp_InBangDiemSV '123ABC'

--29) Nhập vào MS lớp, in ra bảng tổng kết của lớp đó, theo mẫu sau: MSSV, Họ, Tên, ĐTB, Xếp loại
ALTER PROC usp_InBangTongKet
	@MSLop char(4)
As
	If not exists(SELECT * FROM Lop WHERE MSLop = @MSLop)
		print N'Lớp có mã ' +@MSLop+ N' không tồn tại trong CSDL!'
	Else
		Begin
			SELECT 
				A.MSSV,	
				Ho as N'Họ', 
				Ten as N'Tên', 
				ROUND(SUM(Diem*HeSo)/SUM(HeSo), 1) as N'ĐTB',
				CASE 
					WHEN ROUND(SUM(Diem*HeSo)/SUM(HeSo), 1) >= 8.0 THEN N'Giỏi'
					WHEN ROUND(SUM(Diem*HeSo)/SUM(HeSo), 1) >= 6.5 THEN N'Khá'
					WHEN ROUND(SUM(Diem*HeSo)/SUM(HeSo), 1) >= 5.0 THEN N'Trung bình'
					ELSE N'Yếu'
				END as N'Xếp loại'
			FROM SinhVien A, BangDiem B, MonHoc C
			WHERE A.MSSV = B.MSSV and B.MSMH = C.MSMH and MSLop = @MSLop
			GROUP BY A.MSSV, Ho, Ten
		End
go

exec usp_InBangTongKet '99TH'
--exec usp_InBangTongKet 'ABCD'

----------------------CẬP NHẬT DỮ LIỆU---------------------- 
--30) Tạo bảng SinhVienTinh trong đó chứa hồ sơ của các sinh viên 
-- (lấy từ table SinhVien) có quê quán không phải ở TPHCM. 
-- Thêm thuộc tính HBONG (học bổng) cho table SinhVienTinh.
CREATE TABLE SinhVienTinh 
(
    MSSV nvarchar(7) PRIMARY KEY,
    Ho varchar(30),
    Ten varchar(10),
    NgaySinh Datetime,
	MSTinh char(2) REFERENCES TINH(MSTinh),
	NgayNhapHoc Datetime,
	MSLop char(4),
    Phai varchar(5),
	DiaChi varchar(50),
	DienThoai varchar(13),
    HBONG int default 0
)
GO

SELECT * FROM SinhVienTinh

INSERT INTO SinhVienTinh(MSSV, Ho, Ten, NgaySinh, MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi, DienThoai)
SELECT MSSV, Ho, Ten, NgaySinh, A.MSTinh, NgayNhapHoc, MSLop, Phai, DiaChi, DienThoai
FROM SinhVien A, TINH B
WHERE A.MSTinh = B.MSTinh and TenTinh <> 'TPHCM'

--31) Cập nhật thuộc tính HBONG trong table SinhVienTinh thành 10000 cho tất cả sinh viên.
UPDATE SinhVienTinh
SET HBONG = 10000

--32) Tăng HBONG lên 10% cho các sinh viên nữ
UPDATE SinhVienTinh
SET HBONG = HBONG*1.1
WHERE Phai = 'No'

--33) Xóa tất cả các sinh viên có quê quán ở Long An ra khỏi table SinhVienTinh.
DELETE 
FROM SinhVienTinh
WHERE MSTinh = (SELECT MSTinh
			    FROM TINH
			    WHERE TenTinh = 'Long An')