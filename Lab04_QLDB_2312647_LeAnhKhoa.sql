/*--------------------------------------------
	Học phần: Cơ sở dữ liệu
	Họ và tên sinh viên: Lê Anh Khoa
	Mã số sinh viên: 2312647
	Lớp: CTK47A
	Ngày thực hiện: 25/02/2025 - 23/03/2025
--------------------------------------------*/

--Lệnh tạo CSDL
CREATE DATABASE Lab04_QLDatBao
GO

--Lệnh sử dụng CSDL
USE Lab04_QLDatBao
GO

--Nhập các bảng
CREATE TABLE Bao_TChi
(
	MaBaoTC char(4) PRIMARY KEY,
	Ten nvarchar(30) not null,
	DinhKy nvarchar(20) not null,
	SoLuong smallint not null check(SoLuong>0),
	GiaBan int not null check (GiaBan>0)
)
GO

CREATE TABLE PhatHanh
(	
	MaBaoTC char(4) references Bao_TChi(MaBaoTC),
	SoBaoTC smallint not null check(SoBaoTC>0),
	NgayPH Datetime,
	PRIMARY KEY(MaBaoTC, SoBaoTC)
)
GO

CREATE TABLE KhachHang
(
	MaKH char(4) PRIMARY KEY,
	TenKH nvarchar(10) not null,
	DiaChi nvarchar(10) not null
)
GO

CREATE TABLE DatBao
(
	MaKH char(4) references KhachHang(MaKH),
	MaBaoTC char(4) references Bao_TChi(MaBAoTC),
	SLMua int not null check(SLMua>0), 
	NgayDM datetime,
	PRIMARY KEY(MaKH, MaBaoTC)
)
GO

--Xem các bảng
SELECT * FROM Bao_TChi
SELECT * FROM PhatHanh
SELECT * FROM KhachHang
SELECT * FROM DatBao

--Nhập bảng Bao_TChi
INSERT INTO Bao_TChi VALUES ('TT01', N'Tuổi trẻ', N'Nhật báo', 1000, 1500)
INSERT INTO Bao_TChi VALUES ('KT01', N'Kiến thức ngày nay', N'Bán nguyệt san', 3000, 6000)
INSERT INTO Bao_TChi VALUES ('TN01', N'Thanh niên', N'Nhật báo', 1000, 2000)
INSERT INTO Bao_TChi VALUES ('PN01', N'Phụ nữ', N'Tuần báo', 2000, 4000)
INSERT INTO Bao_TChi VALUES ('PN02', N'Phụ nữ', N'Nhật báo', 1000, 2000)

--Xem bảng Bao_TChi
SELECT * FROM Bao_TChi

--Nhập bảng PhatHanh
SET DATEFORMAT dmy
GO

INSERT INTO PhatHanh VALUES ('TT01', 123, '15/12/2005')
INSERT INTO PhatHanh VALUES ('KT01', 70, '15/12/2005')
INSERT INTO PhatHanh VALUES ('TT01', 124, '16/12/2005')
INSERT INTO PhatHanh VALUES ('TN01', 256, '17/12/2005')
INSERT INTO PhatHanh VALUES ('PN01', 45, '23/12/2005')
INSERT INTO PhatHanh VALUES ('PN02', 111, '18/12/2005')
INSERT INTO PhatHanh VALUES ('PN02', 112, '19/12/2005')
INSERT INTO PhatHanh VALUES ('TT01', 125, '17/12/2005')
INSERT INTO PhatHanh VALUES ('PN01', 46, '30/12/2005')

SELECT * FROM PhatHanh

--Nhập bảng KhachHang
INSERT INTO KhachHang VALUES ('KH01', N'LAN', N'2 NCT')
INSERT INTO KhachHang VALUES ('KH02', N'NAM', N'32 THĐ')
INSERT INTO KhachHang VALUES ('KH03', N'NGỌC', N'16 LHP')

--Xem bảng KhachHang
SELECT * FROM KhachHang

--Nhập bảng DatBao
SET DATEFORMAT dmy
GO 

