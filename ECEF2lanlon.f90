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
