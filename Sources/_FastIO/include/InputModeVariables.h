#ifndef InputModeVariables_h
#define InputModeVariables_h

// Configure between reads, under the same serialization as stdin access.
typedef enum {
  FastIOFloatingPointSpecific,
  FastIOFloatingPointLLVM,
  FastIOFloatingPointGCCLike
} FastIOFloatingPointMode;

extern FastIOFloatingPointMode _fastio_floating_point_mode;

typedef enum {
  FastIOIntegerAuto = 0,
  FastIOIntegerAuto2 = 1,
  FastIOIntegerBinary = 2,
  FastIOIntegerOctal = 8,
  FastIOIntegerDecimal = 10,
  FastIOIntegerHexadecimal = 16
} FastIOIntegerMode;

extern FastIOIntegerMode _fastio_integer_mode;

#endif
