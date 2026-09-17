/*	Học phần: Cơ sở dữ liệu
	Lab06: Quản lý học viên
	SV thực hiện: Lê Anh Khoa
	Mã SV: 2312647
	Lớp: CTK47A
	Thời gian: 14/03/2025 - 31/03/2025
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
CREATE DATABASE Lab06_QLHocVien
GO

USE Lab06_QLHocVien
GO

CREATE TABLE CaHoc
(
	Ca tinyint PRIMARY KEY,
	GioBatDau DateTime,
	GioKetThuc DateTime
)
GO

CREATE TABLE GiaoVien
(
	MSGV char(4) PRIMARY KEY,
	HoGV nvarchar(30),
	TenGV nvarchar(20),
	DienThoai varchar(11)
)
GO

CREATE TABLE Lop
(
	MaLop char(4) PRIMARY KEY,
	TenLop nvarchar(30),
	NgayKG DateTime,
	HocPhi int,
	Ca tinyint REFERENCES CaHoc(Ca),
	SoTiet int,
	SoHV int,
	MSGV char(4) REFERENCES GiaoVien(MSGV)
)
GO

CREATE TABLE HocVien
(
	MSHV char(6) PRIMARY KEY,
	Ho nvarchar(30),
	Ten nvarchar(10),
	NgaySinh DateTime,
	Phai nvarchar(4),
	MaLop char(4) REFERENCES Lop(MaLop)
)
GO

CREATE TABLE HocPhi
(
	SoBL char(4) PRIMARY KEY,
	MSHV char(6) REFERENCES HocVien(MSHV),
	NgayThu DateTime,
	SoTien int,
	NoiDung nvarchar(50),
	NguoiThu nvarchar(20)
)
GO

----------------------------------
SELECT * FROM CaHoc
SELECT * FROM GiaoVien
SELECT * FROM Lop
SELECT * FROM HocVien
SELECT * FROM HocPhi

----------XÂY DỰNG CÁC THỦ TỤC NHẬP DỮ LIỆU-------------
--5a) Thêm dữ liệu vào các bảng (đảm bảo các ràng buộc toàn vẹn liên quan.
CREATE PROC usp_ThemCaHoc
	@ca tinyint, @giobd Datetime, @giokt Datetime
As
	If exists(SELECT * FROM CaHoc WHERE Ca = @ca) --kiểm tra có trùng khóa chính (Ca) 
		print N'Đã có ca học ' +@ca+ N' trong CSDL!'
	Else
		begin
			insert into CaHoc values(@ca, @giobd, @giokt)
			print N'Thêm ca học thành công.'
		end
go
--goi thuc hien thu tuc usp_ThemCaHoc---
exec usp_ThemCaHoc 1,'7:30','10:45'
exec usp_ThemCaHoc 2,'13:30','16:45'
exec usp_ThemCaHoc 3,'17:30','20:45'

select * from CaHoc
----------------------------------
CREATE PROC usp_ThemGiaoVien
	@MSGV char(4), @HoGV nvarchar(30), @TenGV nvarchar(20), @DienThoai varchar(11)
As
	If exists(SELECT * FROM GiaoVien WHERE MSGV=@MSGV)
		print N'Đã có giáo viên có mã số'+@MSGV+' trong CSDL!'
	Else
		begin
			INSERT INTO GiaoVien values(@MSGV, @HoGV, @TenGV, @DienThoai)
			print N'Thêm giáo viên thành công.'
		end
go
--goi thuc hien thu tuc usp_ThemGiaoVien---
exec usp_ThemGiaoVien 'G001', N'Lê Hoàng', N'Anh', '858936'
exec usp_ThemGiaoVien 'G002', N'Nguyễn Ngọc', N'Lan', '845623'
exec usp_ThemGiaoVien 'G003', N'Trần Minh', N'Hùng', '823456'
exec usp_ThemGiaoVien 'G004', N'Võ Thanh', N'Trung', '841256'

SELECT * FROM GiaoVien
----------------------------------
CREATE PROC usp_ThemLopHoc
	@MaLop char(4), @TenLop nvarchar(30), @NgayKG Datetime, @HocPhi int,
	@Ca char(4), @SoTiet int, @SoHV int, @MSGV char(4)
As
	If exists(SELECT * FROM CaHoc WHERE Ca=@Ca) and exists(SELECT * FROM GiaoVien WHERE MSGV=@MSGV)
		Begin
			If exists(SELECT * FROM Lop WHERE MaLop=@MaLop)
				print N'Đã có lớp có mã '+@Malop+' trong CSDL!'
			Else
				begin
					INSERT INTO Lop values(@MaLop, @TenLop, @NgayKG, @HocPhi, @Ca, @SoTiet, @SoHV, @MSGV)
					print N'Thêm lớp thành công.'
				end
		End
	Else
		if not exists(SELECT * FROM CaHoc WHERE Ca = @Ca)
			print N'Không có ca học '+@Ca+' trong CSDL nên không thêm được lớp học.'
		if not exists(SELECT * FROM GiaoVien WHERE MSGV=@msgv)
			print N'Không có giáo viên '+@MSGV+' trong CSDL nên không thêm được lớp học.'
go
--goi thuc hien thu tuc usp_ThemLopHoc---
SET DATEFORMAT dmy
go

exec usp_ThemLopHoc 'E114',N'Excel 3-5-7','02/01/2008', 120000, 1, 45, 0, 'G003'
exec usp_ThemLopHoc 'E115',N'Excel 2-4-6','22/01/2008', 120000, 3, 45, 0, 'G001'
exec usp_ThemLopHoc 'W123',N'Word 2-4-6','18/02/2008', 100000, 3, 30, 0 , 'G001'
exec usp_ThemLopHoc 'W124',N'Word 3-5-7','01/03/2008', 100000, 1, 30, 0, 'G002'
exec usp_ThemLopHoc 'A075',N'Access 2-4-6','18/12/2008', 150000, 3, 60, 0, 'G003'

SELECT * FROM Lop
----------------------------------
CREATE PROC usp_ThemHocVien
	@MSHV char(6), @Ho nvarchar(30), @Ten nvarchar(10), @NgaySinh Datetime, 
	@Phai nvarchar(4), @MaLop char(4)
As
	If exists(SELECT * FROM Lop WHERE MaLop=@MaLop)
		Begin
			If exists(SELECT * FROM HocVien WHERE MSHV=@MSHV)
				print N'Đã có học viên có mã '+@MSHV+' trong CSDL!'
			Else
				begin
					INSERT INTO HocVien values(@MSHV, @Ho, @Ten, @NgaySinh, @Phai, @MaLop)
					Update Lop set SoHV=SoHV+1 WHERE MaLop=@MaLop
					print N'Thêm học viên thành công.'
				end
		End
	Else
		print N'Không có lớp nào có mã '+@MaLop+' trong CSDL nên không thể thêm được học viên!'
go
--goi thuc hien thu tuc usp_ThemHocVien---
SET DATEFORMAT dmy
go

exec usp_ThemHocVien 'A07501', N'Lê Văn', N'Minh', '10/06/1998', N'Nam', 'A075'
exec usp_ThemHocVien 'A07502', N'Nguyễn Thị', N'Mai', '20/04/1998', N'Nữ', 'A075'
exec usp_ThemHocVien 'A07503', N'Lê Ngọc', N'Tuấn', '10/06/1994', N'Nam', 'A075'
exec usp_ThemHocVien 'E11401', N'Vương Tuấn', N'Vũ', '25/03/1999', N'Nam', 'E114'
exec usp_ThemHocVien 'E11402', N'Lý Ngọc', N'Hân', '01/12/1995', N'Nữ', 'E114'
exec usp_ThemHocVien 'E11403', N'Trần Mai', N'Linh', '04/06/1990', N'Nữ', 'E114'
exec usp_ThemHocVien 'W12301', N'Nguyễn Ngọc', N'Tuyết', '12/05/1996', N'Nữ', 'W123'

SELECT * FROM HocVien
----------------------------------
CREATE PROC usp_ThemHocPhi
	@SoBL char(4), @MSHV char(6), @NgayThu Datetime, 
	@SoTien int, @NoiDung nvarchar(50), @NguoiThu nvarchar(20)
As
	If exists(SELECT * FROM HocVien WHERE MSHV=@MSHV)
		Begin
			If exists(SELECT * FROM HocPhi WHERE SoBL=@SoBL)
				print N'Đã có số biên lai '+@SoBL+' trong CSDL!'
			Else
				begin
					INSERT INTO HocPhi values(@SoBL, @MSHV, @NgayThu, @SoTien, @NoiDung, @NguoiThu)
					print N'Thêm học phí thành công.'
				end
		End
	Else
		print N'Không có học viên nào có mã '+@MSHV+' trong CSDL nên không thêm được học phí'
go
--goi thuc hien thu tuc usp_ThemHocPhi---
SET DATEFORMAT dmy
go

exec usp_ThemHocPhi '0001', 'E11401', '02/01/2008', 120000, 'HP Access 3-5-7', N'Vân'
exec usp_ThemHocPhi '0002', 'E11402', '02/01/2008', 120000, 'HP Access 3-5-7', N'Vân'
exec usp_ThemHocPhi '0003', 'E11403', '02/01/2008', 80000, 'HP Access 3-5-7', N'Vân'
exec usp_ThemHocPhi '0004', 'W12301', '18/02/2008', 100000, 'HP Word 2-4-6', N'Lan'
exec usp_ThemHocPhi '0005', 'A07501', '16/12/2008', 150000, 'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0006', 'A07502', '16/12/2008', 100000, 'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0007', 'A07503', '18/12/2008', 150000, 'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi '0008', 'A07502', '15/01/2009', 50000, 'HP Access 2-4-6', N'Vân'

SELECT * FROM HocPhi

--5b: Cập nhật thông tin của một học viên cho trước
CREATE PROC usp_CapNhatHocVien
    @MSHV char(6), 
    @Ho nvarchar(30), 
    @Ten nvarchar(10), 
    @NgaySinh Datetime, 
    @Phai nvarchar(4), 
    @MaLop char(4)
As
    IF not exists(SELECT * FROM Lop WHERE MaLop = @MaLop)
        print N'Lớp có mã ' + @MaLop + N' không tồn tại trong cơ sở dữ liệu!'
    If exists(SELECT * FROM HocVien WHERE MSHV = @MSHV)
		Begin
			UPDATE HocVien
			SET Ho = @Ho,
				Ten = @Ten,
				NgaySinh = @NgaySinh,
				Phai = @Phai,
				MaLop = @MaLop
			WHERE MSHV = @MSHV
			print N'Cập nhật thông tin học viên thành công.'
		End
    Else
        print N'Học viên không tồn tại trong cơ sở dữ liệu!'
go

EXEC usp_CapNhatHocVien
    @MSHV = 'A07501', 
    @Ho = N'Lê Anh',
    @Ten = N'Khoa', 
    @NgaySinh = '08/02/2005', 
	@Phai = N'Nam',
    @MaLop = 'A075'

SELECT * FROM HocVien

--5c: Xóa một học viên cho trước
ALTER PROC usp_XoaHocVien
    @MSHV char(6)
As
    If exists(SELECT * FROM HocVien WHERE MSHV = @MSHV)
		Begin
			If not exists(select * from HocPhi where MSHV = @MSHV)
				Begin
					DECLARE @MaLop char(4)
					SELECT @MaLop = MaLop FROM HocVien WHERE MSHV = @MSHV

					DELETE FROM HocVien WHERE MSHV = @MSHV
	
					UPDATE Lop
					SET SoHV = SoHV - 1
					WHERE MaLop = @MaLop
					print N'Xóa học viên có mã '+@MSHV+' thành công.'
				End
			Else
				print N'Không thể xóa học viên có mã '+@MSHV+N' vì có những dòng nộp học phí liên quan.'
		End
    Else
        print N'Học viên không tồn tại trong cơ sở dữ liệu.'
go

EXEC usp_XoaHocVien @MSHV = 'A07504'

-- Kiểm tra kết quả sau khi xóa
SELECT * FROM HocVien
SELECT * FROM Lop
Update Lop 
set SoHV = SoHV+2
Where Malop = 'A075'
Set dateformat dmy
go
exec usp_ThemHocVien 'A07504', N'Nguyễn Ngọc', N'Nam', '10/06/1984', N'Nam', 'A075'

--5d: Cập nhật thông tin của một lớp học cho trước.
ALTER PROC usp_CapNhatLopHoc
	@Malop char(4), @TenLop nvarchar(30), @NgayKG Datetime, @HocPhi int, @Ca tinyint, 
    @SoTiet int, @SoHV int, @MSGV char(4)
As
	If exists(SELECT * FROM CaHoc WHERE Ca = @Ca) and exists(SELECT * FROM GiaoVien WHERE MSGV = @MSGV)
		Begin
			If exists(SELECT * FROM Lop WHERE MaLop = @Malop)
				begin
					Update Lop
					Set TenLop = @TenLop,
						NgayKG = @NgayKG,
						HocPhi = @HocPhi,
						Ca = @Ca,
						SoTiet = @SoTiet,
						SoHV = @SoHV,
						MSGV = @MSGV
					WHERE MaLop = @MaLop
					print N'Cập nhật thông tin lớp học thành công.'
				end
			Else
				print N'Lớp học với mã '+@MaLop+ N' không tồn tại trong CSDL!'
		End
	Else
		If not exists(SELECT * FROM CaHoc WHERE Ca = @Ca)
			print N'Không có ca học ' + CAST(@Ca AS nvarchar(10)) + N' trong CSDL!'
		IF not exists(SELECT * FROM GiaoVien WHERE MSGV = @MSGV)
			print N'Không có giáo viên với mã ' + @MSGV + N' trong CSDL!'
go

SET DATEFORMAT dmy
go

exec usp_CapNhatLopHoc 
    @MaLop = 'E114', 
    @TenLop = N'Thanh Hiền', 
    @NgayKG = '15/03/2025', 
    @HocPhi = 150000, 
    @Ca = 2, 
    @SoTiet = 50, 
    @SoHV = 25, 
    @MSGV = 'G001'

SELECT * FROM Lop

--5e: Xóa một lớp học cho trước nếu lớp học này không có học viên.
CREATE PROC usp_XoaLopHoc
	@MaLop char(4)
As
	If exists(SELECT * FROM Lop WHERE MaLop = @MaLop)
		Begin
			If exists(SELECT * FROM HocVien WHERE MaLop = @MaLop)
				print N'Lớp học có mã ' +@MaLop+ N' vẫn còn học viên, không thể xóa!'
			Else
				begin
					DELETE FROM Lop WHERE MaLop = @MaLop
					print N'Xóa lớp có mã ' +@MaLop+ N' thành công.'
				end
		End
	Else
		print N'Lớp học có mã ' +@MaLop+ N' không tồn tại trong CSDL!'
go

exec usp_XoaLopHoc @MaLop = 'A077'

exec usp_ThemLopHoc 'A077', N'Toán rời rạc', '08/02/2000', 150000, 2, 35, 2, 'G002'

SELECT * FROM Lop

--5f: Lập danh sách học viên của một lớp cho trước.
CREATE PROC	InDSLop
	@MaLop char(4)
As
	If exists(SELECT * FROM Lop WHERE MaLop = @MaLop)
		SELECT * FROM HocVien WHERE MaLop = @MaLop
	Else
		print N'Lớp có mã ' +@MaLop+ N' không tồn tại trong CSDL.'
go

exec InDSLop 'A075'

--5g: Lập danh sách học viên chưa đóng đủ học phí của một lớp cho trước.
CREATE PROC HocVienChuaDongDuHocPhi
	@MaLop char(4)
As
	If exists(SELECT * FROM Lop WHERE MaLop = @MaLop)
		Begin
			SELECT B.MaLop, B.HocPhi, A.MSHV, A.Ho, A.Ten, SUM(C.SoTien) as TongSoTien, B.HocPhi - SUM(C.SoTien) as SoTienConThieu
			FROM HocVien A, Lop B, HocPhi C
			WHERE A.MaLop = B.MaLop and A.MSHV = C.MSHV and B.MaLop = @MaLop
			GROUP BY B.MaLop, B.HocPhi, A.MSHV, A.Ho, A.Ten
			HAVING SUM(C.SoTien) < B.HocPhi
			ORDER BY A.MSHV
		End
	Else
		print N'Mã lớp ' +@MaLop+ N' không tồn tại trong CSDL!'
go

exec HocVienChuaDongDuHocPhi 'E114'
exec HocVienChuaDongDuHocPhi 'A075'

--------------------HÀM CẤP MÃ TỰ ĐỘNG & CÁCH SỬ DỤNG----------------
/*1. Viết hàm cấp mã cho giáo viên mới theo quy tắc lấy mã lớn nhất hiện có 
sau đó tăng thêm 1 đơn vị*/
CREATE FUNCTION CapMaGV() returns char(4)
As
Begin
	declare @MaxMaGV char(4)
	declare @NewMaGV varchar(4)
	declare @stt	int
	declare @i	int	
	declare @sokyso	int

	if exists(select * from GiaoVien)
	 begin
		select @MaxMaGV = max(MSGV) 
		from GiaoVien

		set @stt=convert(int, right(@MaxMaGV,3)) + 1 
	 end
	else
	 set @stt= 1 
	
	set @sokyso = len(convert(varchar(3), @stt))
	set @NewMaGV='G'
	set @i = 0
	while @i < 3 -@sokyso
		begin
			set @NewMaGV = @NewMaGV + '0'
			set @i = @i + 1
		end	
	set @NewMaGV = @NewMaGV + convert(varchar(3), @stt)

