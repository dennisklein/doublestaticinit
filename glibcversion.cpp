#include <gnu/libc-version.h>
#include <stdio.h>

int main() {
    puts(gnu_get_libc_version());

    return 0;
}
