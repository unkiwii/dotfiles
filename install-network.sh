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

cat <<EOF >>/etc/resolv.conf
nameserver 127.0.0.1
EOF

echo "vim /etc/network/interfaces and delete duplication of interfaces"
echo "vim /etc/resolv.conf and move configuration to /etc/bind/named.conf.options"
echo "There's a named.conf.options file example here"
