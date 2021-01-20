#! /bin/bash

yum -y update
yum -y install epel-release
yum -y groupinstall "C Development Tools and Libraries"
yum -y install boost169-devel boost169-filesystem-devel cmake3 gcc-c++ gdb ninja-build redhat-lsb-core zsh
yum -y clean all

# This enables cmake3 globally!
alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
--slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
--slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
--slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
--family cmake
