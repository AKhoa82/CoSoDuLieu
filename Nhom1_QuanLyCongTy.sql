CREATE DATABASE QuanLyCongTy
go

USE QuanLyCongTy
go

CREATE TABLE PhongBan
(
	MaPhongBan char(6) PRIMARY KEY,
	TenPhongBan nvarchar(30) not null unique
)
GO

CREATE TABLE NhanVien
(
	MaNV char(5) PRIMARY KEY,
	Ho nvarchar(30) not null,
	Ten nvarchar(10) not null, 
	DiaChi nvarchar(100) not null,
	NgaySinh Date,
	NgayVaoCongTac Date not null,
	LuongCoBan int not null,
	MaPhongBan char(6) REFERENCES PhongBan(MaPhongBan)
)
GO

CREATE TABLE ChuyenMon
(
	MaCM char(5) PRIMARY KEY,
	TenCM nvarchar(20) not null unique
)
GO

CREATE TABLE NhanVien_ChuyenMon
(
	MaNV char(5) REFERENCES NhanVien(MaNV),
	MaCM char (5) REFERENCES ChuyenMon(MaCM),
	VanBang nvarchar(10) not null,
	NgayNhan Date not null,
	PRIMARY KEY (MaNV, MaCM)
)
GO

CREATE TABLE NhanVienTruongPhong
(
	MaPhongBan char(6) REFERENCES PhongBan(MaPhongBan),
	MaNV char(5) REFERENCES NhanVien(MaNV),
	NgayBoNhiem Date not null,
	PRIMARY KEY(MaPhongBan, MaNV)
)
GO

CREATE TABLE DuAn
(
	MaDA char(5) PRIMARY KEY,
	TenDA nvarchar(15) not null unique,
	NgayKy Date not null,
	DiaChiDA nvarchar(50) not null,
	GiaTri int not null,
	MaPhongBan char(6) REFERENCES PhongBan(MaPhongBan)
)
GO

CREATE TABLE VatTu
(
	MaVatTu char(5) PRIMARY KEY,
	TenVatTu nvarchar(10) not null unique
)
GO

CREATE TABLE DuAnVatTu
(
	MaDA char(5) REFERENCES DuAn(MaDA),
	MaVatTu char(5) REFERENCES VatTu(MaVatTu),
	SoLuong tinyint,
	PRIMARY KEY(MaDA, MaVatTu)
)
GO

CREATE TABLE NhanVienDuAn
(
	MaNV char(5) REFERENCES NhanVien(MaNV),
	MaDA char(5) REFERENCES DuAn(MaDA),
	LuongDA int not null,
	PRIMARY KEY(MaNV, MaDA)
)
GO

CREATE TABLE NhaCungCap
(
	MaNCC char(5) PRIMARY KEY,
	TenNCC nvarchar(50) not null unique,
	SoDienThoai varchar(10) not null unique
)
GO

CREATE TABLE KhaNangCC
(
	MaNCC char(5) REFERENCES NhaCungCap(MaNCC),
	MaVatTu char(5) REFERENCES VatTu(MaVatTu),
	GiaBan int not null,
	PRIMARY KEY(MaNCC, MaVatTu)
)
GO

CREATE TABLE PhieuChi
(
	MaPhieuChi char(5) PRIMARY KEY,
	NgayChi Date not null,
	SoTien int not null,
	MaNCC char(5) REFERENCES NhaCungCap(MaNCC),
	MaDA char(5) REFERENCES DuAn(MaDA)
)
GO

CREATE TABLE ChiTietPhieuChi
(
    MaPhieuChi char(5) REFERENCES PhieuChi(MaPhieuChi),
    MaVatTu char(5) REFERENCES VatTu(MaVatTu),
    SoLuong int not null,
    DonGia int not null,
    PRIMARY KEY (MaPhieuChi, MaVatTu)
)

SELECT * FROM PhongBan
SELECT * FROM NhanVien
SELECT * FROM ChuyenMon
SELECT * FROM NhanVien_ChuyenMon
SELECT * FROM NhanVienTruongPhong
SELECT * FROM DuAn
SELECT * FROM VatTu
SELECT * FROM NhaCungCap
SELECT * FROM KhaNangCC
SELECT * FROM PhieuChi
SELECT * FROM DuAnVatTu
SELECT * FROM NhanVienDuAn

SP_MSforeachtable 'select * from?' 
----------------------------------------------------------
--Kiểm tra mỗi phòng ban ít nhất 4 nhân viên
ALTER TRIGGER trg_KiemTraSoLuongNV
On NhanVien for delete, update
As
	 If exists(SELECT MaPhongBan
			   FROM NhanVien
			   GROUP BY MaPhongBan
			   HAVING COUNT(*) < 4
			  )
	Begin
        raiserror (N'Không thể thực hiện thao tác! Mỗi phòng ban phải có ít nhất 4 nhân viên.',16,1)
        rollback tran
    End
go

