/*--------------------------------------------
	Học phần: Cơ sở dữ liệu
	Họ và tên sinh viên: Lê Anh Khoa
	Mã số sinh viên: 2312647
	Lớp: CTK47A
	Ngày thực hiện: 14/02/2025 - 23/03/2025
--------------------------------------------*/

--Lệnh tạo CSDL
CREATE DATABASE Lab01_QuanLyNhanVien
GO

--Lệnh sử dụng CSDL
USE	Lab01_QuanLyNhanVien
GO

--Lệnh tạo các bảng
CREATE TABLE ChiNhanh
(
	MSCN char(2) primary key, -- khai báo MSCN là khóa chính
	TenCN nvarchar(30) not null unique
)
GO

CREATE TABLE NhanVien
(
	MANV char(4) primary key,
	Ho nvarchar(20) not null,
	Ten nvarchar(10) not null,
	NgaySinh datetime,
	NgayVaoLam datetime,
	MSCN char(2) references ChiNhanh(MSCN) -- khai báo MSCN là khóa ngoại tham chiếu đến khóa chính MSCN của quan hệ ChiNhanh
)
GO

CREATE TABLE KyNang
(
	MSKN char(2) primary key,
	TenKN nvarchar(30) not null
)
GO

CREATE TABLE NhanVienKyNang
(
	MANV char(4) references NhanVien(MANV),
	MSKN char(2) references KyNang(MSKN),
	MucDo tinyint check(MucDo>=1 and MucDo<=9) -- check(MucDo between 1 and 9)
	Primary key(MANV, MSKN) -- khai báo khóa chính gồm nhiều thuộc tính
)
GO

--Nhập dữ liệu cho các bảng
--Nhập bảng chi nhánh
INSERT INTO	ChiNhanh values('01', N'Quận 1')
INSERT INTO	ChiNhanh values('02', N'Quận 5')
INSERT INTO	ChiNhanh values('03', N'Bình Thạnh')

--Xem bảng ChiNhanh
SELECT * FROM ChiNhanh

--Nhập bảng NhanVien
SET DATEFORMAT dmy --khai báo định danh ngày tháng
GO

INSERT INTO NhanVien VALUES ('0001', N'Lê Văn', N'Minh', '10/06/1960', '02/05/1986', '01')
INSERT INTO NhanVien VALUES ('0002', N'Nguyễn Thị', N'Mai', '20/04/1970', '04/07/2001', '01')
INSERT INTO NhanVien VALUES ('0003', N'Lê Anh', N'Tuấn', '25/06/1975', '01/09/1982', '02')
INSERT INTO NhanVien VALUES ('0004', N'Vương Tuấn', N'Vũ', '25/03/1960', '12/01/1986', '02')
INSERT INTO NhanVien VALUES ('0005', N'Lý Anh', N'Hân', '01/12/1980', '15/05/2004', '02')
INSERT INTO NhanVien VALUES ('0006', N'Phan Lê', N'Tuấn', '04/06/1976', '25/10/2002', '03')
INSERT INTO NhanVien VALUES ('0007', N'Lê Tuấn', N'Tú', '15/08/1975', '15/08/2000', '03')

--Xem bảng NhanVien
SELECT * FROM NhanVien

--Nhập bảng KyNang
INSERT INTO KyNang values('01', N'Word')
INSERT INTO KyNang values('02', N'Excel')
INSERT INTO KyNang values('03', N'Access')
INSERT INTO KyNang values('04', N'Power Point')
INSERT INTO KyNang values('05', N'SPSS')

--Xem bảng KyNang
SELECT * FROM KyNang

