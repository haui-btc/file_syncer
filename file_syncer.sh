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

# Load source and destination folders from a configuration file
source paths.conf

# Save the Foldername in a variable
BASE1=$(basename "$SRC1")
BASE2=$(basename "$SRC2")

# Rsync options
OPTS="-au --stats"

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

# Loop over each source and destination
for i in "${!SRC[@]}"; do
  # Execute rsync in the background and save the output
  rsync $OPTS "${SRC[$i]}" "${DST[$i]}" 2>&1 | grep -v 'failed: Invalid argument (22)' > /tmp/out$i & PID=$!
  
  # Start the spinner
  spinner $PID
  
  # Wait for rsync to finish
  wait $PID
  
  # Save the folder name in a variable
  BASE=$(basename "${SRC[$i]}")
  
  # Read the output from the tmp files
  OUT=$(cat /tmp/out$i)
  
  # Use grep to extract the number of files transferred
  NUM_FILES=$(echo "$OUT" | grep 'Number of regular files transferred' | awk '{print $6 }')
  
  # Print the result for each source and destination
  echo
  echo ##########################################
  echo "<<<< Copying finished for Source $i >>>>"
  echo "--> Copied $NUM_FILES files to $BASE"
  echo ------------------------------------------

  # Remove the tmp files
  rm /tmp/out$i
done

# Get end time
END=$(date +%s)

# Calculate duration
DURATION=$((END - START))

# Print total time taken
echo "Time taken: $DURATION seconds"
echo
