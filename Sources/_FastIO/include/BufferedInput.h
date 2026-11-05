#ifndef BufferedInput_h
#define BufferedInput_h

#include <stdio.h>

// Shared stdin pushback slot. Like getchar_unlocked, these functions require
// externally serialized access. All reads must use this wrapper while a byte
// is pending; direct stdio reads cannot see the pending byte.
extern int _fastio_pending_character;

static inline int _getchar_unlocked(void) {
  if (_fastio_pending_character != EOF) {
    int c = _fastio_pending_character;
    _fastio_pending_character = EOF;
    return c;
  }
  return getchar_unlocked();
}

// Returns the pushed byte, or EOF for EOF input or an occupied slot.
// Failure leaves the pending byte unchanged.
static inline int _ungetc(int c) {
  if (c == EOF || _fastio_pending_character != EOF) return EOF;
  _fastio_pending_character = (unsigned char)c;
  return _fastio_pending_character;
}

#endif /* BufferedInput_h */