--Nhập bảng NhanVienKyNang
INSERT INTO NhanVienKyNang values('0001', '01', 2)
INSERT INTO NhanVienKyNang values('0001', '02', 1)
INSERT INTO NhanVienKyNang values('0002', '01', 2)
INSERT INTO NhanVienKyNang values('0002', '03', 2)
INSERT INTO NhanVienKyNang values('0003', '02', 1)
INSERT INTO NhanVienKyNang values('0003', '03', 2)
INSERT INTO NhanVienKyNang values('0004', '01', 5)
INSERT INTO NhanVienKyNang values('0004', '02', 4)
INSERT INTO NhanVienKyNang values('0004', '03', 1)
INSERT INTO NhanVienKyNang values('0004', '04', 3)
INSERT INTO NhanVienKyNang values('0004', '05', 4)
INSERT INTO NhanVienKyNang values('0005', '02', 4)
INSERT INTO NhanVienKyNang values('0005', '04', 4)
INSERT INTO NhanVienKyNang values('0006', '05', 4)
INSERT INTO NhanVienKyNang values('0006', '02', 4)
INSERT INTO NhanVienKyNang values('0006', '03', 2)
INSERT INTO NhanVienKyNang values('0007', '03', 4)
INSERT INTO NhanVienKyNang values('0007', '04', 3)

--Xem bảng NhanVienKyNang
SELECT * FROM NhanVienKyNang

----------------------TRUY VẤN DỮ LIỆU----------------------
--1. Phép chọn
--q1. Lập danh sách | cho biết các nhân viên đang làm việc tại chi nhánh có mã chi nhánh là '01'
SELECT * 
FROM NhanVien 
WHERE MSCN = '01'

--q2. Cho biết các nhân viên sinh sau năm 1975
SELECT * 
FROM NhanVien 
WHERE YEAR(NgaySinh)>1975

--Cho biết các nhân viên có họ 'Lê'
---Cách 1:
SELECT * 
FROM NhanVien 
WHERE LEFT(Ho, 2) = N'Lê'

---Cách 2:
SELECT * 
FROM NhanVien 
WHERE Ho like N'Lê%'

--q4. Cho biết các nhân viên có họ Lê làm việc tại chi nhánh '03'
SELECT *
FROM NhanVien
WHERE MSCN = '03' and Ho like N'Lê %'

--2. Phép chiếu
--q5. Cho biết các thông tin sau của nhân viên: mã nhân viên, họ, tên, mscn, ngày vào làm
SELECT MANV, Ho, Ten, MSCN, NgayVaoLam
FROM NhanVien

--Phép chiếu mở rộng
--q5': Cho biết các thông tin sau của nhân viên: mã nhân viên, họ và tên, mscn, ngày vào làm
SELECT MANV, Ho + ' ' + Ten as HoTen, MSCN, CONVERT(char(10), NgayVaoLam, 103) as NgayVL
FROM NhanVien

--q6: Cho biết các thông tin sau của nhân viên làm việc tại chi nhánh có mã chi nhánh là '02': MANV, Hoten, Số năm công tác
SELECT MANV, Ho + ' ' + Ten as HoTen, YEAR(GetDate())-YEAR(NgayVaoLam) as SoNamCT
FROM NhanVien
WHERE MSCN = '02'

--3. Truy vấn dữ liệu trên nhiều bảng
--Phép tích
SELECT *
FROM NhanVien, ChiNhanh
WHERE NhanVien.MSCN = ChiNhanh.MSCN

--Q1a: SELECT MANV, Ho = ' ' + Ten AS HoTen, YEAR(GETDATE())-YEAR(NgayVaoLam) AS SoNamLamViec
SELECT MANV, Ho + ' ' + Ten as HoTen, MSCN, YEAR(GETDATE())-YEAR(NgayVaoLam) as SoNamCT 
FROM NhanVien
WHERE YEAR(GETDATE())-YEAR(NgayVaoLam)>20

--Phép kết--
SELECT NhanVien.*, ChiNhanh.* 
FROM NhanVien, ChiNhanh
WHERE NhanVien.MSCN=ChiNhanh.MSCN
----------
SELECT a.*, b.*
FROM NhanVien a, ChiNhanh b --sử dụng bí danh
WHERE a.MSCN=b.MSCN

