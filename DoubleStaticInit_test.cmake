set(CTEST_CMAKE_GENERATOR Ninja)
set(CTEST_CONFIGURATION_TYPE Debug)
set(CTEST_SOURCE_DIRECTORY .)
set(CTEST_PROJECT_NAME checker)

cmake_host_system_information(RESULT fqdn QUERY FQDN)
set(CTEST_SITE "${fqdn}")

find_program(LSB_RELEASE_EXEC lsb_release REQUIRED)
execute_process(COMMAND ${LSB_RELEASE_EXEC} -si
  OUTPUT_VARIABLE os_name
  OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${LSB_RELEASE_EXEC} -sr
  OUTPUT_VARIABLE os_release
  OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CTEST_BUILD_NAME "${os_name} ${os_release}")

set(CTEST_BINARY_DIRECTORY "build_${os_name}_${os_release}")

ctest_start(Experimental)
ctest_configure()
ctest_build()
ctest_test()
