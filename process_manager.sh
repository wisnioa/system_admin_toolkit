#!/bin/bash

# Process Management Menu
while true; do
    echo "=== Process Management Menu ==="
    echo "1) View all running processes"
    echo "2) Search for a process by name"
    echo "3) Kill a process by PID"
    echo "4) Show top resource-consuming processes"
    echo "5) Return to main menu"
    read -p "Choose an option [1-5]: " choice

    case "$choice" in
        1) ps aux | less ;;
        2)
            read -p "Enter process name to search: " pname
            ps aux | grep "$pname" | grep -v grep
            ;;
        3)
            read -p "Enter PID to kill: " pid
            kill "$pid" && echo "Process $pid terminated." || echo "Failed to kill process."
            ;;
        4) top -b -n 1 | head -n 15 ;;
        5) break ;;
        *) echo "Invalid option." ;;
    esac
    echo ""
done
