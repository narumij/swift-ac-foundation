#ifndef FloatingPointInput_h
#define FloatingPointInput_h

// Configure between reads, under the same serialization as stdin access.
typedef enum {
  FastIOFloatingPointSpecific,
  FastIOFloatingPointLLVM,
  FastIOFloatingPointGCCLike
} FastIOFloatingPointMode;

extern FastIOFloatingPointMode _fastio_floating_point_mode;

#endif