--Đảm bảo mỗi phòng ban có đúng một trưởng phòng
CREATE TRIGGER trg_KiemTraTruongPhong
On NhanVienTruongPhong for insert, update
As
    If exists(SELECT MaPhongBan
			  FROM NhanVienTruongPhong
			  GROUP BY MaPhongBan
			  HAVING COUNT(*) > 1
			 )
    Begin
        raiserror (N'Mỗi phòng ban chỉ được có đúng một trưởng phòng.', 16, 1);
        rollback tran
    End
go

--Đảm bảo trưởng phòng thuộc phòng ban
CREATE TRIGGER trg_KiemTraTruongPhongThuocPhongBan
on NhanVienTruongPhong for insert, update
As
    If exists(SELECT i.MaNV
			  FROM inserted i, NhanVien n
			  WHERE i.MaNV = n.MaNV and i.MaPhongBan <> n.MaPhongBan
			 )
    Begin
        raiserror (N'Trưởng phòng phải thuộc đúng phòng ban.', 16, 1)
        rollback tran
    End
go

--Kiểm tra ngày nhận chuyên môn không lớn hơn ngày hiện tại
CREATE TRIGGER trg_KiemTraNgayNhanChuyenMon
on NhanVien_ChuyenMon for insert, update
As
    If exists(SELECT *
			  FROM inserted 
			  WHERE NgayNhan > GETDATE()
			 )
    Begin
        raiserror (N'Không thể nhập ngày nhận chuyên môn lớn hơn ngày hiện tại.', 16, 1);
        rollback tran
    End
go

--Đảm bảo một dự án có ít nhất một nhân viên tham gia
CREATE TRIGGER trg_KiemTraNhanVienDuAn
On NhanVienDuAn For DELETE, UPDATE
As
    DECLARE @count int
    SELECT @count = COUNT(*)
    FROM DuAn A, NhanVienDuAn B
	WHERE A.MaDA = B.MaDA
    GROUP BY A.MaDA
    HAVING COUNT(B.MaNV) = 0

    If @count > 0
    Begin
        raiserror (N'Không thể thực hiện thao tác! Mỗi dự án phải có ít nhất một nhân viên tham gia.', 16, 1)
        rollback tran
    End
go

--Một dự án chỉ do một phòng ban duy nhất phụ trách
CREATE TRIGGER trg_KiemTraPhongBan_DuAn
On DuAn For INSERT, UPDATE
As
    If exists(SELECT MaDA
			  FROM DuAn
			  GROUP BY MaDA
			  HAVING COUNT(MaPhongBan) > 1
			 )
    Begin
        raiserror (N'Không thể thực hiện thao tác! Mỗi dự án chỉ được phụ trách bởi một phòng ban.', 16, 1);
        rollback tran
    end
go

--Kiểm tra mỗi phiếu cho chỉ liên quan đến một dự án
CREATE TRIGGER trg_KiemTraPhieu_DuAn
On PhieuChi For INSERT, UPDATE
As
    If exists(SELECT MaPhieuChi
			  FROM PhieuChi
			  GROUP BY MaPhieuChi
			  HAVING COUNT(MaDA) > 1
			 )
    Begin
        raiserror (N'Không thể thực hiện thao tác! Mỗi phiếu chỉ được liên kết với một dự án.', 16, 1);
        rollback tran
    end
go

--Kiểm tra ngày bổ nhiệm phải sau ngày vào công ty
CREATE TRIGGER trg_KiemTraNgayBoNhiem
On NhanVienTruongPhong For Insert
As
    If exists(SELECT *
			  FROM inserted i, NhanVien nv
			  WHERE i.MaNV = nv.MaNV and i.NgayBoNhiem <= nv.NgayVaoCongTac
			 )
    Begin
        raiserror (N'Ngày bổ nhiệm phải sau ngày vào công tác của nhân viên.', 16, 1)
        rollback tran
    END
go

--Kiểm tra tổng số lượng vật tư mua không vượt quá nhu cầu
CREATE TRIGGER trg_KiemTraSoLuongMua
On ChiTietPhieuChi For Insert, Update
As
    Declare @MaPhieuChi char(5), @MaVatTu char(5), @SoLuongMoi int, @MaDA char(5), @TongSoLuong int, @SoLuongNhuCau int

    SELECT @MaPhieuChi = MaPhieuChi, @MaVatTu = MaVatTu, @SoLuongMoi = SoLuong FROM inserted

    SELECT @MaDA = MaDA FROM PhieuChi WHERE MaPhieuChi = @MaPhieuChi

    SELECT @TongSoLuong = ISNULL(SUM(SoLuong), 0)
    FROM ChiTietPhieuChi
    WHERE MaVatTu = @MaVatTu and MaPhieuChi != @MaPhieuChi and MaPhieuChi in (SELECT MaPhieuChi 
																			  FROM PhieuChi 
																			  WHERE MaDA = @MaDA
																			 )

    SET @TongSoLuong = @TongSoLuong + @SoLuongMoi

    SELECT @SoLuongNhuCau = SoLuong
    FROM DuAnVatTu
    WHERE MaDA = @MaDA and MaVatTu = @MaVatTu

    If @TongSoLuong > @SoLuongNhuCau
    Begin
        raiserror (N'Tổng số lượng vật tư chi vượt quá nhu cầu đã đăng ký trong dự án.', 16, 1)
        rollback tran
    End
