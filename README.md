# Alpine Linux appliance

Based on Alpine Linux which is a security-oriented, lightweight Linux distribution based on musl libc and busybox.

## Purpose

Very small VM for migration labs/quick networking tests
Configures itself from OVF Properties, so can be automated easily with govc/ovftool.

VM Hardware Configuration:
- 1 CPU
- 512 MB RAM
- 8 GB Hard Disk

## Download

Built artifact from Packer (Only 48MB !!!)
- https://cloud.tsugliani.fr/ova/alpine-3.15.4.ova

## OVF Properties

Here is the available properties

- `guestinfo.hostname`: "mysmallvm"
- `guestinfo.ipaddress` "192.168.0.11"
- `guestinfo.netprefix` "24"
- `guestinfo.gateway`   "192.168.0.1"
- `guestinfo.dns`       "1.1.1.1"
- `guestinfo.domain`    "zpod.io"
- `guestinfo.password`  "VMware1!" (default password)
- `guestinfo.sshkey`    "ssh-rsa AAAA...[concatened].... tsugliani@zpod"

You can leverage ovftool or govc to automate deployments with the properties.
I usually prefer govc for this as the properties can be managed as a JSON field and this goes pretty well with Python automation.

Have fun !

```shell
❯ govc import.spec alpine-3.15.4.ova
{
  "DiskProvisioning": "flat",
  "IPAllocationPolicy": "dhcpPolicy",
  "IPProtocol": "IPv4",
  "PropertyMapping": [
    {
      "Key": "guestinfo.hostname",
      "Value": ""
    },
    {
      "Key": "guestinfo.ipaddress",
      "Value": ""
    },
    {
      "Key": "guestinfo.netprefix",
      "Value": ""
    },
    {
      "Key": "guestinfo.gateway",
      "Value": ""
    },
    {
      "Key": "guestinfo.dns",
      "Value": ""
    },
    {
      "Key": "guestinfo.domain",
      "Value": ""
    },
    {
      "Key": "guestinfo.password",
      "Value": ""
    },
    {
      "Key": "guestinfo.sshkey",
      "Value": ""
    }
  ],
  "NetworkMapping": [
    {
      "Name": "VM Network",
      "Network": ""
    }
  ],
  "MarkAsTemplate": false,
  "PowerOn": false,
  "InjectOvfEnv": false,
  "WaitForIP": false,
  "Name": null
}
```
