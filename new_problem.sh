#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Step functions ---

step1_difficulty() {
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
}

step2_name() {
    while true; do
        echo ""
        read -rp "Name of problem: " problem_name

        if [[ -z "$problem_name" ]]; then
            echo "Problem name cannot be empty."
            continue
        fi

        break
    done
}

step3_number() {
    while true; do
        echo ""
        read -rp "Problem number: " problem_number

        if [[ -z "$problem_number" ]]; then
            echo "Problem number cannot be empty."
            continue
        fi

        if ! [[ "$problem_number" =~ ^[0-9]+$ ]]; then
            echo "Problem number must be a positive integer."
            continue
        fi

        break
    done
}

step4_ranking() {
    while true; do
        echo ""
        read -rp "Ranking number (or N/A, NA, -1 if none): " ranking_input

        if [[ -z "$ranking_input" ]]; then
            echo "Ranking cannot be empty."
            continue
        fi

        if [[ "$ranking_input" == "N/A" || "$ranking_input" == "NA" || "$ranking_input" == "n/a" || "$ranking_input" == "na" || "$ranking_input" == "-1" ]]; then
            ranking="-1"
        elif [[ "$ranking_input" =~ ^[0-9]+$ ]]; then
            ranking="$ranking_input"
        else
            echo "Invalid input. Enter a number, N/A, NA, or -1."
            continue
        fi

        break
    done
}

step5_time() {
    while true; do
        echo ""
        read -rp "How long did it take in minutes? (enter or -1 to skip): " time_input

        if [[ -z "$time_input" || "$time_input" == "-1" ]]; then
            time_minutes="-1"
            break
        fi

        if [[ "$time_input" =~ ^[0-9]+$ ]]; then
            time_minutes="$time_input"
            break
        fi

        echo "Invalid input. Enter a number or press enter to skip."
    done
}

step6_hints() {
    while true; do
        echo ""
        echo "How much help did you use?"
        echo "0. None (or just press enter)"
        echo "1. Hint 1"
        echo "2. Hint 2"
        echo "3. Hint 3"
        echo "4. Editorial heading"
        echo "5. Editorial paragraph"
        echo "6. Solution (counts as a loss)"
        read -rp "> " hints_input

        if [[ -z "$hints_input" ]]; then
            hints="0"
            break
        fi

        if [[ "$hints_input" =~ ^[0-6]$ ]]; then
            hints="$hints_input"
            break
        fi

        echo "Invalid input. Enter 0-6 or press enter for none."
    done
}

# --- Collect initial inputs ---

step1_difficulty
step2_name
step3_number
step4_ranking
step5_time
step6_hints

# --- Confirmation loop ---

hint_labels=("None" "Hint 1" "Hint 2" "Hint 3" "Editorial heading" "Editorial paragraph" "Solution (loss)")

while true; do
    if [[ "$ranking" == "-1" ]]; then
        ranking_display="N/A"
    else
        ranking_display="$ranking"
    fi

    if [[ "$time_minutes" == "-1" ]]; then
        time_display="N/A"
    else
        time_display="${time_minutes} min"
    fi

    echo ""
    echo "=== Summary ==="
    echo "1. Difficulty:      $difficulty"
    echo "2. Problem name:    $problem_name"
    echo "3. Problem number:  $problem_number"
    echo "4. Ranking:         $ranking_display"
    echo "5. Time:            $time_display"
    echo "6. Hints used:      ${hint_labels[$hints]}"
    echo "==============="
    echo ""
    echo "Type 'confirm' to create, or a step number (1-6) to fix it."
    read -rp "> " action

    case "$action" in
        confirm)
            break
            ;;
        1) step1_difficulty ;;
        2) step2_name ;;
        3) step3_number ;;
        4) step4_ranking ;;
        5) step5_time ;;
        6) step6_hints ;;
        *) echo "Invalid input. Type 'confirm' or a number 1-6." ;;
    esac
done

# --- Create directory and files ---

dir_name="${problem_name,,}"
target_dir="$SCRIPT_DIR/$difficulty/$dir_name"

if [[ -d "$target_dir" ]]; then
    echo ""
    echo "Directory already exists: $target_dir"
    exit 1
fi

mkdir -p "$target_dir"

cat > "$target_dir/REFLECTION.md" << EOF
# $dir_name

## Details

Problem number: $problem_number
Rating: $ranking_display
Time: $time_display
Hints: ${hint_labels[$hints]}

## What went well

## What went wrong

## Closing Notes
EOF

touch "$target_dir/solution.py"

echo "$problem_name, $difficulty, $ranking, $time_minutes, $hints" >> "$SCRIPT_DIR/ranking/solutions.csv"

echo ""
echo "Created: $target_dir/"
echo "  - REFLECTION.md"
echo "  - solution.py"
echo "Added to ranking/solutions.csv"