return @NewMaGV	
End

--Thử hàm sinh mã
SELECT * FROM GiaoVien
print dbo.CapMaGV()
--delete from GiaoVien

----2. Thủ  tục thêm giáo viên với mã giáo viên được cấp tự động----
CREATE PROC usp_ThemGiaoVien2
	@hogv nvarchar(20), @tengv nvarchar(10), @dthoai varchar(10)
As
	declare @Magv char(4)
	
 if not exists(select * from GiaoVien 
				where HoGV = @hogv and TenGV = @tengv and DienThoai = @dthoai)
	Begin
		set @Magv = dbo.CapMaGV()
		INSERT INTO GiaoVien values(@Magv, @hogv, @tengv,@dthoai)
		print N'Đã thêm giáo viên thành công'
	End
else
	print N'Đã có giáo viên ' + @hogv +' ' + @tengv + ' trong CSDL'
Go

---Sử dụng thủ tục thêm giáo viên
exec usp_ThemGiaoVien2 N'Trần Ngọc Bảo', N'Hân', '0123456789'
exec usp_ThemGiaoVien2 N'Vũ Minh', N'Triết', '0123456788'
select * from GiaoVien

------------------CÀI ĐẶT RÀNG BUỘC TOÀN VẸN----------------
--4a) Giờ kết thúc của một ca học không được trước giờ bắt đầu ca học đó
CREATE TRIGGER tr_CaHoc_ins_upd_GioBD_GioKT
On CaHoc for insert, update
As
	If update(GioBatDau) or update (GioKetThuc)
		If exists(SELECT * FROM inserted i WHERE i.GioKetThuc<i.GioBatDau)	
	      begin
	    	 raiserror (N'Giờ kết thúc ca học không thể nhỏ hơn giờ bắt đầu',15,1)
		     rollback tran
	      end
