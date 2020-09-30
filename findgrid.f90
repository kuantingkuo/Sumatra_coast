program findgrid
implicit none
real(kind=8), parameter :: pi=dacos(-1._8), a=6371220._8 
real(kind=8) :: lon1, lat1, lon2, lat2, h
real(kind=8) :: x1, y1, z1, x2, y2, z2
real(kind=8) :: nx, ny, nz, deg, rad
real(kind=8) :: px, py, pz, dd, mm
real(kind=8) :: nlon, nlat
real(kind=8) :: B, d, F, C, aA, bA, cA, b2m4ac
real(kind=8) :: z1A, y1A, x1A, z1B, y1B, x1B
real(kind=8) :: z2A, y2A, x2A, z2B, y2B, x2B
real(kind=8) :: lon1A, lat1A, lon1B, lat1B, ddeg, i
real(kind=8) :: lon2A, lat2A, lon2B, lat2B

lon1=99.75_8
lat1=-0.05_8
h=0._8
call toECEF(lon1, lat1, h, x1, y1, z1)

lon2=104.05_8
lat2=-5.35_8
h=0._8
call toECEF(lon2, lat2, h, x2, y2, z2)

px=x1-x2
py=y1-y2
pz=z1-z2

do i=1,5
   ddeg=2.5_8*real(i,kind=8)
   d=dsqrt(a**2._8-(px**2._8+py**2._8+pz**2._8)/4._8) * dsin(ddeg/2._8*pi/180._8) * 2._8
   F=a**2._8-(d**2._8/2._8)
   
   B=(pz*x1-px*z1)/(px*y1-py*x1)
   C=(F*px-px*x1**2._8-py*x1*y1-pz*x1*z1)/(px*y1-py*x1)
   
   aA=((y1*B+z1)/x1)**2._8 + B**2._8 + 1._8
   bA=2._8*B*C - 2._8*((y1*B+z1)/x1)*(F-y1*C)/x1
   cA=((F-y1*C)/x1)**2._8 + C**2._8 - a**2._8
   b2m4ac=bA**2._8-4._8*aA*cA
   if(b2m4ac < 0._8) then
     print*,"error: no real root"
     stop
   else
     z1A=(dsqrt(b2m4ac)-bA)/(aA*2._8)
     y1A=B*z1A+C
     x1A=(F-y1*y1A-z1*z1A)/x1
   
     z1B=(-dsqrt(b2m4ac)-bA)/(aA*2._8)
     y1B=B*z1B+C
     x1B=(F-y1*y1B-z1*z1B)/x1
   endif

   B=(pz*x2-px*z2)/(px*y2-py*x2)
   C=(F*px-px*x2**2._8-py*x2*y2-pz*x2*z2)/(px*y2-py*x2)

   aA=((y2*B+z2)/x2)**2._8 + B**2._8 + 1._8
   bA=2._8*B*C - 2._8*((y2*B+z2)/x2)*(F-y2*C)/x2
   cA=((F-y2*C)/x2)**2._8 + C**2._8 - a**2._8
   b2m4ac=bA**2._8-4._8*aA*cA
   if(b2m4ac < 0._8) then
     print*,"error: no real root"
     stop
   else
     z2A=(dsqrt(b2m4ac)-bA)/(aA*2._8)
     y2A=B*z2A+C
     x2A=(F-y2*y2A-z2*z2A)/x2

     z2B=(-dsqrt(b2m4ac)-bA)/(aA*2._8)
     y2B=B*z2B+C
     x2B=(F-y2*y2B-z2*z2B)/x2
   endif
 
   call degree2(x1-px/2._8, y1-py/2._8, z1-pz/2._8, x1A-px/2._8, y1A-py/2._8, z1A-pz/2._8, deg, rad)
   write(*,'(2F11.6)') ddeg, deg
   call ecef2latlon(x1A, y1A, z1A, lon1A, lat1A, h)
   call ecef2latlon(x2A, y2A, z2A, lon2A, lat2A, h)
   write(*,'(5F11.6)') lon1A, lat1A, lon2A, lat2A, h
   call ecef2latlon(x1B, y1B, z1B, lon1B, lat1B, h)
   call ecef2latlon(x2B, y2B, z2B, lon2B, lat2B, h)
   write(*,'(5F11.6)') lon1B, lat1B, lon2B, lat2B, h

