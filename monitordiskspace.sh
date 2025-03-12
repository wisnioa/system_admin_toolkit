#!/bin/bash

# Disk space settings
THRESHOLD=80  

# Directory settings
DIRECTORY="/var/log"
LIMIT=1000000  

# Check disk usage
echo "Checking disk space usage..."
df -h | awk -v threshold="$THRESHOLD" '
NR==1 {print $0} 
NR>1 {
    print $0;
    usage=$5; 
    gsub(/%/, "", usage);  # Remove % symbol to compare as a number
    if (usage+0 > threshold) 
        print "WARNING: High disk usage on "$6": "$5
}'


# Check multiple directories
echo ""
echo "Checking directory sizes..."

read -p "Enter the number of levels to check (if no entered input, default is 3): " N
N=${N:-3}  

DIR="$PWD"

DIRECTORIES=("$DIR")  


for ((i=0; i<N; i++)); do
    DIR=$(dirname "$DIR")
    DIRECTORIES+=("$DIR")
done


for DIR in "${DIRECTORIES[@]}"; do
    if [ -d "$DIR" ]; then
        DIR_SIZE=$(du -sk "$DIR" | awk '{print $1}')
        echo "Directory: $DIR"
        echo "Size: $DIR_SIZE KB"
    else
        echo "WARNING: Directory $DIR does not exist!"
    fi
    echo "---------------------------------"
done