INSERT INTO DatBao VALUES ('KH01', 'TT01', 100, '12/01/2000')
INSERT INTO DatBao VALUES ('KH02', 'TN01', 150, '01/05/2001')
INSERT INTO DatBao VALUES ('KH01', 'PN01', 200, '25/06/2001')
INSERT INTO DatBao VALUES ('KH03', 'KT01', 50, '17/03/2002')
INSERT INTO DatBao VALUES ('KH03', 'PN02', 200, '26/08/2003')
INSERT INTO DatBao VALUES ('KH02', 'TT01', 250, '15/01/2004')
INSERT INTO DatBao VALUES ('KH01', 'KT01', 300, '14/10/2004')

--Xem bảng DatBao
SELECT * FROM DatBao

----------------------TRUY VẤN DỮ LIỆU----------------------
--Q1: Cho biết các tờ báo, tạp chí (MABAOTC, TEN, GIABAN) có định kỳ phát hành hàng tuần (Tuần báo).
SELECT MaBaoTC, Ten, GiaBan
FROM Bao_TChi
WHERE DinhKy=N'Tuần báo'

--Q2: Cho biết thông tin về các tờ báo thuộc loại báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT *
FROM Bao_TChi
WHERE MaBaoTC like 'PN%'

--Q3: Cho biết tên các khách hàng có đặt mua báo phụ nữ (mã báo tạp chí bắt đầu bằng PN), không liệt kê khách hàng trùng.
SELECT TenKH
FROM KhachHang A, DatBao B
WHERE A.MaKH=B.MaKH and MaBaoTC like 'PN%'

--Q4: Cho biết tên các khách hàng có đặt mua tất cả các báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT TenKH
FROM KhachHang A, DatBao B
WHERE A.MaKH = B.MaKH and B.MaBaoTC like 'PN%'
GROUP BY TenKH, A.MaKH
HAVING COUNT(B.MaBaoTC) = (SELECT COUNT(MaBaoTC)
						   FROM Bao_TChi
						   WHERE MaBaoTC LIKE 'PN%'
						  )

--Q5: Cho biết các khách hàng không đặt mua báo thanh niên.
SELECT *
FROM KhachHang
WHERE MaKH not in (SELECT MaKH
				   FROM DatBao
				   WHERE MaBaoTC like 'TN%'
				  )

--Q6: Cho biết số tờ báo mà mỗi khách hàng đã đặt mua.
SELECT TenKH, SUM(SLMua) as SoToBao
FROM KhachHang A, DatBao B
WHERE A.MaKH=B.MaKH
GROUP BY TenKH

--Q7: Cho biết số khách hàng đặt mua báo trong năm 2004.
SELECT COUNT(MaKH) as SoKhachHang
FROM DatBao B
WHERE YEAR(NgayDM)=2004

--Q8: Cho biết thông tin đặt mua báo của các khách hàng (TenKH, TeN, DinhKy, SLMua, SoTien), trong đó SoTien = SLMua x DonGia.
SELECT TenKH, Ten, DinhKy, SLMua, (SLMua*GiaBan) as SoTien
FROM KhachHang A, DatBao B, Bao_TChi C
WHERE A.MaKH=B.MaKH and B.MaBaoTC=C.MaBaoTC

--Q9: Cho biết các tờ báo, tạp chí (Ten, DinhKy) và tổng số lượng đặt mua của các khách hàng đối với tờ báo, tạp chí đó.
SELECT Ten, DinhKy, SUM(SLMua) AS TongSoLuongMua
FROM Bao_TChi A, DatBao B
WHERE A.MaBaoTC = B.MaBaoTC
GROUP BY Ten, DinhKy


--Q10: Cho biết tên các tờ báo dành cho học sinh, sinh viên (mã báo tạp chí bắt đầu bằng HS).
SELECT *
FROM Bao_TChi
WHERE MaBaoTC LIKE 'HS%'

--Q11: Cho biết những tờ báo không có người đặt mua.
SELECT Ten
FROM Bao_TChi
WHERE MaBaoTC NOT IN (SELECT MaBaoTC
					  FROM DatBao
				     )

--Q12: Cho biết tên, định kỳ của những tờ báo có nhiều người đặt mua nhất.
SELECT Ten, DinhKy
FROM Bao_TChi A, DatBao B
WHERE A.MaBaoTC = B.MaBaoTC
GROUP BY Ten, DinhKy
HAVING SUM(SLMua) >= all (SELECT SUM(SLMua)
					      FROM Bao_TChi C, DatBao D
						  WHERE C.MaBaoTC = D.MaBaoTC
						  GROUP BY C.MaBaoTC
						  )

