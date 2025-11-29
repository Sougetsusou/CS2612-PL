# 测试与构建结果

- 测试时间：2025-11-29T10:25:30.359Z
- 环境/工具版本：
  - GCC: Apple clang version 17.0.0 (clang-1700.4.4.1)
  - Flex: flex 2.6.4 Apple(flex-35)
  - Bison: bison (GNU Bison) 2.3

---

## 构建与测试输出

```
rm -rf build bin
bison -d -o build/parser.tab.c src/parser.y
src/parser.y: conflicts: 7 shift/reduce
flex -o build/lex.yy.c src/lexer.l
gcc -Wall -Wextra -O2 -Iinclude -Ibuild -c build/lex.yy.c -o build/lex.yy.o
build/lex.yy.c:1149:38: warning: comparison of integers of different signs: 'yy_size_t' (aka 'unsigned long') and 'int' [-Wsign-compare]
 1149 |         if (((yy_n_chars) + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
      |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
build/lex.yy.c:1228:17: warning: unused function 'yyunput' [-Wunused-function]
 1228 |     static void yyunput (int c, char * yy_bp )
      |                 ^~~~~~~
build/lex.yy.c:1275:16: warning: function 'input' is not needed and will not be emitted [-Wunneeded-internal-declaration]
 1275 |     static int input  (void)
      |                ^~~~~
gcc -Wall -Wextra -O2 -Iinclude -Ibuild -c build/parser.tab.c -o build/parser.tab.o
3 warnings generated.
gcc -Wall -Wextra -O2 -Iinclude -Ibuild -c src/lang.c -o build/lang.o
src/lang.c:462:10: warning: unused variable 'name' [-Wunused-variable]
  462 |   char * name = print_var_decl_expr_rec2(e);
      |          ^~~~
gcc -Wall -Wextra -O2 -Iinclude -Ibuild -c src/lib.c -o build/lib.o
gcc -Wall -Wextra -O2 -Iinclude -Ibuild -c src/main.c -o build/main.o
1 warning generated.
gcc -o bin/parser build/lex.yy.o build/parser.tab.o build/lang.o build/lib.o build/main.o 
===== Running tests/simple_test.c =====
var definition:
  Left type: int
  Right type: the LHS type
  Var name: x

===== Running tests/test2.c =====
union definition: Data
  Field:
    Left type: char
    Right type: the LHS type
    Field name: c
  Field:
    Left type: int
    Right type: the LHS type
    Field name: i
enum definition: Color ( BLUE GREEN RED )
typedef:
  Left type: int
  Right type: the LHS type
  Type name: myint
var definition:
  Left type: int
  Right type: array[10] of the LHS type
  Var name: c
var definition:
  Left type: int
  Right type: pointer of the LHS type
  Var name: b
var definition:
  Left type: int
  Right type: the LHS type
  Var name: a
struct definition: Point
  Field:
    Left type: int
    Right type: the LHS type
    Field name: y
  Field:
    Left type: int
    Right type: the LHS type
    Field name: x

===== Running tests/test_ptr_array.c =====
var definition:
  Left type: int
  Right type: array[5] of pointer of the LHS type
  Var name: d

===== Running tests/test_array_ptr.c =====
var definition:
  Left type: int
  Right type: pointer of array[5] of the LHS type
  Var name: e

===== Running tests/comprehensive_test.c =====
typedef:
  Left type: union Data
  Right type: the LHS type
  Type name: Data
typedef:
  Left type: enum Color
  Right type: the LHS type
  Type name: Color
typedef:
  Left type: struct Point
  Right type: the LHS type
  Type name: Point
var definition:
  Left type: int
  Right type: pointer of array[5] of the LHS type
  Var name: e
var definition:
  Left type: int
  Right type: array[5] of pointer of the LHS type
  Var name: d
var definition:
  Left type: int
  Right type: array[10] of the LHS type
  Var name: c
var definition:
  Left type: int
  Right type: pointer of the LHS type
  Var name: b
var definition:
  Left type: int
  Right type: the LHS type
  Var name: a
typedef:
  Left type: int
  Right type: array[10] of the LHS type
  Type name: arr
typedef:
  Left type: int
  Right type: pointer of the LHS type
  Type name: myptr
typedef:
  Left type: int
  Right type: the LHS type
  Type name: myint
var definition:
  Left type: enum Color
  Right type: the LHS type
  Var name: color
enum definition: Color ( BLUE GREEN RED )
var definition:
  Left type: union Data
  Right type: the LHS type
  Var name: d
union definition: Data
  Field:
    Left type: char
    Right type: the LHS type
    Field name: c
  Field:
    Left type: int
    Right type: the LHS type
    Field name: i
var definition:
  Left type: struct Point
  Right type: the LHS type
  Var name: p
struct definition: Point
  Field:
    Left type: int
    Right type: the LHS type
    Field name: y
  Field:
    Left type: int
    Right type: the LHS type
    Field name: x
```

