#!/bin/bash

get_password() {
    while true; do
        read -sp "Enter user password: " password
        echo
        read -sp "Confirm password: " password_confirm
        echo
        if [ "$password" == "$password_confirm" ]; then
            echo "Passwords match."
            break
        else
            echo "Passwords do not match. Please try again."
        fi
    done
}

get_permissions() {
    perms="u=" 
    declare -A perm_options=( ["read"]="r" ["write"]="w" ["execute"]="x" )

    for perm in "${!perm_options[@]}"; do
        read -p "Do you want to allow $perm access? (y/n) " response
        if [[ $response =~ ^[Yy]$ ]]; then
            perms+="${perm_options[$perm]}"
        fi
    done

    echo "$perms"
}


read -p "Enter username: " name
if [[ -z "$name" ]]; then
    echo "Username cannot be empty."
    exit 1
fi


get_password

result_perm=$(get_permissions)
echo "Selected permissions: $result_perm"


if sudo adduser --gecos "" "$name"; then
    echo "User '$name' created successfully."


    sudo chown -R "$name:$name" "/home/$name"
    sudo chmod -R "$result_perm" "/home/$name"
    echo "Permissions applied to /home/$name."
else
    echo "Error: Failed to create user."
    exit 1
fi
