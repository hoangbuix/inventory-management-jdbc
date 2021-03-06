create
proc [dbo].[sp_DanhSachXe]
as
select *
from XeBus GO



CREATE
proc [dbo].[sp_DanhSachTaiXe]
as
select MaTaiXe, HoTenTX = HoTX + ' ' + TenTX, NgaySinh, DienThoai
from TaiXe GO



CREATE
proc [dbo].[sp_DanhSachLoTrinh]
as
select MaLoTrinh, TenLoTrinh, TuyenDuong = DiemXP + ' - ' + DiemDen, ThoiGian, GiaTien
from LoTrinh GO



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
select MaTB = 0,
       TB = N'Hãy kiểm tra lại tài khoản và mật khẩu'
           GO



CREATE
proc [dbo].[Sp_KiemTraBienSoXe]
@BienSo varchar(10)
as
select @BienSo if exists(select a.*  from XeBus a  where a.BienSo = @BienSo )
select TB = '1'
    else
select TB = '0'
           GO



CREATE
proc [dbo].[sp_TimXe]
@DieuKienTim tinyint,
@DauChoNgoi tinyint,
@NoiDungTim varchar(10)
as
	if (@DieuKienTim=0) --tất cả
select *
from XeBus else
		if (@DieuKienTim=1) -- bien số xe
select *
from XeBus
where BienSo = @NoiDungTim else
			if(@DieuKienTim=2) -- năm sản xuất
select *
from XeBus
where NamSX = @NoiDungTim
    else -- số chỗ ngồi
begin
    if
    (@DauChoNgoi =7) -- lớn hơn
select *
from XeBus
where SoChoNgoi > @NoiDungTim else
					if (@DauChoNgoi =4 ) -- nhỏ hơn
select *
from XeBus
where SoChoNgoi < @NoiDungTim
    else -- =
select *
from XeBus
where SoChoNgoi = @NoiDungTim end
GO



create
proc [dbo].[sp_ThemXe]
@BienSo varchar(10),
@NamSX int,
@SoChoNgoi int
as
	if exists (select * from XeBus  where BienSo  = @BienSo )
select MaTB = 0,
       TB = N'Đã tồn tại số xe này rồi.Vui lòng nhập số xe khác'
    else
begin
insert into XeBus(BienSo, NamSX, SoChoNgoi)
values (@BienSo, @NamSX, @SoChoNgoi)

select MaTB = 1,
       TB = N'Lưu thành công'
           end
    GO



create
proc [dbo].[sp_SuaXe]
@BienSo varchar(10),
@NamSX int,
@SoChoNgoi int
as
update XeBus
set NamSX     = @NamSX,
    SoChoNgoi =@SoChoNgoi
where BienSo = @BienSo
    GO



create
proc [dbo].[Sp_XoaXe]
@BienSo varchar(10)
as
delete
    XeBus
where BienSo = @BienSo
    GO



create
proc [dbo].[sp_XepLich]
@BienSo varchar(10),
@MaLoTrinh int
as
insert into GiaoXe(bienSo, MaLoTrinh, NgayGiao)
values (@BienSo, @MaLoTrinh, GETDATE())
    GO


create
proc [dbo].[sp_LichTrinhXe]
@BienSo varchar(10)
as
select a.bienso, c.TenLoTrinh, TuyenDuong = c.DiemXP + '-' + c.DiemDen, a.NgayGiao
from GiaoXe a,
     LoTrinh c
where a.MaLoTrinh = c.MaLoTrinh
  and a.bienSo = @BienSo
order by a.NgayGiao desc
    GO



create
proc [dbo].[sp_InLichTrinh]
as
select b.BienSo, c.TenLoTrinh, c.DiemXP, c.DiemDen, b.NgayGiao
from GiaoXe b,
     LoTrinh c,
     (select a.BienSo, NgayGiao = MAX(a.NgayGiao)
      from GiaoXe a
      group by a.BienSo) as d
where d.BienSo = b.BienSo
  and d.NgayGiao = b.NgayGiao
  and b.MaLoTrinh = c.MaLoTrinh
    GO

