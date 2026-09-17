/*--------------------------------------------
	Học phần: Cơ sở dữ liệu
	Họ và tên sinh viên: Lê Anh Khoa
	Mã số sinh viên: 2312647
	Lớp: CTK47A
	Ngày thực hiện: 25/02/2025 - 27/03/2025
--------------------------------------------*/

--Lệnh tạo CSDL
CREATE DATABASE Lab03_QLNhapXuatHangHoa
GO

--Lệnh dùng CSDL
USE Lab03_QLNhapXuatHangHoa
GO

--Lệnh tạo các bảng
CREATE TABLE HangHoa
(
	MAHH char(5) PRIMARY KEY,
	TENHH nvarchar(50),
	DVT nvarchar(10),
	SOLUONGTON int
)
GO

CREATE TABLE DoiTac
(
	MADT char(5) PRIMARY KEY,
	TENDT nvarchar(30), 
	DIACHI nvarchar(40),
	DIENTHOAI nvarchar(20)
)
GO

CREATE TABLE KhaNangCC
(
	MADT char(5) references DoiTac(MADT),
	MAHH char(5) references HangHoa(MAHH),
	PRIMARY KEY(MADT, MAHH)
)
GO

CREATE TABLE HoaDon
(
	SOHD char(5) PRIMARY KEY,
	NGAYLAPHD Datetime,
	MADT char(5) references DoiTac(MADT),
	TONGTG float
)
GO

CREATE TABLE CT_HoaDon
(
	SOHD char(5) references HoaDon(SOHD),
	MAHH char(5) references HangHoa(MAHH),
	DONGIA int,
	SOLUONG int
)

--Xem các bảng
SELECT * FROM HangHoa
SELECT * FROM DoiTac
SELECT * FROM KhaNangCC
SELECT * FROM HoaDon
SELECT * FROM CT_HoaDon

--Nhập bảng HangHoa
INSERT INTO HangHoa VALUES ('CPU01', N'CPU INTEL,CELERON 600 BOX', N'cái', 5)
INSERT INTO HangHoa VALUES ('CPU02', N'CPU INTEL,PIII 700', N'cái', 10)
INSERT INTO HangHoa VALUES ('CPU03', N'CPU AMD K7 ATHL,ON 600', N'cái', 8)
INSERT INTO HangHoa VALUES ('HDD01', N'HDD 10.2 GB QUANTUM', N'cái', 10)
INSERT INTO HangHoa VALUES ('HDD02', N'HDD 13.6 GB SEAGATE', N'cái', 15)
INSERT INTO HangHoa VALUES ('HDD03', N'HDD 20 GB QUANTUM', N'cái', 6)
INSERT INTO HangHoa VALUES ('KB01', N'KB GENIUS', N'cái', 12)
INSERT INTO HangHoa VALUES ('KB02', N'KB MITSUMIMI', N'cái', 5)
INSERT INTO HangHoa VALUES ('MB01', N'GIGABYTE CHIPSET INTEL', N'cái', 10)
INSERT INTO HangHoa VALUES ('MB02', N'ACOPR BX CHIPSET VIA', N'cái', 10)
INSERT INTO HangHoa VALUES ('MB03', N'INTEL PHI CHIPSET INTEL', N'cái', 10)
INSERT INTO HangHoa VALUES ('MB04', N'ECS CHIPSET SIS', N'cái', 10)
INSERT INTO HangHoa VALUES ('MB05', N'ECS CHIPSET VIA', N'cái', 10)
INSERT INTO HangHoa VALUES ('MNT01', N'SAMSUNG 14" SYNCMASTER', N'cái', 5)
INSERT INTO HangHoa VALUES ('MNT02', N'LG 14"', N'cái', 5)
INSERT INTO HangHoa VALUES ('MNT03', N'ACER 14"', N'cái', 8)
INSERT INTO HangHoa VALUES ('MNT04', N'PHILIPS 14"', N'cái', 6)
INSERT INTO HangHoa VALUES ('MNT05', N'VIEWSONIC 14"', N'cái', 7)

--Xem bảng HangHoa
SELECT * FROM HangHoa

