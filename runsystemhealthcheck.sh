#!/bin/bash

echo ""
echo "=== System Info ==="

echo $HOSTNAME

uptime=$(uptime -p)

echo "Uptime: $uptime"

echo ""

echo "=== Resource Usage ==="

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "CPU Usage: $CPU_USAGE%"

mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_total=$(free -m | awk '/Mem:/ {print $2}')
echo "Memory Usage: $mem_used MB used / $mem_total MB total"

swap_used=$(free -m | awk '/Swap:/ {print $3}')
swap_total=$(free -m | awk '/Swap:/ {print $2}')
if [ "$swap_total" -eq 0 ]; then
  echo "Swap usage: Swap not configured"
else
  echo "Swap usage: $swap_used MB used / $swap_total MB total"
fi

DISK_USAGE=$(df -h / | tail -1)
echo "Root Partition Disk Usage: $DISK_USAGE"

top_processes=$(top -b -n 1 | sed -n '8,12p')
echo "Top Processes:"
echo "$top_processes" | nl

echo ""
echo "=== Network Status ==="

IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "IP Address: $IP_ADDRESS"

DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
echo "Default Gateway: $DEFAULT_GATEWAY"

DNS_SERVERS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
echo "DNS Servers: $DNS_SERVERS"

PING_HOST="google.com"
if ping -c 1 -W 2 $PING_HOST > /dev/null 2>&1; then
    echo "Ping Test: SUCCESS ($PING_HOST reachable)"
else
    echo "Ping Test: FAIL ($PING_HOST not reachable)"
fi

echo "Open Ports:"
ss -tuln | awk '
  /LISTEN/ {
    split($5, a, ":");
    port=a[length(a)];
    if (port ~ /^[0-9]+$/) {
      print "  " port "/tcp"
    }
  }' | sort -n | uniq

echo ""
echo "System health completed."
