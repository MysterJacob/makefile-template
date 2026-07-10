SHELL := bash

CC ?= gcc

LD_FLAGS :=
CC_EXTRA_FLAGS ?=
CC_FLAGS = -Wall -Wextra -Os -pedantic --std=c2x $(CC_EXTRA_FLAGS)

TARGET_NAME = program_name

SRC_DIR = src/
INCLUDE_DIR = include/
BIN_DIR = bin/
TEST_SRC = test/
BUILD_DIR = $(BIN_DIR)build/
OBJ_DIR = $(BIN_DIR)obj/
TEST_OBJ_DIR = $(BIN_DIR)tests/


SOURCES = $(wildcard $(SRC_DIR)*.c)
OBJ_FILES = $(patsubst $(SRC_DIR)%.c, $(OBJ_DIR)%.o, $(SOURCES))
PROJECT_TARGET = $(BUILD_DIR)$(TARGET_NAME)

TEST_SOURCES = $(wildcard $(TEST_SRC)*.c)
TEST_OBJ_FILES = $(patsubst $(TEST_SRC)%.c, $(TEST_OBJ_DIR)%.o, $(TEST_SOURCES))
TEST_TARGET = $(BUILD_DIR)test

default: $(PROJECT_TARGET)
obj: $(OBJ_FILES)

$(BIN_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(TEST_OBJ_DIR)

$(PROJECT_TARGET): $(BIN_DIR) $(OBJ_FILES)
	@$(CC) $(CC_FLAGS) $(LD_FLAGS) $(OBJ_FILES) -o $(PROJECT_TARGET)

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@$(CC) $(CC_FLAGS) -I$(INCLUDE_DIR) -c $< -o $@

objs: $(BIN_DIR) $(OBJ_FILES)


$(TEST_OBJ_DIR)%.o: $(TEST_SRC)%.c
	@$(cc) $(CC_FLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(TEST_TARGET): $(BIN_DIR) $(OBJ_FILES) $(TEST_OBJ_FILES)
	@$(CC) $(CC_FLAGS) -I$(INCLUDE_DIR) $(TEST_OBJ_FILES) $(filter-out $(OBJ_DIR)main.o, $(OBJ_FILES)) -o $(TEST_TARGET)

test: $(SOURCES) $(TEST_SOURCES)
	@make clean
	@make $(TEST_TARGET)
	@./$(TEST_TARGET)


clean:
	@rm -rf $(BIN_DIR)

.PHONY: clean test
