# Bash Script for Rsync

This repository contains a bash script that uses rsync for synchronizing files between multiple directories. The paths for these directories are loaded from a configuration file (paths.conf), enabling easy management and modification of source and destination paths.

## How it works

- This project utilizes a Bash script for automating the file backup process from a local computer to a NAS (Network-Attached Storage).
- The core of the synchronization is handled by rsync, a powerful tool that ensures only the differences (new or updated files) are transferred. This efficiency reduces both the time needed for backups and the overall network traffic.
- It allows for explicit control over file permissions and ownership when files are copied to the NAS, making sure that files are both accessible and manageable according to user preferences or requirements.

## Configuration

To configure the script for your environment, you need to create a paths.conf file.
> rename 'paths_template.conf' to 'paths.conf'

 This file specifies the source directories on your local system and the corresponding destination paths on your NAS where the backups will be stored.
 This should be located in the same directory as your backup script

```bash
declare -a SRC=(
    "path to source 1"
    "path to source 2"    
)

declare -a DST=(
    "path to destination 1"
    "path to destination 2"    
)
```

Replace i with the index number and /path/to/source/directory/i and /path/to/destination/directory/i with your actual directory paths. You can add as many source-destination pairs as you need by incrementing the index i.

For example:

```bash
declare -a SRC=(
    "/path/to/local/source1/"
    "/path/to/local/source2/"
)

declare -a DST=(
    "user@nas:/path/to/nas/destination1/"
    "user@nas:/path/to/nas/destination2/"
)

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

### Create an alias to run the script

Open your .bashrc file in a text editor.

```bash
vim ~/.bashrc
```

Go to the end of the file and add the following line:

```bash
alias backup='/PATH/TO/YOUR/file_syncer.sh'
```

Save the file and exit the editor.

In order for your current terminal to recognize the new alias, you need to source your .bashrc file with the following command:

```bash
source ~/.bashrc
```

Now you can start your backup by simply typing

```bash
backup
```

## Error Handling

The script uses a trap command to catch errors and will print the line number where the error occurred.
