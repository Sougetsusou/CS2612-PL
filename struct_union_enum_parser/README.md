# C 语言 Struct/Union/Enum 词法和语法分析器

## 项目概述

本项目实现了一个 C 语言 struct/union/enum 的词法分析器和语法分析器，使用 Flex 和 Bison 工具。

## 文件结构

```
struct_union_enum_parser/
├── lexer.l              # Flex 词法分析器源文件
├── parser.y             # Bison 语法分析器源文件
├── lang.h               # AST 数据结构定义（已提供）
├── lang.c               # AST 构造函数（已提供）
├── lib.h/lib.c          # 辅助库（已提供）
├── main.c               # 主程序（已提供）
├── lexer.h              # Lexer 头文件
├── parser.h             # Parser 头文件包装
└── parser               # 编译后的可执行文件
```

## 功能支持

### 词法分析 (Flex)

支持以下 token：
- **关键字**: `struct`, `union`, `enum`, `typedef`, `int`, `char`
- **标识符**: 以字母或下划线开头，包含字母、数字、下划线
- **数字**: 整数常量
- **符号**: `{`, `}`, `;`, `,`, `*`, `[`, `]`, `(`, `)`

### 语法分析 (Bison)

支持以下语法结构：

#### 1. Struct 定义和声明
```c
struct Point {
  int x;
  int y;
};

struct Point p;
```

#### 2. Union 定义和声明
```c
union Data {
  int i;
  char c;
};

union Data d;
```

#### 3. Enum 定义和声明
```c
enum Color {
  RED,
  GREEN,
  BLUE
};

enum Color color;
```

#### 4. Typedef 类型定义
```c
typedef int myint;
typedef int *myptr;
typedef int arr[10];
typedef struct Point Point;
```

#### 5. 变量定义（支持复杂声明符）
```c
int a;                  // 简单变量
int *b;                 // 指针
int c[10];              // 数组
int *d[5];              // 指针数组
int (*e)[5];            // 指向数组的指针
```

## 编译和运行

### 编译
```bash
cd struct_union_enum_parser
flex lexer.l
bison -d parser.y
gcc -c lex.yy.c
gcc -c parser.tab.c
gcc -c lang.c
gcc -c lib.c
gcc -c main.c
gcc -o parser lex.yy.o parser.tab.o lang.o lib.o main.o
```

或使用提供的编译脚本：
```bash
./run_all_tests.sh
```

### 运行
```bash
./parser input_file.c
```

## 测试用例

### 测试 1: 简单变量定义
```bash
./parser simple_test.c
```

### 测试 2: Struct、Union、Enum 和 Typedef
```bash
./parser test2.c
```

### 测试 3: 指针数组
```bash
./parser test_ptr_array.c
```

### 测试 4: 指向数组的指针
```bash
./parser test_array_ptr.c
```

### 测试 5: 综合测试
```bash
./parser comprehensive_test.c
```

## 输出格式

解析器输出 AST 的树形结构，例如：

```
struct definition: Point
  Field:
    Left type: int
    Right type: the LHS type
    Field name: x
  Field:
    Left type: int
    Right type: the LHS type
    Field name: y

var definition:
  Left type: int
  Right type: array[5] of pointer of the LHS type
  Var name: d
```

## 语法规则

### 优先级和结合性

- **后缀操作符** (`[]`, `()`) 优先级高于前缀操作符 (`*`)
- 例如：`int *x[10]` 表示 `int *(x[10])`（整数指针的数组）
- 使用圆括号改变优先级：`int (*x)[10]` 表示指向整数数组的指针

### Shift/Reduce 冲突

编译时会产生 7 个 shift/reduce 冲突，这是由于 C 声明符的语法特性导致的，是预期的行为。

## 限制

1. 不支持一条语句定义多个变量
2. 不支持变量定义同时初始化
3. 函数参数类型列表可以为空
4. Struct 和 Union 的域列表可以为空，但 Enum 的元素列表不得为空

## 实现细节

### LEFT_TYPE（左侧类型）
表示类型声明的左侧部分，包括：
- Struct/Union/Enum 的定义、声明和匿名形式
- 基本类型（int、char）
- 已定义的类型标识符

### NAMED_RIGHT_TYPE_EXPR（右侧表达式 - 有名字）
表示包含变量名的声明符，支持：
- 标识符
- 指针（`*`）
- 数组（`[NAT]`）
- 函数（`(param_list)`）
- 圆括号分组

### ANNON_RIGHT_TYPE_EXPR（右侧表达式 - 无名字）
表示不包含变量名的声明符，用于函数参数类型，支持：
- 空（无声明符）
- 指针、数组、函数的组合

## 作者

编译原理课程实验

## 许可证

MIT

