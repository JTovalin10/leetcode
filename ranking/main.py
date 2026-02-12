import csv
from datetime import date

RANK_TIERS = [
    (2900, "Legendary Grandmaster"),
    (2600, "International Grandmaster"),
    (2400, "Grandmaster"),
    (2300, "International Master"),
    (2100, "Master"),
    (1900, "Candidate Master"),
    (1600, "Expert"),
    (1400, "Specialist"),
    (1200, "Pupil"),
    (0, "Newbie"),
]


def get_rank(rating):
    for threshold, title in RANK_TIERS:
        if rating >= threshold:
            return title
    return "Newbie"


def performance_score(row):
    score = 1.0
    score -= 0.1 * int(row["hints_used"])
    score -= 0.15 * int(row["editorial_heading"])
    score -= 0.25 * int(row["editorial_insight"])
    score -= 0.5 * int(row["looked_at_solution"])
    return max(score, 0.0)


rating = 800
topic_ratings = {}
K = 32

with open("solutions.csv", newline="") as f:
    reader = csv.DictReader(f, skipinitialspace=True)
    for row in reader:
        problem_rating = int(row["ranking"])
        if problem_rating == -1:
            continue

        topic = row["topic"].strip()
        if topic not in topic_ratings:
            topic_ratings[topic] = 800

        # Update overall rating
        expected = 1 / (1 + 10 ** ((problem_rating - rating) / 400))
        actual = performance_score(row)
        rating = rating + K * (actual - expected)

        # Update topic rating
        topic_expected = 1 / (1 + 10 ** ((problem_rating - topic_ratings[topic]) / 400))
        topic_ratings[topic] = topic_ratings[topic] + K * (actual - topic_expected)

today = date.today().strftime("%Y-%m-%d")
rank_title = get_rank(rating)
lines = [f"{today}: rating = {rating:.0f} ({rank_title})"]
for topic in sorted(topic_ratings):
    t_rating = topic_ratings[topic]
    t_rank = get_rank(t_rating)
    lines.append(f"  {topic}: {t_rating:.0f} ({t_rank})")

new_entry = "\n".join(lines)

try:
    with open("ranking.txt", "r") as f:
        existing = f.read()
except FileNotFoundError:
    existing = ""

with open("ranking.txt", "w") as f:
    f.write(new_entry + "\n\n" + existing)

print(new_entry)
