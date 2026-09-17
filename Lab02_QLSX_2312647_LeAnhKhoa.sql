/*--------------------------------------------
	Học phần: Cơ sở dữ liệu
	Họ và tên sinh viên: Lê Anh Khoa
	Mã số sinh viên: 2312647
	Lớp: CTK47A
	Ngày thực hiện: 18/02/2025 - 23/03/2025
--------------------------------------------*/

--Lệnh tạo CSDL
CREATE DATABASE Lab02_QuanLySanXuat
GO

--Lệnh sử dụng CSDL
USE Lab02_QuanLySanXuat
GO

--Lệnh tạo các bảng
CREATE TABLE ToSanXuat
(
	MaTSX char(4) PRIMARY KEY,
	TenTSX nvarchar(10) not null unique
)
GO

CREATE TABLE CongNhan
(
	MACN char(5) PRIMARY KEY,
	Ho nvarchar(20) not null,
	Ten nvarchar(10) not null,
	Phai nvarchar(5) not null,
	NgaySinh datetime,
	MaTSX char(4) references ToSanXuat(MaTSX)
)
GO

CREATE TABLE SanPham
(
	MASP char(5) PRIMARY KEY,
	TenSP nvarchar(30) not null unique,
	DVT nvarchar(10),
	TienCong int CHECK(TienCong>0)
)
GO

CREATE TABLE ThanhPham
(
	MACN char(5) references CongNhan(MACN),
	MASP char(5) references SanPham(MASP),
    Ngay datetime,
    SoLuong int CHECK (SoLuong > 0),
    PRIMARY KEY (MACN, MaSP, Ngay)
)
GO

--Xem các bảng
SELECT * FROM ToSanXuat
SELECT * FROM CongNhan
SELECT * FROM SanPham
SELECT * FROM ThanhPham

--Nhập dữ liệu cho các bảng
--Nhập bảng ToSanXuat
INSERT INTO ToSanXuat values('TS01', N'Tổ 1')
INSERT INTO ToSanXuat values('TS02', N'Tổ 2')

--Xem bảng ToSanXuat
SELECT * FROM ToSanXuat

--Nhập bảng CongNhan
SET DATEFORMAT dmy
GO

INSERT INTO CongNhan values('CN001', N'Nguyễn Trường', N'An', N'Nam', '12/05/1981', 'TS01')
INSERT INTO CongNhan values('CN002', N'Lê Thị Hồng', N'Gấm', N'Nữ', '04/06/1980', 'TS01')
INSERT INTO CongNhan values('CN003', N'Nguyễn Công', N'Thành', N'Nam', '04/05/1981', 'TS02')
INSERT INTO CongNhan values('CN004', N'Võ Hữu', N'Hạnh', N'Nam', '15/02/1980', 'TS02')
INSERT INTO CongNhan values('CN005', N'Lý Thanh', N'Hân', N'Nữ', '03/12/1981', 'TS01')

--Xem bảng CongNhan
SELECT * FROM CongNhan

--Nhập bảng SanPham
INSERT INTO SanPham values ('SP001', N'Nồi đất', N'cái', 10000)
INSERT INTO SanPham values ('SP002', N'Chén', N'cái', 2000)
INSERT INTO SanPham values ('SP003', N'Bình gốm nhỏ', N'cái', 20000)
INSERT INTO SanPham values ('SP004', N'Bình gốm lớn', N'cái', 25000)

--Xem bảng SanPham
SELECT * FROM SanPham

--Nhập bảng ThanhPham
SET DATEFORMAT dmy
GO

INSERT INTO ThanhPham values('CN001', 'SP001', '01/02/2007', 10)
INSERT INTO ThanhPham values('CN002', 'SP001', '01/02/2007', 5)
INSERT INTO ThanhPham values('CN003', 'SP002', '10/01/2007', 50)
INSERT INTO ThanhPham values('CN004', 'SP003', '12/01/2007', 10)
INSERT INTO ThanhPham values('CN005', 'SP002', '12/01/2007', 100)
INSERT INTO ThanhPham values('CN002', 'SP004', '13/02/2007', 10)
INSERT INTO ThanhPham values('CN001', 'SP003', '14/02/2007', 15)
INSERT INTO ThanhPham values('CN003', 'SP001', '15/01/2007', 20)
INSERT INTO ThanhPham values('CN003', 'SP004', '14/02/2007', 15)
INSERT INTO ThanhPham values('CN004', 'SP002', '30/01/2007', 100)
INSERT INTO ThanhPham values('CN005', 'SP003', '01/02/2007', 50)
INSERT INTO ThanhPham values('CN001', 'SP001', '20/02/2007', 30) 

--Xem bảng ThanhPham
SELECT * FROM ThanhPham

