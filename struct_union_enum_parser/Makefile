# Project Makefile - structured build

# Directories
SRC_DIR := src
INC_DIR := include
BUILD_DIR := build
BIN_DIR := bin

# Tools
CC := gcc
FLEX := flex
BISON := bison

# Flags
CFLAGS := -Wall -Wextra -O2 -I$(INC_DIR) -I$(BUILD_DIR)
LDFLAGS :=

# Sources
SRC_C := $(SRC_DIR)/lang.c $(SRC_DIR)/lib.c $(SRC_DIR)/main.c
LEX_SRC := $(SRC_DIR)/lexer.l
YACC_SRC := $(SRC_DIR)/parser.y

# Generated sources (in build)
LEX_C := $(BUILD_DIR)/lex.yy.c
YACC_C := $(BUILD_DIR)/parser.tab.c
YACC_H := $(BUILD_DIR)/parser.tab.h

# Objects (in build)
OBJS := $(BUILD_DIR)/lex.yy.o $(BUILD_DIR)/parser.tab.o $(BUILD_DIR)/lang.o $(BUILD_DIR)/lib.o $(BUILD_DIR)/main.o

# Target
TARGET := $(BIN_DIR)/parser

.PHONY: all clean distclean test tree

all: $(TARGET)

# Build target
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

# Compile objects
$(BUILD_DIR)/lex.yy.o: CFLAGS += -Wno-sign-compare -Wno-unused-function -Wno-unneeded-internal-declaration
$(BUILD_DIR)/lex.yy.o: $(LEX_C) $(YACC_H) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/parser.tab.o: $(YACC_C) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lang.o: $(SRC_DIR)/lang.c $(INC_DIR)/lang.h $(INC_DIR)/lib.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lib.o: $(SRC_DIR)/lib.c $(INC_DIR)/lib.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.c $(INC_DIR)/lang.h $(INC_DIR)/lexer.h $(INC_DIR)/parser.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Generate Flex/Bison
$(LEX_C): $(LEX_SRC) $(YACC_H) | $(BUILD_DIR)
	$(FLEX) -o $@ $<

$(YACC_C) $(YACC_H): $(YACC_SRC) | $(BUILD_DIR)
	$(BISON) -d -o $(YACC_C) $<

# Dirs
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

# Tests
TESTS := tests/simple_test.c \
		tests/test2.c \
		tests/test_ptr_array.c \
		tests/test_array_ptr.c \
		tests/comprehensive_test.c

test: $(TARGET)
	@for t in $(TESTS); do \
		echo "===== Running $$t ====="; \
		$(TARGET) $$t || exit 1; \
		echo ""; \
	done

# Utility
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# Remove also legacy generated files in root if any
-distclean: clean
	@rm -f lex.yy.c parser.tab.c parser.tab.h parser.output *.o parser

tree:
	@echo "Source:    $(SRC_DIR)" && \
	echo "Include:   $(INC_DIR)" && \
	echo "Build:     $(BUILD_DIR)" && \
	echo "Binary:    $(BIN_DIR)"
