#!/usr/bin/env bash

set -ex

apt-get update
apt-get install -y vim tmux htop nano
apt-get install -y python3 python3-pip python3-dev python3-venv

apt-get install -y git ninja-build libelf-dev libffi-dev cmake docker.io docker-compose

apt-get install -y apache2
mkdir -p /var/www/

# make docker usable without sudo
usermod -aG docker vagrant

VAGRANT_HOME=/home/vagrant/

# copy everything to the homefolder so that it is persistent independent of the
# run folder.
cp -r /vagrant/* $VAGRANT_HOME
cd $VAGRANT_HOME

# make up/down arrows in bash more convenient
ln -s setup/resources/inputrc .inputrc

# add a sensible vim config
mkdir -p .vim/pack/tpope/start
cd .vim/pack/tpope/start
git clone https://tpope.io/vim/sensible.git
cd $VAGRANT_HOME


# build llvm-mc for use in iwho and llvm-mca13
cd utils/llvm13
git clone -b release/13.x https://github.com/llvm/llvm-project.git
./cmake_setup.sh
cd build
ninja install-llvm-mc
ninja install-llvm-mca
ninja install

# make llvm-mc, clang, etc. available
echo "export PATH=\$PATH:$VAGRANT_HOME/utils/llvm13/install/bin/" >> /etc/profile.d/custom_env_vars.sh

# we also need to make it available in the current script for building the
# schemes, since the above will affect future logins to the VM.
export PATH=$PATH:$VAGRANT_HOME/utils/llvm13/install/bin/

cd $VAGRANT_HOME

# set up the python environment
cd anica_ui

./setup_venv.sh

source ./env/anica_ui/bin/activate

# make the python environment available to the user by default
echo "source /home/vagrant/anica_ui/env/anica_ui/bin/activate" >> $VAGRANT_HOME/.bashrc


# build the uops.info scheme description
cd lib/anica/lib/iwho/
./build_schemes.sh
cd $VAGRANT_HOME

# the predictor registry is an installation-dependent configuration file with
# paths, we copy one to the right location
cp $VAGRANT_HOME/setup/resources/predictor_registry.json $VAGRANT_HOME/anica_ui/lib/anica/lib/iwho/configs/predictors/pred_registry.json

# generate documentation for the python packages
rm -rf /var/www/html/*

pip install pdoc3
pdoc --html -o /var/www/html/doc iwho
pdoc --html -o /var/www/html/doc anica

# abuse pdoc3 to also render the artifact README nicely
cd $VAGRANT_HOME/setup/resources
pdoc --html -o /var/www/html/doc artifact

cd $VAGRANT_HOME


chmod 777 -R /var/www/html

# make everything owned by the default user instead of root
chown -R vagrant:vagrant /home/vagrant/
