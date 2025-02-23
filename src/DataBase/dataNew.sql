USE QLNH
GO

-----------------Bảng NguoiDung ----------------------------
CREATE TABLE NguoiDung (
    ID_ND NUMERIC(8,0) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Matkhau VARCHAR(20) NOT NULL,
    VerifyCode VARCHAR(10) NULL,
    Trangthai VARCHAR(10) DEFAULT '',
    Vaitro VARCHAR(20) NOT NULL
);

ALTER TABLE NguoiDung
    ADD CONSTRAINT ND_Vaitro_Ten CHECK (Vaitro IN ('Khach Hang', 'Nhan Vien', 'Nhan Vien Kho', 'Quan Ly'));

ALTER TABLE NguoiDung
    ADD CONSTRAINT NguoiDung_PK PRIMARY KEY (ID_ND);


--Bang NhanVien
CREATE TABLE NhanVien (
    ID_NV NUMERIC(8,0) NOT NULL,
    TenNV VARCHAR(50) NOT NULL,
    NgayVL DATE NOT NULL,
    SDT VARCHAR(50) NOT NULL,
    Chucvu VARCHAR(50) NOT NULL,
    ID_ND NUMERIC(8,0) NULL,
    ID_NQL NUMERIC(8,0) NOT NULL,
    Tinhtrang VARCHAR(20) NOT NULL
);

ALTER TABLE NhanVien
    ADD CONSTRAINT NV_Chucvu_Thuoc CHECK (Chucvu IN ('Phuc vu', 'Tiep tan', 'Thu ngan', 'Bep', 'Kho', 'Quan ly'));

ALTER TABLE NhanVien
    ADD CONSTRAINT NV_Tinhtrang_Thuoc CHECK (Tinhtrang IN ('Dang lam viec', 'Da nghi viec'));

ALTER TABLE NhanVien
    ADD CONSTRAINT NV_PK PRIMARY KEY (ID_NV);

ALTER TABLE NhanVien
    ADD CONSTRAINT NV_fk_idND FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND);

ALTER TABLE NhanVien
    ADD CONSTRAINT NV_fk_idNQL FOREIGN KEY (ID_NQL) REFERENCES NhanVien(ID_NV);

------------Bang KhachHang-----------------
CREATE TABLE KhachHang (
    ID_KH NUMERIC(8,0) NOT NULL,
    TenKH VARCHAR(50) NOT NULL,
    Ngaythamgia DATE NOT NULL,
    Doanhso NUMERIC(10,0) NOT NULL DEFAULT 0,
    Diemtichluy NUMERIC(5,0) NOT NULL DEFAULT 0,
    ID_ND NUMERIC(8,0) NOT NULL
);


ALTER TABLE KhachHang
    ADD CONSTRAINT KhachHang_PK PRIMARY KEY (ID_KH);

ALTER TABLE KhachHang
    ADD CONSTRAINT KH_fk_idND FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND);

-----------Bảng MonAn ----------------
-- DROP TABLE IF EXISTS MonAn;

CREATE TABLE MonAn (
    ID_MonAn NUMERIC(8,0) NOT NULL,
    TenMon VARCHAR(50) NOT NULL,
    DonGia NUMERIC(8,0) NOT NULL,
    Loai VARCHAR(50) NOT NULL,
    TrangThai VARCHAR(30) NOT NULL
);

