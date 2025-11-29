# C 语言 struct/union/enum 词法与语法分析器

本项目使用 Flex + Bison 实现对 C 语言中 struct/union/enum 的定义/声明、typedef 与变量定义（含指针/数组/函数声明符组合）的词法与语法分析，并生成课程提供的 AST 结构进行打印。

最近一次验证
- 测试时间：2025-11-29T10:25:30.359Z
- 测试结果：全部通过（见 docs/TEST_RESULTS.md）

目录结构
```
struct_union_enum_parser/
├─ src/           # 源码：lexer.l, parser.y, lang.c, lib.c, main.c
├─ include/       # 头文件：lexer.h, parser.h, lang.h, lib.h
├─ tests/         # 测试样例：simple_test.c, test2.c, ...
├─ build/         # 构建中间产物（由 Makefile 生成）
├─ bin/           # 可执行文件输出（parser）
├─ docs/          # 文档（README、TEST_RESULTS 等）
├─ .gitignore
└─ Makefile
```

快速开始
- 依赖：gcc、flex、bison
- 编译与测试：
```bash
cd struct_union_enum_parser
make clean && make
make test
```
- 运行：
```bash
./bin/parser tests/simple_test.c
```

功能范围
- 支持：
  - struct/union/enum 的定义与声明（支持匿名 struct/union/enum，约定 enum 元素列表非空）
  - typedef 类型定义
  - 变量定义（不支持同语句多个变量；不支持初始化）
  - 声明符右侧表达式组合：指针(*)、数组([N])、函数((args)) 与圆括号改变优先级
- 基础类型：int, char, 以及 typedef 定义的已命名类型

语法/优先级要点
- 后缀（[] / ()）优先于前缀（*）；可用括号改变结合：
  - `int *x[10]` 等价 `int *(x[10])` → “指针的数组”
  - `int (*x)[10]` → “指向数组的指针”
- 函数参数类型列表可为空

输出示例
```
var definition:
  Left type: int
  Right type: array[5] of pointer of the LHS type
  Var name: d
```

构建说明
- 使用 Makefile：
  - 生成物定向至 build/（中间文件）与 bin/（可执行 parser）
  - Flex/Bison 生成的头文件位于 build/，编译时通过 `-Iinclude -Ibuild` 包含

测试与结果
- 运行 `make test` 将依次执行 tests/ 下的用例
- 完整的构建与测试输出（含工具版本）已保存至 docs/TEST_RESULTS.md

已知事项
- Bison 会报告若干 shift/reduce 冲突（声明符典型现象）；当前文法按课程要求子集与测试用例均工作正常

许可证与致谢
- 许可证：MIT
- AST 结构与打印由课程提供的 lang.h/lang.c 支持
