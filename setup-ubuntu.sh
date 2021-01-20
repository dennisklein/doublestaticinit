#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade
apt-get -y install build-essential cmake gdb g++ libboost-dev libboost-filesystem-dev lsb-release ltrace ninja-build zsh
apt-get -y clean