-- Ràng buộc kiểm tra
ALTER TABLE MonAn
    ADD CONSTRAINT MA_Loai_Ten CHECK (Loai IN ('Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                                                'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'));

ALTER TABLE MonAn
    ADD CONSTRAINT MA_TrangThai_Thuoc CHECK (TrangThai IN ('Dang kinh doanh','Ngung kinh doanh'));

-- Khóa chính
ALTER TABLE MonAn
    ADD CONSTRAINT MonAn_PK PRIMARY KEY (ID_MonAn);


--------------Bảng Bàn ------------------
CREATE TABLE Ban (
    ID_Ban NUMERIC(8,0) NOT NULL,
    TenBan VARCHAR(50) NOT NULL,
    Vitri VARCHAR(50) NOT NULL,
    Trangthai VARCHAR(50) NOT NULL
);

ALTER TABLE Ban
    ADD CONSTRAINT Ban_Trangthai_Ten CHECK (Trangthai IN ('Con trong','Dang dung bua','Da dat truoc'));

-- Khóa chính
ALTER TABLE Ban
    ADD CONSTRAINT Ban_PK PRIMARY KEY (ID_Ban);


------Bảng VOucher----------
-- DROP TABLE IF EXISTS Voucher;

CREATE TABLE Voucher (
    Code_Voucher VARCHAR(10) NOT NULL,
    Mota VARCHAR(50) NOT NULL,
    Phantram NUMERIC(3,0) NOT NULL,
    LoaiMA VARCHAR(50) NOT NULL,
    SoLuong NUMERIC(3,0) NOT NULL,
    Diem NUMERIC(8,0) NOT NULL
);

ALTER TABLE Voucher
    ADD CONSTRAINT V_Phantram_NNULL CHECK (Phantram > 0 AND Phantram <= 100);

ALTER TABLE Voucher
    ADD CONSTRAINT V_LoaiMA_Thuoc CHECK (LoaiMA IN ('All','Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                                                     'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'));

ALTER TABLE Voucher
    ADD CONSTRAINT Voucher_PK PRIMARY KEY (Code_Voucher);

--------------Bảng HoaDon--------------
-- DROP TABLE IF EXISTS HoaDon;

CREATE TABLE HoaDon (
    ID_HoaDon NUMERIC(8,0) NOT NULL,
    ID_KH NUMERIC(8,0) NOT NULL,
    ID_Ban NUMERIC(8,0) NOT NULL,
    NgayHD DATE NOT NULL,
    TienMonAn NUMERIC(8,0) NOT NULL,
    Code_Voucher VARCHAR(10) NULL,
    TienGiam NUMERIC(8,0) NOT NULL,
    Tongtien NUMERIC(10,0) NOT NULL,
    Trangthai VARCHAR(50) NOT NULL
);

ALTER TABLE HoaDon
    ADD CONSTRAINT HD_TrangThai CHECK (Trangthai IN ('Chua thanh toan','Da thanh toan'));

-- Khóa chính
ALTER TABLE HoaDon
    ADD CONSTRAINT HD_PK PRIMARY KEY (ID_HoaDon);

-- Khóa ngoại
ALTER TABLE HoaDon
    ADD CONSTRAINT HD_fk_idKH FOREIGN KEY (ID_KH) REFERENCES KhachHang(ID_KH);

ALTER TABLE HoaDon
    ADD CONSTRAINT HD_fk_idBan FOREIGN KEY (ID_Ban) REFERENCES Ban(ID_Ban);


	---------------. Bảng CTHD -------------------------
-- DROP TABLE IF EXISTS CTHD;

CREATE TABLE CTHD (
    ID_HoaDon NUMERIC(8,0) NOT NULL,
    ID_MonAn NUMERIC(8,0) NOT NULL,
    SoLuong NUMERIC(3,0) NOT NULL,
    Thanhtien NUMERIC(10,0) NOT NULL
);

-- Khóa chính
ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_PK PRIMARY KEY (ID_HoaDon, ID_MonAn);

-- Khóa ngoại
ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_fk_idHD FOREIGN KEY (ID_HoaDon) REFERENCES HoaDon(ID_HoaDon);

ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_fk_idMonAn FOREIGN KEY (ID_MonAn) REFERENCES MonAn(ID_MonAn);

-------------Bảng NguyenLieu-----------------------
-- DROP TABLE IF EXISTS NguyenLieu;
CREATE TABLE NguyenLieu (
    ID_NL NUMERIC(8,0) NOT NULL,
    TenNL VARCHAR(50) NOT NULL,
    Dongia NUMERIC(8,0) NOT NULL,
    Donvitinh VARCHAR(50) NOT NULL
);

ALTER TABLE NguyenLieu
    ADD CONSTRAINT NL_DVT_Thuoc CHECK (Donvitinh IN ('g','kg','ml','l'));

-- Khóa chính
ALTER TABLE NguyenLieu
    ADD CONSTRAINT NL_PK PRIMARY KEY (ID_NL);

-----------Bảng Kho------------
-- DROP TABLE IF EXISTS Kho;

CREATE TABLE Kho (
    ID_NL NUMERIC(8,0) NOT NULL,
    SLTon NUMERIC(3,0) NOT NULL DEFAULT 0
);

-- Khóa chính
ALTER TABLE Kho
    ADD CONSTRAINT Kho_pk PRIMARY KEY (ID_NL);

-- Khóa ngoại
ALTER TABLE Kho
    ADD CONSTRAINT Kho_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);


----------Bảng PhieuNK------------------
-- DROP TABLE IF EXISTS PhieuNK;

CREATE TABLE PhieuNK (
    ID_NK NUMERIC(8,0) NOT NULL,
    ID_NV NUMERIC(8,0) NOT NULL,
    NgayNK DATE NOT NULL,
    Tongtien NUMERIC(10,0) NOT NULL DEFAULT 0
);

-- Khóa chính
ALTER TABLE PhieuNK
    ADD CONSTRAINT PNK_PK PRIMARY KEY (ID_NK);

-- Khóa ngoại
ALTER TABLE PhieuNK
    ADD CONSTRAINT PNK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV);

------------------Bảng CTNK---------------
-- DROP TABLE IF EXISTS CTNK;

CREATE TABLE CTNK (
    ID_NK NUMERIC(8,0) NOT NULL,
    ID_NL NUMERIC(8,0) NOT NULL,
    SoLuong NUMERIC(3,0) NOT NULL,
    Thanhtien NUMERIC(10,0) NOT NULL
);

-- Khóa chính
ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_PK PRIMARY KEY (ID_NK, ID_NL);

-- Khóa ngoại
ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_fk_idNK FOREIGN KEY (ID_NK) REFERENCES PhieuNK(ID_NK);

ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);

-------------------Bảng PhieuXK----------------
-- DROP TABLE IF EXISTS PhieuXK;

CREATE TABLE PhieuXK (
    ID_XK NUMERIC(8,0) NOT NULL,
    ID_NV NUMERIC(8,0) NOT NULL,
    NgayXK DATE NOT NULL
);

-- Khóa chính
ALTER TABLE PhieuXK
    ADD CONSTRAINT PXK_PK PRIMARY KEY (ID_XK);

-- Khóa ngoại
ALTER TABLE PhieuXK
    ADD CONSTRAINT PXK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV);

