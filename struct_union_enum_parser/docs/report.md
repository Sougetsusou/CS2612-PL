# 项目报告：C 语言 struct/union/enum 词法与语法分析器


## 1. 摘要
本项目实现了一个面向教学的 C 语言类型片段解析器，聚焦于 struct/union/enum 的定义与声明、typedef 与变量定义（含指针、数组、函数声明符的组合）。项目使用 Flex 实现词法分析，使用 Bison 实现语法分析，构造并打印课程提供的 AST 结构（lang.h/lang.c）。项目实现了优先级与结合性正确的声明符解析，并通过一组覆盖典型结构的测试用例验证。

## 2. 需求与范围
  - struct/union/enum 定义与声明；支持匿名 struct/union/enum（enum 元素列表非空）。
  - typedef 类型定义。
  - 变量定义，仅单一声明符；不支持同语句多个变量；不支持初始化。
  - 声明符右侧表达式：指针(*)、数组([N])、函数((args))，可用括号改变结合。
  - 基础类型：int、char、以及通过 typedef 定义的已命名类型。


## 3. 目录结构与构建
```
struct_union_enum_parser/
├─ src/           # 源码：lexer.l, parser.y, lang.c, lib.c, main.c
├─ include/       # 头文件：lexer.h, parser.h, lang.h, lib.h
├─ tests/         # 测试样例：simple_test.c, test2.c, ...
├─ build/         # 构建中间产物（由 Makefile 生成）
├─ bin/           # 可执行文件输出（parser）
├─ docs/          # 文档（README、TEST_RESULTS、REPORT）
├─ .gitignore
└─ Makefile
```
构建与测试（需安装 gcc、flex、bison）：
```bash
cd struct_union_enum_parser
make clean && make
make test
```
手动运行：
```bash
./bin/parser tests/simple_test.c
```

## 4. 词法分析设计（Flex）
- 关键字：`struct`, `union`, `enum`, `typedef`, `int`, `char`
- 标识符：`[a-zA-Z_][a-zA-Z0-9_]*`
- 数字常量：`[0-9]+`（无符号十进制，自 lib.c 的 build_nat 做上限校验）
- 分隔与符号：`{ } ; , * [ ] ( )`
- 空白与换行被忽略；无复杂注释处理需求（可扩展）。
- yylval 载荷：标识符使用 new_str 拷贝；自然数使用 build_nat 转为 unsigned int。

## 5. 语法分析设计（Bison）
### 5.1 关键非终结符
- left_type：左侧基础类型（struct/union/enum/int/char/已定义类型）。
- named_right_type_expr：含名字的右侧声明符，递归表达指针/数组/函数与括号改变结合。
- annon_right_type_expr：无名的右侧声明符（用于函数参数类型），允许为空代表“无声明符”。
- field_list、enum_ele_list_nonempty：域与枚举成员列表。
- param_type_list：函数参数类型列表，允许为空。

### 5.2 结合与优先级策略
- 按 C 声明符约定，后缀（`[]`、`()`）优先于前缀 `*`。
- 使用递归规则体现：
  - `named_right_type_expr -> IDENT | '*' named_right_type_expr | named_right_type_expr '[' NAT ']' | named_right_type_expr '(' param_type_list ')' | '(' named_right_type_expr ')'`
  - 这样 `*x[10]` 解析为 `*(x[10])`（指针数组），`(*x)[10]` 解析为“指向数组的指针”。

### 5.3 shift/reduce 冲突
- C 声明符的固有歧义导致若干 shift/reduce 冲突。本项目通过在 parser.y 顶部添加：
```
%expect 7
```
静音 Bison 关于 7 个预期冲突的提示，不改变语义与行为。

## 6. AST 映射与构造
- 所有节点使用 lang.h/lang.c 中提供的构造器：
  - 左侧类型：`TStructType/TNewStructType/TUnionType/TNewUnionType/TEnumType/TNewEnumType/TIntType/TCharType/TDefinedType`。
  - 右侧声明符：`TOrigType/TPtrType/TArrayType/TFuncType`。
  - 全局项：`TStructDef/TStructDecl/TUnionDef/TUnionDecl/TEnumDef/TEnumDecl/TTypeDef/TVarDef`。
  - 列表：`TTCons/TTNil`, `TECons/TENil`, `TGCons/TGNil`。
- 打印：由 lang.c 中的 print_* 系列完成，特别处理函数类型“返回类型 + 参数类型列表”。

## 7. 关键实现片段（节选）
命名右侧声明符（节选）：
```bison
named_right_type_expr
    : IDENT                         { $$ = TOrigType($1); }
    | STAR named_right_type_expr    { $$ = TPtrType($2); }
    | named_right_type_expr LBRACKET NAT RBRACKET
                                    { $$ = TArrayType($1, $3); }
    | named_right_type_expr LPAREN param_type_list RPAREN
                                    { $$ = TFuncType($1, $3); }
    | LPAREN named_right_type_expr RPAREN
                                    { $$ = $2; }
;
```
参数类型列表（节选）：
```bison
param_type_list
    : /* empty */                   { $$ = TTNil(); }
    | left_type annon_right_type_expr
                                    { $$ = TTCons($1, $2, TTNil()); }
    | left_type annon_right_type_expr COMMA param_type_list
                                    { $$ = TTCons($1, $2, $4); }
;
```

## 8. 构建与质量控制
- Makefile 将中间产物输出至 build/，可执行输出至 bin/；编译包含路径：`-Iinclude -Ibuild`。


## 9. 测试与结果
- 工具链版本：
  - GCC: Apple clang 17.0.0
  - Flex: 2.6.4 Apple(flex-35)
  - Bison: 2.3
- 运行方式：`make clean && make && make test`
- 详尽的构建与测试日志、样例输出见：`docs/TEST_RESULTS.md`
- 覆盖的典型样例：
  - 简单变量：`int x;`
  - 结构体/联合体/枚举的定义与声明（含匿名与命名）：`struct Point {...}; union Data {...}; enum Color {...};`
  - typedef：`typedef int myint; typedef int *myptr; typedef int arr[10];`
  - 指针与数组的组合：`int *d[5]; int (*e)[5];`
  - 函数类型与函数指针：`int f(int); int (*g)(int);`（解析与打印为函数类型结构）

## 10. 局限与改进方向
- 局限：
  - 不支持：同语句多变量声明、初始化表达式、限定符/存储类、更多基础类型（short/long/signed/unsigned 等）。
- 可改进：
  - 扩展类型系统与声明语法（指向函数的数组等更多边界组合的测试）。
  - 采用 GLR 解析（`%glr-parser`）或更细的优先级/结合性声明减少冲突（需充分验证）。

## 11. 结论
本项目按课程要求完成 struct/union/enum + typedef + 变量定义子集的词法/语法分析，正确处理 C 声明符的优先级与结合性，AST 构造与打印符合验收格式。测试覆盖典型用例，构建过程稳定。该实现为进一步扩展 C 语言前端提供了可维护、可演进的基础。


