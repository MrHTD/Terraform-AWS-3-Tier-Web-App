#!/bin/bash
# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1
sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

# Configure iptables for NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Save iptables rules
apt-get update -y
apt-get install -y iptables-persistent
netfilter-persistent save
netfilter-persistent reload