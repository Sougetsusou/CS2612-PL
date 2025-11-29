C 语言中 struct/union/enum 的定义与声明的词法分析与语法分析
考虑 C 语言中 struct/union/enum 的定义与声明，基于 typedef 的类型定义，以及变量的定
义。下面是它们的语法（不需要考虑一条语句定义多个变量的情形，也不需要考虑变量定义同
时初始化的情形）：
```
STRUCT_DEFINITION ::= struct STRUCT_NAME { FIELD_LIST } ;
STRUCT_DECLARATION ::= struct STRUCT_NAME ;
UNION_DEFINITION ::= union UNION_NAME { FIELD_LIST } ;
UNION_DECLARATION ::= union UNION_NAME ;
ENUM_DEFINITION ::= enum ENUM_NAME { ENUM_ELE_LIST } ;
ENUM_DECLARATION ::= enum ENUM_NAME ;
TYPE_DEFINITION ::= typedef LEFT_TYPE NAMED_RIGHT_TYPE_EXPR ;
VAR_DEFINITION ::= LEFT_TYPE NAMED_RIGHT_TYPE_EXPR ;
```
本任务中，约定 struct 与 union 的域列表允许为空，但 enum 的元素列表不得为空。
```
FIELD ::= LEFT_TYPE NAMED_RIGHT_TYPE_EXPR ;
FIELD_LIST ::= FIELD FIELD ... FIELD
ENUM_ELE_LIST ::= ENUM_ELE , ENUM_ELE , ... , ENUM_ELE
```
这里提到的 STRUCT_NAME 、 UNION_NAME 、 ENUM_NAME 、 ENUM_ELE 以及下面会提到的 IDENT （标识
符）都表示以字母或下滑线开头且仅包含字母数码与下划线的名字。需要特别注意的是，C 语
言的中变量定义与域定义中，变量类型与域类型都是通过两部分进行描述的：左半部分是基础
类型，右半部分是包含变量名或域名的一个表达式。例如， int * x 这个定义可以分为 int 与
* x 两个部分，它表示 * x 的值（即存储在 x 地址的内容）为整数类型。这就是上面提到的：
```
LEFT_TYPE NAMED_RIGHT_TYPE_EXPR
```
本任务中需要考虑指针类型、数组类型、函数类型的情形，在基础类型方面只考虑 int 与 char
两个类型：
```
LEFT_TYPE ::= struct STRUCT_NAME { FIELD_LIST }
| struct { FIELD_LIST }
| struct STRUCT_NAME
| union UNION_NAME { FIELD_LIST }
| union { FIELD_LIST }
| union UNION_NAME
| enum ENUM_NAME { ENUM_ELE_LIST }
| enum { ENUM_ELE_LIST }
| enum ENUM_NAME
| int | char | IDENT
```
```
NAMED_RIGHT_TYPE_EXPR ::= IDENT
| * NAMED_RIGHT_TYPE_EXPR
| NAMED_RIGHT_TYPE_EXPR [ NAT ]
| NAMED_RIGHT_TYPE_EXPR ( ARGUMENT_TYPE_LIST )
ANNON_RIGHT_TYPE_EXPR ::= EMPTY
| * ANNON_RIGHT_TYPE_EXPR
| ANNON_RIGHT_TYPE_EXPR [ NAT ]
| ANNON_RIGHT_TYPE_EXPR ( ARGUMENT_TYPE_LIST )
ARGUMENT_TYPE ::= LEFT_TYPE ANNON_RIGHT_TYPE_EXPR
ARGUMENT_TYPE_LIST ::= ARGUMENT_TYPE , ..., ARGUMENT_TYPE
```
在 C 语言中，表达式（这里提到的 NAMED_RIGHT_TYPE_EXPR 与 ANNON_RIGHT_TYPE_EXPR ）后缀（数组与函
数）的结合优先级高于前缀的结合优先级，并且允许使用圆括号改变优先级。例如，int * x[10] 表
示 int * (x[10]) ，定义了一个整数指针的数组；函数参数类型的语法也是类似的，例如 int * [10]
表示整数指针的数组类型， int ( * )(int) 表示整数一元函数的函数指针类型。本题约定，函数
的参数类型列表可以为空。
本任务中，用于所有定义与声明的抽象语法树的 C 语言存储结构以及辅助构造函数、调试函数
已经在 lang.h 与 lang.c 中提供了，main.c 程序也是固定的（详见 struct_union_enum.zip），
请使用 flex 与 bison 实现词法分析与语法分析。 给我解释这个任务