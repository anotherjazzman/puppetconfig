#!/bin/bash -e

##############################################################################
# Program Name  : nginx_setup.sh
# Input         : <none>
# Output        : nginx installed and configured to display a page at port
#               : 8000.
#               :
# Dependencies  : Puppet Agent Running
#               : Git installed
# Contact       : Joe N. Milligan <jmilligan@nspartners.com>
# Notes         :
# Keyword       : Linux
##############################################################################

## Run Puppet locally using puppet apply

/usr/bin/puppet apply --modulepath=/tmp/puppetconfig/modules /tmp/puppetconfig/manifests/site.pp

## Log status of the Puppet run

if [ $? -eq 0 ]
then
    /usr/bin/logger -i "Puppet has run successfully" -t "puppet-run"
    exit 0
else
    /usr/bin/logger -i "Puppet has ran into an error, please run Puppet manually" -t "puppet-run"
    exit 1
fi