--------------------Bảng CTXK-------------------------
-- DROP TABLE IF EXISTS CTXK;

CREATE TABLE CTXK (
    ID_XK NUMERIC(8,0) NOT NULL,
    ID_NL NUMERIC(8,0) NOT NULL,
    SoLuong NUMERIC(3,0) NOT NULL
);

-- Khóa chính
ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_PK PRIMARY KEY (ID_XK, ID_NL);

-- Khóa ngoại
ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_fk_idXK FOREIGN KEY (ID_XK) REFERENCES PhieuXK(ID_XK);

ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);






































	--Them data
SET DATEFORMAT dmy;
--Them data cho Bang NguoiDung
--Nhan vien
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (100,'NVHoangViet@gmail.com','123','Verified','Quan Ly');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (101,'NVHoangPhuc@gmail.com','123','Verified','Nhan Vien');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (102,'NVAnhHong@gmail.com','123','Verified','Nhan Vien Kho');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (103,'NVQuangDinh@gmail.com','123','Verified','Nhan Vien');
--Khach Hang
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (104,'KHThaoDuong@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (105,'KHTanHieu@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (106,'KHQuocThinh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (107,'KHNhuMai@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (108,'KHBichHao@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (109,'KHMaiQuynh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (110,'KHMinhQuang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (111,'KHThanhHang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (112,'KHThanhNhan@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (113,'KHPhucNguyen@gmail.com','123','Verified','Khach Hang');

--Them data cho bang Nhan Vien
SET DATEFORMAT dmy;
--Co tai khoan
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (100,'Nguyen Hoang Viet','10/05/2023','0848044725','Quan ly',100,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (101,'Nguyen Hoang Phuc','20/05/2023','0838033334','Tiep tan',101,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (102,'Le Thi Anh Hong','19/05/2023','0838033234','Kho',102,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (103,'Ho Quang Dinh','19/05/2023','0838033234','Tiep tan',103,100,'Dang lam viec');
--Khong co tai khoan
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (104,'Ha Thao Duong','10/05/2023','0838033232','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (105,'Nguyen Quoc Thinh','11/05/2023','0838033734','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (106,'Truong Tan Hieu','12/05/2023','0838033834','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (107,'Nguyen Thai Bao','10/05/2023','0838093234','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (108,'Tran Nhat Khang','11/05/2023','0838133234','Thu ngan',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (109,'Nguyen Ngoc Luong','12/05/2023','0834033234','Bep',100,'Dang lam viec');

--Them data cho bang KhachHang
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (100,'Ha Thao Duong','10/05/2023',104);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (101,'Truong Tan Hieu','10/05/2023',105);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (102,'Nguyen Quoc Thinh','10/05/2023',106);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (103,'Tran Nhu Mai','10/05/2023',107);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (104,'Nguyen Thi Bich Hao','10/05/2023',108);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (105,'Nguyen Mai Quynh','11/05/2023',109);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (106,'Hoang Minh Quang','11/05/2023',110);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (107,'Nguyen Thanh Hang','12/05/2023',111);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (108,'Nguyen Ngoc Thanh Nhan','11/05/2023',112);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (109,'Hoang Thi Phuc Nguyen','12/05/2023',113);

--Them data cho bang MonAn
--Aries
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(1,'DUI CUU NUONG XE NHO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(2,'BE SUON CUU NUONG GIAY BAC MONG CO', 230000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(3,'DUI CUU NUONG TRUNG DONG', 350000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(4,'CUU XOC LA CA RI', 129000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(5,'CUU KUNGBAO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(6,'BAP CUU NUONG CAY', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(7,'CUU VIEN HAM CAY', 19000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(8,'SUON CONG NUONG MONG CO', 250000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(9,'DUI CUU LON NUONG TAI BAN', 750000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(10,'SUONG CUU NUONG SOT NAM', 450000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(11,'DUI CUU NUONG TIEU XANH', 285000,'Aries','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(12,'SUON CUU SOT PHO MAI', 450000,'Aries','Dang kinh doanh');

--Taurus
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(13,'Bit tet bo My khoai tay', 179000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(14,'Bo bit tet Uc',169000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(15,'Bit tet bo My BASIC', 179000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(16,'My Y bo bam', 169000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(17,'Thit suon Wagyu', 1180000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(18,'Steak Thit Vai Wagyu', 1290000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(19,'Steak Thit Bung Bo', 550000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(20,'Tomahawk', 2390000,'Taurus','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(21,'Salad Romaine Nuong', 180000,'Taurus','Dang kinh doanh');

--Gemini
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(22,'Combo Happy', 180000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(23,'Combo Fantastic', 190000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(24,'Combo Dreamer', 230000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(25,'Combo Cupid', 180000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(26,'Combo Poseidon', 190000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(27,'Combo LUANG PRABANG', 490000,'Gemini','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(28,'Combo VIENTIANE', 620000,'Gemini','Dang kinh doanh');

--Cancer
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(29,'Cua KingCrab Duc sot', 3650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(30,'Mai Cua KingCrab Topping Pho Mai', 2650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(31,'Cua KingCrab sot Tu Xuyen', 2300000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(32,'Cua KingCrab Nuong Tu Nhien', 2550000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(33,'Cua KingCrab Nuong Bo Toi', 2650000,'Cancer','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(34,'Com Mai Cua KingCrab Chien', 1850000,'Cancer','Dang kinh doanh');

--Leo
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(35,'BOSSAM', 650000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(36,'KIMCHI PANCAKE', 350000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(37,'SPICY RICE CAKE', 250000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(38,'SPICY SAUSAGE HOTPOT', 650000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(39,'SPICY PORK', 350000,'Leo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(40,'MUSHROOM SPICY SILKY TOFU STEW', 350000,'Leo','Dang kinh doanh');
--Virgo
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(41,'Pavlova', 150000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(42,'Kesutera', 120000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(43,'Cremeschnitte', 250000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(44,'Sachertorte', 150000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(45,'Schwarzwalder Kirschtorte', 250000,'Virgo','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(46,'New York-Style Cheesecake', 250000,'Virgo','Dang kinh doanh');

--Libra
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(47,'Cobb Salad', 150000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(48,'Salad Israeli', 120000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(49,'Salad Dau den', 120000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(50,'Waldorf Salad', 160000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(51,'Salad Gado-Gado', 200000,'Libra','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(52,'Nicoise Salad', 250000,'Libra','Dang kinh doanh');

--Scorpio
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(53,'BULGOGI LUNCHBOX', 250000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(54,'CHICKEN TERIYAKI LUNCHBOX', 350000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(55,'SPICY PORK LUNCHBOX', 350000,'Scorpio','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(56,'TOFU TERIYAKI LUNCHBOX', 250000,'Scorpio','Dang kinh doanh');

--Sagittarius
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(57,'Thit ngua do tuoi', 250000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(58,'Steak Thit ngua', 350000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(59,'Thit ngua ban gang', 350000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(60,'Long ngua xao dua', 150000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(61,'Thit ngua xao sa ot', 250000,'Sagittarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(62,'Ngua tang', 350000,'Sagittarius','Dang kinh doanh');

--Capricorn
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(63,'Thit de xong hoi', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(64,'Thit de xao rau ngo', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(65,'Thit de nuong tang', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(66,'Thit de chao', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(67,'Thit de nuong xien', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(68,'Nam de nuong/chao', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(69,'Thit de xao lan', 19000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(70,'Dui de tan thuoc bac', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(71,'Canh de ham duong quy', 199000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(72,'Chao de dau xanh', 50000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(73,'Thit de nhung me', 229000,'Capricorn','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(74,'Lau de nhu', 499000,'Capricorn','Dang kinh doanh');


--Aquarius
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(75,'SIGNATURE WINE', 3290000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(76,'CHILEAN WINE', 3990000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(77,'ARGENTINA WINE', 2890000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(78,'ITALIAN WINE', 5590000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(79,'AMERICAN WINE', 4990000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(80,'CLASSIC COCKTAIL', 200000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(81,'SIGNATURE COCKTAIL', 250000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(82,'MOCKTAIL', 160000,'Aquarius','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(83,'JAPANESE SAKE', 1490000,'Aquarius','Dang kinh doanh');

--Pisces
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(84,'Ca Hoi Ngam Tuong', 289000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(85,'Ca Ngu Ngam Tuong', 289000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(86,'IKURA:Trung ca hoi', 189000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(87,'KARIN:Sashimi Ca Ngu', 149000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(88,'KEIKO:Sashimi Ca Hoi', 199000,'Pisces','Dang kinh doanh');
insert into MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) values(89,'CHIYO:Sashimi Bung Ca Hoi', 219000,'Pisces','Dang kinh doanh');

--Them data cho bang Ban
--Tang 1
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(100,'Ban T1.1','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(101,'Ban T1.2','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(102,'Ban T1.3','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(103,'Ban T1.4','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(104,'Ban T1.5','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(105,'Ban T1.6','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(106,'Ban T1.7','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(107,'Ban T1.8','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(108,'Ban T1.9','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(109,'Ban T1.10','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(110,'Ban T1.11','Tang 1','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(111,'Ban T1.12','Tang 1','Con trong');
--Tang 2
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(112,'Ban T2.1','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(113,'Ban T2.2','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(114,'Ban T2.3','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(115,'Ban T2.4','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(116,'Ban T2.5','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(117,'Ban T2.6','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(118,'Ban T2.7','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(119,'Ban T2.8','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(120,'Ban T2.9','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(121,'Ban T2.10','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(122,'Ban T2.11','Tang 2','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(123,'Ban T2.12','Tang 2','Con trong');
--Tang 3
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(124,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(125,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(126,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(127,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(128,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(129,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(130,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(131,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(132,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(133,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(134,'Ban T3.1','Tang 3','Con trong');
insert into Ban(ID_Ban,TenBan,Vitri,Trangthai) values(135,'Ban T3.1','Tang 3','Con trong');

--Them data cho bang Voucher
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('loQy','20% off for Aries Menu',20,'Aries',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('pCfI','30% off for Taurus Menu',30,'Taurus',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('pApo','20% off for Gemini Menu',20,'Gemini',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('ugQx','100% off for Virgo Menu',100,'Virgo',3,500);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('nxVX','20% off for All Menu',20,'All',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('Pwyn','20% off for Cancer Menu',20,'Cancer',10,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('bjff','50% off for Leo Menu',50,'Leo',5,600);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('YPzJ','20% off for Aquarius Menu',20,'Aquarius',5,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('Y5g0','30% off for Pisces Menu',30,'Pisces',5,300);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('7hVO','60% off for Aries Menu',60,'Aries',0,1000);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('WHLm','20% off for Capricorn Menu',20,'Capricorn',0,200);
insert into Voucher(Code_Voucher, Phantram,LoaiMA,SoLuong,Diem) values ('GTsC','20% off for Leo Menu',20,'Leo',0,200);

--Them data cho bang HoaDon
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (101,100,100,'10-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (102,104,102,'15-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (103,105,103,'20-1-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (104,101,101,'13-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (105,103,120,'12-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (106,104,100,'16-3-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (107,107,103,'20-3-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (108,108,101,'10-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (109,100,100,'20-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (110,103,101,'5-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (111,106,102,'10-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (112,108,103,'15-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (113,106,102,'20-5-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (114,108,103,'5-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (115,109,104,'7-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (116,100,105,'7-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (117,106,106,'10-6-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (118,102,106,'10-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (119,103,106,'12-2-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (120,104,106,'10-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (121,105,106,'12-4-2023',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (122,107,106,'12-5-2023',0,0,'Chua thanh toan');

--Them data cho CTHD
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,3,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,10,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,2,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,4,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (103,12,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,30,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,59,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,28,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,88,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,70,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,75,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,78,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,32,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,12,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,12,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,40,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (109,45,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,34,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,43,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,65,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,47,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,49,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,31,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (113,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (113,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,30,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,32,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (115,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,57,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,34,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,67,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,66,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,34,10);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,35,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,83,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,78,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,38,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,39,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,53,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,31,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,33,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,34,6);
UPDATE HOADON SET TrangThai='Da thanh toan';

--Them data cho bang NguyenLieu
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(100,'Thit ga',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(101,'Thit heo',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(102,'Thit bo',80000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(103,'Tom',100000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(104,'Ca hoi',500000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(105,'Gao',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(106,'Sua tuoi',40000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(107,'Bot mi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(108,'Dau ca hoi',1000000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(109,'Dau dau nanh',150000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(110,'Muoi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(111,'Duong',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(112,'Hanh tay',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(113,'Toi',30000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(114,'Dam',50000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(115,'Thit de',130000,'kg');

--Them data cho PhieuNK
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (100,102,'10-01-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (101,102,'11-02-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (102,102,'12-02-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (103,102,'12-03-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (104,102,'15-03-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (105,102,'12-04-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (106,102,'15-04-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (107,102,'12-05-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (108,102,'15-05-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (109,102,'5-06-2023');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (110,102,'7-06-2023');

--Them data cho CTNK
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,100,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,101,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,101,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,103,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,104,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,105,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,106,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,107,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,108,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,109,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,110,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (105,110,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,102,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,115,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,110,35);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,105,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,104,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,103,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,106,30);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,106,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,107,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,110,20);

--Them data cho PhieuXK
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (100,102,'10-01-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (101,102,'11-02-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (102,102,'12-03-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (103,102,'13-03-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (104,102,'12-04-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (105,102,'13-04-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (106,102,'12-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (107,102,'15-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (108,102,'20-05-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (109,102,'5-06-2023');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (110,102,'10-06-2023');

--Them data cho CTXK
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,100,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,101,7);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,103,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,106,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,109,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,112,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,113,8);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,103,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,106,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,115,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,114,5);

SELECT TOP 1 * FROM NguoiDung WHERE Email = '1@gmail.com' AND Matkhau = '123' AND Trangthai = 'Verified'
Select * from NguoiDung