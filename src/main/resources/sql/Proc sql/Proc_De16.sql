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
proc sp_DSThietBi
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103),
       a.GiaMua

from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
order by a.NgayMua desc


alter
proc sp_CapNhatThietBi
@act tinyint,
@MaTB varchar(10),
@tenTB nvarchar(50),
@NgayMua smalldatetime,
@GiaMua int
as
	if @act=0
insert into ThietBi(MaTB, TenTB, NgayMua, GiaMua)
values (@MaTB, @tenTB, @NgayMua, @GiaMua)
    else
update ThietBi
set TenTB   = @tenTB,
    NgayMua = @NgayMua,
    GiaMua  = @GiaMua
where MaTB = @MaTB


create
proc sp_XoaTB
@MaTB int
as
delete
    ThietBi
where MaTB = @MaTB


create
proc sp_KiemTraMaTB
@MaTB varchar(10)
as
	if exists ( select * from ThietBi where MaTB =@MaTB )
select TB = 1
    else
select TB = 0



alter
proc sp_TimKiem
@DieuKienTim tinyint
as
	if @DieuKienTim =0 -- tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103),
       a.GiaMua
from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
order by a.NgayMua desc else
		if @DieuKienTim =1 --ds thiết bị chưa cấp
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103),
       a.GiaMua
from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
where b.NgayCap is null
order by a.NgayMua desc else
			if @DieuKienTim =2 -- ds thiết bị đã cấp và đang sử dụng
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103),
       a.GiaMua
from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
where b.NgayCap is not null
  and b.NgayThuHoi is null
order by a.NgayMua desc
    else -- ds thiết bị cấp và đã thu hồi
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103),
       a.GiaMua
from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
where b.NgayCap is not null
  and b.NgayThuHoi is not null
order by a.NgayMua desc ------------------------------
alter
proc sp_DSThietBiCoTheCapHoacThuHoi
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       TenTB = a.MaTB + ' - ' + a.TenTB,
       a.GiaMua

from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
where b.NgayThuHoi is null
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
select STT = ROW_NUMBER() OVER (ORDER BY b.MaTB asc),
       NgayCap = convert(varchar (15), b.NgayCap, 103),
       TenTB = a.MaTB + ' - ' + a.TenTB,
       NgayThuHoi = convert(varchar (15), b.NgayThuHoi, 103)
from ThietBi a,
     CapCho b
where a.MaTB = b.MaTB
  and b.MaPB = @MaPB
order by b.NgayCap desc


alter
proc sp_CapThietBi
@MaTB varchar(10),
@MaPB int,
@Ngay smalldatetime
as
	if not exists ( select * from CapCho where MaTB =@MaTB)
insert into CapCho(MaTB, MaPB, NgayCap)
values (@MaTB, @MaPB, @Ngay)
    else -- =2 : thu hồi
update CapCho
set NgayThuHoi = @Ngay
where MaTB = @MaTB
    - - - - - - - - - - - - - - - - - - - - - - - ----
create
proc sp_ThongKe
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaTB asc),
       a.MaTB,
       a.TenTB,
       NgayMua = convert(varchar (15), a.ngaymua, 103),
       a.GiaMua
from ThietBi a
         left join capcho b on a.MaTB = b.MaTB
where b.NgayCap is null
order by a.NgayMua desc