go	

-----thử nghiệm hoạt động của trigger tr_CaHoc_ins_upd_GioBD_GioKT----
INSERT INTO CaHoc values(4,'14:40','16:00')
--delete from CaHoc where Ca = 4
Update CaHoc set GioKetThuc = '5:45' where ca = 1
select * from CaHoc

--4b) Sĩ số (SoHV) của 1 lớp không quá 30 và đúng bằng số học viên thuộc lớp đó. 
CREATE TRIGGER trg_Lop_ins_upd
On Lop for insert,update
As
	If Update(MaLop) or Update(SoHV)
		Begin
			If exists(select * from inserted i where i.SOHV>30) 
				begin
					raiserror (N'Số học viên của một lớp không quá 30',15,1)
					rollback tran 
				end
			If exists (select * from inserted l 
					   where l.SOHV <> (select count(MSHV) 
										from HocVien 
										where HocVien.Malop = l.Malop))
				begin
					raiserror (N'Số học viên của một lớp không bằng số lượng học viên tại lớp đó',15,1)
					rollback tran
				end
		End
Go

select * from Lop

SET DATEFORMAT dmy
go
INSERT INTO Lop values('P001',N'Photoshop','1/11/2018',250000,1,100,0,'G004')

update Lop set SoHV = 35 where MaLop = 'P001'

