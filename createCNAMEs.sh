#!/bin/bash

#Version of this script
version="V0.1.0"

#Get newest release from GitHub
release_info=$(curl -s "https://api.github.com/repos/ymichel/dnsmasqCNAMEsUDM/releases/latest")
release_version=$(echo "$release_info" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

#name to use for the CNAMEs
cnameFileName="cname.conf"

#location of the CNAME config during runtime
dnsmasq_path="/run/dnsmasq.conf.d"

#cron task to re-enable CNAMEs after reboot/update
cronFile="/etc/cron.d/createCNAMEs"

#get the scripts current home
SOURCE="${BASH_SOURCE}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the pat h where the symlink file was located
done
scriptHome="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
scriptName="$( basename "$0" )"

#create default crontab file if it does not exist
function check_crontab() {
   if [ ! -f ${cronFile} ]; then
      echo -e "#This is the crontab file for ${scriptHome}/${scriptName} ${version}\n#MAILTO=""\n@reboot    root ${scriptHome}/${scriptName}">${cronFile}
   fi
}

#create default conf file if it does not exist
function check_config_file() {
   if [ ! -f ${scriptHome}/${cnameFileName} ]; then
      echo -e "# This is the user configuration file for ${scriptHome}/${scriptName} ${version}\n\
\n\
#-------------------------------------------------------------------------\n\
# Please add your desired CNAMEs as follows:\n\
#cname=cname.mydomain.lan,hostname.hostdomain.tld\n\
#-------------------------------------------------------------------------\n\ "> ${scriptHome}/${cnameFileName}
      echo "Please maintain the file ${scriptHome}/${cnameFileName} and rerun this script ${scriptHome}/${scriptName}"
   else
      cp ${scriptHome}/${cnameFileName} ${dnsmasq_path}/${cnameFileName}
      pkill dnsmasq
      check_crontab
   fi
}