----------------------TRUY VẤN DỮ LIỆU----------------------
--Q1: Liệt kê các công nhân theo tổ sản xuất gồm các thông tin: TenTSX, HoTen, NgaySinh, Phai (xếp thứ tự tăng dần của tên tổ sản xuất, Tên của công nhân).
SELECT TenTSX, Ho + ' ' + Ten as HoTen, CONVERT(char(10), NgaySinh, 103) as NgaySinh, Phai
FROM ToSanXuat, CongNhan
WHERE ToSanXuat.MaTSX=CongNhan.MaTSX
ORDER BY TenTSX, Ten

--Q2: Liệt kê các thành phẩm mà công nhân ‘Nguyễn Trường An’ đã làm được gồm các thông tin: TenSP, Ngay, SoLuong, ThanhTien (xếp theo thứ tự tăng dần của ngày).
SELECT TenSP, CONVERT(char(10), Ngay, 103) as Ngay, SoLuong, SoLuong*TienCong as ThanhTien
FROM SanPham A, ThanhPham B, CongNhan C
WHERE A.MASP=B.MASP and B.MACN=C.MACN and Ho + ' ' + Ten=N'Nguyễn Trường An'
ORDER BY Ngay

--Q3: Liệt kê các công nhân không sản xuất sản phẩm 'Bình gốm lớn'
SELECT *
FROM CongNhan B
WHERE B.MACN not in (SELECT F.MACN
					 FROM SanPham E, ThanhPham F
					 WHERE	E.MASP = F.MASP and TenSP = N'Bình gốm lớn'
					)

--Q4: Liệt kê thông tin các công nhân có sản xuất cả ‘Nồi đất’ và ‘Bình gốm nhỏ’
SELECT DISTINCT Ho+ ' ' +Ten as HoTen, CONVERT(char(10), NgaySinh, 103) as NgaySinh, Phai
FROM CongNhan A, ThanhPham B, SanPham C
WHERE A.MACN=B.MACN and B.MASP=C.MASP and C.TenSP=N'Nồi đất'
	  and A.MACN in(SELECT E.MACN
				    FROM ThanhPham E, SanPham F
					WHERE E.MASP=F.MASP and F.TenSP=N'Bình gốm nhỏ'
				   )

--Q5: Thống kê Số lượng công nhân theo từng tổ sản xuất
SELECT TenTSX, COUNT(MACN) as SoCongNhan
FROM CongNhan A, ToSanXuat B
WHERE A.MaTSX=B.MaTSX
GROUP BY TenTSX

--Q6. Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được (Ho, Ten, TenSP, TongSLThanhPham, TongThanhTien).
SELECT Ho + ' ' + Ten as HoTen, TenSP, SUM(SoLuong) as TongSLThanhPham, SUM(SoLuong*TienCong) as TongThanhTien
FROM SanPham A, ThanhPham B, CongNhan C
WHERE A.MASP=B.MASP and B.MACN=C.MaCN
GROUP BY Ho+' '+Ten, TenSP
ORDER BY Ho+' '+Ten, TenSP

--Q7. Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007
SELECT SUM(SoLuong*TienCong) as TongTienCong
FROM SanPham A, ThanhPham B
WHERE A.MASP=B.MASP and MONTH(Ngay)=1 and YEAR(Ngay)=2007

--Q8. Cho biết sản phẩm được sản xuất nhiều nhất trong tháng 2/2007
SELECT TenSP, SUM(SoLuong) as TongSoLuong
FROM SanPham A, ThanhPham B
WHERE A.MASP = B.MASP AND MONTH(Ngay) = 2 AND YEAR(Ngay) = 2007
GROUP BY TenSP
HAVING SUM(SoLuong) >= ALL (SELECT SUM(SoLuong)
							FROM ThanhPham
							WHERE MONTH(Ngay) = 2 AND YEAR(Ngay) = 2007
							GROUP BY MaSP
						   )

--Q9. Cho biết công nhân sản xuất được nhiều ‘Chén’ nhất.
SELECT B.MACN, Ho + ' ' + Ten as HoTen, B.MaTSX, TenSP, SoLuong
FROM CongNhan B, ThanhPham C, SanPham D
WHERE B.MACN=C.MACN and C.MASP=D.MASP and D.TenSP=N'Chén'
      and SoLuong = (SELECT MAX(E.SoLuong)
                     FROM ThanhPham E, SanPham F
                     WHERE E.MASP=F.MASP and F.TenSP=N'Chén'
                    )

--Q10: Tiền công tháng 2/2007 của công nhân viên có mã số ‘CN002’
SELECT SUM(TienCong*SoLuong) as TongTienCongThang2
FROM SanPham A, ThanhPham B
WHERE A.MASP=B.MASP and B.MACN='CN002' and MONTH(Ngay)=2 and YEAR(Ngay)=2007

--Q11: Liệt kê các công nhân có sản phẩm từ 3 loại sản phẩm trở lên
SELECT Ho + ' ' + Ten as HoTen, COUNT(MASP) as SoLoaiSanPham
FROM CongNhan A, ThanhPham B
WHERE A.MACN=B.MACN 
GROUP BY Ho, Ten
HAVING COUNT(MASP) >= 3

--Q12: Cập nhật giá tiền công của các loại bình gốm thêm 1000.
UPDATE SanPham
SET TienCong=TienCong+1000
WHERE TenSP like N'Bình gốm%'