--------------------HÀM CẤP MÃ TỰ ĐỘNG--------------------
CREATE FUNCTION	CapMaGV() RETURNS char(4)
As
Begin
	DECLARE @MaxMSGV char(4)
	DECLARE @NewMSGV varchar(4)
	DECLARE @stt int
	DECLARE @i int
	DECLARE @sokyso int

	If exists(SELECT * FROM GiaoVien)
		Begin
			Select @MaxMSGV = Max(MSGV)
			FROM GiaoVien

			Set @stt = CONVERT(int, Right(@MaxMSGV, 3)) + 1
		End
	Else
		Set @stt = 1

	Set @sokyso = len(CONVERT(varchar(3), @stt))
	Set @NewMSGV = 'G'
	Set @i = 0
	while @i < 3 - @sokyso
		begin
			Set @NewMSGV = @NewMSGV + '0'
			Set @i = @i + 1
		end
	Set @NewMSGV = @NewMSGV + CONVERT(varchar(3), @stt)

Return @NewMSGV
End

--2. Thủ  tục thêm giáo viên với mã giáo viên được cấp tự động
ALTER PROC usp_ThemGiaoVien2
	@hogv nvarchar(20), @tengv nvarchar(10), @dthoai varchar(10)
As
	declare @Magv char(4)
	
	If not exists(SELECT * FROM GiaoVien 
				  WHERE HoGV = @hogv and TenGV = @tengv and DienThoai = @dthoai)
		Begin
			set @Magv = dbo.CapMaGV()
			INSERT INTO GiaoVien values(@Magv, @hogv, @tengv,@dthoai)
			print N'Đã thêm giáo viên thành công'
		End
	Else
		print N'Đã có giáo viên ' + @hogv +' ' + @tengv + ' trong CSDL'
