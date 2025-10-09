#!/bin/bash
#Here is the system information report.

echo "System information report is created by:"
hostname
echo ""

echo "It is genetrated by:"
whoami
echo ""

echo "Created on date:"
date
echo ""

echo "Operating System as follow:"
source /etc/os-release
echo "$NAME $VERSION"
echo ""

echo "Uptime of system: "
uptime -p
echo ""

echo "CPU and model name:"
lscpu | grep "Model name"
echo ""

echo "RAM of the system: "
free -h | grep mem
echo ""

echo "Disk Info:"
lsblk
echo ""

echo "Host address:"
hostname -I
echo ""

echo "Gateway IP address:"
ip route | grep default
echo ""

echo -n "DNS server:"
head 1 /etc/resolv.conf
echo ""

echo "Here is the report for System Status"
echo ""
echo "Users that logged in the system:"
who

echo "Disk space:"
df -h

echo ""

echo "proccesses Count:"
ps -e | wc -l
echo ""

echo "Load average time:"
uptime

echo "Network ports:"
sudo ss -tiln | grep LISTEN
echo ""

echo "Firewall status:"
sudo ufw status
echo ""

echo "Here is the report of the system"
