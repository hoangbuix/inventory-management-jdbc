create
proc [dbo].[sp_DSPhongBan]
as
select *
from PhongBan
order by TenPB
    GO


alter
proc [dbo].[sp_DanhSachNhanVien]
as
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , a.HoTen
     , Phai = case a.phai when 1 then N'Nam' else N'Nữ' end
     , a.DiaChi
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



alter
proc [dbo].[sp_TimNV]
@DieuKienTim tinyint,
@NoiDungTim nvarchar(50)
as
	if (@DieuKienTim=0) --tất cả
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , a.HoTen
     , Phai = case a.phai when 1 then N'Nam' else N'Nữ' end
     , a.DiaChi
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB else
		if (@DieuKienTim=1) -- tên phòng ban
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , a.HoTen
     , Phai = case a.phai when 1 then N'Nam' else N'Nữ' end
     , a.DiaChi
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
  and b.TenPB like '%' + @NoiDungTim + '%'
    else
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , a.HoTen
     , Phai = case a.phai when 1 then N'Nam' else N'Nữ' end
     , a.DiaChi
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
  and a.HoTen like '%' + @NoiDungTim + '%'
    GO



ALTER
proc [dbo].[sp_ThemNhanVien]
@MaNV int,
@HoTen nvarchar(50),
@Phai bit,
@DiaChi nvarchar(50),
@MaPB int,
@TaiKhoan varchar(20),
@MatKhau varchar(50)
as
			if @MaNV = 0  -- them mới
begin if
exists ( select * from NhanVien where TaiKhoan = @TaiKhoan)
select TB = N'Đã tồn tại tài khoản này. Vui lòng nhập lại tài khoản khác.'
    else
begin
insert into NhanVien(HoTen, Phai, DiaChi, MaPB, TaiKhoan, MatKhau)
values (@HoTen, @Phai, @DiaChi, @MaPB, @TaiKhoan, PWDENCRYPT(@MatKhau))
select TB = N'Cập nhật thành công'
           end
    end
    else -- sửa
begin
update NhanVien
set HoTen    = @HoTen,
    Phai     = @Phai,
    DiaChi   =@DiaChi,
    MaPB     =@MaPB,
    TaiKhoan = @TaiKhoan
where MaNV = @MaNV
select TB = N'Cập nhật thành công'
           end



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

alter
proc sp_DanhSachBangCap
as
select *
from BangCap
order by TenBC

create
proc sp_ThemTrinhDo
@MaNV int,
@MaBC int,
@NganhHoc nvarchar(50),
@NoiCap nvarchar(50),
@NamCap int
as
insert into TrinhDo(MaNV, MaBC, NganhHoc, NoiCap, NamCap)
values (@MaNV, @MaBC, @NganhHoc, @NoiCap, @NamCap)



create
proc [dbo].[sp_DanhSachNhanVienTheoPhongBan]
@MaPB int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.MaNV
     , a.HoTen
     , Phai = case a.phai when 1 then N'Nam' else N'Nữ' end
     , a.DiaChi
     , a.MaPB
     , a.TaiKhoan
     , a.MatKhau
     , b.TenPB
from nhanvien a,
     phongban b
where a.MaPB = b.MaPB
  and a.MaPB = @MaPB
    GO

create
proc sp_DanhSachTrinhDoCuaNhanVien
@MaPB int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.maNV asc)
     , a.HoTen
     , c.TenBC
     , b.NganhHoc
     , b.NoiCap
     , b.NamCap
from NhanVien a,
     TrinhDo b,
     BangCap c
where a.MaNV = b.MaNV
  and b.MaBC = c.MaBC
  and a.MaPB = @MaPB


create
proc sp_InDanhSachNhanVienVaBangCap
as
select b.TenPB, a.HoTen, c.TenBC, d.NganhHoc, d.NamCap, d.NoiCap
from NhanVien a,
     PhongBan b,
     BangCap c,
     TrinhDo d
where a.MaNV = d.MaNV
  and d.MaBC = c.MaBC
  and a.MaPB = b.MaPB
