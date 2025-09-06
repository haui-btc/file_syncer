#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
source "$(dirname "$0")/paths.conf"

# Rsync options with --chmod for setting permissions explicitly
OPTS="-auvO --chmod=Du=rwx,Dg=rwx,Do=rx,Fu=rw,Fg=rw,Fo=r --stats"

# Function for the spinner
spinner() {
    local pid=$1
    local delay=0.75
    local spinstr='|/-\\'
    while [ "$(ps a | awk '{print $1}' | grep -w $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "       \b\b\b\b\b\b"
}

# Array to store the number of files copied for each folder
declare -a FILES_COPIED

# Loop over each source and destination
for i in "${!SRC[@]}"; do
  echo -e "${CYAN}📁 Backup from:${NC} ${SRC[$i]}"
  echo -e "${CYAN}📁 To:        ${NC} ${DST[$i]}"
  echo -e "${YELLOW}⏳ Starting backup...${NC}"
  rsync $OPTS "${SRC[$i]}" "${DST[$i]}" 2>&1 | grep -v 'failed: Invalid argument (22)' > /tmp/out$i & PID=$!
  
  # Start the spinner
  spinner $PID
  
  # Wait for rsync to finish
  wait $PID
  
  # Read the output from the tmp files
  OUT=$(cat /tmp/out$i)
  
  # Use grep to extract the number of files transferred
  NUM_FILES=$(echo "$OUT" | grep 'Number of regular files transferred' | awk '{print $6 }')
  
  # Store the number of files copied
  if [[ -z "$NUM_FILES" ]]; then
    NUM_FILES=0
  fi
  FILES_COPIED[$i]=$NUM_FILES
  
  # Print the result for each source and destination
  echo
  echo -e "${GREEN}✅ Backup completed for:${NC} ${SRC[$i]}"
  echo -e "${GREEN}📦 Copied: $NUM_FILES file(s)${NC}"
  echo

  # Remove the tmp files
  rm /tmp/out$i
done

# Get end time
END=$(date +%s)

# Calculate duration
DURATION=$((END - START))

# Print summary
echo -e "\n${CYAN}📊 Summary:${NC}"
echo -e "${CYAN}==================${NC}"
for i in "${!SRC[@]}"; do
  echo -e "${GREEN}📁 ${SRC[$i]}${NC}"
  echo -e "   → ${FILES_COPIED[$i]} file(s) copied"
done
echo -e "\n${CYAN}⏱️  Total duration: $DURATION seconds${NC}"

