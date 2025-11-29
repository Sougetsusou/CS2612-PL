struct Point {
  int x;
  int y;
};

struct Point p;

union Data {
  int i;
  char c;
};

union Data d;

enum Color {
  RED,
  GREEN,
  BLUE
};

enum Color color;

typedef int myint;
typedef int *myptr;
typedef int arr[10];

int a;
int *b;
int c[10];
int *d[5];
int (*e)[5];

typedef struct Point Point;
typedef enum Color Color;
typedef union Data Data;

