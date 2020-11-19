begin

expname = "PRSHR"
path = "/data/W.eddie/SPCAM/"+expname
date_sr = yyyymmdd_time(0001, 0010, "integer")
;dates = tostring(date_sr({00010101:00101231:1}))    ; coordinate subscripting
dates = sprinti("%0.8i",date_sr({00010101:00101231:1}))

lev_p = (/ 1000., 975., 950., 925., 900., 875., 850., 825., 775., 750., 700., 600., 500., 300., 200., 100. /)
lev_p!0         = "lev_p"                  ; variable/dim name
lev_p&lev_p     =  lev_p                   ; create coordinate variable
lev_p@long_name = "pressure"               ; attach some attributes
lev_p@units     = "hPa"
lev_p@positive  = "up"

do i=0,dimsizes(dates)-1
  print(dates(i))
  yyyy = str_get_cols(dates(i),0,3)
  mm = str_get_cols(dates(i),4,5)
  dd = str_get_cols(dates(i),6,7)
  if (mm+dd .eq. "0229") then
    continue
  end if

  fi = addfile(path+"/"+expname+".cam.h0."+yyyy+"-"+mm+"-"+dd+"-00000.nc", "r")
  hyam = fi->hyam
  hybm = fi->hybm
  p0   = fi->P0*0.01
  ps   = fi->PS

  omega = fi->OMEGA
  q = fi->Q
  t = fi->T
  u = fi->U
  v = fi->V
  z3 = fi->Z3

  omegap  = vinth2p(omega, hyam, hybm, lev_p, ps, 1, p0, 1, False )
  qp      = vinth2p(q, hyam, hybm, lev_p, ps, 1, p0, 1, False )
  tp      = vinth2p(t, hyam, hybm, lev_p, ps, 1, p0, 1, False )
  up      = vinth2p(u, hyam, hybm, lev_p, ps, 1, p0, 1, False )
  vp      = vinth2p(v, hyam, hybm, lev_p, ps, 1, p0, 1, False )
  z3p     = vinth2p(z3, hyam, hybm, lev_p, ps, 1, p0, 1, False )

  outf = path+"/"+expname+".cam.plev."+yyyy+"-"+mm+"-"+dd+".nc"
  system("/bin/rm -f " + outf)
  fo = addfile(outf, "c")

  copy_VarAtts(omega, omegap)
  copy_VarAtts(q, qp)
  copy_VarAtts(t, tp)
  copy_VarAtts(u, up)
  copy_VarAtts(v, vp)
  copy_VarAtts(z3, z3p)

  fo->OMEGA = omegap
  fo->Q = qp
  fo->T = tp
  fo->U = up
  fo->V = vp
  fo->Z3 = z3p

  delete(fi)
  delete(fo)
end do
end
