program defregime
use netcdf
implicit none
character(20), parameter :: casename="CPL64"
character(99), parameter :: path="../"//trim(casename)//"/"
real(kind=4), parameter :: uQ1=-0.2814124-2.777613, uQ2=-0.2814124, uQ3=-0.2814124+2.777613
integer, parameter :: nx=8, nd=3650, nt=87600
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
character(99) :: filename
integer :: ncid, uid, precid
real(kind=4), dimension(nd) :: uperp
real(kind=4), dimension(nx,nt) :: prec
integer :: countd, year, month, day, h1, h2, countall, countSE, countWE, countWW, countSW
real(kind=4), dimension(nx,24) :: diurprec, diurprecSE, diurprecWE, diurprecWW, diurprecSW
integer :: ind, t, xid, xvid, timeid, timevid
integer :: precseid, precweid, precwwid, precswid
integer :: binid, binvid, nid
integer, dimension(50) :: bin

filename = trim(path)//trim(casename)//".Uperp.nc"
call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
call check_nf90( nf90_inq_varid(ncid, "Uperp", uid) )
call check_nf90( nf90_get_var(ncid, uid, uperp) )
call check_nf90( nf90_close(ncid) )

filename = trim(path)//trim(casename)//".prec.nc"
call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
call check_nf90( nf90_inq_varid(ncid, "prec", precid) )
call check_nf90( nf90_get_var(ncid, precid, prec) )
call check_nf90( nf90_close(ncid) )

countd = 0
countall = 0
countSE = 0
countWE = 0
countWW = 0
countSW = 0
bin = 0

do year=1,10
    do month=1,12
        do day=1,dom(month)
            countd = countd + 1
            if(month /= 12 .and. month > 4) cycle
            h1 = (countd-1)*24 + 1
            h2 = h1 + 23
            diurprec = diurprec + prec(:,h1:h2)
            countall = countall + 1
            if (uperp(countd)<=uQ1) then
                diurprecSE = diurprecSE + prec(:,h1:h2)
                countSE = countSE + 1
            elseif(uperp(countd)<uQ2) then
                diurprecWE = diurprecWE + prec(:,h1:h2)
                countWE = countWE + 1
            elseif(uperp(countd)<uQ3) then
                diurprecWW = diurprecWW + prec(:,h1:h2)
                countWW = countWW + 1
            else
                diurprecSW = diurprecSW + prec(:,h1:h2)
                countSW = countSW + 1
            endif
            ind = int((uperp(countd)+10.)/0.5) + 1
            if (ind < 1 .or. ind > 50) write(*,"(I0.4,2I0.2)") year,month,day
            bin(ind) = bin(ind) + 1
        enddo
    enddo
enddo
print*, countSE, countWE, countWW, countSW
print*, bin
diurprec = diurprec/real(countall, kind=4)
diurprecSE = diurprecSE/real(countSE, kind=4)
diurprecWE = diurprecWE/real(countWE, kind=4)
diurprecWW = diurprecWW/real(countWW, kind=4)
diurprecSW = diurprecSW/real(countSW, kind=4)

filename = trim(path)//trim(casename)//".diurprec.nc"
call check_nf90( nf90_create(filename, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "X", nx, xid) )
call check_nf90( nf90_def_dim(ncid, "time", 24, timeid) )
call check_nf90( nf90_def_var(ncid, "X", NF90_DOUBLE, xid, xvid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "prec", NF90_FLOAT, (/xid, timeid/), precid) )
call check_nf90( nf90_def_var(ncid, "precSE", NF90_FLOAT, (/xid, timeid/), precseid) )
call check_nf90( nf90_def_var(ncid, "precWE", NF90_FLOAT, (/xid, timeid/), precweid) )
call check_nf90( nf90_def_var(ncid, "precWW", NF90_FLOAT, (/xid, timeid/), precwwid) )
call check_nf90( nf90_def_var(ncid, "precSW", NF90_FLOAT, (/xid, timeid/), precswid) )
call check_nf90( nf90_put_att(ncid, xvid, "long_name", &
                                "distance from the coast line of Sumatra") )
call check_nf90( nf90_put_att(ncid, xvid, "units", "degrees") )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, precid, "long_name", "precipitation") )
call check_nf90( nf90_put_att(ncid, precid, "units", "mm/h") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, (/(real(t,kind=8), t=0,23)/)) )
call check_nf90( nf90_put_var(ncid, xvid, &
            (/ -11.25, -8.75, -6.25, -3.75, -1.25, 1.25, 3.75, 6.25 /)) )
call check_nf90( nf90_put_var(ncid, precid, diurprec) )
call check_nf90( nf90_put_var(ncid, precseid, diurprecSE) )
call check_nf90( nf90_put_var(ncid, precweid, diurprecWE) )
call check_nf90( nf90_put_var(ncid, precwwid, diurprecWW) )
call check_nf90( nf90_put_var(ncid, precswid, diurprecSW) )
call check_nf90( nf90_close(ncid) )

filename = trim(path)//trim(casename)//".Uperp_PDF.nc"
call check_nf90( nf90_create(filename, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "bin", 50, binid) )
call check_nf90( nf90_def_var(ncid, "bin", NF90_FLOAT, binid, binvid) )
call check_nf90( nf90_def_var(ncid, "N", NF90_INT, binid, nid) )
call check_nf90( nf90_put_att(ncid, binvid, "long_name", "mid value of bins") )
call check_nf90( nf90_put_att(ncid, binvid, "unit", "m/s") )
call check_nf90( nf90_put_att(ncid, nid, "long_name", & 
            "day counts of Uperp from 0001-0010 [DJFMA]") )
call check_nf90( nf90_put_att(ncid, nid, "unit", "#day") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, binvid, (/(real(t)*0.5-9.75, t=0,49)/)) )
call check_nf90( nf90_put_var(ncid, nid, bin) )
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