--Nhập bảng DoiTac
INSERT INTO DoiTac VALUES ('CC001', N'Cty TNC', N'176 BTX Q1 - TPHCM', '08.8250259')
INSERT INTO DoiTac VALUES ('CC002', N'Cty Hoàng Long', N'15A TTT Q1 – TP. HCM', '08.8250898')
INSERT INTO DoiTac VALUES ('CC003', N'Cty Hợp Nhất', N'152 BTX Q1 – TP.HCM', '08.8252376')
INSERT INTO DoiTac VALUES ('K0001', N'Nguyễn Minh Hải', N'91 Nguyễn Văn Trỗi Tp. Đà Lạt', '063.831129')
INSERT INTO DoiTac VALUES ('K0002', N'Như Quỳnh', N'21 Điện Biên Phủ. N.Trang', '058.590270')
INSERT INTO DoiTac VALUES ('K0003', N'Trần nhật Duật', N'Lê Lợi TP. Huế', '054.848376')
INSERT INTO DoiTac VALUES ('K0004', N'Phan Nguyễn Hùng Anh', N'11 Nam Kỳ Khởi nghĩa- TP. Đà lạt', '063.823409')

--Xem bảng DoiTac
SELECT * FROM DoiTac

--Nhap bang HoaDon
SET DATEFORMAT dmy
GO

INSERT INTO HoaDon VALUES('N0001', '25/01/2006', 'CC001', NULL)
INSERT INTO HoaDon VALUES('N0002', '01/05/2006', 'CC002', NULL)
INSERT INTO HoaDon VALUES('X0001', '12/05/2006', 'K0001', NULL)
INSERT INTO HoaDon VALUES('X0002', '16/06/2006', 'K0002', NULL)
INSERT INTO HoaDon VALUES('X0003', '20/04/2006', 'K0001', NULL)

--Xem bảng HoaDon
SELECT * FROM HoaDon

--Nhập bảng KhaNangCC
INSERT INTO KhaNangCC VALUES ('CC001', 'CPU01')
INSERT INTO KhaNangCC VALUES ('CC001', 'HDD03')
INSERT INTO KhaNangCC VALUES ('CC001', 'KB01')
INSERT INTO KhaNangCC VALUES ('CC001', 'MB02')
INSERT INTO KhaNangCC VALUES ('CC001', 'MB04')
INSERT INTO KhaNangCC VALUES ('CC001', 'MNT01')
INSERT INTO KhaNangCC VALUES ('CC002', 'CPU01')
INSERT INTO KhaNangCC VALUES ('CC002', 'CPU02')
INSERT INTO KhaNangCC VALUES ('CC002', 'CPU03')
INSERT INTO KhaNangCC VALUES ('CC002', 'KB02')
INSERT INTO KhaNangCC VALUES ('CC002', 'MB01')
INSERT INTO KhaNangCC VALUES ('CC002', 'MB05')
INSERT INTO KhaNangCC VALUES ('CC002', 'MNT03')
INSERT INTO KhaNangCC VALUES ('CC003', 'HDD01')
INSERT INTO KhaNangCC VALUES ('CC003', 'HDD02')
INSERT INTO KhaNangCC VALUES ('CC003', 'HDD03')
INSERT INTO KhaNangCC VALUES ('CC003', 'MB03')

--Xem bảng KhaNangCC
SELECT * FROM KhaNangCC

--Nhập bảng CT_HoaDon
INSERT INTO CT_HoaDon VALUES ('N0001', 'CPU01', 63, 10)
INSERT INTO CT_HoaDon VALUES ('N0001', 'HDD03', 97, 7)
INSERT INTO CT_HoaDon VALUES ('N0001', 'KB01', 3, 5)
INSERT INTO CT_HoaDon VALUES ('N0001', 'MB02', 57, 5)
INSERT INTO CT_HoaDon VALUES ('N0001', 'MNT01', 112, 3)
INSERT INTO CT_HoaDon VALUES ('N0002', 'CPU02', 115, 3)
INSERT INTO CT_HoaDon VALUES ('N0002', 'KB02', 5, 7)
INSERT INTO CT_HoaDon VALUES ('N0002', 'MNT03', 111, 5)
INSERT INTO CT_HoaDon VALUES ('X0001', 'CPU01', 67, 2)
INSERT INTO CT_HoaDon VALUES ('X0001', 'HDD03', 100, 2)
INSERT INTO CT_HoaDon VALUES ('X0001', 'KB01', 5, 2)
INSERT INTO CT_HoaDon VALUES ('X0001', 'MB02', 62, 1)
INSERT INTO CT_HoaDon VALUES ('X0002', 'CPU01', 67, 1)
INSERT INTO CT_HoaDon VALUES ('X0002', 'KB02', 7, 3)
INSERT INTO CT_HoaDon VALUES ('X0002', 'MNT01', 115, 2)
INSERT INTO CT_HoaDon VALUES ('X0003', 'CPU01', 67, 1)
INSERT INTO CT_HoaDon VALUES ('X0003', 'MNT03', 115, 2)