--Q13: Thêm bộ <’CN006’, ‘Lê Thị’, ‘Lan’, ‘Nữ’,’TS02’ > vào bảng CongNhan.
SET DATEFORMAT dmy
INSERT INTO CongNhan VALUES ('CN006', N'Lê Thị', N'Lan', N'Nữ', '12/07/1981', 'TS02')

----------------------HÀM----------------------
--a) Tính tổng số công nhân của một tổ sản xuất cho trước
CREATE FUNCTION fn_TongSoCongNhan(@MaTSX char(4)) RETURNS INT
As
Begin
    DECLARE @TongSo INT

    SELECT @TongSo = COUNT(*)
    FROM CongNhan
    WHERE MaTSX = @MaTSX

    RETURN @TongSo
End

print dbo.fn_TongSoCongNhan('TS01')

--b) Tính tổng sản lượng sản xuất trong một tháng của một loại sản phẩm cho trước
CREATE FUNCTION fn_TongSanLuong(@MaSP CHAR(5), @Thang INT, @Nam INT) RETURNS INT
As
Begin
    DECLARE @TongSanLuong int

    SELECT @TongSanLuong = COALESCE(SUM(SoLuong), 0)
    FROM ThanhPham
    WHERE MASP = @MaSP and MONTH(Ngay) = @Thang AND YEAR(Ngay) = @Nam

    RETURN @TongSanLuong
End

print dbo.fn_TongSanLuong('SP001', 2, 2007)

--c) Tính tổng tiền công tháng của một công nhân cho trước
CREATE FUNCTION TinhTongTienCongThang(@MaCN char(5), @Thang int, @Nam int) RETURNS INT
As
Begin
    DECLARE @TongTienCong int

    SELECT @TongTienCong = COALESCE(SUM(TienCong * SoLuong), 0)
    FROM SanPham A, ThanhPham B
    WHERE A.MASP = B.MASP and B.MACN = @MaCN and MONTH(Ngay) = @Thang and YEAR(Ngay) = @Nam

    RETURN @TongTienCong
End

print dbo.TinhTongTienCongThang('CN002', 2, 2007)

--d) Tính tổng thu nhập trong năm của một tổ sản xuất cho trước
CREATE FUNCTION TinhTongThuNhapToSX(@MaTSX char(4), @Nam int) RETURNS INT
As
Begin
    DECLARE @TongThuNhap int

    SELECT @TongThuNhap = COALESCE(SUM(TienCong * SoLuong), 0)
    FROM CongNhan A, ThanhPham B, SanPham C
    WHERE A.MACN = B.MACN and B.MASP = C.MASP and A.MaTSX = @MaTSX and YEAR(Ngay) = @Nam;

    RETURN @TongThuNhap;
End

print dbo.TinhTongThuNhapToSX('TS01', 2007)

--e) Tính tổng sản lượng sản xuất của một loại sản phẩm trong một khoảng thời gian cho trước
CREATE FUNCTION TinhTongSanLuongSP(@MaSP char(5), @NgayBatDau Datetime, @NgayKetThuc Datetime) RETURNS INT
As
Begin
    DECLARE @TongSanLuong INT

    SELECT @TongSanLuong = COALESCE(SUM(SoLuong), 0)
    FROM ThanhPham
    WHERE MASP = @MaSP and Ngay between @NgayBatDau and @NgayKetThuc

    RETURN @TongSanLuong
End

SET DATEFORMAT dmy
print dbo.TinhTongSanLuongSP('SP001', '01/01/2007', '31/12/2007')

----------------------THỦ TỤC----------------------
--a) In danh sách các công nhân của một tổ sản xuất cho trước.
CREATE PROC InDanhSachCongNhan
	@MaTSX char(4)
As
	If exists(SELECT * FROM ToSanXuat WHERE MaTSX = @MaTSX)
		SELECT * FROM CongNhan WHERE MaTSX = @MaTSX
	Else
		print N'Không có tổ sản xuất ' +@MaTSX+ N' trong CSDL!'
go

exec InDanhSachCongNhan 'TS01'

--b) In bảng chấm công sản xuất trong tháng của một công nhân cho trước (bao gồm Tên sản phẩm, đơn vị tính, số lượng sản xuất trong tháng, đơn giá, thành tiền).
CREATE PROC InBangChamCongSanXuat
    @MACN char(5), @Thang tinyint, @Nam int
As
    If exists(SELECT * FROM CongNhan WHERE MACN = @MACN)
		SELECT TenSP, DVT, SoLuong, TienCong, (SoLuong * TienCong) AS ThanhTien
		FROM ThanhPham A, SanPham B
		WHERE A.MASP = B.MASP and A.MACN = @MACN and MONTH(Ngay) = @Thang and YEAR(Ngay) = @Nam
	Else
		print N'Không có công nhân mã ' + @MACN + N' trong CSDL!'
go

exec InBangChamCongSanXuat 'CN001', 2, 2007

