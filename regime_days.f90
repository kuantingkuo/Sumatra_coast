program regime_days
use netcdf
implicit none
character(20), parameter :: casename="CPL64"
character(99), parameter :: path="../"//trim(casename)//"/"
real(kind=4), parameter :: uQ1=-0.2814124-2.777613, uQ2=-0.2814124, uQ3=-0.2814124+2.777613
integer, parameter :: nx=8, nd=3650, nt=87600
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
character(99) :: filename
real(kind=4), dimension(nd) :: uperp
integer :: countd, year, month, day, h1, h2, countall, countSE, countWE, countWW, countSW
integer :: ind, t, xid, xvid, timeid, timevid
integer :: nid, ncid, uid

filename = trim(path)//trim(casename)//".Uperp.nc"
call check_nf90( nf90_open(filename, NF90_NOWRITE, ncid) )
call check_nf90( nf90_inq_varid(ncid, "Uperp", uid) )
call check_nf90( nf90_get_var(ncid, uid, uperp) )
call check_nf90( nf90_close(ncid) )

countd = 0
countall = 0
countSE = 0
countWE = 0
countWW = 0
countSW = 0

do year=1,10
    do month=1,12
        do day=1,dom(month)
            countd = countd + 1
            if(month /= 12 .and. month > 4) cycle
            h1 = (countd-1)*24 + 1
            h2 = h1 + 23
            countall = countall + 1
            if (uperp(countd)<=uQ1) then
                countSE = countSE + 1
            elseif(uperp(countd)<uQ2) then
                countWE = countWE + 1
            elseif(uperp(countd)<uQ3) then
                countWW = countWW + 1
            else
                countSW = countSW + 1
            endif
        enddo
    enddo
enddo
print*, countSE, countWE, countWW, countSW

contains

subroutine check_nf90(err)
integer, intent(in) :: err
if (err /= nf90_noerr) then
    print*, "ERROR: ", nf90_strerror(err), err
    stop
endif
end subroutine

end program
