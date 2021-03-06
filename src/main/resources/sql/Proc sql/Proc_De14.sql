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



create
proc [dbo].[sp_DanhSachPhongBan]
as
select *
from PhongBan
order by TenPB
    GO


create
proc [dbo].[sp_DanhSachNhanVien]
as
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , HoTen = a.TenNV
     , a.LuongCB
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
    GO



create
proc [dbo].[Sp_XoaNhanVien]
@MaNV int
as
delete
    NhanVien
where MaNV = @MaNV
    GO



create
proc [dbo].[sp_TimNV]
@DieuKienTim tinyint,
@NoiDungTim nvarchar(50)
as
	if (@DieuKienTim=0) --tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , HoTen = a.TenNV
     , a.LuongCB
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
    else
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , HoTen = a.TenNV
     , a.LuongCB
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
  and a.TenNV like '%' + @NoiDungTim + '%'
    GO



alter
proc [dbo].[sp_CapNhatNhanVien]
@MaNV int,
@TenNV nvarchar(50),
@LuongCB int,
@MaPB int,
@TaiKhoan varchar(20),
@MatKhau varchar(50)
as
		if @MaNV =0  -- them mới
begin if
exists ( select * from NhanVien where TaiKhoan = @TaiKhoan)
select TB = N'Đã tồn tại tài khoản này. Vui lòng nhập lại tài khoản khác.'
    else
begin
insert into NhanVien(TenNV, LuongCB, MaPB, TaiKhoan, MatKhau)
values (@TenNV, @LuongCB, @MaPB, @TaiKhoan, PWDENCRYPT(@MatKhau))
select TB = N'Cập nhật thành công'
           end
    end
    else -- sửa
begin
update NhanVien
set TenNV    = @TenNV,
    LuongCB  =@LuongCB,
    MaPB     =@MaPB,
    TaiKhoan = @TaiKhoan
where MaNV = @MaNV
select TB = N'Cập nhật thành công'
           end
    GO


create
proc sp_ResetMatKhau
@MaNV int
as
update NHANVIEN
set MatKhau =PWDENCRYPT('123')
where MANV = @MaNV
    - - - - - - - - - - - - - ----


alter
proc sp_DanhSachNhanVienvaPhongBan
as
select a.MaNV, HoTen = b.TenPB + ' - ' + a.TenNV
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
order by b.TenPB


create
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
create
proc sp_ThongKe
@Nam int
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
where YEAR(a.NgayKTDA) = @Nam
  and a.MaDA = c.MaDA
  and c.MaNV = b.MANV
  and b.MaPB = d.MaPB
