#!/bin/bash -e

##############################################################################
# Program Name  : nginx_install.sh
# Input         : <none>
# Output        : <none>
#               :
# Dependencies  : None
# Contact       : Joe N. Milligan <jmilligan@nspartners.com>
# Notes         :
# Keyword       : UNIX
##############################################################################

sudo apt-get update

APTGET_UPDATE=`echo $?`

if [ "$APTGET_UPDATE" -ne 0 ]
then
    echo "APTGET UPDATE ERROR: Unable to update OS. Error code $APTGET_UPDATE\n"
    exit $APTGET_UPDATE
fi

sudo apt-get install nginx -y

APTGET_INSTALL_NGINX=`echo $?`

if [ "$APTGET_INSTALL_NGINX" -ne 0 ]
then
    echo "APTGET_INSTALL_NGINX ERROR: Unable to install nginx. Error code $APTGET_INSTALL_NGINX\n"
    exit $APTGET_INSTALL_NGINX
fi

sudo ufw allow 'Nginx HTTP'

UFW_ALLOW=`echo $?`

if [ "$UFW_ALLOW" -ne 0 ]
then
    echo "UFW_ALLOW ERROR: Unable to update firewall. Error code $UFW_ALLOW\n"
    exit $UFW_ALLOW
fi

sudo systemctl status nginx # look for active (running)

RUNNING_NGINX=`echo $?`

if [ "$RUNNING_NGINX" -ne 0 ]
then
    echo "RUNNING_NGINX ERROR: Unable to update firewall. Error code $RUNNING_NGINX\n"
    exit $RUNNING_NGINX
fi

sudo systemctl enable nginx

ENABLE_NGINX=`echo $?`

if [ "$ENABLE_NGINX" -ne 0 ]
then
    echo "ENABLE_NGINX ERROR: Unable to enable nginx for reboot. Error code $ENABLE_NGINX\n"
    exit $ENABLE_NGINX
fi

sudo mkdir -p /var/www/psetse.com/html

MKDIR_CONTENT=`echo $?`

if [ "$MKDIR_CONTENT" -ne 0 ]
then
    echo "MKDIR_CONTENT ERROR: Unable to create nginx directory. Error code $MKDIR_CONTENT\n"
    exit $MKDIR_CONTENT
fi

sudo chown -R $USER:$USER /var/www/psetse.com/html

CHOWN_NGINX=`echo $?`

if [ "$CHOWN_NGINX" -ne 0 ]
then
    echo "CHOWN_NGINX ERROR: Unable to change owner. Error code $CHOWN_NGINX\n"
    exit $CHOWN_NGINX
fi

sudo chmod -R 0755 /var/www

CHMOD_NGINX=`echo $?`

if [ "$CHMOD_NGINX" -ne 0 ]
then
    echo "CHMOD_NGINX ERROR: Unable to change permissions. Error code $CHMOD_NGINX\n"
    exit $CHMOD_NGINX
fi

cd $HOME

CD_HOME=`echo $?`

if [ "$CD_HOME" -ne 0 ]
then
    echo "CD_HOME ERROR: Unable to change to home directory. Error code $CD_HOME\n"
    exit $CD_HOME
fi

# git clone pse/tse index.html file

git clone git@github.com:puppetlabs/exercise-webpage.git

GIT_CLONE=`echo $?`

if [ "$GIT_CLONE" -ne 0 ]
then
    echo "GIT_CLONE ERROR: Unable to clone exercise. Error code $GIT_CLONE\n"
    exit $GIT_CLONE
fi

sudo cp $HOME/exercise-webpage/index.html /var/www/psetse.com/html

CP_INDEX=`echo $?`

if [ "$CP_INDEX" -ne 0 ]
then
    echo "CP_INDEX ERROR: Unable to copy index.html. Error code $CP_INDEX\n"
    exit $CP_INDEX
fi

sudo cp $HOME/puppetconfig/nginx.conf /etc/nginx/sites-available/psetse.com

CP_NGINX=`echo $?`

if [ "$CP_NGINX" -ne 0 ]
then
    echo "CP_NGINX ERROR: Unable to copy nginx.conf. Error code $CP_NGINX\n"
    exit $CP_NGINX
fi

sudo ln -s /etc/nginx/sites-available/psetse.com /etc/nginx/sites-enabled

LN_NGINX=`echo $?`

if [ "$LN_NGINX" -ne 0 ]
then
    echo "LN_NGINX ERROR: Unable to link nginx site file. Error code $LN_NGINX\n"
    exit $LN_NGINX
fi

sudo nginx -t

T_NGINX=`echo $?`

if [ "$T_NGINX" -ne 0 ]
then
    echo "T_NGINX ERROR: Nginx configuration file error. Error code $T_NGINX\n"
    exit $T_NGINX
fi

sudo systemctl restart nginx

RESTART_NGINX=`echo $?`

if [ "$RESTART_NGINX" -ne 0 ]
then
    echo "RESTART_NGINX ERROR: Nginx configuration file error. Error code $RESTART_NGINX\n"
    exit $RESTART_NGINX
fi