--Q13: Cho biết khách hàng đặt mua nhiều báo, tạp chí nhất.
SELECT TenKH
FROM KhachHang A, DatBao B
WHERE A.MaKH = B.MaKH
GROUP BY TenKH
HAVING SUM(SLMua) >= all (SELECT SUM(SLMua)
						  FROM DatBao 
						  GROUP BY MaKH
						 )

--Q14: Cho biết các tờ báo phát hành định kỳ một tháng 2 lần.
SELECT *
FROM Bao_TChi
WHERE DinhKy = N'Bán nguyệt san'

--Q15: Cho biết các tờ báo, tạp chi có từ 3 khách hàng đặt mua trở lên.
SELECT Ten, DinhKy, COUNT(B.MaKH) as SLKhachMua
FROM Bao_TChi A, DatBao B
WHERE A.MaBaoTC = B.MaBaoTC
GROUP BY Ten, DinhKy
HAVING COUNT(B.MaKH) >= 3

----------------------HÀM----------------------
--a) Tính tổng số tiền mua báo/tạp chí của một khách hàng cho trước
CREATE FUNCTION fn_TongTienMuaBao(@MaKH char(4)) RETURNS INT
As
Begin
	DECLARE @TongTien int

	SELECT @TongTien = COALESCE(SUM(SLMua*GiaBan), 0)
	FROM Bao_TChi A, DatBao B
	WHERE A.MaBaoTC = B.MaBaoTC and B.MaKH = @MaKH

	RETURN @TongTien
End

print dbo.fn_TongTienMuaBao('KH02')

--b) Tính tổng số tiền thu được của một tờ báo/tạp chí cho trước
CREATE FUNCTION fn_TongTienThuDuoc(@MaBaoTC char(4)) RETURNS INT
As
Begin
	DECLARE @TongTien int

	SELECT @TongTien = COALESCE(SUM(SLMua*GiaBan),0)
	FROM Bao_TChi A, DatBao B
	WHERE A.MaBaoTC = B.MaBaoTC and B.MaBaoTC = @MaBaoTC

	RETURN @TongTien
End

print dbo.fn_TongTienThuDuoc('TN01')

----------------------THỦ TỤC----------------------
--a) In danh mục báo, tạp chí phải giao cho một khách hàng cho trước
CREATE PROCEDURE InDanhMucBaoKhachHang 
    @MaKH char(4)
As
    If exists(SELECT * FROM KhachHang WHERE MaKH = @MaKH)
        If exists(SELECT * FROM DatBao WHERE MaKH = @MaKH)
			Begin
				SELECT Ten, DinhKy, SLMua, (SLMua*GiaBan) as ThanhTien
				FROM Bao_TChi A, DatBao B
				WHERE A.MaBaoTC = B.MaBaoTC and B.MaKH = @MaKH
			End
        Else
            print N'Khách hàng ' + @MaKH + N' chưa đặt mua báo/tạp chí nào.'
    Else
        print N'Không tồn tại khách hàng có mã ' + @MaKH
go

exec InDanhMucBaoKhachHang 'KH01' 

--b) In danh sách khách hàng đặt mua báo/tạp chí cho trước
CREATE PROCEDURE InDanhSachKhachHangDatBao 
    @MaBaoTC char(4)
As
    If exists(SELECT * FROM Bao_TChi WHERE MaBaoTC = @MaBaoTC)
        If exists(SELECT * FROM DatBao WHERE MaBaoTC = @MaBaoTC)
			Begin
				SELECT B.MaKH, TenKH, DiaChi, SLMua, (SLMua*GiaBan) as ThanhTien
				FROM DatBao A, KhachHang B, Bao_TChi C
				WHERE A.MaKH = B.MaKH and A.MaBaoTC = C.MaBaoTC and A.MaBaoTC = @MaBaoTC
			End
        Else
            print N'Không có khách hàng nào đặt mua tờ báo/tạp chí có mã ' + @MaBaoTC
    Else
        print N'Không tồn tại báo/tạp chí có mã ' + @MaBaoTC
go

exec InDanhSachKhachHangDatBao 'TT01' 