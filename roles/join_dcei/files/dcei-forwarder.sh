#/bin/sh

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

if [ $# -ne 1 ];
then

    echo "usage: $0 [dcei-server-ip]"
    exit 1

fi

export DCEI_SERVER_IP=$1
curl -ksL https://$DCEI_SERVER_IP:8000/custom/dce_monitor/forwarder/install | bash
