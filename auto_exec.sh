#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Usage: ./auto_exec EXEC1 [EXEC2 ...] INPUT_COUNT TIMEOUT_SECONDS"
  exit 1
fi

INPUT_COUNT=${@: -2:1}
TIMEOUT_SECONDS=${@: -1}
RAW_EXECUTABLES=("${@:1:$#-2}")

# Extract just filenames (in case full paths like ../success/foo are passed)
EXECUTABLES=()
for path in "${RAW_EXECUTABLES[@]}"; do
  EXECUTABLES+=("$(basename "$path")")
done

# Paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUCCESS_DIR="$SCRIPT_DIR/../success"
OUTPUT_DIR="$SCRIPT_DIR/../outputs"
INPUT_PREFIX="$SCRIPT_DIR/input_"

# Init
mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_DIR/timeouts.txt" "$OUTPUT_DIR/errors.txt"

for EXEC in "${EXECUTABLES[@]}"; do
  EXEC_PATH="$SUCCESS_DIR/$EXEC"

  if [ ! -x "$EXEC_PATH" ]; then
    echo "Skipping '$EXEC': not found or not executable in ../success"
    continue
  fi

  for ((i=1; i<=INPUT_COUNT; i++)); do
    INPUT_FILE="${INPUT_PREFIX}${i}.txt"
    OUTPUT_FILE="$OUTPUT_DIR/${EXEC}_${i}.out"

    if [ -f "$INPUT_FILE" ]; then
      echo "Running: $EXEC < input_${i}.txt > outputs/${EXEC}_${i}.out (timeout ${TIMEOUT_SECONDS}s)"
      timeout --foreground "${TIMEOUT_SECONDS}"s "$EXEC_PATH" < "$INPUT_FILE" > "$OUTPUT_FILE"
      EXIT_CODE=$?

      if [ $EXIT_CODE -eq 124 ]; then
        echo "$EXEC timed out on input_${i}.txt" >> "$OUTPUT_DIR/timeouts.txt"
      elif [ $EXIT_CODE -ne 0 ]; then
        echo "$EXEC failed on input_${i}.txt (exit code $EXIT_CODE)" >> "$OUTPUT_DIR/errors.txt"
      fi
    else
      echo "Input file not found: $INPUT_FILE (skipped)"
    fi
  done
done
