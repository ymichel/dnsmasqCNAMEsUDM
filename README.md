# dnsmasqCNAMEsUDM
dnsmasq based CNAMEs for Unifi equipment (UDM-SE & UDM-PRO)

This is an extension script for maintaining and using CNAMEs for any DNS hostname defined on the UDM (as of version 3.0.13 or above).
Unfortunately, this is not provided out of the box, consequently, I had to investigate the options.

You can now add 
- CNAMEs for any DNS entry maintained in the UDM.

Keep in mind, that you can only maintain a CNAME for an A-Record, i.e., a normal DNS Entry / host name.

# Setup
- upload the createCNAMEs.sh into a persistant folder on your UDM (e.g. /data/dns-cname)
- make the script executable 
- run the createCNAMEs.sh once to obtain a cname.conf to set your CNAMEs accordingly
- run createCNAMEs.sh a second time to enable/update the configured names

# Reset dnsmasq cache
pkill -HUP dnsmasq (done automatically wihtin the script but in case needed...)