--Q1b: Liệt kê các thông tin về nhân viên: HoTen, NgaySinh, NgayVaoLam, TenCN (sắp xếp theo tên chi nhánh)
SELECT Ho + ' ' + Ten as HoTen, CONVERT(char(10), NgaySinh, 103) as NgaySinh, CONVERT(char(10), NgayVaoLam, 103) as NgayVL, TenCN
FROM NhanVien, ChiNhanh
WHERE NhanVien.MSCN=ChiNhanh.MSCN
ORDER BY TenCN, Ten, Ho

--Q1c: Liệt kê các nhân viên (HoTen, TenKN, MucDo) của những nhân viên biết sử dụng ‘Word’
SELECT Ho + ' ' + Ten as HoTen, TenKN, MucDo 
FROM NhanVien A,  NhanVienKyNang B, KyNang c
WHERE A.MANV=B.MANV and B.MSKN=C.MSKN and TenKN='Word'

--Q1d: Liệt kê các kỹ năng (TenKN, MucDo) mà nhân viên ‘Lê Anh Tuấn’ biết sử dụng
--Cách 1:
SELECT TenKN, MucDo
FROM NhanVien A, NhanVienKyNang B, KyNang C
WHERE A.MANV=B.MANV and B.MSKN=C.MSKN and Ho = N'Lê Anh' and Ten = N'Tuấn'

--Cách 2:
SELECT TenKN, MucDo
FROM NhanVien A, NhanVienKyNang B, KyNang C
WHERE A.MANV=B.MANV and B.MSKN=C.MSKN and Ho + ' ' + Ten = N'Lê Anh Tuấn'

--q7: Cho biết số lượng nhân viên làm việc tại mỗi chi nhánh
SELECT MSCN, COUNT(MANV) as SoNV
FROM NhanVien
GROUP BY MSCN

--Q3a: Cho biết số nhân viên làm việc tại mỗi chi nhánh. Thông tin hiển thị: TenCN, Số NV
SELECT TenCN, COUNT(MANV) as SoNV
FROM NhanVien A, ChiNhanh B
WHERE A.MSCN=B.MSCN
GROUP BY TenCN

--Q3b: Với mỗi kỹ năng, hãy cho biết TenKN, SoNguoiDung (Số nhân viên biết sử dụng kỹ năng đó)
SELECT TenKN, COUNT(MANV) as SoNguoiDung
FROM KyNang A, NhanVienKyNang B
WHERE A.MSKN=B.MSKN
GROUP BY TenKN
ORDER BY TenKN

--Q3c: Cho biết TenKN có từ 3 nhân viên trong công ty sử dụng trở lên
SELECT TenKN, COUNT(MANV) as SoNguoiDung
FROM KyNang A, NhanVienKyNang B
WHERE A.MSKN=B.MSKN --điều kiện nối | kết bảng và điều kiện chọn bộ (nếu có)
GROUP BY TenKN
HAVING COUNT(MANV)>=3 --điều kiện (tính bằng hàm count | sum) chọn của nhóm

--Q3f: Với mỗi nhân viên, hãy cho biết số kỹ năng tin học mà nhân viên đó sử dụng được
SELECT B.MANV, Ho + ' ' + Ten as HoTen, TenCN, COUNT(MSKN) as SoKyNang
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV
GROUP BY B.MANV, Ho, Ten, TenCN

--Cập nhật dữ liệu
--Q4a: Thêm bộ <'06', 'Photoshop'> vào bảng KyNang
INSERT INTO KyNang values('06', N'Photoshop')
SELECT * FROM KyNang

--Q4b: Thêm các bộ sau vào vào bảng NhanVienKyNang <'0001', '06', 3> <'0005', '06', 2>
INSERT INTO NhanVienKyNang values('0001', '06', 3)
INSERT INTO NhanVienKyNang values('0005', '06', 2)
SELECT * FROM NhanVienKyNang

