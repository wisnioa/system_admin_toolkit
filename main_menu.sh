#!/bin/bash

while true; do
    clear
    echo "=== System Admin Toolkit 🛠️ ==="
    echo "1) Create a user"
    echo "2) Create users from CSV"
    echo "3) Delete a user"
    echo "4) Monitor disk space"
    echo "5) Process management"
    echo "6) Run a system health check"
    echo "7) Run a full system audit"
    echo "8) Exit"
    read -p "Choose an option [1-8]: " choice

    case "$choice" in
        1) bash createuser.sh ;;
        2) bash createusersfromcsv.sh ;;
        3) bash deleteuser.sh ;;
        4) bash monitordiskspace.sh ;;
        5) bash process_manager.sh ;;
        6) bash runsystemhealthcheck.sh;;
        7) bash runfullsystemaudit.sh;;
        8) echo "Exiting. Goodbye!"; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac

    echo
    read -p "Press Enter to return to the menu..."
done
