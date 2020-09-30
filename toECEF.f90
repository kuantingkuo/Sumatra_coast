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