go

--Thêm phòng ban
CREATE PROC usp_ThemPhongBan
	@MaPhongBan char(6), @TenPhongBan nvarchar(20)
As
	If exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
		print N'Đã có phòng ban có mã ' +@MaPhongBan + N' trong CSDL!'
	Else
		Begin
			Insert into PhongBan values(@MaPhongBan, @TenPhongBan)
			print N'Thêm phòng ban thành công.'
		End
go

exec usp_ThemPhongBan 'P20015', N'Phòng Nhân Sự'
exec usp_ThemPhongBan 'P20020', N'Phòng Truyền Thông'
exec usp_ThemPhongBan 'P20025', N'Phòng Kinh Doanh'
exec usp_ThemPhongBan 'P20030', N'Phòng Tài Chính'
exec usp_ThemPhongBan 'P20035', N'Phòng Kỹ Thuật'
----------------------------------------------------------
CREATE PROC usp_ThemNhanVien
	@MaNV char(5), @Ho nvarchar(30), @Ten nvarchar(10), @DiaChi nvarchar(100),
	@NgaySinh Date, @NgayVaoCongTac Date, @LuongCoBan int, @MaPhongBan char(6)
As
	If exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
		Begin
			If exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV)
				print N'Đã có nhân viên có mã ' +@MaNV+ N'trong CSDL!'
			Else
				Begin
					Insert into NhanVien values(@MaNV, @Ho, @Ten, @DiaChi, @NgaySinh, @NgayVaoCongTac, @LuongCoBan, @MaPhongBan)
					print N'Thêm nhân viên thành công.'
				End
		End
	Else
		print N'Không có phòng ban có mã '+@MaPhongBan+' trong CSDL nên không thêm được nhân viên.'
go

set dateformat dmy
exec usp_ThemNhanVien 'NV001', N'Thanh Chí', N'Dũng', N'19/1 Phạm Ngũ Lão', '07/03/2000' , '05/06/2020', 6000000, 'P20025'
exec usp_ThemNhanVien 'NV002', N'Văn An', N'Thái', N'23/4 Lê Lợi', '15/08/1995', '10/02/2018', 7500000, 'P20030'
exec usp_ThemNhanVien 'NV003', N'Minh Hải', N'Trung', N'45 Nguyễn Trãi', '22/11/1998', '12/07/2019', 6800000, 'P20030'
exec usp_ThemNhanVien 'NV004', N'Thị Lan', N'Ngọc', N'78/6 Trần Hưng Đạo', '05/05/1997', '01/03/2021', 7200000, 'P20015'
exec usp_ThemNhanVien 'NV005', N'Văn Bình', N'Hoàng', N'90 Hai Bà Trưng', '30/09/2001', '18/09/2023', 5500000, 'P20015'
exec usp_ThemNhanVien 'NV006', N'Thị Hằng', N'Nhung', N'102 Nguyễn Văn Cừ', '14/06/1996', '05/12/2017', 8000000, 'P20035'
exec usp_ThemNhanVien 'NV007', N'Văn Sơn', N'Quang', N'28/3 Lý Tự Trọng', '25/03/2000', '11/05/2020', 6000000, 'P20025'
exec usp_ThemNhanVien 'NV008', N'Minh Đức', N'Anh', N'67 Bùi Thị Xuân', '19/07/1999', '09/11/2019', 6900000, 'P20015'
exec usp_ThemNhanVien 'NV009', N'Thị Thu', N'Hòa', N'35 Hoàng Diệu', '02/12/1994', '22/08/2016', 8500000, 'P20020'
exec usp_ThemNhanVien 'NV010', N'Văn Trường', N'Phát', N'123/5 Nguyễn Huệ', '10/10/1993', '15/06/2015', 9000000, 'P20025'
exec usp_ThemNhanVien 'NV011', N'Thị Nguyệt', N'Phương', N'11/2 Lê Quý Đôn', '06/01/2002', '01/07/2023', 5800000, 'P20020'
exec usp_ThemNhanVien 'NV012', N'Văn Hoàng', N'Tuấn', N'56/8 Nguyễn Đình Chiểu', '12/04/1997', '20/10/2018', 7200000, 'P20030'
exec usp_ThemNhanVien 'NV013', N'Thị Mai', N'Hương', N'22/3 Trần Cao Vân', '08/09/1995', '05/05/2017', 7800000, 'P20030'
exec usp_ThemNhanVien 'NV014', N'Văn Hậu', N'Thắng', N'77/9 Võ Thị Sáu', '27/02/2000', '15/08/2020', 6400000, 'P20025'
exec usp_ThemNhanVien 'NV015', N'Thị Linh', N'Chi', N'19/5 Phan Đình Phùng', '03/07/1996', '22/04/2019', 7000000, 'P20020'
exec usp_ThemNhanVien 'NV016', N'Văn Khải', N'Nguyên', N'101 Trường Chinh', '21/11/1999', '11/11/2021', 6200000, 'P20035'
exec usp_ThemNhanVien 'NV017', N'Minh Hiếu', N'Khoa', N'12/4 Tôn Đức Thắng', '05/05/2001', '01/09/2022', 5700000, 'P20035'
exec usp_ThemNhanVien 'NV018', N'Thị Yến', N'Vy', N'88 Nguyễn Văn Linh', '30/03/1994', '18/06/2016', 8200000, 'P20015'
exec usp_ThemNhanVien 'NV019', N'Văn Phúc', N'Long', N'65/7 Pasteur', '14/12/1998', '07/07/2020', 6600000, 'P20020'
exec usp_ThemNhanVien 'NV020', N'Thị Kim', N'Oanh', N'45/3 Điện Biên Phủ', '09/01/2002', '23/03/2023', 5900000, 'P20035'
----------------------------------------------------------
CREATE PROC usp_ThemChuyenMon
	@MaCM char(5), @TenCM nvarchar(20)
