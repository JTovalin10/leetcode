import pandas as pd
from datetime import date

STARTING_ELO = 1200
K = 32

# Hints penalty: how much credit you get for solving the problem
# 0 = no hints (full win), 6 = used solution (full loss)
HINT_SCORE = {
    0: 1.0,   # no hints - full win
    1: 0.85,  # hint 1
    2: 0.7,   # hint 2
    3: 0.55,  # hint 3
    4: 0.4,   # editorial heading
    5: 0.25,  # editorial paragraph
    6: 0.0,   # solution - full loss
}

df = pd.read_csv("solutions.csv", skipinitialspace=True)
rated = df[df["ranking"] != -1]

today = date.today().strftime("%Y-%m-%d")

if rated.empty:
    new_entry = f"{today}: leetcode score = none for now"
else:
    elo = STARTING_ELO
    for _, row in rated.iterrows():
        problem_rating = row["ranking"]
        hints = int(row["hints"]) if "hints" in row and pd.notna(row["hints"]) else 0
        score = HINT_SCORE.get(hints, 1.0)
        expected = 1 / (1 + 10 ** ((problem_rating - elo) / 400))
        elo += K * (score - expected)
    new_entry = f"{today}: leetcode score = {elo:.2f}"

try:
    with open("ranking.txt", "r") as f:
        existing = f.read()
except FileNotFoundError:
    existing = ""

with open("ranking.txt", "w") as f:
    f.write(new_entry + "\n\n" + existing)

print(new_entry)
