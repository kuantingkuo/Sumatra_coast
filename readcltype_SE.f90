program readcltype
use netcdf
implicit none
character(10), parameter :: casename="CPL64"
character(99), parameter :: path="/data/W.eddie/cloudtype/"//trim(casename)//"/"
character(99), parameter :: outpath="/data/W.eddie/Sumatra/"//trim(casename)//"/"
character(3), dimension(4), parameter :: lon1=(/"98","95","93","95"/)
character(3), dimension(4), parameter :: lat1=(/"-10","-9","-7","-7"/)
character(3), dimension(4), parameter :: lon2=(/"98","100","98","95"/)
character(3), dimension(4), parameter :: lat2=(/"-9","-9","-7","-5"/)
character(3), dimension(4), parameter :: lon3=(/"100","98","100","98"/)
character(3), dimension(4), parameter :: lat3=(/"-7","-5","-5","-3"/)
character(3), dimension(3), parameter :: lon4=(/"103","100","100"/)
character(3), dimension(3), parameter :: lat4=(/"-5","-3","-1"/)
character(3), dimension(3), parameter :: lon5=(/"103","105","103"/)
character(3), dimension(3), parameter :: lat5=(/"-3","-3","-1"/)
character(3), dimension(3), parameter :: lon6=(/"105","103","105"/)
character(3), dimension(3), parameter :: lat6=(/"-1","1","1"/)
integer, dimension(8,6,48) :: cltype
real(kind=4), dimension(8,6,48) :: clsize
real(kind=4), dimension(3650) :: uperp
integer :: year, month, i, id, idend, eof, t, time, n, clnum, day, j10day, uid
character(4) :: yyyy
character(2) :: mm, typetemp
character(99) :: filename, outfile
real(kind=4) :: sizetemp
integer :: ncid, xid, xvid, timeid, timevid, hcid, asid, acid, stid, scid, cuid, &
           nsid, dcid

call check_nf90( nf90_open(trim(outpath)//trim(casename)//".Uperp.nc", &
                           NF90_NOWRITE, ncid) )
call check_nf90( nf90_inq_varid(ncid, "Uperp", uid) )
call check_nf90( nf90_get_var(ncid, uid, uperp) )
call check_nf90( nf90_close(ncid) )

