#!/bin/bash
# Enable IP forwarding
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

sudo yum update -y
sudo yum install -y iptables-services

# Configure iptables for NAT
sudo iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE


# Save and enable iptables
sudo service iptables save
sudo systemctl enable iptables
sudo systemctl start iptables