--Xem bảng CT_HoaDon
SELECT * FROM CT_HoaDon

----------------------TRUY VẤN DỮ LIỆU----------------------
--Q1: Liệt kê các mặt hàng thuộc loại đĩa cứng.
SELECT * 
FROM HangHoa
WHERE MAHH like 'HDD%'

--Q2: Liệt kê các mặt hàng có số lượng tồn trên 10.
SELECT *
FROM HangHoa
WHERE SOLUONGTON>10

--Q3: Cho biết thông tin các nhà cung cấp ở Thành phố Hồ Chí Minh
SELECT *
FROM DoiTac
WHERE DIACHI like '%HCM%'

--Q4: Liệt kê các hóa đơn nhập hàng trong tháng 5/2006, thông tin hiển thị gồm: sohd; ngaylaphd; tên, địa chỉ, và điện thoại của nhà cung cấp; số mặt hàng
SELECT A.SOHD, CONVERT(char(10),A.NGAYLAPHD,103) as NGAYLAPHD, B.TENDT, B.DIACHI, B.DIENTHOAI, COUNT(C.MAHH) AS SoMatHang
FROM HoaDon A, DoiTac B, CT_HoaDon C
WHERE A.MADT = B.MADT and A.SOHD = C.SOHD and MONTH(A.NGAYLAPHD) = 5 and YEAR(A.NGAYLAPHD) = 2006 and A.SOHD like 'N%'
GROUP BY A.SOHD, A.NGAYLAPHD, B.TENDT, B.DIACHI, B.DIENTHOAI

--Q5: Cho biết tên các nhà cung cấp có cung cấp đĩa cứng.
SELECT TENDT
FROM DoiTac
WHERE MADT IN (SELECT MADT 
			   FROM KhaNangCC 
			   WHERE MAHH LIKE 'HDD%'
			  )

--Q6: Cho biết tên các nhà cung cấp có thể cung cấp tất cả các loại đĩa cứng
SELECT A.MADT, A.TENDT
FROM DoiTac A, KhaNangCC B, HangHoa C
WHERE A.MADT=B.MADT and B.MAHH=C.MAHH and C.MAHH LIKE 'HDD%'
GROUP BY A.MADT, A.TENDT
HAVING COUNT(C.MAHH) = (SELECT COUNT(*) 
						FROM HangHoa 
						WHERE MAHH LIKE 'HDD%'
					   )

--Q7: Cho biết tên nhà cung cấp không cung cấp đĩa cứng.
SELECT *
FROM DoiTac
WHERE MADT NOT IN (SELECT MADT 
				   FROM KhaNangCC 
				   WHERE MAHH LIKE 'HDD%'
				   )

--Q8: Cho biết thông tin của mặt hàng chưa bán được.
SELECT *
FROM HangHoa A
WHERE A.MAHH NOT IN (SELECT MAHH
					 FROM CT_HoaDon
					 WHERE SOHD LIKE 'X%'
					)

--Q9: Cho biết tên và tổng số lượng bán của mặt hàng bán chạy nhất (tính theo số lượng).
SELECT A.MAHH, A.TENHH, SUM(B.SOLUONG) AS TongSoLuongBan
FROM HangHoa A, CT_HoaDon B, HoaDon C
WHERE A.MAHH = B.MAHH AND B.SOHD = C.SOHD AND C.SOHD LIKE 'X%'
GROUP BY A.MAHH, A.TENHH
HAVING SUM(B.SOLUONG) >= ALL (SELECT SUM(SOLUONG)
							  FROM CT_HoaDon
						      WHERE SOHD LIKE 'X%'
							  GROUP BY MAHH
							 )

--Q10: Cho biết tên và tổng số lượng của mặt hàng nhập về ít nhất.
SELECT A.TENHH, SUM(B.SOLUONG) AS TongSoLuongNhap
FROM HangHoa A, CT_HoaDon B, HoaDon C
WHERE A.MAHH = B.MAHH AND B.SOHD = C.SOHD AND C.SOHD LIKE 'N%'
GROUP BY A.TENHH
HAVING SUM(B.SOLUONG) <= ALL (SELECT SUM(SOLUONG)
							  FROM CT_HoaDon
							  WHERE SOHD LIKE 'N%'
							  GROUP BY MAHH
							 )

