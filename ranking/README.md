# Leetcode Ranking

Tracks my Leetcode skill rating using an Elo system with Codeforces-style ranks.

## Why

Saying "I can solve hards" or "I can do mediums" doesn't say much. The difficulty ratings from the **Leetcode Difficulty Rating** Chrome extension give each problem a numerical score based on weekly contest data. An Elo system uses those ratings to compute a skill rating that also penalizes relying on hints and editorials.

## How it works

`main.py` reads from `solutions.csv`, computes an Elo rating based on problem difficulty and how much help was used, and writes the result to `ranking.txt`.

### CSV columns

`solutions.csv` has the following columns:

| Column | Description |
|---|---|
| `name` | Problem name |
| `difficulty` | easy / medium / hard |
| `topic` | Problem topic (e.g. binary tree, dp, graphs). Used for per-topic ratings |
| `ranking` | Numerical difficulty rating (-1 if unavailable) |
| `hints_used` | Number of hints used (0+) |
| `editorial_heading` | 1 if you looked at the editorial heading, 0 otherwise |
| `editorial_insight` | 1 if you read the editorial approach paragraph, 0 otherwise |
| `looked_at_solution` | 1 if you looked at the full solution, 0 otherwise |

### Performance score

Each solve gets a performance score (1.0 = clean solve):

- Start at 1.0
- Each hint: **-0.1**
- Editorial heading: **-0.15**
- Editorial insight: **-0.25**
- Looked at solution: **-0.5**
- Floor at 0.0

### Elo formula

Your rating starts at **800** and updates after each problem:

1. **Expected score** — how likely you are to cleanly solve the problem given your current rating:
   ```
   expected = 1 / (1 + 10^((problem_rating - your_rating) / 400))
   ```
   If the problem rating is close to yours, expected is ~0.5. If the problem is way above you, expected drops toward 0. If it's way below, expected approaches 1.

2. **Actual score** — your performance score (1.0 for a clean solve, reduced by hints/editorial use).

3. **Rating update** — the difference between actual and expected determines how your rating moves:
   ```
   new_rating = old_rating + 32 * (actual - expected)
   ```
   - Cleanly solve a hard problem (actual > expected) → rating goes **up**
   - Struggle with an easy problem (actual < expected) → rating goes **down**
   - The **32** (K-factor) controls how much each problem swings your rating

Rows with `ranking == -1` are skipped (no difficulty data available).

### Codeforces ranks

| Rating | Rank |
|---|---|
| < 1200 | Newbie |
| 1200–1399 | Pupil |
| 1400–1599 | Specialist |
| 1600–1899 | Expert |
| 1900–2099 | Candidate Master |
| 2100–2299 | Master |
| 2300–2399 | International Master |
| 2400–2599 | Grandmaster |
| 2600–2899 | International Grandmaster |
| >= 2900 | Legendary Grandmaster |

### Output

A dated entry is written to the top of `ranking.txt` with the overall rating and per-topic breakdowns (sorted alphabetically):

```
2026-02-06: rating = 831 (Newbie)
  binary tree: 850 (Newbie)
  dp: 780 (Newbie)
```

Each topic starts at 800 and is updated independently using the same Elo formula. This lets you see which topics are your strongest and weakest.

### Running

```
./run.sh
```

## Updating the data

After solving a problem, run `./new_problem.sh` from the repo root. It walks you through all the fields and appends a row to `solutions.csv`. Then run `./run.sh` inside `ranking/` to recalculate.
