#!/bin/bash

SUDO=""
[ "$(whoami)" = "root" ] || SUDO=sudo

which yum 1>/dev/null 2>&1
[ $? -eq 0 ] && package_manager=yum

which apt 1>/dev/null 2>&1
[ $? -eq 0 ] && package_manager=apt

if [ "$package_manager" = "yum" ]; then

    ## Install git
    $SUDO yum -y install git


    ## Install python3
    $SUDO yum -y update
    $SUDO yum -y install yum-utils
    $SUDO yum -y groupinstall development
    $SUDO yum -y install https://centos7.iuscommunity.org/ius-release.rpm
    $SUDO yum -y install python3
    $SUDO yum -y install python-pip
    pip install virtualenv


    ## Install Terraform
    $SUDO yum -y install unzip
    wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip .
    unzip terraform_0.11.10_linux_amd64.zip
    $SUDO mv terraform /usr/bin

    ## INSTALL NODEJS and dependencies
    $SUDO yum install -y gcc-c++ make
    # curl -sL https://rpm.nodesource.com/setup_8.x | $SUDO bash
    curl --silent --location https://rpm.nodesource.com/setup_10.x | $SUDO bash -
    $SUDO yum install -y nodejs
    $SUDO npm install -g yarn
    $SUDO npm install -g @angular/cli
    # $SUDO npm audit fix
    # npm install --save-dev @angular/cli@7.0.6

    ## Install Maven
    $SUDO yum -y install java-1.8.0-openjdk
    ## iNSTALL MAVEN
    $SUDO yum install -y maven


    ## Install docker
    # $SUDO yum install -y epel-release
    $SUDO yum -y install amazon-linux-extras install docker
    $SUDO amazon-linux-extras install -y docker
    $SUDO systemctl start docker


    ## Install mysql
    $SUDO yum -y install mysql

    echo alias cdd=\"cd $(pwd)\" >> ~/.bashrc
    echo alias cdt=\"cd $(pwd)/data/terraform\" >> ~/.bashrc
    echo alias cdl=\"cd $(pwd)/log\" >> ~/.bashrc
    source ~/.bashrc


    ## Install virtualenv
    mkdirs ~/envs/
    virtualenv ~/envs/pacbot_env --python=python3
    source ~/envs/pacbot_env/bin/activate
    echo source ~/envs/pacbot_env/bin/activate >> ~/.bashrc
    pip install -r requirements.txt
elif [ "$package_manager" = "apt" ]; then
    $SUDO apt-get update
    #$SUDO apt-get install --no-install-recommends -y openjdk-8-jdk
    #$SUDO update-java-alternatives --set openjdk-8-jdk

    # build dependencies
    $SUDO apt-get install --no-install-recommends -y maven

    $SUDO apt-get install --no-install-recommends -y curl
    curl -sL -o install_node.sh https://deb.nodesource.com/setup_12.x 
    $SUDO bash install_node.sh
    $SUDO apt-get update
    $SUDO apt-get install --no-install-recommends -y nodejs
    $SUDO apt-get install --no-install-recommends -y npm
    $SUDO npm install -g yarn
    $SUDO npm install -g @angular/cli
    
    # runtime dependencies
    $SUDO apt-get install --no-install-recommends -y docker
    $SUDO apt-get install --no-install-recommends -y docker.io
    $SUDO systemctl start docker
    
    $SUDO apt-get install --no-install-recommends -y python3
    $SUDO apt-get install --no-install-recommends -y python3-venv
    $SUDO apt-get install --no-install-recommends -y mysql-client

    $SUDO apt -y install unzip
    wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
    unzip terraform_0.11.10_linux_amd64.zip
    $SUDO mv terraform /usr/bin

    echo alias cdd=\"cd $(pwd)\" >> ~/.bashrc
    echo alias cdt=\"cd $(pwd)/data/terraform\" >> ~/.bashrc
    echo alias cdl=\"cd $(pwd)/log\" >> ~/.bashrc
    source ~/.bashrc

    
    ## Install virtualenv
    mkdir ~/envs/
    python3 -m venv ~/envs/pacbot_env
    source ~/envs/pacbot_env/bin/activate
    echo source ~/envs/pacbot_env/bin/activate >> ~/.bashrc
    pip install -r requirements.txt
fi