--Q11: Cho biết hóa đơn nhập nhiều mặt hàng nhất.
SELECT A.SOHD, COUNT(B.MAHH) AS SoLuongMatHang
FROM HoaDon A, CT_HoaDon B
WHERE A.SOHD = B.SOHD AND A.SOHD LIKE 'N%'
GROUP BY A.SOHD
HAVING COUNT(B.MAHH) >= ALL (SELECT COUNT(MAHH)
							 FROM CT_HoaDon
						     WHERE SOHD LIKE 'N%'
							 GROUP BY SOHD
							)

--Q12: Cho biết các mặt hàng không được nhập hàng trong tháng 1/2006.
SELECT MAHH, TENHH
FROM HangHoa
WHERE MAHH not in (SELECT B.MAHH
				   FROM HoaDon A, CT_HoaDon B
				   WHERE A.SOHD=B.SOHD and MONTH(NGAYLAPHD)=1 and YEAR(NGAYLAPHD)=2006 and A.SOHD like 'N%'
				  )

--Q13: Cho biết tên các mặt hàng không bán được trong tháng 6/2006.
SELECT MAHH, TENHH
FROM HangHoa
WHERE MAHH not in (SELECT B.MAHH
				   FROM HoaDon A, CT_HoaDon B
				   WHERE A.SOHD=B.SOHD and MONTH(NGAYLAPHD)=6 and YEAR(NGAYLAPHD)=2006 and A.SOHD like 'X%' 
				  )

--Q14: Cho biết cửa hàng bán bao nhiêu mặt hàng.
SELECT COUNT(*) AS SoLuongMatHang 
FROM HangHoa

--Q15: Cho biết số mặt hàng mà từng nhà cung cấp có khả năng cung cấp.
SELECT MADT, COUNT(MAHH) AS SoLuongMatHang
FROM KhaNangCC
GROUP BY MADT

--Q16: Cho biết thông tin của khách hàng có giao dịch với cửa hàng nhiều nhất.
SELECT A.MADT, A.TENDT, DIACHI, DIENTHOAI, COUNT(B.SOHD) as SoLuongGiaoDich
FROM DoiTac A, HoaDon B
WHERE A.MADT=B.MADT 
GROUP BY A.MADT, A.TENDT, DIACHI, DIENTHOAI
HAVING COUNT(B.SOHD) >= all (SELECT	COUNT(SOHD)
						     FROM HoaDon
							 GROUP BY MADT
							)

--Q17: Tính tổng doanh thu năm 2006.
SELECT SUM(B.DONGIA * B.SOLUONG) AS TongDoanhThu
FROM HoaDon A, CT_HoaDon B
WHERE A.SOHD = B.SOHD and B.SOHD LIKE 'X%' and YEAR(A.NGAYLAPHD) = 2006

--Q18: Cho biết loại mặt hàng bán chạy nhất.
SELECT MAHH, SUM(SOLUONG) AS TongSoLuongBan
FROM CT_HoaDon A, HoaDon B
WHERE A.SOHD = B.SOHD and B.SOHD LIKE 'X%'
GROUP BY MAHH
HAVING SUM(SOLUONG) >= all (SELECT SUM(SOLUONG) 
							FROM HoaDon C, CT_HoaDon D
							WHERE C.SOHD=D.SOHD and C.SOHD like 'X%'
                            GROUP BY MAHH
						   )

--Q19: Liệt kê thông tin bán hàng của tháng 5/2006 bao gồm: mahh, tenhh, dvt, tổng số lượng, tổng thành tiền
SELECT C.MAHH, C.TENHH, C.DVT, SUM(A.SOLUONG) as TongSoLuong, SUM(A.SOLUONG*A.DONGIA) as TongThanhTien
FROM CT_HoaDon A, HoaDon B, HangHoa C
WHERE A.SOHD = B.SOHD and A.MAHH = C.MAHH and MONTH(B.NGAYLAPHD) = 5 and YEAR(B.NGAYLAPHD) = 2006
GROUP BY C.MAHH, C.TENHH, C.DVT

--Q20: Liệt kê thông tin của mặt hàng có nhiều người mua nhất.
SELECT A.MAHH, A.TENHH, A.DVT, COUNT(B.MADT) AS SoLuongKhachMua
FROM HangHoa A, HoaDon B, CT_HoaDon C
WHERE A.MAHH = C.MAHH and B.SOHD = C.SOHD and B.SOHD LIKE 'X%'
GROUP BY A.MAHH, A.TENHH, A.DVT
HAVING COUNT(B.MADT) >= ALL (SELECT COUNT(F.MADT)
							 FROM CT_HoaDon E, HoaDon F
							 WHERE F.SOHD = E.SOHD and F.SOHD LIKE 'X%'
							 GROUP BY E.MAHH
							)

