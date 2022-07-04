#
# This script setups the entire OVF VM based on properties
#

FILE_CUSTOMIZATION="/etc/customization.state"
FILE_OVFENVIRONMENT="/tmp/ovfenvironment.xml"

#
# If customization was already launch, exit right away
#
if [ -s $FILE_CUSTOMIZATION ]
then
    exit 0
fi

# Customization process
echo "> Retrieving OVF information..."

# Retrieve OVF settings from VMware Tools.
/usr/bin/vmtoolsd --cmd "info-get guestinfo.ovfEnv" > $FILE_OVFENVIRONMENT

if [ -s "$FILE_OVFENVIRONMENT" ]
then
    echo $(date) > $FILE_CUSTOMIZATION

    guestinfo_hostname=$(cat $FILE_OVFENVIRONMENT| grep guestinfo.hostname | cut -d '"' -f 4 | head -1)
    guestinfo_domain=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.domain | cut -d '"' -f 4 | head -1)
    guestinfo_ipaddress=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.ipaddress | cut -d '"' -f 4 | head -1)
    guestinfo_netprefix=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.netprefix | cut -d '"' -f 4 | head -1)
    guestinfo_gateway=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.gateway | cut -d '"' -f 4 | head -1)
    guestinfo_dns=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.dns | cut -d '"' -f 4 | head -1)
    guestinfo_password=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.password | cut -d '"' -f 4 | head -1)
    guestinfo_sshkey=$(cat $FILE_OVFENVIRONMENT | grep guestinfo.sshkey | cut -d '"' -f 4 | head -1)

    echo "Alpine Linux Settings" >> $FILE_CUSTOMIZATION
    echo "=====================" >> $FILE_CUSTOMIZATION
    echo "hostname:    $guestinfo_hostname" >> $FILE_CUSTOMIZATION
    echo "domain:      $guestinfo_domain" >> $FILE_CUSTOMIZATION
    echo "ipaddress:   $guestinfo_ipaddress" >> $FILE_CUSTOMIZATION
    echo "netprefix:   $guestinfo_netprefix" >> $FILE_CUSTOMIZATION
    echo "gateway      $guestinfo_gateway" >> $FILE_CUSTOMIZATION
    echo "dns:         $guestinfo_dns" >> $FILE_CUSTOMIZATION
    echo "password:    $guestinfo_password" >> $FILE_CUSTOMIZATION
    echo "sshkey:      $guestinfo_sshkey" >> $FILE_CUSTOMIZATION

    # Setup Alpine hostname
    if [ ! -z "$guestinfo_hostname" ]
    then
        setup-hostname -n $guestinfo_hostname
		
		cat > /etc/hosts <<-EOF
		127.0.0.1    $guestinfo_hostname.$guestinfo_domain $guestinfo_hostname localhost.localdomain localhost
		::1          localhost localhost.localdomain
		EOF

        rc-service hostname restart
    fi

    # Setup Alpine networking (if either ip/netprefix/gw is missing, we keep dhcp)
    if [ -z "$guestinfo_ipaddress" ] || [ -z "$guestinfo_netprefix" ] ||  [ -z "$guestinfo_gateway" ]
    then
        echo "DHCP CONFIG, skipping..."
    else
        echo "STATIC CONFIG, configuring..."

		cat > /etc/network/interfaces <<-EOF
		auto lo
		iface lo inet loopback

		auto eth0
		iface eth0 inet static
		address $guestinfo_ipaddress/$guestinfo_netprefix
		gateway $guestinfo_gateway
		EOF

        # restart networking
        rc-service networking restart
    fi

    if [ ! -z "$guestinfo_dns" ] && [ ! -z "$guestinfo_domain" ]
    then
    	setup-dns -d $guestinfo_domain -n $guestinfo_dns
    fi

    # Setup Password
    if [ ! -z "$guestinfo_password" ]
    then
        echo "root:$guestinfo_password" | chpasswd
    fi
    
    # /etc/hosts to rebuild
    if [ ! -z "$guestinfo_sshkey" ]
    then 
        mkdir -vp /root/.ssh
        echo "$guestinfo_sshkey" > /root/.ssh/authorized_keys
    fi
fi

exit 0
