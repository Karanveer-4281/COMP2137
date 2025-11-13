#!/bin/bash
# COMP2137 - Assignment 2
# Karanveer Singh
# Student Number: 200624281

# To run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Setting IP address
NETFILE="/etc/netplan/01-netcfg.yaml"
if ! grep -q "192.168.16.21" "$NETFILE"; then
  sed -i '/addresses:/c\            addresses: [192.168.16.21/24]' "$NETFILE"
  netplan apply
fi

# Update hosts file
if ! grep -q "192.168.16.21" /etc/hosts; then
  sed -i '/server1/d' /etc/hosts
  echo "192.168.16.21 server1" >> /etc/hosts
fi

# Install apache2 and squid
apt-get update -qq
apt-get install -y apache2 squid -qq
systemctl enable apache2
systemctl enable squid
systemctl start apache2
systemctl start squid

# Create users
USERS="dennis aubrey captain snibbles brownie scooter sandy perrier cindy tiger yoda"

for u in $USERS; do
  if ! id "$u" &>/dev/null; then
    useradd -m -s /bin/bash "$u"
  fi

  mkdir -p /home/$u/.ssh
  ssh-keygen -t rsa -N "" -f /home/$u/.ssh/id_rsa >/dev/null 2>&1
  ssh-keygen -t ed25519 -N "" -f /home/$u/.ssh/id_ed25519 >/dev/null 2>&1
  cat /home/$u/.ssh/id_rsa.pub /home/$u/.ssh/id_ed25519.pub > /home/$u/.ssh/authorized_keys

  if [ "$u" = "dennis" ]; then
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" >> /home/$u/.ssh/authorized_keys
    usermod -aG sudo dennis
  fi

  chmod 700 /home/$u/.ssh
  chmod 600 /home/$u/.ssh/authorized_keys
  chown -R $u:$u /home/$u/.ssh
done

echo "System Modification Completed."
