#!/bin/bash

cmake -S. -Bbuild > /dev/null 2>&1
cmake --build build > /dev/null 2>&1
cmake --build build --target all-containers -j5 > /dev/null 2>&1

echo "| OS | glibc | double static init |"
echo "| --- | --- | --- |"
for container in $(ls build/*.sif); do
  os=$($container lsb_release -is)
  ver=$($container lsb_release -rs)
  $container ctest -VV -S DoubleStaticInit_test.cmake > /dev/null 2>&1
  ldd=$($container build_${os}_${ver}/glibcversion)
  $container gdb --batch --command=gdbchecker --args build_${os}_${ver}/checker > /dev/null 2>&1
  res=$?
  echo "| ${os} ${ver} | ${ldd} | ${res} |"
done
