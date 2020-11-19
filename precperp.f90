program precperpendicular
use netcdf
implicit none
character(20), parameter :: casename="PRSHR"
character(99), parameter :: path="/data/W.eddie/SPCAM/"//trim(casename)//"/"
integer, parameter :: nx=144, ny=96, nz=11, nt=87600, np=28
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
integer, dimension(np) :: ix, iy, reg
integer, dimension(8) :: regcount
real(kind=4), dimension(8,nt) :: precperp
real(kind=8), dimension(nt) :: time
real(kind=8) :: tempt
real(kind=4), dimension(nz) :: lev
real(kind=4), dimension(nx,ny) :: prec
integer :: countt, year, month, day, h, i
character(4) :: yyyy
character(2) :: mm, dd
character(99) :: filename, outfile
integer :: ncid, timevid, uid, vid, timeid, precid, levvid, levid, xid, xvid

open(unit=10, file="region.txt", status="old", access="sequential", &
        form="formatted", action="read")
regcount = 0
do i=1,np
    read(10,"(I2,1X,I2,1X,I1)") ix(i), iy(i), reg(i)
    reg(i) = reg(i) + 1
    regcount(reg(i)) = regcount(reg(i)) + 1
enddo
close(10)

precperp = 0.
countt = 1
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        write(mm,'(I0.2)') month
!        print*, yyyy,mm
        do day=1,dom(month)
            write(dd,'(I0.2)') day
            print*, yyyy,mm,dd
            filename = &
              trim(path)//trim(casename)//".cam.h0."//yyyy//"-"//mm//"-"//dd//"-00000.nc"
            call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
            call check_nf90( nf90_inq_varid(ncid, "time", timevid) )
            call check_nf90( nf90_inq_varid(ncid, "PRECT", precid) )

            do h=1,24
                call check_nf90( nf90_get_var(ncid, timevid, time(countt), (/h/)) )
                call check_nf90( nf90_get_var(ncid, precid, prec, (/1,1,h/), (/nx,ny,1/)) )
                do i=1,np
                    precperp(reg(i),countt) = precperp(reg(i),countt) &
                                              + prec(ix(i),iy(i))*1000.*3600.
                enddo
                countt = countt + 1
            enddo
            call check_nf90( nf90_close(ncid) )
        enddo
    enddo
enddo
do i=1,8
    precperp(i,:) = precperp(i,:)/real(regcount(i), kind=4)
enddo

outfile = "/data/W.eddie/Sumatra/"//trim(casename)//"/"//trim(casename)//".prec.nc"
call execute_command_line( "rm -f "//trim(outfile), wait=.True. )
call check_nf90( nf90_create(outfile, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "X", 8, xid) )
call check_nf90( nf90_def_dim(ncid, "time", nt, timeid) )
call check_nf90( nf90_def_var(ncid, "X", NF90_DOUBLE, xid, xvid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "prec", NF90_FLOAT, (/xid, timeid/), precid) )
call check_nf90( nf90_put_att(ncid, xvid, "long_name", &
                                "distance from the coast line of Sumatra") )
call check_nf90( nf90_put_att(ncid, xvid, "units", "degrees") )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, timevid, "calendar", "noleap") )
call check_nf90( nf90_put_att(ncid, precid, "long_name", "precipitation") )
call check_nf90( nf90_put_att(ncid, precid, "units", "mm/h") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, time) )
call check_nf90( nf90_put_var(ncid, xvid, &
            (/ -11.25, -8.75, -6.25, -3.75, -1.25, 1.25, 3.75, 6.25 /)) )
call check_nf90( nf90_put_var(ncid, precid, precperp) )
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