go
---Sử dụng thủ tục thêm giáo viên
exec usp_ThemGiaoVien2 N'Trần Ngọc Bảo', N'Hân', '0123456789'
exec usp_ThemGiaoVien2 N'Vũ Minh', N'Triết', '0123456788'
SELECT * FROM GiaoVien

--------------------RÀNG BUỘC TOÀN VẸN--------------------
--4a) Giờ kết thúc của một ca học không được trước giờ bắt đầu ca học đó 
CREATE TRIGGER tr_CaHoc_ins_upd_GioBD_GioKT
On CaHoc for insert, update
As
If update(GioBatDau) or update (GioKetThuc)
	If exists(SELECT * FROM inserted i WHERE i.GioKetThuc<i.GioBatDau)	
		begin
			raiserror (N'Giờ kết thúc ca học không thể nhỏ hơn giờ bắt đầu',15,1)
		    rollback tran	
		end
go

INSERT INTO CaHoc values(4,'16:00','14:40')
Update CaHoc set GioKetThuc = '20:00' where ca = 1
select * from CaHoc

--4b): Số học viên của 1 lớp không quá 30 và đúng bằng số học viên thuộc lớp đó. 
CREATE TRIGGER trg_Lop_ins_upd
On Lop for insert,update
AS
If Update(MaLop) or Update(SoHV)
	If exists(SELECT * FROM inserted i WHERE i.SOHV>30) 
		begin
			raiserror (N'Số học viên của một lớp không quá 30',15,1)
			rollback tran 
		end
	If exists (SELECT * FROM inserted l 
	           WHERE l.SOHV <> (SELECT count(MSHV) 
								FROM HocVien 
								WHERE HocVien.Malop = l.Malop))
		begin
			raiserror (N'Số học viên của một lớp không bằng số lượng học viên tại lớp đó',15,1)
			rollback tran
		end
