class Solution:
    def largestEven(self, s: str) -> str:
        if not s:
            return ""
        if s[-1] == "2":
            return s
        # we just need to add all 2's as we can delete any from of chaacrcets of s wuthiyt changing order of remaining characters
        for i in range(len(s) - 1, -1, -1):
            if int(s[i]) % 2 == 0:
                return s[0 : i + 1]
        return ""
