#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin



function check_disk(){

  docker_vg_dev=$1

  flag=`fdisk -l | grep -i "$docker_vg_dev" | wc -l` 
  if [ "$flag" -gt 1 ]
  then
      echo "need to init disk $docker_vg_dev, exit 1"
  elif [ "$flag" -eq 1 ]
  then
      wipefs -a -f "$docker_vg_dev"
      partprobe  
      echo "finish partprobe $docker_vg_dev"
  else
     echo "there is no $docker_vg_dev, please check, exit 2"
  fi

}


function help(){

  echo "usage: $0 [dev]"
  echo "eg: $0 /dev/vde"
  exit 3

}

function main(){

  [ $# -ne 1 ] && help
  check_disk $1

}

main $1




