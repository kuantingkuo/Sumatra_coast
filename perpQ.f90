program Qvperpendicular
use netcdf
implicit none
character(20), parameter :: casename="CPL64"
character(99), parameter :: path="/data/W.eddie/SPCAM/"//trim(casename)//"/"
integer, parameter :: nx=144, ny=96, nz=25, nt=87600, np=28
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
integer, dimension(np) :: ix, iy, reg
integer, dimension(8) :: regcount
real(kind=4), dimension(8,nz,nt) :: Qvperp
real(kind=8), dimension(nt) :: time
real(kind=4), dimension(nz) :: lev
real(kind=4), dimension(nx,ny,nz,nt) :: Qv
integer :: countt, year, month, day, h, i, j, k, t, tall
character(4) :: yyyy
character(2) :: mm, dd
character(99) :: filename, outfile
integer :: ncid, timevid, uid, vid, timeid, Qvid, levvid, levid, xid, xvid
real(kind=4) :: fillvalue, qnew
logical :: first

open(unit=10, file="region.txt", status="old", access="sequential", &
        form="formatted", action="read")
regcount = 0
do i=1,np
    read(10,"(I2,1X,I2,1X,I1)") ix(i), iy(i), reg(i)
    reg(i) = reg(i) + 1
    regcount(reg(i)) = regcount(reg(i)) + 1
enddo
close(10)

first = .True.
Qvperp = 0.
countt = 1
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        write(mm,'(I0.2)') month
        print*, yyyy,mm
        filename = &
          trim(path)//trim(casename)//".Q.plev."//yyyy//"-"//mm//".nc"
        call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
        call check_nf90( nf90_inq_varid(ncid, "time", timevid) )
        call check_nf90( nf90_inq_varid(ncid, "lev_p", levvid) )
        call check_nf90( nf90_inq_varid(ncid, "Q", Qvid) )

        if(first) then
            call check_nf90( nf90_get_var(ncid, levvid, lev) )
            first = .False.
        endif
        h = dom(month)*24
        call check_nf90( nf90_get_var(ncid, timevid, time(countt:countt+h-1)) )
        call check_nf90( nf90_get_var(ncid, Qvid, Qv(:,:,:,1:h)) )
        call check_nf90( nf90_get_att(ncid, Qvid, "_FillValue", fillvalue) )

        do t=1,h
            tall = countt+t-1
            do k=1,nz
                regcount = 0
                do i=1,np
                    qnew = Qv(ix(i),iy(i),k,t)
                    if(qnew == fillvalue) cycle
                    Qvperp(reg(i),k,tall) = Qvperp(reg(i),k,tall) + qnew
                    regcount(reg(i)) = regcount(reg(i)) + 1
                enddo
                do j=1,8
                    if(regcount(j) == 0) then
                        Qvperp(j,k,tall) = fillvalue
                    else
                        Qvperp(j,k,tall) = Qvperp(j,k,tall)/real(regcount(j), kind=4)
                    endif
                enddo
            enddo
        enddo
        countt = countt + h
        call check_nf90( nf90_close(ncid) )
    enddo
enddo

outfile = "/data/W.eddie/Sumatra/"//trim(casename)//"/"//trim(casename)//".Q.nc"
call execute_command_line( "rm -f "//trim(outfile), wait=.True. )
call check_nf90( nf90_create(outfile, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "X", 8, xid) )
call check_nf90( nf90_def_dim(ncid, "lev", nz, levid) )
call check_nf90( nf90_def_dim(ncid, "time", nt, timeid) )
call check_nf90( nf90_def_var(ncid, "X", NF90_DOUBLE, xid, xvid) )
call check_nf90( nf90_def_var(ncid, "lev", NF90_DOUBLE, levid, levvid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "Q", NF90_FLOAT, (/xid, levid, timeid/), Qvid) )
call check_nf90( nf90_put_att(ncid, xvid, "long_name", &
                                "distance from the coast line of Sumatra") )
call check_nf90( nf90_put_att(ncid, xvid, "units", "degrees") )
call check_nf90( nf90_put_att(ncid, levvid, "long_name", "pressure") )
call check_nf90( nf90_put_att(ncid, levvid, "units", "hPa") )
call check_nf90( nf90_put_att(ncid, levvid, "positive", "up") )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, timevid, "calendar", "noleap") )
call check_nf90( nf90_put_att(ncid, Qvid, "long_name", "specific humidity") )
call check_nf90( nf90_put_att(ncid, Qvid, "units", "kg/kg") )
call check_nf90( nf90_put_att(ncid, Qvid, "_FillValue", fillvalue) )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, time) )
call check_nf90( nf90_put_var(ncid, levvid, lev) )
call check_nf90( nf90_put_var(ncid, xvid, &
            (/ -11.25, -8.75, -6.25, -3.75, -1.25, 1.25, 3.75, 6.25 /)) )
call check_nf90( nf90_put_var(ncid, Qvid, Qvperp) )
call check_nf90( nf90_close(ncid) )

contains

subroutine check_nf90(err)
integer, intent(in) :: err
if (err /= nf90_noerr) then
  print*, "ERROR: ", nf90_strerror(err), err
  stop
endif
end subroutine

end program
