#include "FastIO.h"

extern const char digit_pairs[200];
extern const char digit4[40000];

static char buffer[40] = {0};

static inline int ___write_4_digits(unsigned r, int i) {
  i -= 4;

  const char* p = digit4 + r * 4;

  buffer[i + 0] = p[0];
  buffer[i + 1] = p[1];
  buffer[i + 2] = p[2];
  buffer[i + 3] = p[3];

  return i;
}

static inline unsigned ___skip_zeros_4(unsigned x) {
  return x < 10 ? 3 : x < 100 ? 2 : x < 1000 ? 1 : 0;
}

static inline int ___write_8_digits(unsigned r, int i) {
  unsigned q = r / 10000;
  unsigned lo = r - q * 10000;

  unsigned a = q / 100;
  unsigned b = q - a * 100;
  unsigned c = lo / 100;
  unsigned d = lo - c * 100;

  i -= 8;

  const char* p;

  p = digit_pairs + a * 2;
  buffer[i + 0] = p[0];
  buffer[i + 1] = p[1];

  p = digit_pairs + b * 2;
  buffer[i + 2] = p[0];
  buffer[i + 3] = p[1];

  p = digit_pairs + c * 2;
  buffer[i + 4] = p[0];
  buffer[i + 5] = p[1];

  p = digit_pairs + d * 2;
  buffer[i + 6] = p[0];
  buffer[i + 7] = p[1];

  return i;
}

static inline unsigned ___skip_zeros_8(unsigned x) {
  if (x >= 10000) {
    if (x >= 1000000) {
      if (x >= 10000000) return 0;
      return 1;
    } else {
      if (x >= 100000) return 2;
      return 3;
    }
  } else {
    if (x >= 100) {
      if (x >= 1000) return 4;
      return 5;
    } else {
      if (x >= 10) return 6;
      return 7;
    }
  }
}

static inline void ___print_positive_eight(uint64_t x) {
  int i = sizeof(buffer);
  unsigned r;

  do {
    uint64_t q = x / 100000000ULL;
    r = (unsigned)(x - q * 100000000ULL);

    i = ___write_8_digits(r, i);

    x = q;
  } while (x != 0);

  i += ___skip_zeros_8(r);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_negative_eight(int64_t x) {
  putchar_unlocked('-');

  int i = sizeof(buffer);
  unsigned r;

  do {
    int64_t q = x / 100000000LL;
    r = (unsigned)(q * 100000000LL - x);

    i = ___write_8_digits(r, i);

    x = q;
  } while (x != 0);

  i += ___skip_zeros_8(r);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_positive_four(uint64_t x) {
  int i = sizeof(buffer);
  unsigned r;

  do {
    uint64_t q = x / 10000;
    r = (unsigned)(x - q * 10000);

    i = ___write_4_digits(r, i);

    x = q;
  } while (x != 0);

  i += ___skip_zeros_4(r);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_negative_four(int64_t x) {
  putchar_unlocked('-');

  int i = sizeof(buffer);
  unsigned r;

  do {
    int64_t q = x / 10000;
    r = (unsigned)(q * 10000 - x);

    i = ___write_4_digits(r, i);

    x = q;
  } while (x != 0);

  i += ___skip_zeros_4(r);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_positive_two(uint64_t x) {
  int i = sizeof(buffer);
  unsigned r;

  do {
    uint64_t q = x / 100;
    r = (unsigned)(x - q * 100);

    i -= 2;
    buffer[i + 0] = digit_pairs[r * 2 + 0];
    buffer[i + 1] = digit_pairs[r * 2 + 1];

    x = q;
  } while (x != 0);

  if (r < 10) {
    ++i;
  }

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_negative_two(int64_t x) {
  putchar_unlocked('-');

  int i = sizeof(buffer);
  unsigned r;

  do {
    int64_t q = x / 100;
    r = (unsigned)(q * 100 - x);

    i -= 2;
    buffer[i + 0] = digit_pairs[r * 2 + 0];
    buffer[i + 1] = digit_pairs[r * 2 + 1];

    x = q;
  } while (x != 0);

  if (r < 10) {
    ++i;
  }

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_positive_one(uint64_t x) {
  int i = sizeof(buffer);
  do {
    int r = x % 10;
    x = x / 10;
    buffer[--i] = 0x30 | r;
  } while (x > 0);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

static inline void ___print_negative_one(int64_t x) {
  putchar_unlocked(0x2D);
  int i = sizeof(buffer);
  do {
    int r = x % 10;
    x = x / 10;
    buffer[--i] = 0x30 | -r;
  } while (x < 0);

  fwrite(buffer + i, 1, sizeof(buffer) - i, stdout);
}

void ___print_int_one(int64_t x) {
  if (x < 0) {
    ___print_negative_one(x);
  }
  else {
    ___print_positive_one((uint64_t)x);
  }
}

void ___print_uint_one(uint64_t x) {
  ___print_positive_one(x);
}

void ___print_int_two(int64_t x) {
  if (x < 0) {
    ___print_negative_two(x);
  }
  else {
    ___print_positive_two((uint64_t)x);
  }
}

void ___print_uint_two(uint64_t x) {
  ___print_positive_two(x);
}

void ___print_int_four(int64_t x) {
  if (x < 0) {
    ___print_negative_four(x);
  }
  else {
    ___print_positive_four((uint64_t)x);
  }
}

void ___print_uint_four(uint64_t x) {
  ___print_positive_four(x);
}

void ___print_int_eight(int64_t x) {
  if (x < 0) {
    ___print_negative_eight(x);
  }
  else {
    ___print_positive_eight((uint64_t)x);
  }
}

void ___print_uint_eight(uint64_t x) {
  ___print_positive_eight(x);
}


void ___print_int(int64_t x) {
  ___print_int_eight(x);
}

void ___print_uint(uint64_t x) {
  ___print_uint_eight(x);
}
