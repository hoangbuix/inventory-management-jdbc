create
proc sp_KiemTraDangNhap
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
proc sp_ThemKhachHang
@KiHieu nvarchar(15), 
@TenCT nvarchar(200),
@DiaChi nvarchar(200),
@ThanhPho nvarchar(50),
@SoDienThoai int
as
insert into KhachHang(KiHieu, TenCT, DiaChi, ThanhPho, SoDienThoai)
values (@KiHieu, @TenCT, @DiaChi, @ThanhPho, @SoDienThoai)
select MaKH = @@IDENTITY


create
proc sp_SuaKhachHang
@MaKH int,
@KiHieu nvarchar(15), 
@TenCT nvarchar(200),
@DiaChi nvarchar(200),
@ThanhPho nvarchar(50),
@SoDienThoai int
as
update KhachHang
set KiHieu      =@KiHieu,
    TenCT       = @TenCT,
    DiaChi      = @DiaChi,
    ThanhPho    = @ThanhPho,
    SoDienThoai = @SoDienThoai
where MaKH = @MaKH


create
proc Sp_XoaKhachHang
@MaKH int
as
delete
    KhachHang
where MaKH = @MaKH


create
proc	sp_DanhSachSanPham
as
select *
from SanPham


create
proc	sp_DanhSachKhachHang
as
select *
from KhachHang


create
proc sp_ThemHoaDon
@MaKH int
as
insert into HoaDon(MaKH, NgayLapHD)
values (@MaKH, GETDATE())
select MaHD = @@IDENTITY


create
proc	sp_ThemChiTietHoaDon
@MaHoaDon int, 
@MaSanPham int, 
@DonGia int, 
@SoLuong int
as
insert into ChiTietHoaDon(MaHD, MaSP, SoLuong, DonGia)
values (@MaHoaDon, @MaSanPham, @SoLuong, @DonGia) sp_ThongKeBanHang '1/1/1997','1/15/1997'
	
	
	sp_ThongKeKhachHang 1,1997

alter
proc sp_ThongKeKhachHang
@Thang int,
@Nam int
as
select d.MaKH, d.TenCT, d.KiHieu, TongThanhTien = SUM(c.SoLuong * c.DonGia)
from HoaDon a,
     KhachHang d,
     ChiTietHoaDon c
where a.MaKH = d.MaKH
  and a.MaHD = c.MaHD
  and month(
              a.NgayLapHD) = @Thang
  and YEAR(a.NgayLapHD) = @Nam
group by d.MaKH, d.TenCT, d.KiHieu
order by SUM(c.SoLuong * c.DonGia) desc

select *
from KhachHang