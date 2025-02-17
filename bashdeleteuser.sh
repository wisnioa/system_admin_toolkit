#!/bin/bash


remove_user() {
    if sudo userdel -rf "$1"; then
        echo "User '$1' has been successfully removed"
    else
        echo "Error: Failed to remove user '$1'"
        exit 1
    fi
}


check_user() {
    if id "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}


while true; do

    read -p "Enter username to remove (or 'quit' to exit): " username
    

    if [ -z "$username" ]; then
        echo "Error: Username cannot be empty"
        continue
    fi
    
    if [ "${username,,}" = "quit" ]; then
        echo "Exiting..."
        exit 0
    fi
    

    if check_user "$username"; then

        read -p "Are you sure you want to remove user '$username'? (y/n): " confirm
        
        if [ "${confirm,,}" = "y" ]; then
            remove_user "$username"
        else
            echo "Operation cancelled"
        fi
    else
        echo "User '$username' not found"
    fi
    
    read -p "Do you want to remove another user? (y/n): " continue
    if [ "${continue,,}" != "y" ]; then
        echo "Exiting..."
        exit 0
    fi
done