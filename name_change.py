#!/bin/python3
import os

PARENT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
skipped_files = []

for filename in os.listdir(PARENT_DIR):
    full_path = os.path.join(PARENT_DIR, filename)

    # Skip directories
    if os.path.isdir(full_path):
        continue

    try:
        # Expected format: 이름-학번_학번_챕터_문제번호-번호.확장자
        name_parts = filename.split('-')
        if len(name_parts) != 3:
            raise ValueError("Invalid format: does not have 3 parts split by '-'")

        id_part = name_parts[1]  # 학번_학번_06_01
        id_parts = id_part.split('_')
        if len(id_parts) != 4:
            raise ValueError("Invalid format: does not have 4 parts split by '_'")

        student_id = id_parts[1]  # use second 학번
        chapter = id_parts[2]
        problem = id_parts[3]

        new_name = f"{student_id}_{chapter}_{problem}.c"
        new_path = os.path.join(PARENT_DIR, new_name)

        os.rename(full_path, new_path)
        print(f"Renamed: {filename} → {new_name}")

    except Exception as e:
        skipped_files.append((filename, str(e)))

# Print summary of skipped files
if skipped_files:
    print("\n[⚠️ Skipped files]:")
    for name, reason in skipped_files:
        print(f"  - {name}: {reason}")