As
	If exists(SELECT * FROM ChuyenMon WHERE MaCM = @MaCM)
		print N'Đã có chuyên môn có mã ' +@MaCM + N' trong CSDL!'
	Else
		Begin
			Insert into ChuyenMon values(@MaCM, @TenCM)
			print N'Thêm chuyên môn thành công.'
		End
GO

exec usp_ThemChuyenMon 'CM001', N'Tiếp thị'
exec usp_ThemChuyenMon 'CM002', N'Bán hàng'
exec usp_ThemChuyenMon 'CM003', N'Marketing'
exec usp_ThemChuyenMon 'CM004', N'Tư vấn'
exec usp_ThemChuyenMon 'CM005', N'Quản lý nhân sự'
----------------------------------------------------------
CREATE PROC usp_ThemNhanVienChuyenMon
	@MaNV char(5), @MaCM char(5), @VanBang nvarchar(10), @NgayNhan Date
As
	If exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV) and exists(SELECT * FROM ChuyenMon WHERE MaCM = @MaCM)
		Begin
			Insert into NhanVien_ChuyenMon values(@MaNV, @MaCM, @VanBang, @NgayNhan)
			print N'Thêm nhân viên chuyên môn thành công.'
		End
	Else
		If not exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV)
			print N'Không có nhân viên có mã ' +@MaNV+ N' trong CSDL'
		If not exists(SELECT * FROM ChuyenMon WHERE MaCM = @MaCM)
			print N'Không có chuyên môn có mã ' +@MaCM+ N' trong CSDL'
go

set dateformat dmy
exec usp_ThemNhanVienChuyenMon 'NV001', 'CM001', N'Đại Học', '06/12/2020'
exec usp_ThemNhanVienChuyenMon 'NV002', 'CM002', N'IELTS', '07/10/2022'
exec usp_ThemNhanVienChuyenMon 'NV003', 'CM002', N'Quốc Tế', '08/02/2020'
exec usp_ThemNhanVienChuyenMon 'NV004', 'CM004', N'Cao Đẳng', '12/05/2019'
exec usp_ThemNhanVienChuyenMon 'NV005', 'CM003', N'QLý', '03/10/2021'

select * from NhanVien_ChuyenMon

CREATE PROC usp_ThemTruongPhong
@MaPhongBan char(6), @MaNV char(5), @NgayBoNhiem Date
As
	If exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV) and exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
		Begin
			Insert into NhanVienTruongPhong values(@MaPhongBan, @MaNV, @NgayBoNhiem)
			print N'Thêm trưởng phòng thành công.'
		End
	Else
		If not exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV)
			print N'Không có nhân viên có mã ' +@MaNV+ N' trong CSDL'
		If not exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
			print N'Không có chuyên môn có mã ' +@MaPhongBan+ N' trong CSDL'
go

set dateformat dmy
exec usp_ThemTruongPhong 'P20015', 'NV004', '12/12/2022'
exec usp_ThemTruongPhong 'P20020', 'NV009', '1/5/2021'
exec usp_ThemTruongPhong 'P20030', 'NV003', '8/4/2022'
exec usp_ThemTruongPhong 'P20025', 'NV007', '9/6/2020'
exec usp_ThemTruongPhong 'P20035', 'NV016', '15/1/2022'

CREATE PROC usp_ThemDuAn
	@MaDA char(5), @TenDA nvarchar(15), @NgayKy Date,
	@DiaChiDA nvarchar(50), @GiaTri int, @MaPhongBan char(6)
As
	If exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
		Begin
			If exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
				print N'Đã có dự án có mã ' +@MaDA+ N' trong CSDL!'
			Else
				Begin
					Insert into DuAn values(@MaDA, @TenDA, @NgayKy, @DiaChiDA, @GiaTri, @MaPhongBan)
					print N'Thêm dự án thành công'
				End
		End
	Else
		print N'Không có phòng ban nào có mã '+@MaPhongBan+' trong CSDL!'
go

