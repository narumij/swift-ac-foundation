#ifndef IntegerInput_h
#define IntegerInput_h

typedef enum {
  FastIOIntegerAuto = 0,
  FastIOIntegerBinary = 2,
  FastIOIntegerOctal = 8,
  FastIOIntegerDecimal = 10,
  FastIOIntegerHexadecimal = 16
} FastIOIntegerMode;

extern FastIOIntegerMode _fastio_integer_mode;

#endif
