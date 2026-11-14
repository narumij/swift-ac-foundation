#include "BufferedInput.h"
#include "FastIO.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

size_t _readLine_stdin(unsigned char **LinePtr) {
  if (_restore_stdin() == EOF)
    return 0;
  size_t Capacity = 0;
  size_t result;
  do {
    result = getline((char **)LinePtr, &Capacity, stdin);
  } while (result < 0 && errno == EINTR);
  return result;
}

void _free(void *ptr) { free(ptr); }