set dateformat dmy
exec usp_ThemDuAn 'S0001', N'Tháp viễn thông', '09/11/2022', N'TP.HCM', '500000', 'P20035'
exec usp_ThemDuAn 'S0002', N'Tòa Nhà Quốc Hội', '11/05/2020', N'Hà Nội', '2500000', 'P20030'
exec usp_ThemDuAn 'S0003', N'Win Park', '23/1/2021', N'Đà Lạt', '300000', 'P20020'
exec usp_ThemDuAn 'S0004', N'Museum', '19/11/2023', N'Phan Thiết', '60000', 'P20020'
exec usp_ThemDuAn 'S0005', N'Quốc Tử Giám', '20/5/2000', N'Huế', '520000', 'P20015'
exec usp_ThemDuAn 'S0006', N'Cầu Gió Bay', '15/2/2020', N'Hải Phòng', '700000', 'P20030'
exec usp_ThemDuAn 'S0007', N'Nhà máy kẹo dừa', '1/1/1997', N'Bến Tre', '250000', 'P20020'

CREATE PROC usp_ThemVatTu
	@MaVatTu char(5), @TenVatTu nvarchar(10)
As
	If exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
		print N'Đã có vật tư có mã ' +@MaVatTu+ ' trong CSDL'
	Else
		Begin
			Insert into VatTu values(@MaVatTu, @TenVatTu)
			print N'Thêm vật tư thành công!'
		End
go

exec usp_ThemVatTu 'VT001', N'Thép'
exec usp_ThemVatTu 'VT002', N'Ván ép'
exec usp_ThemVatTu 'VT003', N'Gạch men'
exec usp_ThemVatTu 'VT004', N'Xi măng'
exec usp_ThemVatTu 'VT005', N'Cáp'
exec usp_ThemVatTu 'VT006', N'Cát'
exec usp_ThemVatTu 'VT007', N'Nhựa đường'
exec usp_ThemVatTu 'VT008', N'Hắc ín'
exec usp_ThemVatTu 'VT009', N'Gỗ'
exec usp_ThemVatTu 'VT010', N'Kính'
exec usp_ThemVatTu 'VT011', N'Bê Tông'
exec usp_ThemVatTu 'VT012', N'Đá'
exec usp_ThemVatTu 'VT013', N'Gạch'
exec usp_ThemVatTu 'VT014', N'Máy phát'
exec usp_ThemVatTu 'VT015', N'Máy múc'

CREATE PROC usp_ThemNhaCungCap
	@MaNCC char(5), @TenNCC nvarchar(50), @SoDienThoai varchar(10)
As
	If exists(SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC)
		print N'Đã có nhà cung cấp ' +@MaNCC+ ' trong CSDL!'
	Else
		Begin
			Insert into NhaCungCap values(@MaNCC, @TenNCC, @SoDienThoai)
			print N'Thêm nhà cung cấp thành công!'
		End
go

exec usp_ThemNhaCungCap 'NCC01', N'Tôn Hoa Sen', '0905123246'
exec usp_ThemNhaCungCap 'NCC02', N'Chí Bình', '0987765432' 
exec usp_ThemNhaCungCap 'NCC03', N'Xi măng Hoàng Sơn', '0912333445'
exec usp_ThemNhaCungCap 'NCC04', N'Thép Hòa Phát', '0985221465'

CREATE PROC usp_ThemKhaNangCC
    @MaNCC char(5), @MaVatTu char(5), @GiaBan int
As
    If exists(SELECT * FROM KhaNangCC WHERE MaNCC = @MaNCC AND MaVatTu = @MaVatTu)
        print N'Khả năng cung cấp đã tồn tại!';

    If not exists(SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC)
        print N'Không có nhà cung cấp ' + @MaNCC + N' trong CSDL'
    If not exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
        print N'Không có vật tư ' + @MaVatTu + N' trong CSDL'

	Else
		Begin
			Insert into KhaNangCC values (@MaNCC, @MaVatTu, @GiaBan)
			print N'Thêm khả năng cung cấp thành công!'
		End
go

exec usp_ThemKhaNangCC 'NCC01', 'VT001', '450000'
exec usp_ThemKhaNangCC 'NCC01', 'VT005', '40000'
exec usp_ThemKhaNangCC 'NCC01', 'VT003', '70000'
exec usp_ThemKhaNangCC 'NCC01', 'VT007', '80000'
exec usp_ThemKhaNangCC 'NCC01', 'VT011', '110000'
exec usp_ThemKhaNangCC 'NCC01', 'VT002', '120000'
exec usp_ThemKhaNangCC 'NCC01', 'VT009', '827000'
exec usp_ThemKhaNangCC 'NCC01', 'VT014', '212000'
exec usp_ThemKhaNangCC 'NCC01', 'VT006', '143000'
exec usp_ThemKhaNangCC 'NCC02', 'VT004', '780000'
exec usp_ThemKhaNangCC 'NCC02', 'VT003', '69000'
exec usp_ThemKhaNangCC 'NCC02', 'VT011', '120000'
exec usp_ThemKhaNangCC 'NCC02', 'VT006', '140000'
exec usp_ThemKhaNangCC 'NCC02', 'VT015', '50000'
exec usp_ThemKhaNangCC 'NCC03', 'VT013', '880000'
exec usp_ThemKhaNangCC 'NCC03', 'VT008', '560000'
exec usp_ThemKhaNangCC 'NCC03', 'VT004', '62000'
exec usp_ThemKhaNangCC 'NCC03', 'VT006', '12000'
exec usp_ThemKhaNangCC 'NCC03', 'VT011', '110000'
exec usp_ThemKhaNangCC 'NCC03', 'VT012', '61000'
exec usp_ThemKhaNangCC 'NCC03', 'VT014', '227000'
exec usp_ThemKhaNangCC 'NCC04', 'VT010', '125000'
exec usp_ThemKhaNangCC 'NCC04', 'VT009', '860000'
exec usp_ThemKhaNangCC 'NCC04', 'VT014', '240000'
exec usp_ThemKhaNangCC 'NCC04', 'VT012', '60000'
exec usp_ThemKhaNangCC 'NCC04', 'VT001', '460000'
exec usp_ThemKhaNangCC 'NCC04', 'VT006', '128000'
exec usp_ThemKhaNangCC 'NCC04', 'VT002', '130000'
exec usp_ThemKhaNangCC 'NCC04', 'VT005', '142000'
exec usp_ThemKhaNangCC 'NCC04', 'VT015', '52000'

