#
# Update alpine to latest packages
# 
set -exu

echo '> Upgrade to latest available packages...'

apk upgrade -U --available

echo '> Done'