--Q4c: Cập nhật cho các nhân viên có sử dụng kỹ năng 'Word' có mức độ tăng thêm một bật
UPDATE NhanVienKyNang
SET MucDo=MucDo+1
WHERE MSKN='01'

--xem kết quả
SELECT *
FROM NhanVienKyNang
WHERE MSKN='01'

--Q4d: Tạo bảng mới NhanVienChiNhanh1(MANV, HoTen, SoKyNang)
CREATE TABLE NhanVienChiNhanh1
(
	MANV char(4) primary key,
	HoTen NVARCHAR(30),
	SoKyNang tinyint
)

--xem bảng
SELECT * FROM NhanVienChiNhanh1

--Q4e: Thêm vào bảng trên các thông tin như đã liệt kê của các nhân viên thuộc chi nhánh 1
INSERT INTO NhanVienChiNhanh1
SELECT B.MANV, Ho + ' ' + Ten as HoTen, COUNT(MSKN)
FROM NhanVien B, NhanVienKyNang C
WHERE B.MANV=C.MANV and MSCN='01'
GROUP BY B.MANV, Ho, Ten

--Các phép toán trên tập hợp
--Phép giao
--Q2b: Liệt kê MANV, HoTen, TenCN của các nhân viên vừa biết ‘Word’ vừa biết ‘Excel’ (dùng truy vấn lồng).
SELECT B.MANV, Ho + ' ' + Ten as HoTen, TenCN
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV and C.MSKN=D.MSKN and TenKN='Word'
		and B.MANV in (SELECT E.MANV
					   FROM NhanVienKyNang E, KyNang F
					   WHERE E.MSKN=F.MSKN and TenKN='Excel'
					  )

--Phép trừ | Phép hiệu
--q8: Cho biết các nhân viên không sử dụng Access
--Cách 1: dùng not in
SELECT *
FROM NhanVien
WHERE MANV not in (SELECT E.MANV
			       FROM NhanVienKyNang E, KyNang F
				   WHERE E.MSKN=F.MSKN and TenKN='Access'
				  )
--Cách 2: dùng hàm not exists (hàm kiểm tra)
SELECT *
FROM NhanVien B
WHERE not exists (SELECT *
			      FROM NhanVienKyNang E, KyNang F
				  WHERE E.MANV=B.MANV and E.MSKN=F.MSKN and TenKN='Access'
				 )

--Cách 3: dùng phép nối | kết ngoài
SELECT B.*
FROM NhanVien B left join (SELECT E.MANV
						   FROM NhanVienKyNang E, KyNang F
						   WHERE E.MSKN=F.MSKN and TenKN='Access'
						  )
						  as NVSuDungAccess
		on B.MANV=NVSuDungAccess.MANV
WHERE NVSuDungAccess.MANV is NULL

--Bài toán tìm Min | Max
--Q2a: Liệt kê MANV, HoTen, MSCN, TenCN của các nhân viên có mức độ thành thạo về ‘Excel’ cao nhất trong công ty .
--Cách 1: dùng hàm Max
SELECT B.MANV, Ho + ' ' + Ten as HoTen, B.MSCN, TenCN, TenKN, MucDo
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV and C.MSKN=D.MSKN 
		and TenKN='Excel' and C.MucDo =(SELECT MAX(E.MucDo)
										FROM NhanVienKyNang E, KyNang F
										WHERE E.MSKN=F.MSKN and TenKN='Excel'
									   )

--Cách 2: dùng phép so sánh với tập hợp
SELECT B.MANV, Ho + ' ' + Ten as HoTen, B.MSCN, TenCN, TenKN, MucDo
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV and C.MSKN=D.MSKN 
		and TenKN='Excel' and C.MucDo >= all(SELECT E.MucDo
											 FROM NhanVienKyNang E, KyNang F
											 WHERE E.MSKN=F.MSKN and TenKN='Excel'
											)