CREATE PROC usp_ThemPhieuChi
	@MaPhieuChi char(5), @NgayChi Date, @SoTien int, @MaNCC char(5), @MaDA char(5)
As
	If exists(SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC) and exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
		Begin
			If exists(SELECT * FROM PhieuChi WHERE MaPhieuChi = @MaPhieuChi)
				print N'Đã có phiếu chi ' +@MaPhieuChi+ ' trong CSDL'
			Else
				Begin
					Insert into PhieuChi values(@MaPhieuChi, @NgayChi, @SoTien, @MaNCC, @MaDA)
					print N'Thêm phiếu chi thành công!'
				End
		End
	Else
		If not exists(SELECT * FROM NhaCungCap WHERE MaNCC = @MaNCC)
			print N'Không có nhà cung cấp ' +@MaNCC+ ' trong CSDL'
		If not exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
			print N'Không có dự án ' +@MaDA+ ' trong CSDL'
go

set dateformat dmy
exec usp_ThemPhieuChi 'PC001', '23/12/2024', '250000', 'NCC01', 'S0001'
exec usp_ThemPhieuChi 'PC002', '12/1/2024', '320000', 'NCC02', 'S0004'
exec usp_ThemPhieuChi 'PC003', '18/7/2016', '650000', 'NCC02','S0002'
exec usp_ThemPhieuChi 'PC004', '19/5/2019', '710000' , 'NCC03','S0003'
exec usp_ThemPhieuChi 'PC005', '2/10/2022', '940000', 'NCC04','S0006'

CREATE PROC usp_ThemDuAnVatTu
	@MaDA char(5), @MaVatTu char(5), @SoLuong tinyint
As
	If exists(SELECT * FROM DuAn WHERE MaDA = @MaDA) and exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
		Begin
			Insert into DuAnVatTu values(@MaDA, @MaVatTu, @SoLuong)
			print N'Thêm dự án vật tư thành công'
		End
	Else
		If not exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
			print N'Không có dự án nào có mã ' +@MaDA+ ' trong CSDL'
		If not exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
			print N'Không có vật tư nào có mã ' +@MaVatTu+ ' trong CSDL'
go

exec usp_ThemDuAnVatTu 'S0001', 'VT001', 152
exec usp_ThemDuAnVatTu 'S0001', 'VT003', 219
exec usp_ThemDuAnVatTu 'S0001', 'VT004', 87
exec usp_ThemDuAnVatTu 'S0001', 'VT005', 199
exec usp_ThemDuAnVatTu 'S0001', 'VT010', 134
exec usp_ThemDuAnVatTu 'S0001', 'VT012', 251
exec usp_ThemDuAnVatTu 'S0001', 'VT014', 103
exec usp_ThemDuAnVatTu 'S0002', 'VT001', 190
exec usp_ThemDuAnVatTu 'S0002', 'VT003', 78
exec usp_ThemDuAnVatTu 'S0002', 'VT004', 244
exec usp_ThemDuAnVatTu 'S0002', 'VT010', 59
exec usp_ThemDuAnVatTu 'S0002', 'VT011', 207
exec usp_ThemDuAnVatTu 'S0002', 'VT014', 170
exec usp_ThemDuAnVatTu 'S0003', 'VT001', 42
exec usp_ThemDuAnVatTu 'S0003', 'VT002', 237
exec usp_ThemDuAnVatTu 'S0003', 'VT005', 88
exec usp_ThemDuAnVatTu 'S0003', 'VT007', 214
exec usp_ThemDuAnVatTu 'S0003', 'VT008', 146
exec usp_ThemDuAnVatTu 'S0004', 'VT009', 91
exec usp_ThemDuAnVatTu 'S0004', 'VT011', 204
exec usp_ThemDuAnVatTu 'S0004', 'VT013', 229
exec usp_ThemDuAnVatTu 'S0004', 'VT014', 115
exec usp_ThemDuAnVatTu 'S0004', 'VT015', 39
exec usp_ThemDuAnVatTu 'S0005', 'VT001', 76
exec usp_ThemDuAnVatTu 'S0005', 'VT002', 131
exec usp_ThemDuAnVatTu 'S0005', 'VT003', 241
exec usp_ThemDuAnVatTu 'S0005', 'VT004', 98
exec usp_ThemDuAnVatTu 'S0006', 'VT007', 187
exec usp_ThemDuAnVatTu 'S0006', 'VT008', 53
exec usp_ThemDuAnVatTu 'S0006', 'VT009', 223
exec usp_ThemDuAnVatTu 'S0006', 'VT011', 72
exec usp_ThemDuAnVatTu 'S0007', 'VT001', 135
exec usp_ThemDuAnVatTu 'S0007', 'VT010', 201
exec usp_ThemDuAnVatTu 'S0007', 'VT006', 147
exec usp_ThemDuAnVatTu 'S0007', 'VT008', 165

