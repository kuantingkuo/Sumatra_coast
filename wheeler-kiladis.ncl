load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"
;=============================================================
begin
  case     = "PRSHR"
  diro     = "../"+case+"/"     ; output dir: location of plots  [wkdir]

  latBound = 15

  level    = -999     ; only used for 4D [set -999 otherwise]

  VAR      = "FLUT"
;  VAR      = "olr"
  spd      = 1        ; samples per day
  diri     = "/data/W.eddie/SPCAM/"+case+"/"
;  diri     = "../"
;  diri     = "/data/W.eddie/NOAA-OLR/"
  fili     = case+".FLUT.daily.nc"
;  fili     = case+".FLUT.daily.nc"
;  fili     = "olr-daily_v01r02_20060101_20191231.nc"
;  fili     = "NOAA_non-interpolated_OLR.daily.2006-2019.nc"
;  fili     = "NOAA_Interpolated_OLR.daily.2000-2018.nc"

  nDayWin  = 96       ; Wheeler-Kiladis [WK] temporal window length (days)
  nDaySkip = -65      ; time (days) between temporal windows [segments]
                      ; negative means there will be overlapping temporal segments
  opt      = True
  opt@pltType = "eps" ; make eps
  opt@pltColorMap = "WhiteBlueGreenYellowRed"
  opt@Fig_3b = (/.5,.6,.7,.8,.9,1.,1.1,1.2,1.3,1.4,1.6,1.9,2.2,2.5,2.8/)
;  opt@pltTitle = case+" 2006-2019  LOG[Power: "+latBound+"S-"+latBound+"N]"

  wkSpaceTime_cam( diri, fili, diro, case, VAR, latBound, spd, level, nDayWin, nDaySkip, opt )
end
