#include "cxx.h"
#include <numeric>
#include <cstdio>

int64_t gcd_i64(int64_t a, int64_t b) {
    return std::gcd(a, b);
}

uint64_t gcd_u64(uint64_t a, uint64_t b) {
    return std::gcd(a, b);
}

int64_t lcm_i64(int64_t a, int64_t b) {
    return std::lcm(a, b);
}

uint64_t lcm_u64(uint64_t a, uint64_t b) {
    return std::lcm(a, b);
}

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