--Q21: Tính và cập nhật tổng trị giá của các hóa đơn.
SELECT SOHD, SUM(DONGIA*SOLUONG) as TongTriGia
FROM CT_HoaDon
GROUP BY SOHD

UPDATE HoaDon
SET TONGTG = (SELECT SUM(DONGIA * SOLUONG)
			  FROM CT_HoaDon A
              WHERE A.SOHD = HoaDon.SOHD
			 )

SELECT * FROM HoaDon

----------------------HÀM----------------------
--a) Tính tổng số lượng nhập trong một khoảng thời gian của một mặt hàng cho trước
CREATE FUNCTION fn_TongSoLuongNhap(@MAHH char(5), @NgayBD Datetime, @NgayKT Datetime) RETURNS INT
As
Begin
	DECLARE @TongSoLuong int

	SELECT @TongSoLuong = COALESCE(SUM(SoLuong), 0)
	FROM HoaDon A, CT_HoaDon B
	WHERE A.SOHD = B.SOHD and B.MAHH = @MAHH and A.SOHD like 'N%' and A.NGAYLAPHD between @NgayBD and @NgayKT

	RETURN @TongSoLuong
End

SET DATEFORMAT dmy
print dbo.fn_TongSoLuongNhap('CPU01', '01/01/2006', '31/12/2006')

--b) Tính tổng số lượng xuất trong một khoảng thời gian của một mặt hàng cho trước
CREATE FUNCTION fn_TongSoLuongXuat(@MAHH char(5), @NgayBD Datetime, @NgayKT Datetime) RETURNS INT
As
Begin
	DECLARE @TongSoLuong int

	SELECT @TongSoLuong = COALESCE(SUM(SoLuong), 0)
	FROM HoaDon A, CT_HoaDon B
	WHERE A.SOHD = B.SOHD and B.MAHH = @MAHH and A.SOHD like 'X%' and NGAYLAPHD between @NgayBD and @NgayKT

	RETURN @TongSoLuong
End

SET DATEFORMAT dmy
print dbo.fn_TongSoLuongXuat('CPU01', '01/01/2006', '31/12/2006')

--c) Tính tổng doanh thu trong một tháng cho trước
CREATE FUNCTION fn_TongDoanhThu1Thang(@Nam int, @Thang tinyint) RETURNS DECIMAL(18,2)
As
Begin
	DECLARE @TongDoanhThu DECIMAL(18,2)

	SELECT @TongDoanhThu = COALESCE(SUM(DONGIA*SOLUONG), 0)
	FROM HoaDon A, CT_HoaDon B
	WHERE A.SOHD = B.SOHD and A.SOHD like 'X%' and YEAR(NGAYLAPHD) = @Nam and MONTH(NGAYLAPHD) = @Thang

	RETURN @TongDoanhThu
End

print dbo.fn_TongDoanhThu1Thang(2006, 05)

--d) Tính tổng doanh thu của một mặt hàng trong một khoảng thời gian cho trước
CREATE FUNCTION fn_TongDoanhThu1MatHang(@MAHH char(5), @NgayBD Datetime, @NgayKT Datetime) RETURNS DECIMAL(18,2)
As
Begin
	DECLARE @TongDoanhThu DECIMAL(18,2)

	SELECT @TongDoanhThu = COALESCE(SUM(DONGIA*SOLUONG), 0)
	FROM HoaDon A, CT_HoaDon B
	WHERE A.SOHD = B.SOHD and B.MAHH = @MAHH and A.SOHD like 'X%' and NGAYLAPHD between @NgayBD and @NgayKT

	RETURN @TongDoanhThu
End

SET DATEFORMAT dmy
print dbo.fn_TongDoanhThu1MatHang('CPU01', '01/01/2006', '30/05/2006')

--e) Tính tổng số tiền nhập hàng trong một khoảng thời gian cho trước
CREATE FUNCTION fn_TongSoTienNhap(@NgayBD Datetime, @NgayKT Datetime) RETURNS DECIMAL(18,2)
As
Begin
	DECLARE @TongSoTienNhap DECIMAL(18,2)

	SELECT @TongSoTienNhap = COALESCE(SUM(DONGIA*SOLUONG), 0)
	FROM HoaDon A, CT_HoaDon B
	WHERE A.SOHD = B.SOHD and A.SOHD like 'N%' and NGAYLAPHD between @NgayBD and @NgayKT

	RETURN @TongSoTienNhap
