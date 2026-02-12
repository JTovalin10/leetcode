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

TOPICS=(
    "array"
    "backtracking"
    "binary search"
    "binary tree"
    "bit manipulation"
    "design"
    "dp"
    "graph"
    "greedy"
    "hash map"
    "heap"
    "linked list"
    "math"
    "matrix"
    "monotonic stack"
    "sliding window"
    "sorting"
    "stack"
    "string"
    "topological sort"
    "trie"
    "two pointers"
    "union find"
)

step5_topic() {
    while true; do
        echo ""
        echo "Select a topic:"
        for i in "${!TOPICS[@]}"; do
            printf "  %2d. %s\n" "$((i + 1))" "${TOPICS[$i]}"
        done
        printf "  %2d. other (type your own)\n" "$(( ${#TOPICS[@]} + 1 ))"
        read -rp "> " topic_choice

        if [[ -z "$topic_choice" ]]; then
            echo "Cannot be empty."
            continue
        fi

        if ! [[ "$topic_choice" =~ ^[0-9]+$ ]]; then
            echo "Please enter a number."
            continue
        fi

        if (( topic_choice >= 1 && topic_choice <= ${#TOPICS[@]} )); then
            topic="${TOPICS[$((topic_choice - 1))]}"
            break
        elif (( topic_choice == ${#TOPICS[@]} + 1 )); then
            read -rp "Enter custom topic: " topic
            if [[ -z "$topic" ]]; then
                echo "Topic cannot be empty."
                continue
            fi
            break
        else
            echo "Invalid choice. Enter 1-$(( ${#TOPICS[@]} + 1 ))."
        fi
    done
}

step6_hints() {
    while true; do
        echo ""
        read -rp "How many hints did you use? (0 if none): " hints_used

        if [[ -z "$hints_used" ]]; then
            echo "Cannot be empty."
            continue
        fi

        if ! [[ "$hints_used" =~ ^[0-9]+$ ]]; then
            echo "Must be a non-negative integer."
            continue
        fi

        break
    done
}

step7_editorial_heading() {
    while true; do
        echo ""
        read -rp "Did you look at the editorial heading? (y/n): " eh_input

        case "$eh_input" in
            y|Y|yes|Yes) editorial_heading=1 ; break ;;
            n|N|no|No)  editorial_heading=0 ; break ;;
            *) echo "Please enter y or n." ;;
        esac
    done
}

step8_editorial_insight() {
    while true; do
        echo ""
        read -rp "Did you look at the editorial insight? (y/n): " ei_input

        case "$ei_input" in
            y|Y|yes|Yes) editorial_insight=1 ; break ;;
            n|N|no|No)  editorial_insight=0 ; break ;;
            *) echo "Please enter y or n." ;;
        esac
    done
}

step9_solution() {
    while true; do
        echo ""
        read -rp "Did you look at the solution? (y/n): " sol_input

        case "$sol_input" in
            y|Y|yes|Yes) looked_at_solution=1 ; break ;;
            n|N|no|No)  looked_at_solution=0 ; break ;;
            *) echo "Please enter y or n." ;;
        esac
    done
}

# --- Cascade helper: ask steps 6-9 with early exit ---

collect_help_steps() {
    step6_hints
    if [[ "$hints_used" -eq 0 ]]; then
        editorial_heading=0
        editorial_insight=0
        looked_at_solution=0
        return
    fi
    step7_editorial_heading
    if [[ "$editorial_heading" -eq 0 ]]; then
        editorial_insight=0
        looked_at_solution=0
        return
    fi
    step8_editorial_insight
    if [[ "$editorial_insight" -eq 0 ]]; then
        looked_at_solution=0
        return
    fi
    step9_solution
}

# --- Collect initial inputs ---

step1_difficulty
step2_name
step3_number
step4_ranking
step5_topic
collect_help_steps

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
    echo "1. Difficulty:           $difficulty"
    echo "2. Problem name:         $problem_name"
    echo "3. Problem number:       $problem_number"
    echo "4. Ranking:              $ranking_display"
    echo "5. Topic:                $topic"
    echo "6. Hints used:           $hints_used"
    echo "7. Editorial heading:    $editorial_heading"
    echo "8. Editorial insight:    $editorial_insight"
    echo "9. Looked at solution:   $looked_at_solution"
    echo "==============="
    echo ""
    echo "Type 'confirm' to create, or a step number (1-9) to fix it."
    read -rp "> " action

    case "$action" in
        confirm)
            break
            ;;
        1) step1_difficulty ;;
        2) step2_name ;;
        3) step3_number ;;
        4) step4_ranking ;;
        5) step5_topic ;;
        6) collect_help_steps ;;
        7) step7_editorial_heading
           if [[ "$editorial_heading" -eq 0 ]]; then
               editorial_insight=0
               looked_at_solution=0
           fi ;;
        8) step8_editorial_insight
           if [[ "$editorial_insight" -eq 0 ]]; then
               looked_at_solution=0
           fi ;;
        9) step9_solution ;;
        *) echo "Invalid input. Type 'confirm' or a number 1-9." ;;
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

echo "$problem_name, $difficulty, $topic, $ranking, $hints_used, $editorial_heading, $editorial_insight, $looked_at_solution" >> "$SCRIPT_DIR/ranking/solutions.csv"

echo ""
echo "Created: $target_dir/"
echo "  - REFLECTION.md"
echo "  - solution.py"
echo "Added to ranking/solutions.csv"
