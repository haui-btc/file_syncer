# Bash Script for Local to NAS File Backup
This project provides a Bash script designed for automating the backup of files from a local system to a Network-Attached Storage (NAS) unit. It's built with simplicity, efficiency, and robust error handling in mind.

## How It Works
- **Automated Backup**: Utilizes a Bash script to streamline the file backup process from local systems to NAS devices.
- **Efficient Synchronization**: Employs `rsync` for intelligent file transfer, ensuring only differences are sent to minimize network load and speed up backups.
- **Permission Control**: Offers explicit control over the permissions and ownership of the transferred files, ensuring they remain accessible and manageable on the NAS.

## Process Overview
1. **Initialization**: On execution, reads source and destination paths from the `paths.conf` configuration file.
2. **Robust Error Handling**: Implements stringent error checks, terminating and logging on any failures to facilitate troubleshooting.
3. **Synchronization**: Executes `rsync` for each source-destination pair, offering real-time progress feedback and summarizing transfer statistics upon completion.
4. **Completion**: Calculates and displays the total time taken for the backup process.



## Configuration
### Prerequisites
- Bash shell environment.
- `rsync` installed on both the local and NAS systems.
- Network connectivity with the NAS.
- Appropriate permissions for accessing source locations and writing to destinations.

## Setup
### Setting Up paths.conf
To configure the script for your environment, you need to create a paths.conf file.
( **It should be located in the same directory as your backup script**)
> rename 'paths_template.conf' to 'paths.conf'
```bash
declare -a SRC=(
    "/path/to/local/directory1/"
    "/path/to/local/directory2/"
    ...
)

declare -a DST=(
    "user@nas-ip:/path/to/nas/directory1/"
    "user@nas-ip:/path/to/nas/directory2/"
    ...
)
```

 This file specifies the source directories on your local system and the corresponding destination paths on your NAS where the backups will be stored.

### Customize the Paths
- Replace /path/to/local/directory1/, /path/to/local/directory2/, etc., with the actual paths of the directories on your local system you wish to back up.
- Replace user@nas-ip:/path/to/nas/directory1/, user@nas-ip:/path/to/nas/directory2/, etc., with the appropriate SSH-accessible paths on your NAS where each local directory should be backed up.

### Script Options
The backup script includes configurable options for `rsync` to fine-tune the synchronization process. These can be adjusted in the script file directly:

- `OPTS="-auvO --chmod=Du=rwx,Dg=rwx,Do=rx,Fu=rw,Fg=rw,Fo=r --stats"`: This option string includes:
  - `-a`: Archive mode to copy files recursively and preserve symbolic links, file permissions, user & group ownerships (except when overridden by `--chmod`), and timestamps.
  - `-u`: Skip files that are newer on the receiver.
  - `-v`: Verbose mode to provide detailed output.
  - `-O`: Omit directories from being included in the modification time comparisons, useful for avoiding unnecessary directory updates.
  - `--chmod`: Explicitly set file and directory permissions on the destination.
  - `--stats`: Give a summary at the end of the transfer for a quick overview of what was transferred.

Feel free to modify the `OPTS` string to match your specific backup requirements or preferences.


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

The script ensures robust and user-friendly error handling:

- **Immediate Exit on Error**: Utilizes `set -e` to halt execution at the first sign of trouble, preventing cascading failures.

- **Custom Error Reporting**: Implements a `handle_error()` function, invoked with `trap` on any error, to report the precise line where an issue occurs, facilitating quicker diagnostics.

- **Operation Feedback**: Outputs detailed information post-backup, including the number of files transferred, for user verification and troubleshooting.

- **Temporary File Management**: Generates and subsequently cleans up temporary files for each backup operation, ensuring a tidy environment and aiding in error analysis if needed.

This streamlined error handling framework enhances the script's reliability, making it easier to use and maintain.


