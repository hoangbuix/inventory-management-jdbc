/****** Object:  StoredProcedure [dbo].[sp_DanhSachXe]    Script Date: 01/04/1980 00:49:27 ******/
SET
    ANSI_NULLS ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
create
proc [dbo].[sp_DanhSachXe]
as
select *
from XeBus GO
/****** Object:  StoredProcedure [dbo].[sp_DanhSachLoTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
create
proc [dbo].[sp_DanhSachLoTrinh]
as
select *
from LoTrinh GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraDangNhap]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
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
       TB = N'Hãy kiểm tra lại tài khoản và mật khẩu' GO
/****** Object:  StoredProcedure [dbo].[sp_TimLoTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
CREATE
proc [dbo].[sp_TimLoTrinh]
@DieuKienTim tinyint,
@NoiDungTim varchar(10)
as
	if (@DieuKienTim=0) --tất cả
select *
from LoTrinh else
		if (@DieuKienTim=1) -- điểm xuất phát
select *
from LoTrinh
where lower(DiemXP) like '%' + @NoiDungTim + '%'
    else
select *
from LoTrinh
where lower(DiemDen) like '%' + @NoiDungTim + '%' GO
/****** Object:  StoredProcedure [dbo].[sp_ThemLoTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
CREATE
proc [dbo].[sp_ThemLoTrinh]
@TenLoTrinh nvarchar(50),
@DiemXP nvarchar(30),
@DiemDen nvarchar(30),
@QuangDuong int,
@ThoiGian int,
@GiaTien int
as
insert into LoTrinh(TenLoTrinh, DiemXP, DiemDen, QuangDuong, ThoiGian, GiaTien)
values (@TenLoTrinh, @DiemXP, @DiemDen, @QuangDuong, @ThoiGian, @GiaTien)
    GO
/****** Object:  StoredProcedure [dbo].[sp_SuaLoTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
CREATE
proc [dbo].[sp_SuaLoTrinh]
@MaLoTrinh int,
@TenLoTrinh nvarchar(50),
@DiemXP nvarchar(30),
@DiemDen nvarchar(30),
@QuangDuong int,
@ThoiGian int,
@GiaTien int
as
update LoTrinh
set TenLoTrinh = @TenLoTrinh,
    DiemXP=@DiemXP,
    DiemDen    =@DiemDen,
    QuangDuong = @QuangDuong,
    ThoiGian   =@ThoiGian,
    GiaTien    =@GiaTien
where MaLoTrinh = @MaLoTrinh GO
/****** Object:  StoredProcedure [dbo].[Sp_XoaLoTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
create
proc [dbo].[Sp_XoaLoTrinh]
@MaLoTrinh varchar(10)
as
delete
    LoTrinh
where MaLoTrinh = @MaLoTrinh
    GO
/****** Object:  StoredProcedure [dbo].[sp_XepLich]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
create
proc [dbo].[sp_XepLich]
@BienSo varchar(10),
@MaLoTrinh int
as
	if exists( select * from GiaoXe where BienSo = @BienSo)
update GiaoXe
set MaLoTrinh = @MaLoTrinh
where bienSo = @BienSo
    else
insert
into GiaoXe(bienSo, MaLoTrinh)
values (@BienSo, @MaLoTrinh)
    GO
/****** Object:  StoredProcedure [dbo].[sp_LichTrinhXe]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
create
proc [dbo].[sp_LichTrinhXe]
as
select a.bienso, c.TenLoTrinh, TuyenDuong = c.DiemXP + '-' + c.DiemDen
from GiaoXe a,
     LoTrinh c
where a.MaLoTrinh = c.MaLoTrinh GO
/****** Object:  StoredProcedure [dbo].[sp_InLichTrinh]    Script Date: 01/04/1980 00:49:27 ******/
SET ANSI_NULLS
    ON
    GO
SET QUOTED_IDENTIFIER ON
    GO
CREATE
proc [dbo].[sp_InLichTrinh]
as
select b.BienSo, c.TenLoTrinh, c.DiemXP, c.DiemDen, c.quangDuong
from GiaoXe b,
     LoTrinh c
where b.MaLoTrinh = c.MaLoTrinh
order by c.QuangDuong desc
    GO
/****** Object:  ForeignKey [FK_GiaoXe_LoTrinh]    Script Date: 01/04/1980 00:49:28 ******/
ALTER TABLE [dbo].[GiaoXe] WITH CHECK ADD CONSTRAINT [FK_GiaoXe_LoTrinh] FOREIGN KEY ([MaLoTrinh])
    REFERENCES [dbo].[LoTrinh] ([MaLoTrinh])
    GO
ALTER TABLE [dbo].[GiaoXe] CHECK CONSTRAINT [FK_GiaoXe_LoTrinh]
    GO
/****** Object:  ForeignKey [FK_GiaoXe_XeBus]    Script Date: 01/04/1980 00:49:28 ******/
ALTER TABLE [dbo].[GiaoXe] WITH CHECK ADD CONSTRAINT [FK_GiaoXe_XeBus] FOREIGN KEY ([BienSo])
    REFERENCES [dbo].[XeBus] ([BienSo])
    GO
ALTER TABLE [dbo].[GiaoXe] CHECK CONSTRAINT [FK_GiaoXe_XeBus]
    GO
