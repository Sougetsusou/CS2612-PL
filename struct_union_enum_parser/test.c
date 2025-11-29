struct Point {
  int x;
  int y;
};

int a;
int *b;
int c[10];
int *d[5];
int (*e)[5];
int f(int, char);
int (*g)(int);

typedef int myint;
typedef int *myptr;
typedef int arr[10];

enum Color {
  RED,
  GREEN,
  BLUE
};

union Data {
  int i;
  char c;
};

