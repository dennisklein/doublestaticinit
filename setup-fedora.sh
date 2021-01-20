#! /bin/bash

dnf -y update
dnf -y groupinstall "C Development Tools and Libraries"
dnf -y install boost-devel boost-filesystem cmake gcc-c++ gdb ninja-build redhat-lsb-core zsh
dnf -y clean all
