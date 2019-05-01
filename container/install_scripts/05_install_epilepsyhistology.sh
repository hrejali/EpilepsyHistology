#!/bin/bash

DIR=/opt/git
mkdir -p $DIR/EpilepsyHistology

# Install missing dependencies
apt-get install -y libsm6 libxt6 libgl1-mesa-glx libpng16-16
apt-get install -y python3-tk

# Git
git clone https://github.com/hrejali/EpilepsyHistology $DIR/EpilepsyHistology
cd $DIR/EpilepsyHistology
# git checkout khanlab # dev branch, comment for release

# Install requirements
pip3 install -r requirements.txt

# Install neurobeer
python3 setup.py install
