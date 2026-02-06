#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Step 1: Pick difficulty
while true; do
    echo ""
    echo "Which directory do you want to add the new problem in?"
    echo "1. Easy"
    echo "2. Medium"
    echo "3. Hard"
    read -rp "> " choice

    case "$choice" in
        1) difficulty="easy" ; break ;;
        2) difficulty="medium" ; break ;;
        3) difficulty="hard" ; break ;;
        *) echo "Invalid choice. Please enter 1, 2, or 3." ;;
    esac
done

# Step 2: Get problem name (with back option)
while true; do
    echo ""
    read -rp "Name of problem (or type 'back' if you selected the wrong difficulty): " problem_name

    if [[ "$problem_name" == "back" ]]; then
        # Go back to difficulty selection
        while true; do
            echo ""
            echo "Which directory do you want to add the new problem in?"
            echo "1. Easy"
            echo "2. Medium"
            echo "3. Hard"
            read -rp "> " choice

            case "$choice" in
                1) difficulty="easy" ; break ;;
                2) difficulty="medium" ; break ;;
                3) difficulty="hard" ; break ;;
                *) echo "Invalid choice. Please enter 1, 2, or 3." ;;
            esac
        done
        continue
    fi

    if [[ -z "$problem_name" ]]; then
        echo "Problem name cannot be empty."
        continue
    fi

    break
done

# Step 3: Create directory and files
dir_name="${problem_name,,}"
target_dir="$SCRIPT_DIR/$difficulty/$dir_name"

if [[ -d "$target_dir" ]]; then
    echo ""
    echo "Directory already exists: $target_dir"
    exit 1
fi

mkdir -p "$target_dir"

# Create REFLECTION.md
cat > "$target_dir/REFLECTION.md" << EOF
# $dir_name

## Details

Problem number:
Rating: N/A

## What went well

## What went wrong

## Closing Notes
EOF

# Create empty solution.py
touch "$target_dir/solution.py"

echo ""
echo "Created: $target_dir/"
echo "  - REFLECTION.md"
echo "  - solution.py"