CREATE PROC usp_ThemNhanVienDuAn
	@MaNV char(5), @MaDA char(5), @LuongDA int
As
	If exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV) and exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
		Begin
			Insert into NhanVienDuAn values(@MaNV, @MaDA, @LuongDA)
			print N'Thêm nhân viên dự án thành công'
		End
	Else
		If not exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV)
			print N'Không có nhân viên nào có mã ' +@MaNV+ ' trong CSDL'
		If not exists(SELECT * FROM DuAn WHERE MaDA = @MaDA)
			print N'Không có sự án nào có mã ' +@MaDA+ ' trong CSDL'
go

exec usp_ThemNhanVienDuAn 'NV006', 'S0006', 14000000
exec usp_ThemNhanVienDuAn 'NV001', 'S0001', 10000000
exec usp_ThemNhanVienDuAn 'NV004', 'S0005', 12000000
exec usp_ThemNhanVienDuAn 'NV013', 'S0004', 9000000
exec usp_ThemNhanVienDuAn 'NV017', 'S0002', 7500000

CREATE PROC usp_ThemChiTietPhieuChi
	@MaPhieuChi char(5), @MaVatTu char(5), @SoLuong int, @DonGia int
As
	If exists(SELECT * FROM PhieuChi WHERE MaPhieuChi = @MaPhieuChi) and exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
		Begin
			Insert into ChiTietPhieuChi values(@MaPhieuChi, @MaVatTu, @SoLuong, @DonGia)
			print N'Thêm chi tiết phiếu chi thành công'
		End
	Else
		If not exists(SELECT * FROM PhieuChi WHERE MaPhieuChi = @MaPhieuChi)
			print N'Không có mã phiếu chi ' +@MaPhieuChi+ ' trong CSDL'
		If not exists(SELECT * FROM VatTu WHERE MaVatTu = @MaVatTu)
			print N'Không có mã vật tư ' +@MaVatTu+ ' trong CSDL'
go

exec usp_ThemChiTietPhieuChi 'PC001', 'VT001', 50, 100000
exec usp_ThemChiTietPhieuChi 'PC001', 'VT002', 30, 150000
exec usp_ThemChiTietPhieuChi 'PC001', 'VT005', 10, 200000
exec usp_ThemChiTietPhieuChi 'PC002', 'VT003', 100, 120000
exec usp_ThemChiTietPhieuChi 'PC002', 'VT006', 20, 80000
exec usp_ThemChiTietPhieuChi 'PC002', 'VT004', 5, 500000
exec usp_ThemChiTietPhieuChi 'PC003', 'VT007', 15, 170000
exec usp_ThemChiTietPhieuChi 'PC003', 'VT008', 60, 70000
exec usp_ThemChiTietPhieuChi 'PC003', 'VT001', 10, 100000
exec usp_ThemChiTietPhieuChi 'PC004', 'VT009', 25, 90000
exec usp_ThemChiTietPhieuChi 'PC004', 'VT010', 40, 110000
exec usp_ThemChiTietPhieuChi 'PC004', 'VT002', 15, 150000
exec usp_ThemChiTietPhieuChi 'PC005', 'VT003', 90, 120000
exec usp_ThemChiTietPhieuChi 'PC005', 'VT004', 12, 500000
exec usp_ThemChiTietPhieuChi 'PC005', 'VT006', 18, 85000

--Hàm 
--Tổng lương của nhân viên
CREATE FUNCTION fn_TongLuongNhanVien (@MaNV char(5)) RETURNS int
As
	Begin
		Declare @LuongCoBan int
		Declare @LuongDA int

		SELECT @LuongCoBan = LuongCoBan 
		FROM NhanVien 
		WHERE MaNV = @MaNV

		SELECT @LuongDA = Isnull(SUM(LuongDA), 0)
		FROM NhanVienDuAn
		WHERE MaNV = @MaNV

		RETURN @LuongCoBan + @LuongDA
	End
go

print dbo.fn_TongLuongNhanvien ('NV001')

