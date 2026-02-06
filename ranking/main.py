import pandas as pd
from datetime import date

df = pd.read_csv("solutions.csv", skipinitialspace=True)
scores = df[df["difficulty"] != -1]["difficulty"]

today = date.today().strftime("%Y-%m-%d")

if scores.empty:
    new_entry = f"{today}: leetcode score = none for now"
else:
    new_entry = f"{today}: leetcode score = {scores.mean():.2f}"

try:
    with open("ranking.txt", "r") as f:
        existing = f.read()
except FileNotFoundError:
    existing = ""

with open("ranking.txt", "w") as f:
    f.write(new_entry + "\n\n" + existing)

print(new_entry)
