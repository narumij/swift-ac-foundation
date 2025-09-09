#include "cxx.h"
#include <iostream>
#include <cstdio>

size_t _readLine_stdin(unsigned char **LinePtr) {
  size_t Capacity = 0;
  size_t result;
  do {
    result = getline((char **)LinePtr, &Capacity, stdin);
  } while (result < 0 && errno == EINTR);
  return result;
}

void _free(void * ptr) {
  free(ptr);
}