go

select * from Lop
Set dateformat dmy
go
INSERT INTO Lop values('P001',N'Photoshop','1/11/2018',250000,1,100,0,'G004')

update Lop set SoHV = 35 where MaLop = 'P001'

--4c) Tổng số tiền thu của một học viên không vượt quá học phí của lớp mà học viên đó đăng ký học
ALTER TRIGGER trg_HocPhi
On HocPhi for insert, update
As
    If exists(SELECT *
			  FROM HocVien A, Lop B, HocPhi C
			  WHERE A.MaLop = B.MaLop and A.MSHV = C.MSHV
			  GROUP BY A.MSHV, B.HocPhi
			  HAVING SUM(C.SoTien) > B.HocPhi
			 )
		Begin
			raiserror (N'Tổng tiền thu của một học viên vượt quá học phí của lớp!', 15, 1);
			rollback tran
		End
go

SELECT * FROM HocPhi
UPDATE HocPhi
SET SoTien = 10000
WHERE SoBL = '0001'

------------------HÀM----------------
--6a) Hàm tính tổng số học phí đã thu được của một lớp khi biết mã lớp.
CREATE FUNCTION fn_TongHocPhi1Lop(@malop char(4)) returns int
As
Begin
	DECLARE @TongTien int

	If exists(SELECT * FROM Lop WHERE MaLop = @MaLop)
		Begin
			SELECT @TongTien = SUM(SoTien)
			FROM HocPhi A, HocVien B	
			WHERE A.MSHV = B.MSHV and B.Malop = @malop
		End	
	 	
	RETURN @TongTien
