CREATE DATABASE OnTapLab2
GO

USE OnTapLab2
GO

CREATE TABLE ToSanXuat
(
	MaTSX char(4) PRIMARY KEY,
	TenTSX nvarchar(10) not null unique
)
GO

CREATE TABLE CongNhan
(
	MaCN char(5) PRIMARY KEY,
	Ho nvarchar(30) not null,
	Ten nvarchar(10) not null,
	Phai nvarchar(4) not null,
	NgaySinh Date,
	MaTSX char(4) REFERENCES ToSanXuat(MaTSX)
)
GO

CREATE TABLE SanPham
(
	MaSP char(5) PRIMARY KEY,
	TenSP nvarchar(30) not null unique,
	DVT nvarchar(10),
	TienCong int check(TienCong>0)
)
GO

CREATE TABLE ThanhPham
(
	MaCN char(5) REFERENCES CongNhan(MaCN),
	MaSP char(5) REFERENCES SanPham(MaSP),
	Ngay Date,
	SoLuong int check(SoLuong>0),
	PRIMARY KEY(MaCN, MaSP, Ngay)
)
GO

EXEC sp_MSforeachtable 'SELECT * FROM ?'

--
CREATE PROC usp_ThemToSanXuat
	@MaTSX char(4), @TenTSX nvarchar(10)
As
	If exists(SELECT * FROM ToSanXuat WHERE MaTSX = @MaTSX)
		print N'Đã có tổ sản xuất có mã ' +@MaTSX+ ' trong CSDL'
	Else
		Begin
			INSERT INTO ToSanXuat values(@MaTSX, @TenTSX)
			print N'Thêm tổ sản xuất thành công!'
		End
GO

exec usp_ThemToSanXuat 'TS01', N'Tổ 1'
exec usp_ThemToSanXuat 'TS02', N'Tổ 2'

--
CREATE PROC usp_ThemCongNhan
	@MaCN char(5), @Ho nvarchar(30), @Ten nvarchar(10),
	@Phai nvarchar(4), @NgaySinh Date, @MaTSX char(4)
As
	If exists(SELECT * FROM ToSanXuat WHERE MaTSX = @MaTSX)
		Begin
			If exists(SELECT * FROM CongNhan WHERE MaCN = @MaCN)
				print N'Đã có công nhân có mã ' +@MaCN+ ' trong CSDL'
			Else
				INSERT INTO CongNhan values(@MaCN, @Ho, @Ten, @Phai, @NgaySinh, @MaTSX)
				print N'Thêm công nhân thành công '
		End
	Else
		print N'Không có tổ sản xuất ' +@MaTSX+ ' trong CSDL'
GO

set dateformat dmy
go

exec usp_ThemCongNhan 'CN001', N'Nguyễn Trường', N'An', N'Nam', '12/05/1981', 'TS01'
exec usp_ThemCongNhan 'CN002', N'Lê Thị Hồng', N'Gấm', N'Nữ', '04/06/1980', 'TS01'
exec usp_ThemCongNhan 'CN003', N'Nguyễn Công', N'Thành', N'Nam', '04/05/1981', 'TS02'
exec usp_ThemCongNhan 'CN004', N'Võ Hữu', N'Hạnh', N'Nam', '15/02/1980', 'TS02'
exec usp_ThemCongNhan 'CN005', N'Lý Thanh', N'Hân', N'Nữ', '03/12/1981', 'TS01'

--
CREATE PROC usp_ThemSanPham
	@MaSP char(5), @TenSP nvarchar(30), @DVT nvarchar(4), @TienCong int
As
	If exists(SELECT * FROM SanPham WHERE MaSP = @MaSP)
		print N'Đã có sản phẩm có mã ' +@MaSP+ ' trong CSDL'
	Else
		Begin
			INSERT INTO SanPham values(@MaSP, @TenSP, @DVT, @TienCong)
			print N'Thêm sản phẩm thành công!'
		End
GO

exec usp_ThemSanPham 'SP001', N'Nồi đất', N'cái', 10000
exec usp_ThemSanPham 'SP002', N'Chén', N'cái', 2000
exec usp_ThemSanPham 'SP003', N'Bình gốm nhỏ', N'cái', 20000
exec usp_ThemSanPham 'SP004', N'Bình gốm lớn', N'cái', 25000

--
ALTER PROC usp_ThemThanhPham
	@MaCN char(5), @MaSP char(5), @Ngay Date, @SoLuong int
As
	If exists(SELECT * FROM CongNhan WHERE MaCN = @MaCN) and exists(SELECT * FROM SanPham WHERE MaSP = @MaSP)
		Begin
			If exists(SELECT * FROM ThanhPham WHERE MaCN = @MaCN and MaSP = @MaSP and Ngay = @Ngay)
				print N'Đã có dữ liệu thành phẩm của công nhân ' + @MaCN + N' cho sản phẩm ' + @MaSP + N' vào ngày ' + CONVERT(nvarchar, @Ngay, 103)
			Else
				INSERT INTO ThanhPham values(@MaCN, @MaSP, @Ngay, @SoLuong)
				print N'Thêm thành phẩm thành công!'
		End
	Else
		If not exists(SELECT * FROM CongNhan WHERE MaCN = @MaCN)
			print N'Không có công nhân nào có mã ' +@MaCN+ ' trong CSDL'
		If not exists(SELECT * FROM SanPham WHERE MaSP = @MaSP)
			print N'Không có sản phẩm nào có mã ' +@MaSP+ ' trong CSDL'