cltype = 0
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        if(month > 4 .and. month < 12) cycle
        write(mm,'(I0.2)') month
        do i=1,4
            filename = trim(path)//"Q_"//trim(lon1(i))//"-"//trim(lat1(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            open(unit=10, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon2(i))//"-"//trim(lat2(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            open(unit=20, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon3(i))//"-"//trim(lat3(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            open(unit=30, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon4(i))//"-"//trim(lat4(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            if(i <= 3) then
                open(unit=40, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
                filename = trim(path)//"Q_"//trim(lon5(i))//"-"//trim(lat5(i))// &
                            "_"//yyyy//"-"//mm//".txt"
                open(unit=50, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
                filename = trim(path)//"Q_"//trim(lon6(i))//"-"//trim(lat6(i))// &
                            "_"//yyyy//"-"//mm//".txt"
                open(unit=60, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
            endif
            if(i > 3) then 
                idend = 30
            else
                idend = 60
            endif
            do id=10,idend,10
            do
                read(id, '(I5,I9,F9.3,1X,A2)', iostat=eof) time, n, sizetemp, typetemp
                if (eof /= 0) exit
                day = (time-1)/48 + 1
                call do10y(year, month, day, j10day)
                if (uperp(j10day) > -0.2814124-2.777613) cycle  ! SE
                t = mod(time, 48)
                if (t == 0) t = 48
                call type2num(typetemp, clnum)
                cltype(clnum,id/10,t) = cltype(clnum,id/10,t) + 1
                clsize(clnum,id/10,t) = clsize(clnum,id/10,t) + sizetemp
            enddo
            close(id)
            enddo
        enddo
    enddo
enddo
outfile = trim(outpath)//"/cltype_diurnal_DJFMA_SE.nc"
call check_nf90( nf90_create(outfile, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "X", 6, xid) )
call check_nf90( nf90_def_dim(ncid, "time", 48, timeid) )
call check_nf90( nf90_def_var(ncid, "X", NF90_DOUBLE, xid, xvid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "Hc", NF90_INT, (/xid, timeid/), hcid) )
call check_nf90( nf90_def_var(ncid, "As", NF90_INT, (/xid, timeid/), asid) )
call check_nf90( nf90_def_var(ncid, "Ac", NF90_INT, (/xid, timeid/), acid) )
call check_nf90( nf90_def_var(ncid, "St", NF90_INT, (/xid, timeid/), stid) )
call check_nf90( nf90_def_var(ncid, "Sc", NF90_INT, (/xid, timeid/), scid) )
call check_nf90( nf90_def_var(ncid, "Cu", NF90_INT, (/xid, timeid/), cuid) )
call check_nf90( nf90_def_var(ncid, "Ns", NF90_INT, (/xid, timeid/), nsid) )
call check_nf90( nf90_def_var(ncid, "Dc", NF90_INT, (/xid, timeid/), dcid) )
call check_nf90( nf90_put_att(ncid, xvid, "long_name", &
                                "distance from the coast line of Sumatra") )
call check_nf90( nf90_put_att(ncid, xvid, "units", "degrees") )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, timevid, "calendar", "noleap") )
call check_nf90( nf90_put_att(ncid, hcid, "long_name", "High cloud counts") )
call check_nf90( nf90_put_att(ncid, asid, "long_name", "Altostratus counts") )
call check_nf90( nf90_put_att(ncid, acid, "long_name", "Altocumulus counts") )
call check_nf90( nf90_put_att(ncid, stid, "long_name", "Stratus counts") )
call check_nf90( nf90_put_att(ncid, scid, "long_name", "Stratocumulus counts") )
call check_nf90( nf90_put_att(ncid, cuid, "long_name", "Cumulus counts") )
call check_nf90( nf90_put_att(ncid, nsid, "long_name", "Nimbostratus counts") )
call check_nf90( nf90_put_att(ncid, dcid, "long_name", "Deep convective cloud counts") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, (/ (real(i,kind=8)/48._8, i=0,47) /)) )
call check_nf90( nf90_put_var(ncid, xvid, (/ (real(i,kind=8)*2.5_8-11.25_8, i=1,6) /)) )
call check_nf90( nf90_put_var(ncid, hcid, cltype(1,:,:)) )
call check_nf90( nf90_put_var(ncid, asid, cltype(2,:,:)) )
call check_nf90( nf90_put_var(ncid, acid, cltype(3,:,:)) )
call check_nf90( nf90_put_var(ncid, stid, cltype(4,:,:)) )
call check_nf90( nf90_put_var(ncid, scid, cltype(5,:,:)) )
call check_nf90( nf90_put_var(ncid, cuid, cltype(6,:,:)) )
call check_nf90( nf90_put_var(ncid, nsid, cltype(7,:,:)) )
call check_nf90( nf90_put_var(ncid, dcid, cltype(8,:,:)) )
call check_nf90( nf90_close(ncid) )

outfile = trim(outpath)//"/clsize_diurnal_DJFMA_SE.nc"
call check_nf90( nf90_create(outfile, NF90_NETCDF4, ncid) )
call check_nf90( nf90_def_dim(ncid, "X", 6, xid) )
call check_nf90( nf90_def_dim(ncid, "time", 48, timeid) )
call check_nf90( nf90_def_var(ncid, "X", NF90_DOUBLE, xid, xvid) )
call check_nf90( nf90_def_var(ncid, "time", NF90_DOUBLE, timeid, timevid) )
call check_nf90( nf90_def_var(ncid, "Hc", NF90_INT, (/xid, timeid/), hcid) )
call check_nf90( nf90_def_var(ncid, "As", NF90_INT, (/xid, timeid/), asid) )
call check_nf90( nf90_def_var(ncid, "Ac", NF90_INT, (/xid, timeid/), acid) )
call check_nf90( nf90_def_var(ncid, "St", NF90_INT, (/xid, timeid/), stid) )
call check_nf90( nf90_def_var(ncid, "Sc", NF90_INT, (/xid, timeid/), scid) )
call check_nf90( nf90_def_var(ncid, "Cu", NF90_INT, (/xid, timeid/), cuid) )
call check_nf90( nf90_def_var(ncid, "Ns", NF90_INT, (/xid, timeid/), nsid) )
call check_nf90( nf90_def_var(ncid, "Dc", NF90_INT, (/xid, timeid/), dcid) )
call check_nf90( nf90_put_att(ncid, xvid, "long_name", &
                                "distance from the coast line of Sumatra") )
