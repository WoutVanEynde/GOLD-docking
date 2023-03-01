# Script to automate concatanation of parallelisastion outputfiles
# This script is supposed to be used in same folder as the parallelisation script

### CHANGE VARIABLE ###

START_FILE="ambinter_all_solutions"

### CONCATANATION ###

for dir in */; do
	echo $dir
	cd $dir
	dirname=$(basename `pwd`)
	cp *_all_solutions.sdf ${START_FILE}_$dirname.sdf
	cp *_all_solutions_*.sdf ../
	cd .. 
done

cat *_all_solutions_*.sdf > ${START_FILE}.sdf
