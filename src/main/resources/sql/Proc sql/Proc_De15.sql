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
           STT = ROW_NUMBER() OVER(ORDER BY a.MaKH asc),


alter
proc sp_DSThietBi
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.ngaymua,
       a.TenTB,
       a.GiaMua,
       a.SoLuongMua,
       SoLuongCap = (select SUM(b.SoLuongCap)
                     from CapCho b
                     where a.MaTB = b.MaTB
                     group by b.MaTB)
from ThietBi a
order by a.NgayMua desc


create
proc sp_CapNhatThietBi
@MaTB int,
@tenTB nvarchar(50),
@NgayMua smalldatetime,
@GiaMua int,
@SoLuongMua int
as
	if @MaTB =0

insert into ThietBi(TenTB, NgayMua, GiaMua, SoLuongMua)
values (@tenTB, @NgayMua, @GiaMua, @SoLuongMua)
    else
update ThietBi
set TenTB      = @tenTB,
    NgayMua    = @NgayMua,
    GiaMua     = @GiaMua,
    SoLuongMua = @SoLuongMua
where MaTB = @MaTB


create
proc sp_XoaTB
@MaTB int
as
delete
    ThietBi
where MaTB = @MaTB



alter
proc sp_TimKiem
@DieuKienTim tinyint,
@NgayTim smalldatetime
as
	if @DieuKienTim =0 -- tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.ngaymua,
       a.TenTB,
       a.GiaMua,
       a.SoLuongMua,
       SoLuongCap = (select SUM(b.SoLuongCap)
                     from CapCho b
                     where a.MaTB = b.MaTB
                     group by b.MaTB)
from ThietBi a
order by a.NgayMua desc else
		if @DieuKienTim =1 -- thiết bị còn trong kho
select *
from (select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
             a.MaTB,
             a.ngaymua,
             a.TenTB,
             a.GiaMua,
             a.SoLuongMua,
             SoLuongCap = (select SUM(b.SoLuongCap)
                           from CapCho b
                           where a.MaTB = b.MaTB
                           group by b.MaTB)
      from ThietBi a
     ) tbl
where tbl.SoLuongMua > tbl.SoLuongCap
   or tbl.SoLuongCap is null
order by tbl.NgayMua desc else
			if @DieuKienTim =2 -- mua trước ngày
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.ngaymua,
       a.TenTB,
       a.GiaMua,
       a.SoLuongMua,
       SoLuongCap = (select SUM(b.SoLuongCap)
                     from CapCho b
                     where a.MaTB = b.MaTB
                     group by b.MaTB)
from ThietBi a
where a.NgayMua < @NgayTim
order by a.NgayMua desc
    else -- mua sau ngày
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.ngaymua,
       a.TenTB,
       a.GiaMua,
       a.SoLuongMua,
       SoLuongCap = (select SUM(b.SoLuongCap)
                     from CapCho b
                     where a.MaTB = b.MaTB
                     group by b.MaTB)
from ThietBi a
where a.NgayMua > @NgayTim
order by a.NgayMua desc


create
proc sp_DanhSachPhongBan
as
select *
from PhongBan
order by TenPB asc


alter
proc sp_DSThietBiCapChoMoiPhongBan
@MaPB int
as
select STT = ROW_NUMBER() OVER (ORDER BY b.MaTB asc)
     , NgayCap = convert(varchar (15), b.NgayCap, 103)
     , a.TenTB
     , b.SoLuongCap
from ThietBi a,
     CapCho b
where a.MaTB = b.MaTB
  and b.MaPB = @MaPB
order by b.NgayCap desc


create
proc sp_CapThietBi
@MaTB int,
@MaPB int,
@SLCap int,
@NgayCap smalldatetime
as
insert into CapCho(MaTB, MaPB, SoLuongCap, NgayCap)
values (@MaTB, @MaPB, @SLCap, @NgayCap)


alter
proc sp_ThongKe
as
select tbl.STT,
       tbl.NgayMua,
       tbl.TenTB,
       tbl.SoLuongMua,
       SoLuongCon = case when tbl.SoLuongCap is null then tbl.SoLuongMua else tbl.SoLuongMua - tbl.SoLuongCap end
from (select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
             a.MaTB,
             a.ngaymua,
             a.TenTB,
             a.GiaMua,
             a.SoLuongMua,
             SoLuongCap = (select SUM(b.SoLuongCap)
                           from CapCho b
                           where a.MaTB = b.MaTB
                           group by b.MaTB)
      from ThietBi a
     ) tbl
where tbl.SoLuongMua > tbl.SoLuongCap
   or tbl.SoLuongCap is null
order by tbl.NgayMua desc