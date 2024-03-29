#include "stdio.h"
#include "float.h"

int main(int argc, char const *argv[]) {
  printf("eps(FLOAT32) = %e\n", __FLT_EPSILON__);
  printf("eps(FLOAT64) = %e\n", __FLT64_EPSILON__);
  printf("max(FLOAT32) = %e\n", __FLT_MAX__);
  printf("max(FLOAT64) = %e\n", __FLT64_MAX__);
  return 0;
}
