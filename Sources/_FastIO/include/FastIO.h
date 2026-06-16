#ifndef FastPrint_h
#define FastPrint_h

#include <stdio.h>
#include <stdint.h>

void ___print_int(int64_t x);
void ___print_uint(uint64_t x);
void ___print_int_one(int64_t x);
void ___print_uint_one(uint64_t x);
void ___print_int_two(int64_t x);
void ___print_uint_two(uint64_t x);
void ___print_int_four(int64_t x);
void ___print_uint_four(uint64_t x);

size_t _readLine_stdin(unsigned char **LinePtr);
void _free(void * ptr);

#endif /* FastPrint_h */
