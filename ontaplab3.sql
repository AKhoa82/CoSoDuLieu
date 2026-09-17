CREATE DATABASE OnTapLab3
GO

USE OnTapLab3
GO

CREATE TABLE HangHoa
(
	MaHH char(5) PRIMARY KEY,
	TenHH nvarchar(50) not null,
	DVT nvarchar(10) not null,
	SoLuongTon int,
)
GO

CREATE TABLE DoiTac
(
	MaDT char(5) PRIMARY KEY,
	TenDT nvarchar(30) not null,
	DiaChi nvarchar(100) not null,
	DienThoai varchar(10) not null
)
GO

CREATE TABLE HoaDon
(
	SoHD char(5) PRIMARY KEY,
	NgayLapHD Date not null,
	MaDT char(5) REFERENCES DoiTac(MaDT),
	TongTG float
)
GO

CREATE TABLE KhaNangCC
(
	MaDT char(5) REFERENCES DoiTac(MaDT),
	MaHH char(5) REFERENCES HangHoa(MaHH),
	PRIMARY KEY(MaDT, MaHH)
)
GO

CREATE TABLE CT_HoaDon
(
	SoHD char(5) REFERENCES HoaDon(SoHD),
	MaHH char(5) REFERENCES HangHoa(MaHH),
	DonGia int not null,
	SoLuong int not null,
	PRIMARY KEY(SoHD, MaHH)
)
GO

--
CREATE PROC usp_ThemHangHoa
	@MaHH char(5), @TenHH nvarchar(50), @DVT nvarchar(10), @SoLuongTon int
As
	If exists(SELECT * FROM HangHoa WHERE MaHH = @MaHH)
		print N'Đã có hàng hóa có mã ' +@MaHH+ ' trong CSDL'
	Else
		Begin
			INSERT INTO HangHoa values(@MaHH, @TenHH, @DVT, @SoLuongTon)
			print N'Thêm hàng hóa thành công'
		End
GO

exec usp_ThemHangHoa 'CPU01', N'CPU INTEL,CELERON 600 BOX', N'cái', 5
exec usp_ThemHangHoa 'CPU02', N'CPU INTEL,PIII 700', N'cái', 10
exec usp_ThemHangHoa 'CPU03', N'CPU AMD K7 ATHL,ON 600', N'cái', 8
exec usp_ThemHangHoa 'HDD01', N'HDD 10.2 GB QUANTUM', N'cái', 10
exec usp_ThemHangHoa 'HDD02', N'HDD 13.6 GB SEAGATE', N'cái', 15
exec usp_ThemHangHoa 'HDD03', N'HDD 20 GB QUANTUM', N'cái', 6
exec usp_ThemHangHoa 'KB01', N'KB GENIUS', N'cái', 12
exec usp_ThemHangHoa 'KB02', N'KB MITSUMIMI', N'cái', 5
exec usp_ThemHangHoa 'MB01', N'GIGABYTE CHIPSET INTEL', N'cái', 10
exec usp_ThemHangHoa 'MB02', N'ACOPR BX CHIPSET VIA', N'cái', 10
exec usp_ThemHangHoa 'MB03', N'INTEL PHI CHIPSET INTEL', N'cái', 10
exec usp_ThemHangHoa 'MB04', N'ECS CHIPSET SIS', N'cái', 10
exec usp_ThemHangHoa 'MB05', N'ECS CHIPSET VIA', N'cái', 10
exec usp_ThemHangHoa 'MNT01', N'SAMSUNG 14" SYNCMASTER', N'cái', 5
exec usp_ThemHangHoa 'MNT02', N'LG 14"', N'cái', 5
exec usp_ThemHangHoa 'MNT03', N'ACER 14"', N'cái', 8
exec usp_ThemHangHoa 'MNT04', N'PHILIPS 14"', N'cái', 6
exec usp_ThemHangHoa 'MNT05', N'VIEWSONIC 14"', N'cái', 7

--
CREATE PROC usp_ThemDoiTac
	@MaDT char(5), @TenDT nvarchar(30), @DiaChi nvarchar(100), @DienThoai varchar(10)
As
	If exists(SELECT * FROM DoiTac WHERE MaDT = @MaDT)
		print N'Đã có đối tác có mã ' +@MaDT+ ' trong CSDL'
	Else
		Begin
			INSERT INTO DoiTac values(@MaDT, @TenDT, @DiaChi, @DienThoai)
			print N'Thêm đối tác thành công'
		End
