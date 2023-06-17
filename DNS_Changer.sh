#!/bin/bash

# Store the current DNS settings
dns1=$(nmcli device show wlan0 | grep IP4.DNS\[1\] | awk '{print $2}')
dns2=$(nmcli device show wlan0 | grep IP4.DNS\[2\] | awk '{print $2}')

# Get the active Wi-Fi connection name
wifi_connection=$(nmcli -t -f NAME,TYPE con show --active | awk -F: '$2 == "802-11-wireless" {print $1}')

# Set your custom DNS
nmcli connection modify "$wifi_connection" ipv4.dns "178.22.122.100 185.51.200.2"

# Restart the network connection
nmcli connection down "$wifi_connection"
nmcli connection up "$wifi_connection"

# Wait for the connection to come up
sleep 5

# Display the new DNS settings
echo "DNS changed to:"
nmcli device show wlan0 | grep IP4.DNS

# Reset to the original DNS settings when the script is closed
cleanup() {
    nmcli connection modify "$wifi_connection" ipv4.dns "$dns1 $dns2"
    nmcli connection down "$wifi_connection"
    nmcli connection up "$wifi_connection"
}
trap cleanup EXIT

# Keep the script running
read -r -d '' _ </dev/tty