GO

SET DATEFORMAT dmy
GO

exec usp_ThemThanhPham 'CN001', 'SP001', '01/02/2007', 10
exec usp_ThemThanhPham 'CN002', 'SP001', '01/02/2007', 5
exec usp_ThemThanhPham 'CN003', 'SP002', '10/01/2007', 50
exec usp_ThemThanhPham 'CN004', 'SP003', '12/01/2007', 10
exec usp_ThemThanhPham 'CN005', 'SP002', '12/01/2007', 100
exec usp_ThemThanhPham 'CN002', 'SP004', '13/02/2007', 10
exec usp_ThemThanhPham 'CN001', 'SP003', '14/02/2007', 15
exec usp_ThemThanhPham 'CN003', 'SP001', '15/01/2007', 20
exec usp_ThemThanhPham 'CN003', 'SP004', '14/02/2007', 15
exec usp_ThemThanhPham 'CN004', 'SP002', '30/01/2007', 100
exec usp_ThemThanhPham 'CN005', 'SP003', '01/02/2007', 50
exec usp_ThemThanhPham 'CN001', 'SP001', '20/02/2007', 30

--1)
SELECT TenTSX, Ho + ' ' + Ten as HoTen, CONVERT(char(10), NgaySinh, 103) as NgaySinh, Phai
FROM ToSanXuat A, CongNhan B
WHERE A.MaTSX = B.MaTSX 
ORDER BY TenTSX, Ten

--2)
SELECT TenSP, CONVERT(char(10), Ngay, 103) as Ngay, SoLuong, (SoLuong*TienCong) as ThanhTien
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MaCN = B.MaCN and B.MaSP = C.MaSP and Ho + ' ' +Ten = N'Nguyễn Trường An'
ORDER BY Ngay

--3)
SELECT *
FROM CongNhan 
WHERE MaCN not in(SELECT B.MaCN
				  FROM SanPham A, ThanhPham B
				  WHERE A.MaSP = B.MaSP and TenSP = N'Bình gốm lớn'
				 )

--4)
SELECT DISTINCT Ho + ' ' +Ten as HoTen, Phai, CONVERT(char(10), NgaySinh, 103) as NgaySinh
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Nồi đất'
		and A.MaCN in(SELECT E.MaCN
					  FROM ThanhPham E, SanPham F
					  WHERE E.MaSP = F.MaSP and TenSP = N'Bình gốm nhỏ'
					 )

--5)  
SELECT TenTSX, COUNT(MaCN) as SLCongNhan
FROM ToSanXuat A, CongNhan B
WHERE A.MaTSX = B.MaTSX
GROUP BY TenTSX

--6)
SELECT Ho, Ten, TenSP, SUM(SoLuong) as TongSLThanhPham, SUM(SoLuong*TienCong) as TongThanhTien
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MaCN = B.MaCN and B.MaSP = C.MaSP
GROUP BY Ho, Ten, TenSP

--7)
SELECT SUM(SoLuong*TienCong) as TongSoTienCongThang1Nam2007 
FROM SanPham A, ThanhPham B
WHERE A.MaSP = B.MaSP and MONTH(Ngay) = 1 and YEAR(Ngay) = 2007

--8)
SELECT TenSP, SUM(SoLuong) as TongSoLuong
FROM SanPham A, ThanhPham B
WHERE A.MaSP = B.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
GROUP BY TenSP
HAVING SUM(SoLuong) >= all(SELECT SUM(SoLuong)
						   FROM ThanhPham 
						   WHERE MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
						   GROUP BY MaSP
						  )

--9)
SELECT A.MACN, Ho + ' ' + Ten as HoTen, A.MaTSX, TenSP, SoLuong
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Chén'
		and SoLuong = (SELECT MAX(E.SoLuong)
					   FROM ThanhPham E, SanPham F
					   WHERE E.MaSP = F.MaSP and TenSP = N'Chén'
				      )

--10)
SELECT SUM(SoLuong*TienCong) as TienCongThang2Nam2007
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MaCN = B.MaCN and B.MaSP = C.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007 and A.MaCN = 'CN002'

--11)
SELECT A.MaCN, Ho + ' ' + Ten as HoTen, COUNT(MaSP) as SoLoaiSanPham
FROM CongNhan A, ThanhPham B
WHERE A.MaCN = B.MaCN
GROUP BY A.MaCN, Ho + ' ' + Ten
HAVING COUNT(MaSP) >= 3

--12)
UPDATE SanPham
SET TienCong = TienCong + 1000
WHERE TenSP like N'Bình gốm%'

--13)
exec usp_ThemCongNhan 'CN006', N'Lê Thị', N'Lan', N'Nữ', NULL, 'TS02'