Go

exec usp_ThemDoiTac 'CC001', N'Cty TNC', N'176 BTX Q1 - TPHCM', '08.8250259'
exec usp_ThemDoiTac 'CC002', N'Cty Hoàng Long', N'15A TTT Q1 – TP. HCM', '08.8250898'
exec usp_ThemDoiTac 'CC003', N'Cty Hợp Nhất', N'152 BTX Q1 – TP.HCM', '08.8252376'
exec usp_ThemDoiTac 'K0001', N'Nguyễn Minh Hải', N'91 Nguyễn Văn Trỗi Tp. Đà Lạt', '063.831129'
exec usp_ThemDoiTac 'K0002', N'Như Quỳnh', N'21 Điện Biên Phủ. N.Trang', '058.590270'
exec usp_ThemDoiTac 'K0003', N'Trần nhật Duật', N'Lê Lợi TP. Huế', '054.848376'
exec usp_ThemDoiTac 'K0004', N'Phan Nguyễn Hùng Anh', N'11 Nam Kỳ Khởi nghĩa- TP. Đà lạt', '063.823409'

--
CREATE PROC usp_ThemHoaDon
	@SoHD char(5), @NgayLapHD Date, @MaDT char(5), @TongTG float
As
	If exists(SELECT * FROM DoiTac WHERE MaDT = @MaDT)
		Begin
			If exists(SELECT * FROM HoaDon WHERE SoHD = @SoHD)
				print N'Đã có số hóa đơn ' +@SoHD+ ' trong CSDL'
			Else
				Begin
					INSERT INTO HoaDon values(@SoHD, @NgayLapHD, @MaDT, @TongTG)
					print N'Thêm hóa đơn thành công'
				End
		End
	Else
		print N'Không có đối tác nào có mã ' +@MaDT+ ' trong CSDL'
GO

SET DATEFORMAT dmy
GO

exec usp_ThemHoaDon 'N0001', '25/01/2006', 'CC001', NULL
exec usp_ThemHoaDon 'N0002', '01/05/2006', 'CC002', NULL
exec usp_ThemHoaDon 'X0001', '12/05/2006', 'K0001', NULL
exec usp_ThemHoaDon 'X0002', '16/06/2006', 'K0002', NULL
exec usp_ThemHoaDon 'X0003', '20/04/2006', 'K0001', NULL

--
CREATE PROC usp_ThemKhaNangCC
	@MaDT char(5), @MaHH char(5)
As
	If exists(SELECT * FROM DoiTac WHERE MaDT = @MaDT) and exists(SELECT * FROM HangHoa WHERE MaHH = @MaHH)
		Begin
			INSERT INTO KhaNangCC values(@MaDT, @MaHH)
			print N'Thêm khả năng cung cấp thành công'
		End
	Else
		If not exists(SELECT * FROM DoiTac WHERE MaDT = @MaDT)
			print N'Không có đối tác nào có mã ' +@MaDT+ ' trong CSDL'
		If not exists(SELECT * FROM HangHoa	WHERE MaHH = @MaHH)
			print N'Không có hàng hóa nào có mã ' +@MaHH+ ' trong CSDL'
go

exec usp_ThemKhaNangCC 'CC001', 'CPU01'
exec usp_ThemKhaNangCC 'CC001', 'HDD03'
exec usp_ThemKhaNangCC 'CC001', 'KB01'
exec usp_ThemKhaNangCC 'CC001', 'MB02'
exec usp_ThemKhaNangCC 'CC001', 'MB04'
exec usp_ThemKhaNangCC 'CC001', 'MNT01'
exec usp_ThemKhaNangCC 'CC002', 'CPU01'
exec usp_ThemKhaNangCC 'CC002', 'CPU02'
exec usp_ThemKhaNangCC 'CC002', 'CPU03'
exec usp_ThemKhaNangCC 'CC002', 'KB02'
exec usp_ThemKhaNangCC 'CC002', 'MB01'
exec usp_ThemKhaNangCC 'CC002', 'MB05'
exec usp_ThemKhaNangCC 'CC002', 'MNT03'
exec usp_ThemKhaNangCC 'CC003', 'HDD01'
exec usp_ThemKhaNangCC 'CC003', 'HDD02'
exec usp_ThemKhaNangCC 'CC003', 'HDD03'
exec usp_ThemKhaNangCC 'CC003', 'MB03'

