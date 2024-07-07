#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Use 'users.txt' as default if no file is provided
input_file="${1:-users.txt}"

# Variables
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Create necessary directories and set permissions
mkdir -p /var/secure
chmod 700 /var/secure
touch $LOG_FILE
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Read the file line by line
while IFS=';' read -r username groups; do
  # Remove leading/trailing whitespaces
  username=$(echo "$username" | xargs)
  groups=$(echo "$groups" | xargs)

  # Check if user already exists
  if id "$username" &>/dev/null; then
    echo "User $username already exists, updating groups" | tee -a $LOG_FILE
  else
    # Create user with a personal group
    useradd -m -s /bin/bash -g "$username" "$username"
    echo "Created user $username with personal group $username" | tee -a $LOG_FILE

    # Generate random password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "Generated password for $username" | tee -a $LOG_FILE

    # Store username and password in secure file
    echo "$username,$password" >> $PASSWORD_FILE
  fi

  # Add user to additional groups
  IFS=',' read -r -a group_array <<< "$groups"
  for group in "${group_array[@]}"; do
    group=$(echo "$group" | xargs)  # Remove whitespace
    # Check if group exists, create if not
    if ! getent group "$group" &>/dev/null; then
      groupadd "$group"
      echo "Created group $group" | tee -a $LOG_FILE
    fi
    usermod -aG "$group" "$username"
    echo "Added $username to group $group" | tee -a $LOG_FILE
  done

  # Ensure user belongs to their personal group
  usermod -g "$username" "$username"
  echo "Ensured $username belongs to their personal group $username" | tee -a $LOG_FILE

done < "$input_file"

echo "User creation process completed" | tee -a $LOG_FILE
