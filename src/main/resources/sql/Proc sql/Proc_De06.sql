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
proc sp_DanhSachLop
as
select *
from Lop



alter
proc sp_DSHocSinhTheoLop
@Lop varchar(5)
as
select STT = ROW_NUMBER() OVER (ORDER BY a.maHS asc),
       a.maHS,
       Ho = a.HOHS,
       Ten = a.TENHS,
       a.NGAYSINH,
       GioiTinh = case a.Phai
                      when 0 then N'Nam'
                      else N'Nữ'
           end,
       a.QueQuan
from HOCSINH a
where MaLop = @Lop


create
proc sp_ThemHocSinh
@Ho nvarchar(40),
@Ten nvarchar(10),
@GioiTinh bit,
@NgaySinh smalldatetime,
@QueQuan nvarchar(100),
@Lop int
as
insert into hocsinh(Hohs, Tenhs, phai, NgaySinh, QueQuan, MaLop)
values (@Ho, @Ten, @GioiTinh, @NgaySinh, @QueQuan, @Lop)



create
proc sp_SuaHocSinh
@MaHS int,
@Ho nvarchar(40),
@Ten nvarchar(10),
@GioiTinh bit,
@NgaySinh smalldatetime,
@QueQuan nvarchar(100),
@Lop int
as
update HOCSINH
set HOhs     = @Ho,
    TENhs    =@Ten,
    Phai     = @GioiTinh,
    NGAYSINH = @NgaySinh,
    queQuan  =@QueQuan,
    maLOP    =@Lop
where mahs = @MaHS


create
proc Sp_XoaHocSinh
@MaHS int
as
delete
    HOCSINH
where mahs = @MaHS


create
proc sp_DanhSachMon
as
select *
from MonHoc


alter
proc sp_DSHSChuaCoDiemMon
@MaMH int,
@Lop int
as
select HoTen = HoHS + ' ' + TenHS + '-' + convert(varchar, NgaySinh, 103), MaHS
from HocSinh
where malop = @Lop
  and MaHS not in (select b.MaHS
                   from Diem b
                   where b.MaMH = @MaMH)


alter
proc sp_DSHSDaCoDiemMon
@MaMH int,
@Lop int
as
select STT = ROW_NUMBER() OVER (ORDER BY a.MaHS asc)
     , a.MaHS
     , b.MaMH
     , a.HoHS
     , a.TenHS
     , a.NgaySinh
     , b.Diem
from HocSinh a,
     Diem b
where a.mahs = b.MaHS
  and a.malop = @Lop
  and b.MaMH = @MaMH


create
proc sp_CapNhatDiem
@MaHS int,
@MaMH tinyint,
@Diem float
as
insert into Diem(MaHS, MaMH, Diem)
values (@MaHS, @MaMH, @Diem) Sp_InBangDiem 50,1

alter
proc Sp_InBangDiem
@MaMH int,
@Lop int
as
select HoHS, TenHS, NgaySinh, Diem = 0
from HocSinh
where malop = @Lop
  and MaHS not in (select b.MaHS
                   from Diem b
                   where b.MaMH = @MaMH)

union
select a.HoHS, a.TenHS, a.NgaySinh, b.Diem
from HocSinh a,
     Diem b
where a.mahs = b.MaHS
  and a.malop = @Lop
  and b.MaMH = @MaMH
order by TenHS, HoHS
