class Solution:
    def sumOfDigits(self, nums: List[int]) -> int:
        # find the min integer
        res = float("inf")
        for num in nums:
            res = min(res, num)
        res_char = str(res)
        total = 0
        for c in res_char:
            total += int(c)
        if total % 2 == 0:
            return 1
        return 0