--Hàm tổng tiền đã chi cho một dự án
CREATE FUNCTION fn_TongChiDuAn (@MaDA char(5)) RETURNS int
As
	Begin
		DECLARE @TongTien float

		SELECT @TongTien = ISNULL(SUM(SoLuong * DonGia), 0)
		FROM PhieuChi A, ChiTietPhieuChi B
		WHERE A.MaPhieuChi = B.MaPhieuChi and A.MaDA = @MaDA

		RETURN @TongTien
	End
go

print dbo.fn_TongChiDuAn ('S0001')

--Hàm lấy số lượng nhân viên trong phòng ban
CREATE FUNCTION fn_SoLuongNhanVien (@MaPhongBan char(6)) RETURNS int
As
	Begin
		Declare @SoLuong int

		SELECT @SoLuong = COUNT(MaNV)
		FROM NhanVien
		WHERE MaPhongBan = @MaPhongBan
		
		RETURN @SoLuong
	End
Go

print dbo.fn_SoLuongNhanVien ('P20015')

--Thủ tục
--Thủ tục cập nhật nhân viên
ALTER PROC usp_CapNhatNhanVien
	@MaNV char(5), @Ho nvarchar(30), @Ten nvarchar(10), @DiaChi nvarchar(100),
	@NgaySinh Date, @NgayVaoCongTac Date, @LuongCoBan int, @MaPhongBan char(6)
As
	If exists(SELECT * FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
		Begin
			If exists(SELECT * FROM NhanVien WHERE MaNV = @MaNV)
				Begin
					Update NhanVien

					Set Ho = @Ho,
						Ten = @Ten,
						DiaChi = @DiaChi,
						NgaySinh = @NgaySinh,
						NgayVaoCongTac = @NgayVaoCongTac,
						LuongCoBan = @LuongCoBan,
						MaPhongBan = @MaPhongBan
					Where MaNV = @MaNV

					print N'Cập nhật nhân viên thành công'
				End
			Else
				print N'Không có nhân viên nào có mã ' +@MaNV+ ' trong CSDL'
		End
	Else
		print N'Không có phòng ban ' +@MaPhongBan+ ' trong CSDL'
go

set dateformat dmy
exec usp_CapNhatNhanVien
    @MaNV = 'NV001',
    @Ho = N'Lê',
    @Ten = N'Hà',
    @DiaChi = N'456 Trần Phú, Huế',
    @NgaySinh = '01/10/1995',
    @NgayVaoCongTac = '15/01/2020',
    @LuongCoBan = 15000000,
    @MaPhongBan = 'P20025'

select * from NhanVien

--Thủ tục cập nhật trưởng phòng
CREATE PROC usp_CapNhatTruongPhong
    @MaPhongBan char(6), @MaNV char(5), @NgayBoNhiem date
As
	Begin
    -- 1. Kiểm tra phòng ban tồn tại
    IF NOT EXISTS (SELECT 1 FROM PhongBan WHERE MaPhongBan = @MaPhongBan)
    BEGIN
        PRINT N'Phòng ban không tồn tại.'
        RETURN
    END

    -- 2. Kiểm tra nhân viên tồn tại
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV = @MaNV)
    BEGIN
        PRINT N'Nhân viên không tồn tại.'
        RETURN
    END

    -- 3. Kiểm tra nhân viên có thuộc phòng ban không
    IF EXISTS (
        SELECT 1
        FROM NhanVien
        WHERE MaNV = @MaNV AND MaPhongBan <> @MaPhongBan
    )
    BEGIN
        PRINT N'Nhân viên không thuộc phòng ban cần bổ nhiệm.'
        RETURN
    END

    -- 4. Kiểm tra ngày bổ nhiệm phải sau ngày vào công tác
    IF EXISTS (
        SELECT 1
        FROM NhanVien
        WHERE MaNV = @MaNV AND @NgayBoNhiem <= NgayVaoCongTac
    )
    BEGIN
        PRINT N'Ngày bổ nhiệm phải sau ngày vào công tác.'
        RETURN
    END

    -- 5. Kiểm tra nếu phòng ban đã có trưởng phòng khác (và khác nhân viên này)
    IF EXISTS (
        SELECT 1
        FROM NhanVienTruongPhong
        WHERE MaPhongBan = @MaPhongBan AND MaNV <> @MaNV
    )
    BEGIN
        PRINT N'Phòng ban này đã có trưởng phòng khác.'
        RETURN
    END

    -- 6. Nếu đã có dòng trưởng phòng với mã phòng ban và mã nhân viên → cập nhật
    IF EXISTS (
        SELECT 1
        FROM NhanVienTruongPhong
        WHERE MaPhongBan = @MaPhongBan AND MaNV = @MaNV
    )
    BEGIN
        UPDATE NhanVienTruongPhong
        SET NgayBoNhiem = @NgayBoNhiem
        WHERE MaPhongBan = @MaPhongBan AND MaNV = @MaNV

        PRINT N'Cập nhật ngày bổ nhiệm trưởng phòng thành công.'
    END
    ELSE
    BEGIN
        INSERT INTO NhanVienTruongPhong(MaPhongBan, MaNV, NgayBoNhiem)
        VALUES(@MaPhongBan, @MaNV, @NgayBoNhiem)

        PRINT N'Bổ nhiệm trưởng phòng thành công.'
    END
END
GO
