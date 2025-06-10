#!/bin/bash


timestamp=$(date '+%Y-%m-%d %H:%M:%S')
REAL_USER=$(logname)


print_header() {
  echo "=== System Audit Report ==="
  echo "Generated on: $timestamp"
  echo "Hostname: $HOSTNAME"
  echo "User: $REAL_USER"
  echo ""
}

system_info() {
  echo "----------------------------"
  echo "System Information"
  echo "----------------------------"
  echo "OS: $(lsb_release -ds)"
  echo "Kernel Version: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "Uptime: $(uptime -p)"
  echo ""
}

resource_usage() {
  echo "----------------------------"
  echo "Resource Usage"
  echo "----------------------------"
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  echo "CPU Usage: ${CPU_USAGE}%"

  mem_used=$(free -m | awk '/Mem:/ {print $3}')
  mem_total=$(free -m | awk '/Mem:/ {print $2}')
  echo "Memory Usage: ${mem_used} MB used / ${mem_total} MB total"

  swap_used=$(free -m | awk '/Swap:/ {print $3}')
  swap_total=$(free -m | awk '/Swap:/ {print $2}')
  if [ "$swap_total" -eq 0 ]; then
    echo "Swap Usage: Swap not configured"
  else
    echo "Swap Usage: ${swap_used} MB used / ${swap_total} MB total"
  fi

  DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 " used)"}')
  echo "Disk Usage on / : $DISK_USAGE"

  echo ""
  echo "Top 5 Processes by CPU/Memory:"
  top -b -n 1 | sed -n '8,12p' | nl
  echo ""
}

network_info() {
  echo "----------------------------"
  echo "Network Information"
  echo "----------------------------"
  IP_ADDRESS=$(hostname -I | awk '{print $1}')
  echo "IP Address: $IP_ADDRESS"

  DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
  echo "Default Gateway: $DEFAULT_GATEWAY"

  DNS_SERVERS=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | paste -sd ", ")
  echo "DNS Servers: $DNS_SERVERS"

  PING_HOST="google.com"
  if ping -c 1 -W 2 $PING_HOST > /dev/null 2>&1; then
    echo "Ping Test: SUCCESS ($PING_HOST reachable)"
  else
    echo "Ping Test: FAIL ($PING_HOST not reachable)"
  fi

  echo ""
  echo "Open Ports:"
  ss -tuln | awk '/LISTEN/ {
    split($5, a, ":");
    port=a[length(a)];
    if (port ~ /^[0-9]+$/) {
      print "  " port "/tcp"
    }
  }' | sort -n | uniq
  echo ""
}

security_info() {
  echo "----------------------------"
  echo "Security & User Audit"
  echo "----------------------------"
  echo "Logged-in Users:"
  who | awk '{print "  " $1 " : " $2 " : " $3 " " $4}'
  echo ""

  echo "Sudo Users:"
  getent group sudo | cut -d: -f4 | tr ',' '\n' | awk '{print "  " $1}'
  echo ""

  echo "Failed Login Attempts (last 5):"
  journalctl _COMM=sshd | grep "Failed password" | tail -n 5 | awk '{print "  " $0}'
  echo ""

  echo "Firewall Status:"
  ufw status | sed 's/^/  /'
  echo ""

  if ufw status | grep -q "inactive"; then
    echo "UFW is inactive. Consider enabling it: sudo ufw enable"
  fi

}

# === Run Audit ===
print_header
system_info
resource_usage
network_info
security_info
echo "----------------------------"
echo "System audit completed."
echo "----------------------------"
