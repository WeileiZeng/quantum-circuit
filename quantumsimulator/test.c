#include <stdio.h>
int main()
{
  // printf() displays the string inside quotation
  char a[256];
  sprintf(a,"hello%0.3f\n",0.05);
  printf(a);
  printf("Hello, World!");
  return 0;
}
