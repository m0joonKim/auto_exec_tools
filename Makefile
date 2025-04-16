# auto_exec_tools/Makefile

CC = gcc
CFLAGS = -Wall -Wextra -O2

SRC_DIR := ..
OUT_DIR := ../success

SRCS := $(wildcard $(SRC_DIR)/*.c)
TARGETS := $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%, $(SRCS))

.PHONY: all clean prepare

all: prepare $(TARGETS)

prepare:
	@mkdir -p $(OUT_DIR)
	@rm -f fail_compile.txt

$(OUT_DIR)/%: $(SRC_DIR)/%.c
	@echo "Compiling $< ..."
	@{ \
		$(CC) $(CFLAGS) -o $@ $< 2> .errlog; \
		if [ $$? -ne 0 ]; then \
			echo "Failed to compile: $<" >> fail_compile.txt; \
			rm -f $@; \
			echo "      ❌ Failed: $<"; \
			cat .errlog; \
		else \
			echo "      ✅ Success: $<"; \
		fi; \
		rm -f .errlog; \
	}

clean:
	rm -rf $(OUT_DIR) fail_compile.txt ../outputs
