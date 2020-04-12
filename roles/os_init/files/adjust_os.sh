#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

function check_os(){
    systemctl stop firewalld
    setenforce 0
    echo 1 > /proc/sys/net/ipv4/ip_forward
    swapoff -a
    if ! (cat /etc/security/limits.conf | grep -i 'hard nofile 65530')
    then
        cat >> /etc/security/limits.conf << EOF

    * soft noproc 11000
    * hard noproc 11000
    * soft nofile 65530
    * hard nofile 65530
EOF
    fi
}

function main(){

  check_os

}

main


