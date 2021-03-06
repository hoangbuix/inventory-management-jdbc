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
select STT = ROW_NUMBER() OVER (ORDER BY a.SoBD asc),
       a.SoBD,
       a.HO,
       a.TEN,
       a.NGAYSINH,
       GioiTinh = case a.GioiTinh
                      when 0 then N'Nam'
                      else N'Nữ'
           end
from HOCSINH a
where Lop = @Lop
    - - - -sp_ThemHocSinh với các tham số….. dùng để thêm một học sinh mới
alter
proc sp_ThemHocSinh
@SoBD varchar(7),
@Ho nvarchar(40),
@Ten nvarchar(10),
@GioiTinh bit,
@NgaySinh smalldatetime,
@Lop varchar(5)
as
	if exists (select * from hocsinh where sobd = @SoBD)
select MaTB = 0,
       TB = N'Đã tồn tại số báo danh này rồi.Vui lòng nhập Số báo danh khác'
    else
begin
insert into hocsinh(SoBD, Ho, Ten, GioiTinh, NgaySinh, Lop)
values (@SoBD, @Ho, @Ten, @GioiTinh, @NgaySinh, @Lop)
insert
into DIEM(SoBD)
values (@SoBD)
select MaTB = 1,
       TB = N'Lưu thành công'
           end


create
proc sp_SuaHocSinh
@SoBD varchar(7),
@Ho nvarchar(40),
@Ten nvarchar(10),
@GioiTinh bit,
@NgaySinh smalldatetime,
@Lop varchar(5)
as
update HOCSINH
set HO       = @Ho,
    TEN      =@Ten,
    GioiTinh = @GioiTinh,
    NGAYSINH = @NgaySinh,
    LOP      =@Lop
where SoBD = @SoBD
    - -Sp_XoaHocSinh với tham số truyền vào @ SoBD  dùng để xóa học sinh
create
proc Sp_XoaHocSinh
@SoBD varchar(7)
as
delete
    DIEM
where SoBD = @SoBD
delete
    HOCSINH
where SoBD = @SoBD
    - -sp_DanhSachBangDiemTheoLop dùng liệt kê bảng điểm của học sinh
--gồm các thông tin: Số báo danh, Toán, Văn, Ngoại ngữ có lớp là tham số đưa vào
create
proc sp_DanhSachBangDiemTheoLop
@Lop varchar(5)
as
select STT = ROW_NUMBER() OVER (ORDER BY SoBD asc), SoBD, TOAN, VAN, NN
from DIEM --sp_CapNhatDiem: cập nhật điểm số với tham số đưa vào là
--SoBD, Toán, Văn,Ngoại ngữ
create
proc sp_CapNhatDiem
@soBD varchar(5),
@Toan real,
@Van real,
@NN real
as
update DIEM
set TOAN = @Toan,
    VAN  = @Van,
    NN   = @NN
where SoBD = @soBD
    - -Sp_InBangDiem : liệt kê danh sách bảng điểm của học sinh gồm các thông tin :
-- Họ tên, Ngày sinh, toán, văn, ngoại ngữ, Điểm trung bình , Tình trạng . 
-- Trong đó Điểm trung bình là trung bình tổng của 3 cột điểm toán, văn, ngoại ngữ . 
-- Nếu điểm trung bình >6 thì tình trạng là đậu, ngược lại tình trạng là rớt.
    Sp_InBangDiem '12A1'
alter
proc Sp_InBangDiem
@Lop varchar(5)
as
select STT = ROW_NUMBER() OVER (ORDER BY a.SoBD asc),
       HoTenHS = a.HO + ' ' + a.TEN,
       a.NGAYSINH,
       b.TOAN,
       b.VAN,
       b.NN,
       DTB = round((b.TOAN + b.VAN + b.NN) / 3, 2),
       XepLoai = case
                     when round((b.TOAN + b.VAN + b.NN) / 3, 2) > 6 then N'Đậu'
                     else N'Rớt'
           end
from HOCSINH a,
     DIEM b
where a.SoBD = b.SoBD
  and a.LOP = @Lop
