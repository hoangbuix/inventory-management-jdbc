use
    QuanLyThuVien
    go

Create
proc sp_KiemTraDangNhap
@TaiKhoan nvarchar(50),
@MatKhau nvarchar(50)
as
select MaNhanVien, HoTenNhanVien
from NhanVien a
where a.taikhoan = @TaiKhoan
  and PWDCOMPARE(@MatKhau, a.MatKhau) = 1


create
proc sp_LayThongTinDocGia
@MaDocGia int
as
select MaDocGia, HoTenDocGia, NgaySinh, GioiTinh, DiaChi
from DocGia
where MaDocGia = @MaDocGia
    go


create
proc sp_LayThongTinSach
@MaSach int
as
select a.MaSach, a.TenSach, b.HoTenTacGia
from Sach a,
     TacGia b
where a.MaTacGia = b.MaTacGia
  and a.MaSach = @MaSach
    go


create
proc sp_LuuMuonSach
@MaDocGia int,
@MaSach int,
@NgayMuon datetime,
@NgayHenTra datetime,
@MaNhanVien int
as
insert into MuonTraSach(MaDocGia, MaSach, NgayMuon, NgayHenTra, MaNhanVien)
values (@MaDocGia, @MaSach, @NgayMuon, @NgayHenTra, @MaNhanVien)
    go


create
proc sp_DocGiaGetAll
as
select MaDocGia, HoTenDocGia, GioiTinh, NgaySinh, DiaChi, Hinh
from DocGia go


create
proc sp_ThemDocGia
@HoTenDocGia nvarchar(100),
@GioiTinh bit,
@NgaySinh datetime,
@DiaChi nvarchar(100),
@Hinh image
as
Insert into DocGia(HoTenDocGia, GioiTinh, NgaySinh, DiaChi, Hinh)
values (@HoTenDocGia, @GioiTinh, @NgaySinh, @DiaChi, @Hinh)
    go


create
proc sp_CapNhatDocGia
@MaDocGia int,
@HoTenDocGia nvarchar(100),
@GioiTinh bit,
@NgaySinh datetime,
@DiaChi nvarchar(100),
@Hinh image
as
Update DocGia
Set HoTenDocGia=@HoTenDocGia,
    GioiTinh   = @GioiTinh,
    NgaySinh=@NgaySinh,
    DiaChi=@DiaChi,
    hinh       = @Hinh
where MaDocGia = @MaDocGia
    go


create
proc sp_rptMuonSach
@TuNgay datetime,
@DenNgay datetime
as
select a.MaDocGia,
       a.HoTenDocGia,
       a.GioiTinh,
       a.DiaChi,
       a.hinh,
       b.TenSach,
       c.NgayMuon,
       c.NgayHenTra,
       c.NgayTra
from DocGia a,
     Sach b,
     MuonTraSach c
where a.MaDocGia = c.MaDocGia
  and b.MaSach = c.MaSach
  and c.NgayMuon between @TuNgay and @DenNgay