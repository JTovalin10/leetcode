# Leetcode Ranking

Tracks my average Leetcode problem difficulty score over time.

## Why

Saying "I can solve hards" or "I can do mediums" doesn't say much. The difficulty ratings from the **Leetcode Difficulty Rating** Chrome extension give each problem a numerical score based on weekly contest data, which provides a much more accurate picture of my current skill level.

## How it works

`main.py` reads from `solutions.csv`, computes the average difficulty score of all problems that have a rating, and writes the result to `ranking.txt`.

### Data flow

1. **Reads** `solutions.csv` -- a CSV with columns `name` and `difficulty`
2. **Filters out** any entries with a difficulty of `-1` (problems where the rating isn't available yet)
3. **Calculates** the mean of the remaining difficulty scores
4. **Writes** a dated entry (e.g. `2026-02-05: leetcode score = 1432.50`) to the top of `ranking.txt`, preserving previous entries below it
5. **Prints** the same entry to the terminal

### Running

```
./run.sh
```

## Updating the data

After solving a problem:

1. Open `solutions.csv`
2. Add a new row with the problem name and its difficulty rating from the Leetcode Difficulty Rating extension:
   ```
   Two Sum, 1150
   ```
3. If the problem hasn't appeared in a weekly contest, it won't have a rating in the extension (N/A). Use `-1` for these -- they are excluded from the score:
   ```
   Some Problem, -1
   ```
4. Run `./run.sh` to recalculate and log the updated score
