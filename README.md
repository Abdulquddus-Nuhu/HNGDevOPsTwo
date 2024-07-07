# HNGDevOPsTwo
HNG DevOps Task Stage 2

# User Management Script

This repository contains a Bash script for automating the creation of users and groups on a Linux system. The script reads from a specified file containing usernames and group information, creates users and groups accordingly, sets up home directories, generates random passwords, and logs all actions.

## Script Details

- The script reads a file containing usernames and groups.
- It creates users and groups as specified.
- It sets up home directories with appropriate permissions and ownership.
- It generates random passwords for the users.
- It logs all actions to `/var/log/user_management.log`.
- It securely stores the generated passwords in `/var/secure/user_passwords.csv`.

## Usage

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/YOUR-USERNAME/user-management-script.git
    cd user-management-script
    ```

2. **Ensure the Script is Executable**:

    ```bash
    chmod +x create_users.sh
    ```

3. **Run the Script with Root Privileges**:

    By default, the script will use `users.txt`:
    
    ```bash
    sudo bash create_users.sh
    ```

    You can also specify a different file if needed:

    ```bash
    sudo bash create_users.sh <name-of-text-file>
    ```

## Example `users.txt` File

The format of the input file should be as follows:

light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data


- Each line represents a user.
- The username and groups are separated by a semicolon `;`.
- Multiple groups are separated by a comma `,`.

## Requirements

- Each user must have a personal group with the same name as the username. This group name will not be written in the text file.
- A user can have multiple groups, each group delimited by a comma `,`.
- The script assumes the file `users.txt` if no file name is provided as an argument.

## Logging and Security

- Actions performed by the script are logged to `/var/log/user_management.log`.
- Generated passwords are securely stored in `/var/secure/user_passwords.csv`, and only the file owner can read this file.

## Additional Information

This script is part of a task for the [HNG Internship](https://hng.tech/internship). For more information about the HNG Internship and opportunities to hire talented interns, please visit:

- [HNG Internship](https://hng.tech/internship)
- [HNG Hire](https://hng.tech/hire)


## Acknowledgements

This script was created as part of the HNG Internship program. Special thanks to the mentors and organizers for their support and guidance.
