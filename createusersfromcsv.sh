#!/bin/bash

INPUT_FILE="users.csv"

while IFS=',' read -r username password full_name
do
    # Skip the header row
    if [[ "$username" == "username" ]]; then
        continue
    fi

    # Create user with home directory and set password
    sudo useradd -m -c "$full_name" "$username"
    echo "$username:$password" | sudo chpasswd

    echo "User $username created successfully."
done < "$INPUT_FILE"
