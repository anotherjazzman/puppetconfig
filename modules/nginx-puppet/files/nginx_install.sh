#!/bin/bash -e

##############################################################################
# Program Name  : nginx_install.sh
# Input         : <none>
# Output        : Installation and configuration of nginx with a custom page
#               : at port 8000
#               :
# Dependencies  : Puppet Agent Installed
#               : nginx not installed
#               : Git installed
#               : OS - Ubuntu 16.04
# Contact       : Joe N. Milligan <jmilligan@nspartners.com>
# Notes         :
# Keyword       : Linux
##############################################################################

# Run a system update to ensure latest software installed.

sudo apt-get update

APTGET_UPDATE=`echo $?`

# Verify that system update had no issues.

if [ "$APTGET_UPDATE" -ne 0 ]
then
    echo "APTGET UPDATE ERROR: Unable to update OS. Error code $APTGET_UPDATE\n"
    exit $APTGET_UPDATE
fi

# Run install of nginx

sudo apt-get install nginx -y

APTGET_INSTALL_NGINX=`echo $?`

# Verify that install of nginx had no issues.

if [ "$APTGET_INSTALL_NGINX" -ne 0 ]
then
    echo "APTGET_INSTALL_NGINX ERROR: Unable to install nginx. Error code $APTGET_INSTALL_NGINX\n"
    exit $APTGET_INSTALL_NGINX
fi

# Run firewall update to allow access to nginx sites

sudo ufw allow 'Nginx HTTP'

UFW_ALLOW=`echo $?`

# Verify that update had no issues.

if [ "$UFW_ALLOW" -ne 0 ]
then
    echo "UFW_ALLOW ERROR: Unable to update firewall. Error code $UFW_ALLOW\n"
    exit $UFW_ALLOW
fi

# Run status on nginx 

sudo systemctl status nginx 

RUNNING_NGINX=`echo $?`

# Verify that there was no issues

if [ "$RUNNING_NGINX" -ne 0 ]
then
    echo "RUNNING_NGINX ERROR: Unable to update firewall. Error code $RUNNING_NGINX\n"
    exit $RUNNING_NGINX
fi

# Enable restart of nginx on reboot of server

sudo systemctl enable nginx

ENABLE_NGINX=`echo $?`

# Verify that there was no issues

if [ "$ENABLE_NGINX" -ne 0 ]
then
    echo "ENABLE_NGINX ERROR: Unable to enable nginx for reboot. Error code $ENABLE_NGINX\n"
    exit $ENABLE_NGINX
fi

# make directory for new site

sudo mkdir -p /var/www/psetse.com/html

MKDIR_CONTENT=`echo $?`

# Verify that there was no issues

if [ "$MKDIR_CONTENT" -ne 0 ]
then
    echo "MKDIR_CONTENT ERROR: Unable to create nginx directory. Error code $MKDIR_CONTENT\n"
    exit $MKDIR_CONTENT
fi

# Change ownership of file

sudo chown -R $USER:$USER /var/www/psetse.com/html

CHOWN_NGINX=`echo $?`

# Verify that there was no issues

if [ "$CHOWN_NGINX" -ne 0 ]
then
    echo "CHOWN_NGINX ERROR: Unable to change owner. Error code $CHOWN_NGINX\n"
    exit $CHOWN_NGINX
fi

# Change mode on directory for nginx

sudo chmod -R 0755 /var/www

CHMOD_NGINX=`echo $?`

# Verify that there was no issues

if [ "$CHMOD_NGINX" -ne 0 ]
then
    echo "CHMOD_NGINX ERROR: Unable to change permissions. Error code $CHMOD_NGINX\n"
    exit $CHMOD_NGINX
fi

# Change directory in preparation for git clone 

cd /tmp

CD_TMP=`echo $?`

# Verify that there was no issues

if [ "$CD_TMP" -ne 0 ]
then
    echo "CD_TMP ERROR: Unable to change to home directory. Error code $CD_TMP\n"
    exit $CD_TMP
fi

# git clone pse/tse index.html file for nginx site

git clone https://github.com/puppetlabs/exercise-webpage

GIT_CLONE=`echo $?`

# Verify that there was no issues

if [ "$GIT_CLONE" -ne 0 ]
then
    echo "GIT_CLONE ERROR: Unable to clone exercise. Error code $GIT_CLONE\n"
    exit $GIT_CLONE
fi

# Copy psetese index.hmtl to appropriate nginx site

sudo cp /tmp/exercise-webpage/index.html /var/www/psetse.com/html

CP_INDEX=`echo $?`

# Verify that there was no issues

if [ "$CP_INDEX" -ne 0 ]
then
    echo "CP_INDEX ERROR: Unable to copy index.html. Error code $CP_INDEX\n"
    exit $CP_INDEX
fi

# Copy psetse nginx port configuration file to appropriate location

sudo cp /tmp/puppetconfig/modules/nginx-puppet/files/nginx.conf /etc/nginx/sites-available/psetse.com

CP_NGINX=`echo $?`

# Verify that there was no issues

if [ "$CP_NGINX" -ne 0 ]
then
    echo "CP_NGINX ERROR: Unable to copy nginx.conf. Error code $CP_NGINX\n"
    exit $CP_NGINX
fi

# Link psetse nginx port configuration file to appropriate location

sudo ln -s /etc/nginx/sites-available/psetse.com /etc/nginx/sites-enabled

LN_NGINX=`echo $?`

# Verify that there was no issues

if [ "$LN_NGINX" -ne 0 ]
then
    echo "LN_NGINX ERROR: Unable to link nginx site file. Error code $LN_NGINX\n"
    exit $LN_NGINX
fi

# Confirm that there are no issue with the updated nginx configuration

sudo nginx -t

T_NGINX=`echo $?`

# Verify that there was no issues

if [ "$T_NGINX" -ne 0 ]
then
    echo "T_NGINX ERROR: Nginx configuration file error. Error code $T_NGINX\n"
    exit $T_NGINX
fi

# Perform a restart of nginx to reload the new configuration

sudo systemctl restart nginx

RESTART_NGINX=`echo $?`

# Verify that there was no issues

if [ "$RESTART_NGINX" -ne 0 ]
then
    echo "RESTART_NGINX ERROR: Nginx configuration file error. Error code $RESTART_NGINX\n"
    exit $RESTART_NGINX
fi
