/*	Học phần: Cơ sở dữ liệu
	Lab01:	Quản lý nhân viên
	SV thực hiện:	?????
	Mã SV:			??????
	Lớp:			CTK47A
	Thời gian:		14/2/2025 - ????????
*/
------------------LỆNH TẠO CẤU TRÚC CƠ SỞ DỮ LIỆU--------------
Create database	Lab01_QLNV	--Lệnh tạo CSDL Lab01_QLNV trống
go
Use	Lab01_QLNV	--Lệnh gọi sử dụng CSDL Lab01_QLNV
go
---Tạo bảng ChiNhanh
Create table ChiNhanh
(MSCN	char(2) primary key, ---khai báo khóa chính
TenCN	nvarchar(30) not null unique
)
go
---Tạo bảng ChiNhanh
Create table NhanVien
(MaNV	char(4) primary key,
Ho	nvarchar(20) not null,
Ten	nvarchar(10) not null,
NgaySinh DateTime not null,
NgayVaoLam DateTime not null,
MSCN char(2) references ChiNhanh(MSCN) --khai báo khóa ngoại
)
---Tạo bảng KyNang
Create table KyNang
(MSKN	char(2) primary key, ---khai báo khóa chính chỉ 1 thuộc tính
TenKN	nvarchar(30) not null unique
)
go
---Tạo bảng NhanVienKyNang
Create table NhanVienKyNang
(MaNV char(4) references NhanVien(MaNV),
MSKN	char(2) references KyNang(MSKN),
MucDo	tinyint	check (MucDo>=1 and MucDo <=9),--Kiểm tra MucDo phải thuộc phạm vi từ 1 đến 9
Primary key(MaNV, MSKN) --Khai báo khóa chính gồm nhiều thuộc tính
)
go
----Xem các bảng
Select * from ChiNhanh
Select * from NhanVien
Select * from KyNang
Select * from NhanVienKyNang
----------------NHẬP DỮ LIỆU CHO CÁC BẢNG-------
--Nhập bảng ChiNhanh
insert into ChiNhanh values('01', N'Quận 1')
insert into ChiNhanh values('02', N'Quận 5')
insert into ChiNhanh values('03', N'Bình Thạnh')
--Xem bảng ChiNhanh
Select * from ChiNhanh

--Nhập bảng NhanVien
Set Dateformat dmy --khai báo với SQL nhập ngày tháng theo dạng ngày/tháng/năm
go
insert into NhanVien values('0001',N'Lê Văn', N'Minh','10/06/1960','02/05/1986','01')
insert into NhanVien values('0002',N'Nguyễn Thị',N'Mai','20/04/1970','04/07/2001','01')
insert into NhanVien values('0003',N'Lê Anh',N'Tuấn','25/06/1975','01/09/1982','02')
insert into NhanVien values('0004',N'Vương Tuấn',N'Vũ','25/03/1975','12/01/1986','02')
insert into NhanVien values('0005',N'Lý Anh',N'Hân','01/12/1980','15/05/2004','02')
insert into NhanVien values('0006',N'Phan Lê',N'Tuấn','04/06/1976','25/10/2002','03')
insert into NhanVien values('0007',N'Lê Tuấn',N'Tú','15/08/1975','15/08/2000','03')
--Xem bảng NhanVien
Select * from NhanVien

--Nhập bảng KyNang
insert into KyNang values('01',N'Word')
insert into KyNang values('02',N'Excel')
insert into KyNang values('03',N'Access')
insert into KyNang values('04',N'Power Point')
insert into KyNang values('05',N'SPSS')
--Xem bảng KyNang
Select * from KyNang

--Nhập bảng nhanvienkynang
insert into NhanVienKyNang values('0001','01',2)
insert into NhanVienKyNang values('0001','02',1)
insert into NhanVienKyNang values('0002','01',2)
insert into NhanVienKyNang values('0002','03',2)
insert into NhanVienKyNang values('0003','02',1)
insert into NhanVienKyNang values('0003','03',2)
insert into NhanVienKyNang values('0004','01',5)
insert into NhanVienKyNang values('0004','02',4)
insert into NhanVienKyNang values('0004','03',1)
insert into NhanVienKyNang values('0004','04',3)
insert into NhanVienKyNang values('0004','05',4)
insert into NhanVienKyNang values('0005','02',4)
insert into NhanVienKyNang values('0005','04',4)
insert into NhanVienKyNang values('0006','05',4)
insert into NhanVienKyNang values('0006','02',4)
insert into NhanVienKyNang values('0006','03',2)
insert into NhanVienKyNang values('0007','03',4)
insert into NhanVienKyNang values('0007','04',3)
--Xem bảng NhanVienKyNang
Select * from NhanVienKyNang

-----------------TRUY VẤN DỮ LIỆU---------------