--
CREATE PROC usp_ThemCTHoaDon
	@SoHD char(5), @MaHH char(5), @DonGia int, @SoLuong int
As
	If exists(SELECT * FROM HoaDon WHERE SoHD = @SoHD) and exists(SELECT * FROM HangHoa WHERE MaHH = @MaHH)
		Begin
			INSERT INTO CT_HoaDon values(@SoHD, @MaHH, @DonGia, @SoLuong)
			print N'Thêm chi tiết hóa đơn thành công'
		End
	Else
		If not exists(SELECT * FROM HoaDon WHERE SoHD = @SoHD)
			print N'Không có hóa đơn nào có mã ' +@SoHD+ ' trong CSDL'
		If not exists(SELECT * FROM HangHoa WHERE MaHH = @MaHH)
			print N'Không có hàng hóa nào có mã ' +@MaHH+ ' trong CSDL'
GO

exec usp_ThemCTHoaDon 'N0001', 'CPU01', 63, 10
exec usp_ThemCTHoaDon 'N0001', 'HDD03', 97, 7
exec usp_ThemCTHoaDon 'N0001', 'KB01', 3, 5
exec usp_ThemCTHoaDon 'N0001', 'MB02', 57, 5
exec usp_ThemCTHoaDon 'N0001', 'MNT01', 112, 3
exec usp_ThemCTHoaDon 'N0002', 'CPU02', 115, 3
exec usp_ThemCTHoaDon 'N0002', 'KB02', 5, 7
exec usp_ThemCTHoaDon 'N0002', 'MNT03', 111, 5
exec usp_ThemCTHoaDon 'X0001', 'CPU01', 67, 2
exec usp_ThemCTHoaDon 'X0001', 'HDD03', 100, 2
exec usp_ThemCTHoaDon 'X0001', 'KB01', 5, 2
exec usp_ThemCTHoaDon 'X0001', 'MB02', 62, 1
exec usp_ThemCTHoaDon 'X0002', 'CPU01', 67, 1
exec usp_ThemCTHoaDon 'X0002', 'KB02', 7, 3
exec usp_ThemCTHoaDon 'X0002', 'MNT01', 115, 2
exec usp_ThemCTHoaDon 'X0003', 'CPU01', 67, 1
exec usp_ThemCTHoaDon 'X0003', 'MNT03', 115, 2

EXEC sp_MSforeachtable 'SELECT * FROM ?'

--1)
SELECT *
FROM HangHoa
WHERE MaHH like 'HDD%'

--2)
SELECT *
FROM HangHoa
WHERE SoLuongTon > 10

--3)
SELECT *
FROM DoiTac
WHERE DiaChi like '%HCM%'

--4)
SELECT B.SoHD, CONVERT(char(10), NgayLapHD, 103) as NgayLapHD, TenDT, DiaChi, DienThoai, COUNT(MaHH) as SoMatHang
FROM DoiTac A, HoaDon B, CT_HoaDon C
WHERE A.MaDT = B.MaDT and B.SoHD = C.SoHD and MONTH(NgayLapHD) = 5 and YEAR(NgayLapHD) = 2006 and B.SoHD like 'N%'
GROUP BY B.SoHD, NgayLapHD, TenDT, DiaChi, DienThoai

--5)
SELECT TenDT
FROM DoiTac 
WHERE MaDT in(SELECT MaDT
			  FROM KhaNangCC
			  WHERE MaHH like 'HDD%'
			 )

--6)
SELECT TenDT
FROM DoiTac A, KhaNangCC B, HangHoa C
WHERE A.MaDT = B.MaDT and B.MaHH = C.MaHH and B.MaHH like 'HDD%'
GROUP BY TenDT
HAVING COUNT(B.MaHH) = (SELECT COUNT(MaHH)
						FROM HangHoa
						WHERE MaHH like 'HDD%'
					   )

--7)
SELECT *
FROM DoiTac 
WHERE MaDT not in(SELECT MaDT
				  FROM KhaNangCC
				  WHERE MaHH like 'HDD%'
				 )

--8)
SELECT *
FROM HangHoa 
WHERE MaHH not in(SELECT MaHH
				  FROM CT_HoaDon
				  WHERE SoHD like 'X%'
				 )