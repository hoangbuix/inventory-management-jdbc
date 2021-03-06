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
proc sp_ThemSanPham
@TenSanPham nvarchar(100), 
@DonViTinh nvarchar(20),
@DonGia int, 
@SoLuong int,
@Hinh image
as
insert into SanPham(TenSP, DVT, DonGia, soLuong, Hinh)
values (@TenSanPham, @DonViTinh, @DonGia, @soLuong, @Hinh)
select MaSP = @@IDENTITY


create
proc sp_SuaSanPham
@MaSP int,
@TenSanPham nvarchar(100), 
@DonViTinh nvarchar(20), 
@DonGia int, 
@SoLuong int,
@Hinh image
as
update SanPham
set TenSP   =@TenSanPham,
    DVT     = @DonViTinh,
    DonGia  = @DonGia,
    SoLuong = @SoLuong,
    Hinh    = @Hinh
where MaSP = @MaSP


create
proc Sp_XoaSanPham
@MaSP int
as
delete
    SanPham
where MaSP = @MaSP


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


alter
proc sp_ThongKeBanHang
@TuNgay smalldatetime,
@DenNgay smalldatetime
as
select a.*,
       d.TenCT,
       ThanhTien = (select sum(b.SoLuong * b.DonGia)
                    from ChiTietHoaDon b
                    where b.MaHD = a.MaHD
                    group by b.MaHD)
from HoaDon a,
     KhachHang d
where a.MaKH = d.MaKH
  and a.NgayLapHD between @TuNgay and @DenNgay
order by a.NgayLapHD