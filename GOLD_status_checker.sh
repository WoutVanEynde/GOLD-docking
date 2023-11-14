# Script to check status of parallel dockings

for dir in */; do
    echo "$dir"
    cd $dir
    tail gold.log -n 9 | head -n 1
    cd ..
done