End

SET DATEFORMAT dmy
print dbo.fn_TongSoTienNhap('01/01/2006', '30/05/2006')

--f) Tính tổng số tiền của một hóa đơn cho trước
CREATE FUNCTION fn_TongSoTienHoaDon(@SOHD char(5)) RETURNS DECIMAL(18,2)
As
Begin
	DECLARE @TongSoTien DECIMAL(18,2)

	SELECT @TongSoTien = COALESCE(SUM(DONGIA*SOLUONG), 0)
	FROM CT_HoaDon 
	WHERE SOHD = @SOHD

	RETURN @TongSoTien
End

print dbo.fn_TongSoTienHoaDon('N0001')

----------------------THỦ TỤC----------------------
--a) Cập nhật số lượng tồn của một mặt hàng khi nhập hàng hoặc xuất hàng
CREATE PROC usp_CapNhatSoLuongTon
	@MAHH char(5)
As
	DECLARE @SoLuongTon int, @SoLuongNhap int, @SoLuongXuat int, @TonCu int

	If exists(SELECT * FROM HangHoa WHERE MAHH = @MAHH)
		Begin
			SELECT @SoLuongNhap = COALESCE(SUM(SOLUONG), 0 )
			FROM CT_HoaDon
			WHERE SOHD like 'N%' and MAHH = @MAHH

			SELECT @SoLuongXuat = COALESCE(SUM(SOLUONG), 0)
			FROM CT_HoaDon
			WHERE SOHD like 'X%' and MAHH = @MAHH

			SET @SoLuongTon = @SoLuongNhap - @SoLuongXuat

			SELECT @TonCu = SOLUONGTON
			FROM HangHoa 
			WHERE MAHH = @MAHH

			UPDATE HangHoa
			SET SOLUONGTON = @SoLuongTon + @TonCu
			WHERE MAHH = @MAHH

			print N'Cập nhật thành công mã hàng: ' +@MAHH
		End
	Else
		print N'Không có mặt hàng ' +@MAHH+ N' được nhập hay xuất'
go

exec usp_CapNhatSoLuongTon 'CPU02'

SELECT * FROM HangHoa

--b) Cập nhật tổng giá trị của một hóa đơn
CREATE PROC usp_CapNhatTongGiaTriHoaDon
	@SOHD char(5)
As
	DECLARE @TongGiaTri DECIMAL(18, 2)

	If exists(SELECT * FROM HoaDon WHERE SOHD = @SOHD)
		Begin
			SELECT @TongGiaTri = COALESCE(SUM(SOLUONG*DONGIA), 0)
			FROM CT_HoaDon
			WHERE SOHD = @SOHD

			UPDATE HoaDon
			SET TONGTG = @TongGiaTri
			WHERE SOHD = @SOHD

			print N'Cập nhật tổng giá trị hóa đơn thành công: ' +@SOHD
		End
	Else
		print N'Không tìm tháy hóa đơn: ' +@SOHD
go

exec usp_CapNhatTongGiaTriHoaDon 'N0002'

SELECT * FROM HoaDon

--c) In đầy đủ thông tin của một hóa đơn
CREATE PROCEDURE usp_InThongTinHoaDon
    @SOHD char(5)
AS
    If exists(SELECT * FROM HoaDon WHERE SOHD = @SOHD)
		Begin
			print N'===== THÔNG TIN HÓA ĐƠN =====';
 
			SELECT SOHD as [Mã hóa đơn], NGAYLAPHD as [Ngày lập hóa đơn], MADT as [Mã đối tác], TONGTG as [Tổng tiền]
			FROM HoaDon
			WHERE SOHD = @SOHD

			print N'===== CHI TIẾT HÓA ĐƠN =====';

			SELECT A.MAHH as [Mã hàng hóa], B.TENHH as [Tên hàng hóa], A.SOLUONG as [Số lượng], A.DONGIA as [Đơn giá], (A.SOLUONG * A.DONGIA) as [Thành tiền]
			FROM CT_HoaDon A, HangHoa B
			WHERE A.MAHH = B.MAHH and A.SOHD = @SOHD

			print N'===== KẾT THÚC HÓA ĐƠN =====';
		End
    Else
        print N'Không tìm thấy hóa đơn: ' + @SOHD;
go

exec usp_InThongTinHoaDon 'N0001'