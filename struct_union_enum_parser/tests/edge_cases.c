// Edge cases to cover all grammar requirements from instructions.md

// Forward declarations
struct FwdS;
union FwdU;
enum FwdE;

// Empty field list for struct/union (allowed)
struct EmptyS {};
union EmptyU {};

// Enum element list must be non-empty (test minimal 1 element)
enum Single { ONLY };

// Anonymous types in variable definitions
struct { int x; int y; } anon_s_var;
union { int i; char c; } anon_u_var;
enum { R, G, B } anon_e_var;

// Anonymous types with typedef
typedef struct { int a; } AnonS;
typedef union { int i; char c; } AnonU;
typedef enum { A1, A2 } AnonE;

// Use typedef IDENT as LEFT_TYPE
AnonS s_alias_var;
AnonU u_alias_var;
AnonE e_alias_var;

typedef struct EmptyS EmptySAlias;
typedef union EmptyU EmptyUAlias;
typedef enum Single SingleAlias;
// typedef to forward-declared struct name
typedef struct FwdS FwdSAlias;
EmptySAlias es;
EmptyUAlias eu;
SingleAlias se;
FwdSAlias *ps;  // pointer to incomplete type is legal; good for parser coverage

// Basic typedefs and their usage
typedef int myint;
typedef int *myptr;
typedef int arr[10];
myint v1;
myptr p2;
arr av;

// Function declarations with complex parameter types
int h(int*, char [10]);                 // pointer and array parameter
int i(int (*)(int));                    // function pointer parameter
int j(int (*)[10]);                     // pointer-to-array parameter

// Function returning pointer to array (functions can't return arrays, but can return pointers to arrays)
int (*k())[10];

// Array of pointers to functions: a[3] is array, each element is pointer to function(int)->int*
int *(*a[3])(int);

// Function pointer variable with empty parameter list
int (*fp_noarg)();

// Nested parentheses precedence stress tests
int (*(*complex)[2])(char);             // complex: pointer to array[2] of pointer to function(char)->int

// Struct with fields using anonymous types and complex declarators
struct Container {
  struct { int x; } s;
  union { int i; char c; } u;
  enum { E1, E2 } e;
  int (*fp)(int);
  int (*pa)[10];
  int *arr_of_ptrs[5];
};

