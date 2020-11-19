#!/bin/bash

casename=PRSHR
path=/data/W.eddie/SPCAM/${casename}/
lon=(97.5 95 97.5 100 92.5 95 97.5 100 95 97.5 100 102.5 97.5 100 102.5 105 100 102.5 105 102.5 105)
lat=(-10.4211 -8.52632 -8.52632 -8.52632 -6.63158 -6.63158 -6.63158 -6.63158 -4.73684 -4.73684 -4.73684 -4.73684 -2.84211 -2.84211 -2.84211 -2.84211 -0.947368 -0.947368 -0.947368 0.947368 0.947368)

source /opt/intel/composer_xe_2015/bin/compilervars.sh intel64
module load netcdf4.6.1-intel15.0

cd /data/W.eddie/cloudtype/

sed -i "4s|\(casename=\"\).*\"$|\1${casename}\"|" getCRM.f90
sed -i "5s|\(path=\"\).*\"$|\1${path}\"|" getCRM.f90
for ((i = 0; i < ${#lon[@]}; ++i)); do
    target_lon=${lon[$i]}
    target_lat=${lat[$i]}
    echo $target_lon $target_lat
    sed -i "6s|\(target_lon=\).*\(, target_lat=\).* \! target grid|\1${target_lon}\2${target_lat} \! target grid|" getCRM.f90

    ifort getCRM.f90 -o getCRM.exe -I/opt/netcdf-intel15/include -L/opt/netcdf-intel15/lib -lnetcdff -lnetcdf -mcmodel medium -shared-intel

    ./getCRM.exe
done
