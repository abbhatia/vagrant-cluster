#!/bin/bash

sudo yum -y install ntp
sudo chkconfig ntpd on
sudo service ntpd start

sudo setenforce 0

sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo sh -c 'echo "* soft nofile 10000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nofile 10000" >> /etc/security/limits.conf'
