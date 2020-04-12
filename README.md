#操作须知
##ansible-playbook包含4个role角色部份，功能如下：
 - os_init: 优化系统脚本。
 - install_pexpect: 在节点部署python的pexpect模块。
 - install_osr: 部署docker、kubelet等。
 - join_node: 接入DCE集群。
 - join_dcei: 接入dce insight，如果容器化部署，忽略。
 
##roles角色组成
 roles/角色名称/{files,tasks,templates}
 - files： 放置文件、脚本之类。
 - tasks： 角色剧本的主任务程序。
 - templates：放置j2模版的配置。
 
 其它根据需要可以自行扩展。
 
## group_vars
  对应roles角色设置变量
  - dce_config: 配置所有角色变量。
  
## 操作

### 设置group_vars/dce_config 参数
```bash
#role: install_pexpect
#copy python pexpect package to dest_pkg_dir
# 配置python路径包
dest_pkg_dir: /root/devops/pkg/python



#role: os_init
#copy script to dest package dir for running
# 配置系统初始化脚本路径
os_pkg_dir: /tmp/os_init
disk_dev: /dev/vdb



#role: install_osr
#configure dce info
# 配置安装docker vg的路径、设置dce版本、设置存放dce包的路径
osr_pkg_dir: /root/devops/pkg/dce
dce_ver: 3.0.6-28385
#disk_dev: /dev/vdb

#configure http web server info
#url: http://{{web_server_ip}}:{{web_server_port}}/3.0.6-28385.tar.gz
# 配置web服务器dce tar包的路径
web_server_ip: 172.23.0.12
web_server_port: 9999

#configre remove confict package
# 移除安装os-requirement时冲突的依赖包（定制化os版本的可忽略跳过）
remove_pkg: nss-softokn-freebl-3.28.3-8.el7_4.i686



#role: join_node
#configure dce info
# 配置DCE版本信息，如果role角色
#dce_ver: 3.0.6-28385
# 配置DCE镜像仓库ip
dce_image_ip: 172.22.106.25
# 配置DCE控制节点ip
dce_controller_addr: 172.22.106.16
# 配置DCE计算节点加入DCE的脚本路径
dce_join_script_path: /usr/local/bin/dce-installer



#role: join_dcei
# 配置insight server ip
dcei_server_ip: 172.22.106.19

```

### 1.设置host
```bash
[car_club_sit]       
    qitv2786  ansible_host=172.23.5.195

[car_club_prod]       
    qitv2809  ansible_host=172.22.4.80

[car_club:children]
    car_club_sit
    car_club_prod


[car_club:vars]
  ansible_ssh_user=abc111
  ansible_ssh_pass=google!@#
  ansible_become=true
  ansible_become_method=su
  ansible_become_user=root
  ansible_become_pass=google!@#
```

### 2.设置main.yml

```

- hosts: car_club_prod
  vars_files:
    - group_vars/dce_config

  roles:
    - install_pexpect 
    - os_init
    - install_osr
    - join_node
    - join_dcei
    
```



### 3.执行

#### 3.1 配置单个角色逐个执行（方法一）
```bash
ansible-playbook -i host os_init.yml
ansible-playbook -i host install_pexpect.yml
ansible-playbook -i host install_osr.yml
ansible-playbook -i host join_dce.yml
ansible-playbook -i host join_dcei.yml
```

#### 3.2 配置一个角色执行（方法二）
```bash
ansible-playbook -i host main.yml
```


  