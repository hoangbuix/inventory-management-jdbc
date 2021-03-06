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


alter
proc sp_DSKhachHang
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaKH asc)
     , a.MaKH
     , a.TenKH
     , a.DiaChi
     , b.MucDichSuDung
     , b.MaLoai
from KhachHang a,
     PhanLoai b
where a.MaLoai = b.MaLoai


create
proc sp_LoaiSuDung
as
select *
from PhanLoai


create
proc sp_ThemKhachHang
@MaKH int,
@TenKH nvarchar(50),
@DiaChi nvarchar(100),
@MaLoai int
as
	if @MaKH =0 -- them mới
insert into KhachHang(TenKH, DiaChi, MaLoai)
values (@TenKH, @DiaChi, @MaLoai)
    else
update KhachHang
set TenKH  = @TenKH,
    DiaChi = @DiaChi,
    MaLoai = @MaLoai
where MaKH = @MaKH


create
proc sp_XoaKhachHang
@MaKH int
as
delete
    KhachHang
where MaKH = @MaKH


alter
proc sp_TimKiem
@DieuKienTim tinyint,
@NoiDungTim nvarchar(50)
as
	if @DieuKienTim =0 -- tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.MaKH asc)
     , a.MaKH
     , a.TenKH
     , a.DiaChi
     , b.MucDichSuDung
     , b.MaLoai
from KhachHang a,
     PhanLoai b
where a.MaLoai = b.MaLoai else
		if @DieuKienTim =1 -- loại sử dụng
select STT = ROW_NUMBER() OVER (ORDER BY a.MaKH asc)
     , a.MaKH
     , a.TenKH
     , a.DiaChi
     , b.MucDichSuDung
     , b.MaLoai
from KhachHang a,
     PhanLoai b
where a.MaLoai = b.MaLoai
  and b.MucDichSuDung like '%' + @NoiDungTim + '%'
    else -- tên khach hang
select STT = ROW_NUMBER() OVER (ORDER BY a.MaKH asc)
     , a.MaKH
     , a.TenKH
     , a.DiaChi
     , b.MucDichSuDung
     , b.MaLoai
from KhachHang a,
     PhanLoai b
where a.MaLoai = b.MaLoai
  and a.TenKH like '%' + @NoiDungTim + '%'


create
proc sp_QuaTrinhSuDungNuocCuaKhachHang
@MaKH int
as
select a.TenKH, a.DiaChi, b.Thang, b.Nam, b.ChiSoDauKi, b.ChiSoCuoiKi
from KhachHang a,
     SuDung b
where a.MaKH = b.MaKH
  and a.MaKH = @MaKH
order by b.Thang, b.Nam


create
proc sp_ThemSuDung
@MaKH int,
@Thang int,
@Nam int,
@ChiSoDK int,
@ChiSoCuoiKi int
as
insert into SuDung(MaKH, Thang, Nam, ChiSoDauKi, ChiSoCuoiKi)
values (@MaKH, @Thang, @Nam, @ChiSoDK, @ChiSoCuoiKi)


create
proc sp_InHoaDon
@Thang int,
@Nam int
as
select *,
       ChiSoTieuThu = b.ChiSoCuoiKi - b.ChiSoDauKi,
       TrongDinhMuc = case
                          when b.ChiSoCuoiKi - b.ChiSoDauKi > c.DinhMuc then c.DinhMuc
                          else b.ChiSoCuoiKi - b.ChiSoDauKi
           end,
       NgoaiDinhMuc = case
                          when b.ChiSoCuoiKi - b.ChiSoDauKi > c.DinhMuc then b.ChiSoCuoiKi - b.ChiSoDauKi - c.DinhMuc
                          else 0
           end

from KhachHang a,
     SuDung b,
     PhanLoai c
where a.MaKH = b.MaKH
  and a.MaLoai = c.MaLoai
  and b.Thang = @Thang
  and b.Nam = @Nam