enddo
end program

subroutine degree(lon1, lat1, lon2, lat2, deg, rad)
real(kind=8), intent(in) :: lon1, lat1, lon2, lat2
real(kind=8), intent(out) :: deg, rad
real(kind=8), parameter :: pi=dacos(-1._8)
real(kind=8) :: phi1, lamda1, phi2, lamda2
phi1=lat1*pi/180._8
lamda1=lon1*pi/180._8
phi2=lat2*pi/180._8
lamda2=lon2*pi/180._8

rad = dacos( dcos(phi1)*dcos(phi2) * &
             (dcos(lamda1)*dcos(lamda2) + dsin(lamda1)*dsin(lamda2)) + &
             dsin(phi1)*dsin(phi2) )
deg = rad*180._8/pi

end subroutine

subroutine degree2(x1, y1, z1, x2, y2, z2, deg, rad)
real(kind=8), intent(in) :: x1, y1, z1, x2, y2, z2
real(kind=8), intent(out) :: deg, rad
real(kind=8), parameter :: pi=dacos(-1._8)
real(kind=8) :: phi1, lamda1, phi2, lamda2
rad = dacos( (x1*x2 + y1*y2 + z1*z2) / &
             (dsqrt(x1**2+y1**2+z1**2) * dsqrt(x2**2+y2**2+z2**2)) )
deg = rad*180._8/pi

end subroutine

subroutine toECEF(lon, lat, h, x, y, z)
real(kind=8), intent(in) :: lon, lat, h
real(kind=8), intent(out) :: x, y, z
real(kind=8), parameter :: a=6.37122e6, pi=dacos(-1._8)
real(kind=8) :: phi, lamda, b
b = a
phi = lat*pi/180._8
lamda = lon*pi/180._8

N = a**2/dsqrt( a**2 * dcos(phi)**2 + b**2 * dsin(phi)**2 )
x = (N+h) * dcos(phi) * dcos(lamda)
y = (N+h) * dcos(phi) * dsin(lamda)
z = (b**2/a**2 * N + h) * dsin(phi)
end subroutine

subroutine ecef2latlon(x, y, z, lon, lat, alt)
!! convert ECEF (meters) to geodetic coordintes
!!
!! based on:
!! You, Rey-Jer. (2000). Transformation of Cartesian to Geodetic
!Coordinates without Iterations.
!! Journal of Surveying Engineering. doi: 10.1061/(ASCE)0733-9453
real(kind=8), intent(in) :: x, y, z
real(kind=8), intent(out) :: lon, lat, alt
real(kind=8) :: eb, r, E, u, Q, huE, Beta, eps, sinBeta, cosBeta
real(kind=8), parameter :: ea=6.37122e6, pi=dacos(-1._8)
logical :: d, inside

eb = ea

r = dsqrt(x**2 + y**2 + z**2)

E = dsqrt(ea**2 - eb**2)

! eqn. 4a
u = dsqrt(0.5 * (r**2 - E**2) + 0.5 * dsqrt((r**2 - E**2)**2 + 4 * E**2 * z**2))

Q = hypot(x, y)

huE = hypot(u, E)

!> eqn. 4b
Beta = datan2(huE / u * z, hypot(x, y))

!> final output
if (abs(beta-pi/2) <= epsilon(beta)) then !< singularity
  lat = pi/2
  cosBeta = 0
  sinBeta = 1
elseif (abs(beta+pi/2) <= epsilon(beta)) then !< singularity
  lat = -pi/2
  cosBeta = 0
  sinBeta = -1
else
  !> eqn. 13
  eps = ((eb * u - ea * huE + E**2) * dsin(Beta)) / &
         (ea * huE * 1 / dcos(Beta) - E**2 * dcos(Beta))
  Beta = Beta + eps

  lat = datan(ea / eb * dtan(Beta))
  cosBeta = dcos(Beta)
  sinBeta = dsin(Beta)
endif

lon = datan2(y, x)

! eqn. 7
  alt = hypot(z - eb * sinBeta, Q - ea * cosBeta)

  !> inside ellipsoid?
  inside = x**2 / ea**2 + y**2 / ea**2 + z**2 / eb**2 < 1._8
  if (inside) alt = -alt


lat = lat*180._8/pi
lon = lon*180._8/pi

end subroutine

