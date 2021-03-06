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



alter
proc sp_DanhSachGiaiDau
as
select MaGiai,
       TenGiai,
       SoLuongVDV,
       NgayBatDau = CONVERT(varchar (15), NgayBatDau, 103),
       NgayKetThuc = CONVERT(varchar (15), NgayKetThuc, 103)
from GiaiDau



create
proc sp_DSChangDua
@MaGiai int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.machang asc), a.*
from ChangDua a
where a.MaGiai = @MaGiai


alter
proc sp_ThemChangDua
@TenChang nvarchar(100),
@DoDai int,
@DVT nvarchar(10),
@NgayDua datetime,
@MaGiai int
as
	declare
@NgayBatDau as datetime
	declare
@NgayKetThuc as datetime
set @NgayBatDau = (select NgayBatDau
                   from GiaiDau
                   where MaGiai = @MaGiai)
set @NgayKetThuc = (select NgayKetThuc
                    from GiaiDau
                    where MaGiai = @MaGiai) if @NgayDua < @NgayBatDau
select TB = N'Ngày đua phải lớn hơn ngày bắt đầu' else
		if @NgayDua > @NgayKetThuc
select TB = N'Ngày đua phải nhỏ hơn ngày kết thúc'
    else
begin
insert into ChangDua(TenChang, DoDai, DVT, NgayDua, MaGiai)
values (@TenChang, @DoDai, @DVT, @NgayDua, @MaGiai)

select TB = N'Lưu thành công'
           end


alter
proc sp_SuaChangDua
@MaChang int,
@TenChang nvarchar(100),
@DoDai int,
@DVT nvarchar(10),
@NgayDua datetime,
@MaGiai int
as
	declare
@NgayBatDau as datetime
	declare
@NgayKetThuc as datetime
set @NgayBatDau = (select NgayBatDau
                   from GiaiDau
                   where MaGiai = @MaGiai)
set @NgayKetThuc = (select NgayKetThuc
                    from GiaiDau
                    where MaGiai = @MaGiai) if @NgayDua < @NgayBatDau
select TB = N'Ngày đua phải lớn hơn ngày bắt đầu' else
		if @NgayDua > @NgayKetThuc
select TB = N'Ngày đua phải nhỏ hơn ngày kết thúc'
    else
begin
update ChangDua
set TenChang = @TenChang,
    DoDai    = @DoDai,
    DVT      = @DVT,
    NgayDua  = @NgayDua
where MaChang = @MaChang
select TB = N'Cập nhật thành công'
           end



alter
proc Sp_XoaChangDua
@MaChang int
as
	if GETDATE() >= (select NgayDua -2 from ChangDua where MaChang = @MaChang )
select TB = N'Đã quá ngày hủy chặng đua .'
    else
begin
delete
    ChangDua
where MaChang = @MaChang
select TB = N'Xóa thành công'
           end ------------------------


alter
proc sp_CapNhatThanhTich
@MaVDV int,
@MaChang int,
@ThanhTich nvarchar(50)
as
insert into KetQua(MaVDV, MaChang, ThanhTich)
values (@MaVDV, @MaChang, @ThanhTich)


alter
proc sp_DSVDVChuaCoThanhTich
@MaChang int,
@MaGiai int
as
select MaVDV, HoTen = HoTen + ' - ' + convert(varchar (15), NgaySinh, 103) + ' - ' + NoiSinh
from VDV
where MaGiai = @MaGiai
  and MaVDV not in (select a.MaVDV
                    from KetQua a
                    where a.MaChang = @MaChang
)


create
proc sp_DSVDVDaCoThanhTich
@MaChang int,
@MaGiai int
as
select *
from VDV a,
     KetQua b
where a.MaVDV = b.MaVDV
  and a.MaGiai = @MaGiai
  and b.MaChang = @MaChang
    - - - - - - - - - - - - - - - - - - - - - - - - - - ----
create
proc Sp_InThanhTich
@MaGiai int,
@MaChang int
as
select a.MaVDV, a.HoTen, a.NgaySinh, a.NoiSinh, c.TenChang, c.NgayDua, b.ThanhTich
from VDV a,
     KetQua b,
     ChangDua c
where a.MaVDV = b.MaVDV
  and b.MaChang = c.MaChang
  and c.MaGiai = @MaGiai
  and c.MaChang = @MaChang