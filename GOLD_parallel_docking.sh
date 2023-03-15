# Script to automate splitting, distribution and docking compounds in parallel
# Prepare the gold.config using the wizard
# You need the dummy and the conformers in the same directory
# Ligand file has to be in *_*.sdf format

### Assign variables ###
START_FILE="monomer_ambinter"
SPLIT_NUMBER=10 					#Amount of compounds on each core
NUM_FOLDERS=9						#Amount of cores being used
GOLD_CONF_DIR="/home/wout/test"
GOLD_AUTO="/opt/CCDC/Discovery_2022/bin/gold_auto"

### Variables that do not need to be changed ###
GOLD_CONF_IN="${START_FILE}.sdf"
MOL2_OUT="${START_FILE}.mol2"
FILE_PATTERN="${START_FILE}_*"

### Splitting of .sdf file ###

python split_sdf.py "$START_FILE" "$SPLIT_NUMBER" &
pid=$!
wait $pid
echo "Splitting completed"

### Starting parallel run ###

# Create the required number of folders
for ((j=0; j<=$NUM_FOLDERS; j++)); do
    mkdir "$j"
done

# List the files matching the pattern and save to a file
ls $FILE_PATTERN > file_list.txt

# Move the listed files to their respective folders
awk -F[_.] '{print "mv " $0 " " $3 "/"}' < file_list.txt | sh -v

# Copy the gold.conf file to each folder and replace the relevant path
awk -F[_.] '{print "tee ./" $3 "/gold.conf < 'gold.conf' >/dev/null"}' < file_list.txt |sh -v
for dir in */; do
    echo "$dir"
    cd $dir
    sed -i "s?$GOLD_CONF_DIR?`pwd`?" gold.conf
    sed -i "s?$GOLD_CONF_IN?$MOL2_OUT?" gold.conf
    obabel *.sdf -O $MOL2_OUT
    sleep 15 
    $GOLD_AUTO gold.conf &
    sleep 15
    cd ..
done
