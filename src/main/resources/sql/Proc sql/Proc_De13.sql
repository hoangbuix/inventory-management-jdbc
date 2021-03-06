create
proc [dbo].[sp_KiemTraDangNhap]
@TaiKhoan varchar(20),
@MatKhau varchar(20)
as
	if exists(select * from NhanVien a
				where a.taikhoan = @TaiKhoan
				and PWDCOMPARE(@MatKhau, MatKhau) = 1 )
select MaTB = 1,
       TB = N'Đăng nhập thành công'
    else
select MaTB = 0, TB = N'Hãy kiểm tra lại tài khoản và mật khẩu'



create
proc sp_DSDeAn
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc)
     , a.MaDA
     , a.TenDA
     , a.NgayBDDA
     , a.NgayKTDA
from DEAN a



alter
proc sp_CapNhatDeAn
@MaDA int,
@TenDA nvarchar(100),
@NgayBatDau smalldatetime,
@NgayKetThuc smalldatetime
as
	if @MaDA =0 -- them mới
insert into DEAN(TenDA, NgayBDDA, NgayKTDA)
values (@TenDA, @NgayBatDau, @NgayBatDau)
    else
update DEAN
set TenDA    = @TenDA,
    NgayBDDA = @NgayBatDau,
    NgayKTDA =@NgayKetThuc
where MaDA = @MaDA


create
proc sp_XoaDeAn
@MaDA int
as
delete
    DEAN
where MaDA = @MaDA


alter
proc sp_TimKiem
@DieuKienTim tinyint,
@NoiDungTim nvarchar(50)
as
	if @DieuKienTim =0 -- tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc)
     , a.MaDA
     , a.TenDA
     , a.NgayBDDA
     , a.NgayKTDA
from DEAN a else
		if @DieuKienTim =1 -- tên đề án
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc)
     , a.MaDA
     , a.TenDA
     , a.NgayBDDA
     , a.NgayKTDA
from DEAN a
where a.TenDA like '%' + @NoiDungTim + '%' else
			if @DieuKienTim =2 -- những đề án đã bắt đầu
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc)
     , a.MaDA
     , a.TenDA
     , a.NgayBDDA
     , a.NgayKTDA
from DEAN a
where a.NgayBDDA <= GETDATE()
  and a.NgayKTDA > GETDATE()
    else -- những đề án đã kết thúc
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc)
     , a.MaDA
     , a.TenDA
     , a.NgayBDDA
     , a.NgayKTDA
from DEAN a
where a.NgayKTDA <= GETDATE()

select GETDATE()
           - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ----

CREATE
proc sp_DanhSachPhongBan
as
select *
from PHONGBAN
order by TenPB desc



create
proc sp_DSNVTheoPhongBanChuaPhanCongDeAn
@MaPB int,
@MaDA int
as
select *
from NHANVIEN a
where MaPB = @MaPB
  and a.MANV not in (select MaNV from PHANCONG where MaDA = @MaDA)
order by TenNV



alter
proc sp_DanhSachNhanVienTheoDeAn
@MaDA int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaNV asc),
       a.MANV,
       a.TenNV,
       c.TenPB,
       b.CongViec
from NHANVIEN a,
     PHANCONG b,
     PHONGBAN c
where a.MANV = b.MaNV
  and a.MaPB = c.MaPB
  and b.MaDA = @MaDA



create
proc sp_ThemPhanCong
@MaDA int,
@MaNV int,
@CongViec nvarchar(100)
as
insert into PHANCONG(MaDA, MaNV, CongViec)
values (@MaDA, @MaNV, @CongViec)


create
proc sp_XoaPhanCong
@MaNV int,
@MaDA int
as
delete
    PHANCONG
where MaNV = @MaNV
  and MaDA = @MaDA
    - - - - - - - - - - - - - - - - - - - - - - - - ----
alter
proc sp_ThongKe
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaDA asc),
       a.MaDA,
       a.TenDA,
       a.NgayBDDA,
       a.NgayKTDA,
       b.TenNV,
       d.TenPB,
       c.CongViec
from DEAN a,
     NHANVIEN b,
     PHANCONG c,
     PHONGBAN d
where a.NgayBDDA <= GETDATE()
  and a.NgayKTDA > GETDATE()
  and a.MaDA = c.MaDA
  and c.MaNV = b.MANV
  and b.MaPB = d.MaPB