class Solution:
    def highFive(self, items: List[List[int]]) -> List[List[int]]:
        # set up
        top_five = {sub[0]: list() for sub in items}
        student_top_five_min = {sub[0]: float("inf") for sub in items}
        for key, value in items:
            if len(top_five[key]) < 5:
                top_five[key].append(value)
                student_top_five_min[key] = min(student_top_five_min[key], value)
            else:
                # we want to see if the new value is greater than our current min score so we can replace it
                if student_top_five_min[key] < value:
                    # we want to replace it and remove it from the top_five
                    top_five[key].remove(student_top_five_min[key])
                    # find the new smallest valu
                    top_five[key].append(value)
                    student_top_five_min[key] = min(top_five[key])

        # now we want to loop through top_five and get the result
        res = [[key, 0] for key in top_five]
        for i, (key, value) in enumerate(top_five.items()):
            curr = 0
            for num in value:
                curr += num
            res[i][0] = key
            res[i][1] = int(float(curr) / 5)
        res.sort()
        return res
