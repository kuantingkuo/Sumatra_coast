case="CPL64"
path='/data/W.eddie/SPCAM/'case'/'
'reinit'
'ini -l'
'open 'path'atm.ctl'
'open 'path'plev.ctl'
'set lon 80 150'
'set lat -20 20'
'p=ave(prect*1000*86400,time=00z01jan0001,time=23z30apr0001)'

'set grads off'
'color -levs 1 2 4 6 8 10 12 14 16 18 20 -kind cwb'
'set xlint 10'
'set ylint 10'
'd p'
'cbar3 [mm d`a-1`n]'
'off'

