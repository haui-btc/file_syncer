# Bash script to backup local files on a NAS
## How it works

- This project utilizes a Bash script for automating the file backup process from a local computer to a NAS (Network-Attached Storage).
- The core of the synchronization is handled by rsync, a powerful tool that ensures only the differences (new or updated files) are transferred. This efficiency reduces both the time needed for backups and the overall network traffic.
- It allows for explicit control over file permissions and ownership when files are copied to the NAS, making sure that files are both accessible and manageable according to user preferences or requirements.

## Configuration
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
Replace /path/to/local/directory1/, /path/to/local/directory2/, etc., with the actual paths of the directories on your local system you wish to back up.
Replace user@nas-ip:/path/to/nas/directory1/, user@nas-ip:/path/to/nas/directory2/, etc., with the appropriate SSH-accessible paths on your NAS where each local directory should be backed up.

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
