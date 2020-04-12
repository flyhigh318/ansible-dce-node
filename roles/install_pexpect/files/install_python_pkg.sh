#!/bin/bash
# author: tangrongwen
# description: it can install python package setuptool, pip and pexpect
# mail: rongwen.tang@daocloud.io
# version: 1.0


function exportEnv() {

    package_dir="/root/devops/pkg/python"
    array_pkg=("setuptools-40.8.0" "pip-19.0.3" "ptyprocess-0.6.0" "pexpect-4.6.0.tar.gz")
    
}

function install_python_pexpect() {

    array_pkg=$1
    for i in ${array_pkg[@]}
    do

        if [ -d  ${package_dir}/${i} ]; then

             cd ${package_dir}/${i}
             python setup.py install

        elif [ -f ${package_dir}/${i} ]; then

            which pip && pip install ${package_dir}/${i}
            [ $? -eq 0 ] && echo `date +'%F %T'` install pexpect package successfully

        else
            echo "no such diretory or file ${package_dir}/${i}"
            exit 1
        fi

    done

}

function main() {

     exportEnv
     install_python_pexpect ${array_pkg}
}

main
