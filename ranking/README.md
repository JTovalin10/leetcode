# Leetcode Ranking

Tracks my Leetcode skill level over time using a chess-style Elo rating system.

## Why

Saying "I can solve hards" or "I can do mediums" doesn't say much. The difficulty ratings from the **Leetcode Difficulty Rating** Chrome extension give each problem a numerical score based on weekly contest data, which provides a much more accurate picture of my current skill level.

## How it works

The scoring uses an Elo system (same concept as chess ratings). Each problem you solve is treated like a match against an opponent rated at that problem's difficulty. Your Elo adjusts based on whether the problem was above or below your current level, and how much help you needed.

### Elo calculation

- You start at **1200 Elo**
- For each solved problem, the expected outcome is calculated: `E = 1 / (1 + 10^((problem_rating - your_elo) / 400))`
- Your Elo updates: `new_elo = old_elo + K * (score - E)` where K = 32
- `score` depends on how much help you used (see below)

This means:
- Solving a problem rated **above** your current Elo gives a big boost
- Solving a problem rated **below** your current Elo gives a small boost
- Using hints reduces the credit you get
- Using the full solution counts as a **loss** and drops your Elo

### Hint penalties

Each problem tracks how much help was used on a 0-6 scale:

| Level | Description | Score (credit) |
|-------|-------------|----------------|
| 0 | No hints | 1.0 (full win) |
| 1 | Hint 1 | 0.85 |
| 2 | Hint 2 | 0.70 |
| 3 | Hint 3 | 0.55 |
| 4 | Editorial heading | 0.40 |
| 5 | Editorial paragraph | 0.25 |
| 6 | Full solution | 0.0 (full loss) |

### Data flow

1. **Reads** `solutions.csv` -- columns: `name`, `difficulty`, `ranking`, `time_minutes`, `hints`
2. **Filters out** entries with a ranking of `-1` (no rating available)
3. **Replays** each problem through the Elo formula in order, applying hint penalties
4. **Writes** a dated entry (e.g. `2026-02-12: leetcode score = 1260.49`) to the top of `ranking.txt`
5. **Prints** the same entry to the terminal

### Running

```
./run.sh
```

## Updating the data

Use `new_problem.sh` in the repo root. It asks for all the fields and appends to `solutions.csv` automatically.