End

print dbo.fn_TongHocPhi1Lop('A075')

--6b) Hàm tính tổng số học phí thu được trong một khoảng thời gian cho trước. 
CREATE FUNCTION fn_TongHocPhiTheoThoiGian(@NgayBD DATE, @NgayKT DATE) returns int  
As  
Begin 
    DECLARE @TongTien int 

    SELECT @TongTien = SUM(SoTien)  
    FROM HocPhi  
    WHERE NgayThu between @NgayBD and @NgayKT 

    RETURN @TongTien
END
go

set dateformat dmy

print dbo.fn_TongHocPhiTheoThoiGian('1/1/2008', '15/1/2008')

--6c) Cho biết một học viên cho trước đã nộp đủ học phí hay chưa. 
ALTER FUNCTION fn_KiemTraHocPhi(@MSHV char(6)) returns nvarchar(50)  
As  
Begin  
    DECLARE @TongTien int  
    DECLARE @HocPhi int
    DECLARE @MaLop char(4)
	DECLARE @KetQua nvarchar(50)

    SELECT @MaLop = MaLop FROM HocVien WHERE MSHV = @MSHV 
    SELECT @HocPhi = HocPhi FROM Lop WHERE MaLop = @MaLop

    SELECT @TongTien = SUM(SoTien)  
    FROM HocPhi  
    WHERE MSHV = @MSHV

    If @TongTien >= @HocPhi  
        set @KetQua = N'Đã nộp đủ học phí'
    Else  
        set @KetQua = N'Chưa nộp đủ học phí'

	RETURN @KetQua
End 
go

print dbo.fn_KiemTraHocPhi('A07502')

--6d) Hàm sinh mã số học viên theo quy tắc mã số học viên gồm mã lớp của học viên kết hợp với số thứ tự của học viên trong lớp đó.
CREATE FUNCTION fn_SinhMaHocVien(@MaLop CHAR(4)) RETURNS CHAR(6)  
As  
Begin  
    DECLARE @SoThuTu int
    DECLARE @MaHocVien char(6)

    SELECT @SoThuTu = COUNT(*) + 1  
    FROM HocVien  
    WHERE MaLop = @MaLop

    SET @MaHocVien = @MaLop + RIGHT('000' + CONVERT(varchar(3), @SoThuTu), 2) 

    RETURN @MaHocVien
End
go
---
CREATE PROC usp_ThemHocVien2
	@Ho nvarchar(20), @Ten nvarchar(10), @NgaySinh Datetime,
    @Phai nvarchar(4), @MaLop char(4)
As
Begin
    DECLARE @MaHocVien char(6)

	If not exists(SELECT * FROM HocVien 
				where Ho = @Ho and Ten = @Ten and NgaySinh = @NgaySinh and Phai = @Phai and MaLop = @MaLop)
		Begin
			SET @MaHocVien = dbo.fn_SinhMaHocVien(@MaLop)

			INSERT INTO HocVien values(@MaHocVien, @Ho, @Ten, @NgaySinh, @Phai, @MaLop)
			print N'Đã thêm học viên thành công'
		End
	Else
		print N'Đã có học viên ' + @Ho +' ' + @Ten + ' trong CSDL'
End
go

set dateformat dmy
exec usp_ThemHocVien2 N'Nguyễn', N'Văn A', '08/02/2005', N'Nam', 'A075'
exec usp_ThemHocVien2 N'Lê', N'Anh Khoa', '10/02/2005', N'Nam', 'A075'

SELECT * FROM HocVien