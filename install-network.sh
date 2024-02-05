# run this file as root

usermod -a -G netdev unkiwii

cat <<EOF >>/etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev
update_config=1
EOF

cat <<EOF >>/etc/network/interfaces
# The primary network interface
allow-hotplug wlp0s20f3
iface wlp0s20f3 inet dhcp
        wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF

echo "vim /etc/network/interfaces and delete duplication of interfaces"