call check_nf90( nf90_put_att(ncid, xvid, "units", "degrees") )
call check_nf90( nf90_put_att(ncid, timevid, "long_name", "time") )
call check_nf90( nf90_put_att(ncid, timevid, "units", "days since 0001-01-01 00:00:00") )
call check_nf90( nf90_put_att(ncid, timevid, "calendar", "noleap") )
call check_nf90( nf90_put_att(ncid, hcid, "long_name", "High cloud counts") )
call check_nf90( nf90_put_att(ncid, hcid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, asid, "long_name", "Altostratus counts") )
call check_nf90( nf90_put_att(ncid, asid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, acid, "long_name", "Altocumulus counts") )
call check_nf90( nf90_put_att(ncid, acid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, stid, "long_name", "Stratus counts") )
call check_nf90( nf90_put_att(ncid, stid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, scid, "long_name", "Stratocumulus counts") )
call check_nf90( nf90_put_att(ncid, scid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, cuid, "long_name", "Cumulus counts") )
call check_nf90( nf90_put_att(ncid, cuid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, nsid, "long_name", "Nimbostratus counts") )
call check_nf90( nf90_put_att(ncid, nsid, "units", "km^2") )
call check_nf90( nf90_put_att(ncid, dcid, "long_name", "Deep convective cloud counts") )
call check_nf90( nf90_put_att(ncid, dcid, "units", "km^2") )
call check_nf90( nf90_enddef(ncid) )

call check_nf90( nf90_put_var(ncid, timevid, (/ (real(i,kind=8)/48._8, i=0,47) /)) )
call check_nf90( nf90_put_var(ncid, xvid, (/ (real(i,kind=8)*2.5_8-11.25_8, i=1,6) /)) )
call check_nf90( nf90_put_var(ncid, hcid, clsize(1,:,:)) )
call check_nf90( nf90_put_var(ncid, asid, clsize(2,:,:)) )
call check_nf90( nf90_put_var(ncid, acid, clsize(3,:,:)) )
call check_nf90( nf90_put_var(ncid, stid, clsize(4,:,:)) )
call check_nf90( nf90_put_var(ncid, scid, clsize(5,:,:)) )
call check_nf90( nf90_put_var(ncid, cuid, clsize(6,:,:)) )
call check_nf90( nf90_put_var(ncid, nsid, clsize(7,:,:)) )
call check_nf90( nf90_put_var(ncid, dcid, clsize(8,:,:)) )
call check_nf90( nf90_close(ncid) )
contains

subroutine type2num(cltype, clnum)
character(2), intent(in) :: cltype
integer, intent(out) :: clnum
select case(cltype)
    case("Hc")
        clnum = 1
    case("As")
        clnum = 2
    case("Ac")
        clnum = 3
    case("St")
        clnum = 4
    case("Sc")
        clnum = 5
    case("Cu")
        clnum = 6
    case("Ns")
        clnum = 7
    case("Dc")
        clnum = 8
end select
end subroutine

subroutine do10y(year, month, day, j10day)
integer, intent(in) :: year, month, day
integer, intent(out) :: j10day
integer, dimension(12), parameter :: dom=(/31,28,31,30,31,30,31,31,30,31,30,31/)
integer :: i, mdaysum
mdaysum = 0
do i=1,month-1
    mdaysum = mdaysum + dom(i)
enddo
j10day = (year-1)*365 + mdaysum + day
end subroutine

subroutine check_nf90(err)
integer, intent(in) :: err
if (err /= nf90_noerr) then
  print*, "ERROR: ", nf90_strerror(err), err
  stop
endif
end subroutine

end program
