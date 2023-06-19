# Bash Script for Rsync

This repository contains a bash script that uses rsync for synchronizing files between two directories located at different paths. The paths for these directories are loaded from a configuration file (paths.conf), enabling easy management and modification of source and destination paths.

## How it works

The script performs the following tasks:

1. Loads source and destination paths from paths.conf.
2. Uses rsync to copy files from the source to the destination directory.
3. Provides a spinning progress indicator while the copying operation is ongoing.
4. Calculates and displays the number of files copied and the total time taken for the operation.

## Configuration

The paths.conf file should contain the source and destination directories for the rsync operations in the following format:

```bash
SRC1="/path/to/source/directory/1"
DST1="/path/to/destination/directory/1"

SRC2="/path/to/source/directory/2"
DST2="/path/to/destination/directory/2"
```

Please replace "/path/to/source/directory/1", "/path/to/destination/directory/1", "/path/to/source/directory/2", and "/path/to/destination/directory/2" with your actual directory paths.

## Running the script

You can run the script with the following command:

```bash
./file_syncer.sh
```

Please ensure that the script has execute permissions. If not, you can add execute permissions with the following command:

```bash
chmod +x script.sh
```

## Error Handling

The script uses a trap command to catch errors and will print the line number where the error occurred.
