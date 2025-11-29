.PHONY: all clean test

CC = gcc
FLEX = flex
BISON = bison

SOURCES = lex.yy.c parser.tab.c lang.c lib.c main.c
OBJECTS = lex.yy.o parser.tab.o lang.o lib.o main.o
TARGET = parser

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d parser.y

lex.yy.o: lex.yy.c
	$(CC) -c $<

parser.tab.o: parser.tab.c
	$(CC) -c $<

lang.o: lang.c
	$(CC) -c $<

lib.o: lib.c
	$(CC) -c $<

main.o: main.c
	$(CC) -c $<

test: $(TARGET)
	./$(TARGET) simple_test.c
	@echo ""
	./$(TARGET) test2.c
	@echo ""
	./$(TARGET) test_ptr_array.c
	@echo ""
	./$(TARGET) test_array_ptr.c
	@echo ""
	./$(TARGET) comprehensive_test.c

clean:
	rm -f $(OBJECTS) $(TARGET) lex.yy.c parser.tab.c parser.tab.h parser.output

