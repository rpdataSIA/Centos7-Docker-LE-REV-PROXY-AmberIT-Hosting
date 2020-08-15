#!/bin/bash
#!/usr/bin/env bash

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

printf 'Installing Docker and required services. Please wait...'
spinner &

sleep 35  
#######################################################################
###           .--.  .-.   .-..----. .----..----.    .-. .---.       ###
###          / {} \ |  `.'  || {}  }| {__ | {}  }   | |{_   _}      ###
###         /  /\  \| |\ /| || {}  }| {__ | .-. \   | |  | |        ###
###         `-'  `-'`-' ` `-'`----' `----'`-' `-'   `-'  `-'`       ###
###                                                                 ###
###             Created by RP Data, SIA                             ###
###             Creation data 06.08.2020                            ###
###             Script version: V1                                  ###
###             GIT:     https://www/amberit.in                     ###
###             Website: https://www.amberit.org                    ###
###                                                                 ###
#######################################################################


# Set UTF-8 support 
localectl set-locale LC_CTYPE=en_US.utf8 ;

echo "export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8" >> /etc/bashrc ;
source /etc/bashrc ; 

# Let's update and upgrade our system
yum -q -y update  1> /dev/null 2>> temp ; yum -q -y upgrade 1> /dev/null 2>> temp ;

# Disable default firewall
systemctl stop firewalld 1> /dev/null 2>> temp ;
systemctl disable firewalld 1> /dev/null 2>> temp ;
systemctl mask --now firewalld 1> /dev/null 2>> temp ;

# Install needed packages
yum install -q -y yum-utils 1> /dev/null 2>> temp ; yum install -q -y device-mapper-persistent-data lvm2 1> /dev/null 2>> temp ;

# Configure the docker-ce repo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 1> /dev/null 2>> temp ;

# Install docker-ce
yum install -q -y docker-ce 1> /dev/null 2>> temp ;

# Add your user to the docker group with the following command.
usermod -aG docker $(whoami) 1> /dev/null 2>> temp ;

# Set Docker to start automatically at boot time and let's start it
systemctl enable docker.service 1> /dev/null 2>> temp ;
systemctl start docker.service 1> /dev/null 2>> temp ;

# Install Extra Packages for Enterprise Linux
yum install -q -y epel-release 1> /dev/null 2>> temp ;

# Install python-pip
yum install -q -y python-pip 1> /dev/null 2>> temp ;

# Upgrade pip
pip install --upgrade pip 1> /dev/null 2>> temp ;

# Install docker composer
pip install docker-compose 1> /dev/null 2>> temp ;

#U pgrade python to latest version
yum -q -y upgrade python* 1> /dev/null 2>> temp ;

# Create directory
mkdir /srv/docker 1> /dev/null 2>> temp ;

# Let's run portainer management system
# Pull portainer from docker hub 
docker pull portainer/portainer 1> /dev/null 2>> temp ;

# Let's run a portainer image.
docker run -d --name portainer-manager -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer 1> /dev/null 2>> temp ;

# Let's download nginx-proxy
docker pull jwilder/nginx-proxy:latest 1> /dev/null 2>> temp ;

# Let's start nginx-proxy container
docker run --detach --name nginx-proxy --publish 80:80 --publish 443:443 --volume /srv/docker/certs:/etc/nginx/certs --volume /srv/docker/vhosts.d/:/etc/nginx/vhost.d --volume /srv/docker/vhosts.d/:/usr/share/nginx/html --volume /srv/docker/dhparam:/etc/nginx/dhparam --volume /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy 1> /dev/null 2>> temp ;

# Let's run Let's encrypt Nginx
docker pull jrcs/letsencrypt-nginx-proxy-companion:latest 1> /dev/null 2>> temp ;

# Let's start container
docker run --detach --name nginx-proxy-letsencrypt --volumes-from nginx-proxy --volume /var/run/docker.sock:/var/run/docker.sock:ro --env "DEFAULT_EMAIL=YOUR-EMAIL@MAILSERVER.COM" jrcs/letsencrypt-nginx-proxy-companion 1> /dev/null 2>> temp ;

kill "$!" 1> /dev/null 2>> temp ;  # kill the spinner 
printf '\n' 1> /dev/null 2>> temp ;
rm -rf temp 1> /dev/null ;

IP=$(curl ifconfig.me)
echo "

#######################################################################
###                                                                 ###
###             Created by RP Data, SIA                             ###
###             Creation data 06.08.2020                            ###
###             Script version: V1                                  ###
###             GIT:     https://www/amberit.in                     ###
###             Website: https://www.amberit.org                    ###
###                                                                 ###
#######################################################################

Your Portainer management system http://$IP:9000 
For hosting visit: https://www.amberit.org

" > /etc/motd
echo "


#######################################################################
###                                                                 ###
###             Created by RP Data, SIA                             ###
###             Creation data 06.08.2020                            ###
###             Script version: V1                                  ###
###             GIT:     https://www/amberit.in                     ###
###             Website: https://www.amberit.org                    ###
###                                                                 ###
#######################################################################

The setup is completed.
Please visit http://$IP:9000 for portainer management and setup your admin account.

This script was written by RP Data, SIA European
Hosting company https://www.amberit.org

"
