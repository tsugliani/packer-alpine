#
# System settings for Alpine 
#
set -exu

echo '> Enabling /etc/local.d scripts at default runlevel...'

rc-update add local default

echo '> Done'


