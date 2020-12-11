program Q_profile_reg
use netcdf
implicit none
character(20), parameter :: casename="CPL64"
character(99), parameter :: path="/data/W.eddie/SPCAM/"//trim(casename)//"/"
real(kind=4), parameter :: uQ1=-0.2814124-2.777613, uQ2=-0.2814124, uQ3=-0.2814124+2.777613
integer, parameter :: nx=144, ny=96, nz=25, nd=3650, nt=744, np=11
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
integer, dimension(np) :: ix, iy, reg
integer :: i, j, k, t, year, month, day, iday, itime1, itime2
character(99) :: filename
integer :: ncid, uid, Qid, zid, levid, qallid, qSEid, qWEid, qWWid, qSWid
real(kind=4), dimension(nz) :: lev
real(kind=4), dimension(nd) :: uperp
real(kind=4), dimension(np,nz,nt) :: q
real(kind=4), dimension(nz) :: qall, qSE, qWE, qWW, qSW
integer, dimension(nz) :: countall, countSE, countWE, countWW, countSW
real(kind=4) :: ureg, fillvalue
logical :: first
character(4) :: yyyy
character(2) :: mm

open(unit=10, file="region.txt", status="old", access="sequential", &
        form="formatted", action="read")
i=1
do while(i<=np)
    read(10,"(I2,1X,I2,1X,I1)") ix(i), iy(i), reg(i)
    if(reg(i) >= 2 .and. reg(i) <= 4) i = i + 1
enddo
close(10)

filename = "../"//trim(casename)//"/"//trim(casename)//".Uperp.nc"
call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
call check_nf90( nf90_inq_varid(ncid, "Uperp", uid) )
call check_nf90( nf90_get_var(ncid, uid, uperp) )
call check_nf90( nf90_close(ncid) )

first = .True.
qall = 0.
qSE = 0.
qWE = 0.
qWW = 0.
qSW = 0.
countall = 0
countSE = 0
countWE = 0
countWW = 0
countSW = 0
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        if(month /= 12 .and. month > 4) cycle
        write(mm,'(I0.2)') month
        print*, yyyy,mm
        filename = trim(path)//trim(casename)//".Q.plev."//yyyy//"-"//mm//".nc"
        call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
        call check_nf90( nf90_inq_varid(ncid, "Q", Qid) )
        do t=1,dom(month)*24
            do k=1,nz
                do i=1,np
                    call check_nf90( nf90_get_var(ncid, Qid, q(i,k,t), &
                                start=(/ix(i),iy(i),k,t/)) )
                enddo
            enddo
        enddo

        if(first) then
            call check_nf90( nf90_inq_varid(ncid, "lev_p", zid) )
            call check_nf90( nf90_get_var(ncid, zid, lev) )
            call check_nf90( nf90_get_att(ncid, Qid, "_FillValue", fillvalue) )
            first = .False.
        endif
        call check_nf90( nf90_close(ncid) )

        do day=1,dom(month)
            iday = (year-1)*365 + sum(dom(1:month-1)) + day
            ureg = uperp(iday)
            itime1 = day*24 - 23
            itime2 = day*24
            call addQcount(q(:,:,itime1:itime2),qall,countall)
            if (ureg <= uQ1) then
                call addQcount(q(:,:,itime1:itime2),qSE,countSE)
            elseif(ureg < uQ2) then
                call addQcount(q(:,:,itime1:itime2),qWE,countWE)
            elseif(ureg < uQ3) then
                call addQcount(q(:,:,itime1:itime2),qWW,countWW)
            else
                call addQcount(q(:,:,itime1:itime2),qSW,countSW)
            endif
        enddo
    enddo
enddo

qall = qall/real(countall,kind=4)
qSE = qSE/real(countSE,kind=4)
qWE = qWE/real(countWE,kind=4)
qWW = qWW/real(countWW,kind=4)
qSW = qSW/real(countSW,kind=4)

filename = "/data/W.eddie/Sumatra/"//trim(casename)//"/"//trim(casename)//".Qprofile.nc"
call execute_command_line( "rm -f "//trim(filename), wait=.True. )
call check_nf90( nf90_create(filename, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "lev", nz, zid) )
call check_nf90( nf90_def_var(ncid, "lev", NF90_FLOAT, zid, levid) )
call check_nf90( nf90_def_var(ncid, "qall", NF90_FLOAT, zid, qallid) )
call check_nf90( nf90_def_var(ncid, "qSE", NF90_FLOAT, zid, qSEid) )
call check_nf90( nf90_def_var(ncid, "qWE", NF90_FLOAT, zid, qWEid) )
call check_nf90( nf90_def_var(ncid, "qWW", NF90_FLOAT, zid, qWWid) )
call check_nf90( nf90_def_var(ncid, "qSW", NF90_FLOAT, zid, qSWid) )
call check_nf90( nf90_put_att(ncid, levid, "positive", "up") )
call check_nf90( nf90_put_att(ncid, levid, "units", "hPa") )
call check_nf90( nf90_put_att(ncid, levid, "long_name", "pressure") )
call check_nf90( nf90_put_att(ncid, qallid, "long_name", "average specific humidity over Sumatra 7.5 degrees offshore during DJFMA") )
call check_nf90( nf90_put_att(ncid, qallid, "units", "kg/kg") )
call check_nf90( nf90_put_att(ncid, qSEid, "long_name", "average specific humidity for SE regime") )
call check_nf90( nf90_put_att(ncid, qSEid, "units", "kg/kg") )
call check_nf90( nf90_put_att(ncid, qWEid, "long_name", "average specific humidity for WE regime") )
call check_nf90( nf90_put_att(ncid, qWEid, "units", "kg/kg") )
call check_nf90( nf90_put_att(ncid, qWWid, "long_name", "average specific humidity for WW regime") )
call check_nf90( nf90_put_att(ncid, qWWid, "units", "kg/kg") )
call check_nf90( nf90_put_att(ncid, qSWid, "long_name", "average specific humidity for SW regime") )
call check_nf90( nf90_put_att(ncid, qSWid, "units", "kg/kg") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, levid, lev) )
call check_nf90( nf90_put_var(ncid, qallid, qall) )
call check_nf90( nf90_put_var(ncid, qSEid, qSE) )
call check_nf90( nf90_put_var(ncid, qWEid, qWE) )
call check_nf90( nf90_put_var(ncid, qWWid, qWW) )
call check_nf90( nf90_put_var(ncid, qSWid, qSW) )
call check_nf90( nf90_close(ncid) )

contains

subroutine addQcount(qaday, qreg, countreg)
real(kind=4), dimension(np,nz,24), intent(in) :: qaday
real(kind=4), dimension(nz), intent(inout) :: qreg
integer, dimension(nz), intent(inout) :: countreg

do t=1,24
    do k=1,nz
        do i=1,np
            if(qaday(i,k,t) /= fillvalue) then
                qreg(k) = qreg(k) + qaday(i,k,t)
                countreg(k) = countreg(k) + 1
            endif
        enddo
    enddo
enddo
end subroutine

subroutine check_nf90(err)
integer, intent(in) :: err
if (err /= nf90_noerr) then
    print*, "ERROR: ", nf90_strerror(err), err
    stop
endif
end subroutine

end program
