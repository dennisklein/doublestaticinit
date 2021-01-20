cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

project(double_static_init_checker LANGUAGES CXX)

find_program(LSB_RELEASE_EXEC lsb_release REQUIRED)
execute_process(COMMAND ${LSB_RELEASE_EXEC} -si
  OUTPUT_VARIABLE os_name
  OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${LSB_RELEASE_EXEC} -sr
  OUTPUT_VARIABLE os_release
  OUTPUT_STRIP_TRAILING_WHITESPACE)
if(os_name MATCHES CentOS)
  set(BOOST_INCLUDEDIR /usr/include/boost169)
  set(BOOST_LIBRARYDIR /usr/lib64/boost169)
endif()
find_package(Boost REQUIRED COMPONENTS filesystem)

set(CMAKE_EXE_LINKER_FLAGS -rdynamic)
add_executable(checker checker.cpp)
target_link_libraries(checker
  PRIVATE Boost::boost Boost::filesystem ${CMAKE_DL_LIBS})

add_executable(glibcversion glibcversion.cpp)

include(CTest)

add_test(NAME no_double_static_init
  COMMAND ${CMAKE_BINARY_DIR}/checker)

find_program(BASH bash HINTS "/bin")
find_program(SINGULARITY singularity)

if(BASH AND SINGULARITY)
  function(container)
    cmake_parse_arguments(ARGS "BOOTSTRAP_CMAKE" "OS;VERSION;DOCKER_TAG;PACKAGE_SETUP_SCRIPT" "" ${ARGN})

    if(ARGS_DOCKER_TAG)
      set(DOCKER_TAG ${ARGS_DOCKER_TAG})
    else()
      set(DOCKER_TAG "${ARGS_OS}:${ARGS_VERSION}")
    endif()

    if(ARGS_PACKAGE_SETUP_SCRIPT)
      set(PACKAGE_SETUP_SCRIPT "${CMAKE_SOURCE_DIR}/${ARGS_PACKAGE_SETUP_SCRIPT}")
    else()
      set(PACKAGE_SETUP_SCRIPT "${CMAKE_SOURCE_DIR}/setup-${ARGS_OS}.sh")
    endif()

    set(container "${ARGS_OS}.${ARGS_VERSION}")
    set(def "${container}.def")
    set(log "${container}.log")
    set(target "${container}.sif")

    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/linux.def.in" ${def} @ONLY)

    add_custom_command(OUTPUT ${target}
      COMMAND ${CMAKE_COMMAND} -E env ${BASH} -c
        "${SINGULARITY} build -f -F ${target} ${def} > ${log} 2>&1"
      VERBATIM
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Building container ${target}, logging to ${CMAKE_CURRENT_BINARY_DIR}/${log}"
      DEPENDS ${PACKAGE_SETUP_SCRIPT} ${bootstrap_cmake_script}
    )

    list(APPEND containers ${target})
    set(containers ${containers} PARENT_SCOPE)
  endfunction()

  container(OS centos VERSION 7)
  container(OS debian VERSION 9)
  container(OS debian VERSION 10)
  container(OS fedora VERSION 33)
  container(OS fedora VERSION 32)
  container(OS fedora VERSION 31)
  container(OS fedora VERSION 30)
  container(OS fedora VERSION 29)
  container(OS fedora VERSION 28)
  container(OS fedora VERSION 27)
  container(OS ubuntu VERSION 18.04)
  container(OS ubuntu VERSION 20.04)
  container(OS ubuntu VERSION 20.10)

  add_custom_target(all-containers DEPENDS ${containers})
endif()
