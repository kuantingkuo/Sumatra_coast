program Uperp_profile
use netcdf
implicit none
character(20), parameter :: casename="CPL64"
character(99), parameter :: path="/data/W.eddie/SPCAM/"//trim(casename)//"/"
integer, dimension(11), parameter :: ix=(/ 40, 41, 40, 41, 39, 40, 41, 42, 40, 41, 41 /), &
                                     iy=(/ 44, 44, 45, 45, 46, 46, 46, 46, 47, 47, 48 /)
integer, parameter :: nx=144, ny=96, nz=16, nt=87600
real(kind=4), parameter :: lonA=99.75, latA=-0.05, lonB=104.05, latB=-5.35
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
real(kind=4), dimension(nz,nt) :: uperp
real(kind=8), dimension(nt) :: time
real(kind=8) :: tempt
real(kind=4), dimension(nz) :: lev
real(kind=4), dimension(nx,ny,nz) :: u, v
real(kind=4) :: vx1, vy1, vx2, vy2, rad, fillvalue, uavg, vavg
integer :: countt, year, month, day, h, i, j, k, countz(nz)
character(4) :: yyyy
character(2) :: mm, dd
character(99) :: filename, outfile
integer :: ncid, timevid, uid, vid, timeid, uperpid, levvid, levid
logical :: first
vx1=lonB-lonA
vy1=latB-latA
vx2=0.
vy2=vy1
rad = acos( (vx1*vx2+vy1*vy2) / (sqrt(vx1**2+vy1**2) * sqrt(vx2**2+vy2**2)) )
print*, rad*180./3.141592654," degrees"

first = .true.
uperp = 0.
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
              trim(path)//trim(casename)//".cam.plev."//yyyy//"-"//mm//"-"//dd//".nc"
            call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
            call check_nf90( nf90_inq_varid(ncid, "time", timevid) )
            call check_nf90( nf90_inq_varid(ncid, "U", uid) )
            call check_nf90( nf90_inq_varid(ncid, "V", vid) )

            if (first) then
                call check_nf90( nf90_inq_varid(ncid, "lev_p", levvid) )
                call check_nf90( nf90_get_var(ncid, levvid, lev) )
                call check_nf90( nf90_get_att(ncid, vid, "_FillValue", fillvalue) )
                first = .false.
            endif
            do h=1,24
                countz = 0
                call check_nf90( nf90_get_var(ncid, timevid, time(countt), (/h/)) )
                call check_nf90( nf90_get_var(ncid, uid, u, (/1,1,1,h/), (/nx,ny,nz,1/)) )
                call check_nf90( nf90_get_var(ncid, vid, v, (/1,1,1,h/), (/nx,ny,nz,1/)) )
                do i=1,11
                    do k=1,nz
                        if ( u(ix(i),iy(i),k) /= fillvalue ) then
                            uperp(k,countt) = uperp(k,countt) + &
                                u(ix(i),iy(i),k)*cos(rad) + v(ix(i),iy(i),k)*sin(rad)
                            countz(k) = countz(k) + 1
                        endif
                    enddo
                enddo
                uperp(:,countt) = uperp(:,countt)/real(countz, kind=4)
                countt = countt + 1
            enddo
            call check_nf90( nf90_close(ncid) )
        enddo
    enddo
enddo

outfile = "/data/W.eddie/Sumatra/"//trim(casename)//".Uperp_profile.nc"
call execute_command_line( "rm -f "//trim(outfile), wait=.True. )
call check_nf90( nf90_create(outfile, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "time", nt, timeid) )
call check_nf90( nf90_def_dim(ncid, "lev", nz, levid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "lev", NF90_FLOAT, levid, levvid) )
call check_nf90( nf90_def_var(ncid, "Uperp", NF90_FLOAT, (/levid, timeid/), uperpid) )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, timevid, "calendar", "noleap") )
call check_nf90( nf90_put_att(ncid, levvid, "long_name", "pressure") )
call check_nf90( nf90_put_att(ncid, levvid, "unit", "hPa") )
call check_nf90( nf90_put_att(ncid, levvid, "positive", "up") )
call check_nf90( nf90_put_att(ncid, uperpid, "long_name", &
            "perpendicular wind to the western coast of Sumatra island") )
call check_nf90( nf90_put_att(ncid, uperpid, "units", "m/s") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, time) )
call check_nf90( nf90_put_var(ncid, levvid, lev) )
call check_nf90( nf90_put_var(ncid, uperpid, uperp) )
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
