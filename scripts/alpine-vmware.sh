#
# VMware related stuff
#
set -exu

echo '> Installing VMware Tools...'

echo "http://dl-cdn.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories

apk update
apk add open-vm-tools
apk add open-vm-tools-guestinfo

rc-update add open-vm-tools boot

echo '> Done'