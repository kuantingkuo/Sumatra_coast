program readcltype
implicit none
character(10), parameter :: casename="PRSHR"
character(99), parameter :: path="/data/W.eddie/cloudtype/"//trim(casename)//"/"
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
integer :: year, month, i, id, idend, eof, t, time, n, clnum
character(4) :: yyyy
character(2) :: mm, typetemp
character(99) :: filename, outfile
real(kind=4) :: sizetemp
integer :: ncid, xid, xvid, timeid, timevid, hcid, asid, acid, stid, scid, cuid, &
           nsid, dcid

cltype = 0
do year=1,10
    write(yyyy,'(I0.4)') year
    do month=1,12
        if(month > 4 .and. month < 12) cycle
        write(mm,'(I0.2)') month
        print*, yyyy//mm
        do i=1,4
            filename = trim(path)//"Q_"//trim(lon1(i))//"-"//trim(lat1(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            call checkfile(filename)
            open(unit=10, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon2(i))//"-"//trim(lat2(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            call checkfile(filename)
            open(unit=20, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon3(i))//"-"//trim(lat3(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            call checkfile(filename)
            open(unit=30, file=filename, status='old', access='sequential', &
                    form='formatted', action='read')
            filename = trim(path)//"Q_"//trim(lon4(i))//"-"//trim(lat4(i))// &
                        "_"//yyyy//"-"//mm//".txt"
            call checkfile(filename)
            if(i <= 3) then
                open(unit=40, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
                filename = trim(path)//"Q_"//trim(lon5(i))//"-"//trim(lat5(i))// &
                            "_"//yyyy//"-"//mm//".txt"
                call checkfile(filename)
                open(unit=50, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
                filename = trim(path)//"Q_"//trim(lon6(i))//"-"//trim(lat6(i))// &
                            "_"//yyyy//"-"//mm//".txt"
                call checkfile(filename)
                open(unit=60, file=filename, status='old', access='sequential', &
                        form='formatted', action='read')
            endif
            close(id)
        enddo
    enddo
enddo
contains

subroutine checkfile( filename )
character(*), intent(in) :: filename
logical :: logopen, ex
integer :: qtime
qtime=120000
inquire(file=filename, exist=ex)
do while(.not. ex)
    print*, trim(filename)
    call sleepqq(qtime)
    inquire(file=filename, exist=ex)
enddo

inquire(file=filename, opened=logopen)
do while(logopen)
    print*, trim(filename)
    call sleepqq(qtime)
    inquire(file=filename, opened=logopen)
enddo
end subroutine

end program
