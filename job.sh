#/bin/bash

list=(8.0 7.8 7.6 7.4 7.2 7.0 6.8 6.6 6.4 6.2 6.0 5.8 5.6 5.4 5.2 5.0 4.8 4.6 4.4 4.2 4.0 3.8 3.6 3.4 3.2 3.0 2.8 2.6 2.4 2.2 2.0)
host="compute-0-12"
core=2
temp=300
fold="EN_NaF_1273_0.1_nvtsample"
mkdir ${fold}

i=0
dir1="${list[$i]}"
cd ${list[${i}]}
date -d now
nohup mpirun --prefix /export/apps/openmpi-2.1.0 --hostfile ${host} -np ${core} --mca btl_base_warn_component_unused 0 /export/apps/bin/DLPOLY.Z-4.09-openmpi
date -d now
awk '{if(NR>=1&&(NR-9)%10==0) print $1}' STATIS > EN_${dir1}
echo -e "output EN_${dir1}"
cp EN_${dir1} ../${fold}

while [ ${i} -le 29 ] 
do

	let i++
	dir2="${list[$i]}"
	mkdir ../${dir2}
	echo -e "making dir ${dir2}\n"

        cp CONTROL ../${dir2}
        cp FIELD ../${dir2}
	cp ${host} ../${dir2}
#	cp  file.name ./${list[${i}]}
#       sed -i -e "10d" -i -e "9 a pmf  ${dir1} " FIELD
	date -d now
#	nohup mpirun -host ${host} -np ${core} lmp_mpi <input>out 
	cp REVCON ../${dir2} 
	cd ../${dir2}
	sed -i -e "10d" -i -e "9 a pmf  ${dir2} " FIELD
 	mv REVCON CONFIG
	nohup mpirun --prefix /export/apps/openmpi-2.1.0 --hostfile ${host} -np ${core} --mca btl_base_warn_component_unused 0 /export/apps/bin/DLPOLY.Z-4.09-openmpi
	date -d now
	awk '{if(NR>=1&&(NR-9)%10==0) print $1}' STATIS > EN_${dir2}
	echo -e "output EN_${dir2}"
	cp EN_${dir2} ../${fold}
	
done

echo -e "done!"