--Cách 3: dùng top - không chắc đúng trong trường hợp tổng quát
SELECT  top 3 B.MANV, Ho + ' ' + Ten as HoTen, B.MSCN, TenCN, TenKN, MucDo
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV and C.MSKN=D.MSKN and TenKN='Excel'
ORDER BY MucDo DESC

--Q2c: Với từng kỹ năng, hãy liệt kê các thông tin (MANV, HoTen, TenCN, TenKN, MucDo) của những nhân viên thành thạo kỹ năng đó nhất.
SELECT B.MANV, Ho + ' ' + Ten as HoTen, B.MSCN, TenCN, TenKN, MucDo
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV and C.MSKN=D.MSKN
	and C.MucDo=(SELECT MAX(E.MucDo)
				 FROM NhanVienKyNang E
				 WHERE E.MSKN=D.MSKN
				)
ORDER BY TenKN, Ten, Ho

--Q3d: Cho biết TenCN có nhiều nhân viên nhất.
SELECT TenCN, COUNT(MANV) as SoNV
FROM ChiNhanh A, NhanVien B
WHERE A.MSCN=B.MSCN
GROUP BY TenCN
HAVING COUNT(MANV) >= all(SELECT COUNT(MANV)
						  FROM NhanVien
						  GROUP BY MSCN
						 )

--Q3e: Cho biết TenCN có ít nhân viên nhất
SELECT TenCN, COUNT(MANV) as SoNV
FROM ChiNhanh A, NhanVien B
WHERE A.MSCN=B.MSCN
GROUP BY TenCN
HAVING COUNT(MANV) <= all(SELECT COUNT(MANV)
						  FROM NhanVien
						  GROUP BY MSCN
						 )

--Q3g: Cho biết HoTen, TenCN của nhân viên biết sử dụng nhiều kỹ năng nhất
SELECT B.MANV, Ho + ' ' + Ten as HoTen, TenCN, COUNT(MSKN) as SoKN
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C
WHERE A.MSCN=B.MSCN and B.MANV=C.MANV
GROUP BY B.MaNV, Ho, Ten, TenCN
HAVING COUNT(MSKN) >= all(SELECT COUNT(MSKN)
						  FROM NhanVienKyNang
						  GROUP BY MANV
						 )

--Phép chia
--q9) Cho biết nhân viên (MaNV) sử dụng được mọi kỹ năng
--Cách 1:
SELECT MANV
FROM NhanVienKyNang
GROUP BY MANV
HAVING COUNT(MSKN) = (SELECT count(MSKN)
					  FROM KyNang
					 )
--
SELECT A.MANV, Ho +' '+ Ten as HoTen
FROM NhanVien A, NhanVienKyNang B
WHERE A.MaNV = B.MANV 
GROUP BY A.MANV, Ho, Ten
HAVING count(MSKN) = (Select count(MSKN)
					  From KyNang
					 )

/* Cách 2: phát biểu tương đương "cho biết các nhân viên không có kỹ năng nào mà 
									nhân viên đó không sử dụng được."
*/
SELECT *
FROM NhanVien A
WHERE not exists(SELECT *
				 FROM KyNang B
				 WHERE not exists(SELECT *
								  FROM NhanVienKyNang C
								  WHERE	C.MANV = A.MANV and C.MSKN = B.MSKN)
				)

--Q2d) Liệt kê các chi nhánh (MSCN, TenCN) mà mọi nhân viên trong chi nhánh đó đều biết ‘Word’. 
SELECT A.MSCN, TenCN, COUNT(B.MANV) as SoNVDungWord
FROM ChiNhanh A, NhanVien B, NhanVienKyNang C, KyNang D
WHERE A.MSCN = B.MSCN and B.MaNV = C.MaNV and C.MSKN = D.MSKN and TenKN = 'Word'
GROUP BY A.MSCN, TenCN
HAVING COUNT(B.MaNV) = (SELECT COUNT(E.MaNV)
						FROM NhanVien E
						WHERE E.MSCN = A.MSCN
					   )
