#ifndef IntegerInput_h
#define IntegerInput_h

typedef enum {
  FastIOIntegerAuto = 0, // Reserved for automatic base detection; not implemented yet.
  FastIOIntegerBinary = 2,
  FastIOIntegerOctal = 8,
  FastIOIntegerDecimal = 10,
  FastIOIntegerHexadecimal = 16
} FastIOIntegerMode;

#endif
