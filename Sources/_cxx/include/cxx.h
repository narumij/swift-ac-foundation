#include <stdint.h>

#ifndef Header_h
#define Header_h

#ifdef __cplusplus
extern "C" {
#endif

int64_t gcd_i64(int64_t a, int64_t b);
uint64_t gcd_u64(uint64_t a, uint64_t b);
int64_t lcm_i64(int64_t a, int64_t b);
uint64_t lcm_u64(uint64_t a, uint64_t b);

#ifdef __cplusplus
}
#endif

#endif /* Header_h */
