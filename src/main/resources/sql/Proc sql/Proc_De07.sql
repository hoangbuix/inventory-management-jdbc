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
proc sp_DanhSachGiaiDau
as
select *
from GiaiDau



alter
proc sp_DSVDVTheoGiaiDau
@MaGiai int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaVDV asc),
       a.MaVDV,
       a.MaGiai,
       a.HoTen,
       a.NGAYSINH,
       a.NoiSinh
from VDV a
where a.MaGiai = @MaGiai


alter
proc sp_ThemVDV
@HoTen nvarchar(50),
@NgaySinh smalldatetime,
@NoiSinh nvarchar(50),
@MaGiai int
as
	if GETDATE() >= (select NgayBatDau -5 from GiaiDau where MaGiai = @MaGiai)
select TB = N'Đã hết hạn đăng kí'
    else
begin
insert into VDV (HoTen, NgaySinh, NoiSinh, MaGiai)
values (@HoTen, @NgaySinh, @NoiSinh, @MaGiai)
select TB = N'Đăng kí thành công'
           end



create
proc sp_SuaVDV
@MaVDV int,
@HoTen nvarchar(50),
@NgaySinh smalldatetime,
@NoiSinh nvarchar(50),
@MaGiai int
as
	if GETDATE() >= (select NgayBatDau  from GiaiDau where MaGiai = @MaGiai)
select TB = 'Đã hết hạn chuyển sang giải đấu này.'
    else
begin
update VDV
set HoTen    = @HoTen,
    NgaySinh = @NgaySinh,
    NoiSinh  = @NoiSinh,
    MaGiai   =@MaGiai
where MaVDV = @MaVDV
select TB = 'Cập nhật thành công'
           end



ALTER
proc [dbo].[Sp_XoaVDV]
@MaVDV int,
@MaGiai int
as
	if GETDATE() >= (select NgayBatDau  from GiaiDau where MaGiai = @MaGiai)
select TB = 'Đã chốt danh sách.'
    else
begin
delete
    VDV
where MaVDV = @MaVDV
  and MaGiai = @MaGiai
select TB = 'Xóa thành công'
           end

create
proc sp_DanhSachChangDuongTheoGiaiDau
@MaGiai int
as
select *
from ChangDua
where MaGiai = @MaGiai


alter
proc sp_CapNhatThanhTich
@MaVDV int,
@MaChang int,
@ThanhTich nvarchar(50)
as
	if not exists( select * from  KetQua where MaChang = @MaChang and MaVDV = @MaVDV  )
insert into KetQua(MaVDV, MaChang, ThanhTich)
values (@MaVDV, @MaChang, @ThanhTich)
    else
update KetQua
set ThanhTich =@ThanhTich
where MaVDV = @MaVDV
  and MaChang = @MaChang



alter
proc sp_DSThanhTichVDVTheoGiaiDauvaChangDua
@MaChang int,
@MaGiai int
as
	if exists (select b.ThanhTich from KetQua b
								where b.MaChang = @MaChang )
select STT = ROW_NUMBER() OVER (ORDER BY a.MaVDV asc), a.*, b.ThanhTich, b.MaChang
from VDV a,
     KetQua b
where a.MaGiai = @MaGiai
  and b.MaChang = @MaChang
  and a.MaVDV = b.MaVDV
    else
select STT = ROW_NUMBER() OVER (ORDER BY a.MaVDV asc), a.*, ThanhTich = '', MaChang = 0
from VDV a
where a.MaGiai = @MaGiai


create
proc Sp_InThanhTich
@MaGiai int
as
select a.MaVDV, a.HoTen, a.NgaySinh, a.NoiSinh, c.TenChang, c.NgayDua, b.ThanhTich
from VDV a,
     KetQua b,
     ChangDua c
where a.MaVDV = b.MaVDV
  and b.MaChang = c.MaChang
  and a.MaGiai = @MaGiai


