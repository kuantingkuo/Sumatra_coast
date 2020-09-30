program readcltype
use netcdf
implicit none
character(30), parameter :: path="/data/W.eddie/cloudtype/CPL64/"
character(3), dimension(4), parameter :: lon1=(/"98","95","93","95"/)
character(3), dimension(4), parameter :: lat1=(/"-10","-9","-7","-7"/)
character(3), dimension(4), parameter :: lon2=(/"98","100","98","95"/)
character(3), dimension(4), parameter :: lat2=(/"-9","-9","-7","-5"/)
character(3), dimension(4), parameter :: lon3=(/"100","98","100","98"/)
character(3), dimension(4), parameter :: lat3=(/"-7","-5","-5","-3"/)
character(3), dimension(3), parameter :: lon4=(/"103","100","100"/)
character(3), dimension(3), parameter :: lat4=(/"-5","-3","-1"/)
character(3), dimension(3), parameter :: lon5=(/"103","105","103"/)
character(3), dimension(3), parameter :: lon5=(/"-3","-3","-1"/)
character(3), dimension(3), parameter :: lat6=(/"105","103","105"/)
character(3), dimension(3), parameter :: lat6=(/"-1","1","1"/)

cltype = 0
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        write(mm,'(I0.2)') month
        do i=1,4
            filename = path//"Q_"//trim(lon1(i))//"-"//trim(lat1(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            open(unit=10, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            do
                read(10, '(I5,I9,F9.3,1X,A2)', iostat=eof) time, n, clsize, typetemp
                if (eof /= 0) exit
                t = mod(time, 24)
                if (t == 0) t=24
                call type2num(typetemp, clnum)
                cltype(clnum,1,t) = cltype(clnum,1,t) + 1
            enddo
            close(10)
        enddo
    enddo
enddo

contains

subroutine type2num(cltype, clnum)
character(2), intent(in) :: cltype
integer(kind=1), intent(out) :: clnum
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

subroutine check_nf90(err)
integer, intent(in) :: err
if (err /= nf90_noerr) then
  print*, "ERROR: ", nf90_strerror(err), err
  stop
endif
end subroutine

end program
