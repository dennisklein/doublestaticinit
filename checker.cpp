#include <boost/dll/shared_library.hpp>         // for shared_library
#include <boost/dll/runtime_symbol_info.hpp>    // for program_location()

namespace
{
  struct A {
    A() {}
  };

  A a;
}

int main()
{
  boost::dll::shared_library self(boost::dll::program_location());

  return 0;
}
