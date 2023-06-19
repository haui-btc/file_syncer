#!/bin/bash

# Get start time
START=$(date +%s)

# Exit immediately if a command exits with a non-zero status
set -e

# Function to handle errors
handle_error() {
    local line=$1
    echo "An error occurred on line $line"
    exit 1
}

# Call handle_error() function when the script exits with an error
trap 'handle_error $LINENO' ERR

# Source and destination folders
SRC1="/home/haui/Dokumente/IT/"
DST1="/synology-nas/IT"

SRC2="/home/haui/Dokumente/Haushalt/"
DST2="/synology-nas/Haushalt"

# Save the Foldername in a variable
BASE1=$(basename "$SRC1")
BASE2=$(basename "$SRC2")

# Unison options
OPTS="-auto -silent"

# Function for the spinner
spinner() {
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "Script is running %c" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    done
    printf "                            \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}

# Execute Unison in the background and save the output
unison $OPTS "$SRC1" "$DST1" > /tmp/out1 & PID1=$!
unison $OPTS "$SRC2" "$DST2" > /tmp/out2 & PID2=$!

# Start the spinner
spinner $PID1
spinner $PID2

# Wait for Unison to finish
wait $PID1
wait $PID2

# Get end time
END=$(date +%s)

# Calculate duration
DURATION=$((END - START))

# Use grep to count the number of updated files
NUM_FILES1=$(grep -c 'updates:' /tmp/out1)
NUM_FILES2=$(grep -c 'updates:' /tmp/out2)

# Print the result
echo
echo "<<<< Copying finished >>>>"
echo "Copied $NUM_FILES1 files to $BASE1"
echo "Copied $NUM_FILES2 files to $BASE2"
echo "Time taken: $DURATION seconds"

# Remove the tmp files
rm /tmp/out1 /tmp/out2
