# Bash script to backup local files on a NAS
## How it works

- This project utilizes a Bash script for automating the file backup process from a local computer to a NAS (Network-Attached Storage).
- The core of the synchronization is handled by rsync, a powerful tool that ensures only the differences (new or updated files) are transferred. This efficiency reduces both the time needed for backups and the overall network traffic.
- It allows for explicit control over file permissions and ownership when files are copied to the NAS, making sure that files are both accessible and manageable according to user preferences or requirements.

## Process Overview
1. **Start Script**: Upon execution, the script reads source and destination paths from a configuration file.
2. **Error Handling**: Implements robust error handling to terminate the operation if any command within the script fails, logging the error for troubleshooting.
3. **File Synchronization**: For each source-destination pair defined in the configuration, the script uses rsync with specific options to sync the files. It provides feedback on the operation's progress and final statistics.
4. **Completion**: Upon successfully copying all files, the script calculates and displays the total execution time.

## Configuration
### Prerequisites
- Bash shell
- rsync installed on both local and NAS systems
- Network access to the NAS
- Permissions to read from the source and write to the destination paths

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


