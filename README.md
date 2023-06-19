# Bash Script for Rsync

This repository contains a bash script that uses rsync for synchronizing files between multiple directories. The paths for these directories are loaded from a configuration file (paths.conf), enabling easy management and modification of source and destination paths.

## How it works

The script performs the following tasks:

1. Loads source and destination paths from paths.conf.
2. Loops over each source-destination pair and uses rsync to copy files from each source to its corresponding destination directory.
3. Provides a spinning progress indicator while the copying operation is ongoing for each pair.
4. Calculates and displays the number of files copied and the total time taken for all operations.

![Screenshot](screenshot1.png)

## Configuration

The paths.conf file should contain the source and destination directories for the rsync operations in the following format:
(rename 'paths_template.conf' to 'paths.conf')

```bash
SRC[i]="/path/to/source/directory/i"
DST[i]="/path/to/destination/directory/i"
```

Replace i with the index number and /path/to/source/directory/i and /path/to/destination/directory/i with your actual directory paths. You can add as many source-destination pairs as you need by incrementing the index i.

For example:

```bash
SRC[0]="/home/username/documents/"
DST[0]="/media/username/backup/documents"

SRC[1]="/home/username/pictures/"
DST[1]="/media/username/backup/pictures"
```

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
