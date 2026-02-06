class Solution:
    def isValid(self, s: str) -> bool:
        if not s or len(s) == 0:
            return True
        if len(s) == 1:
            return False
        mapping = {")": "(", "}": "{", "]": "["}
        stack = []
        for c in s:
            if c == ")" or c == "]" or c == "}":
                # we want to check if the last element in stack is the corresponding one
                if not stack or mapping[c] != stack[len(stack) - 1]:
                    return False
                stack.pop()
            else:
                # it is a open one so we can add it as it should be closed later
                # or return false
                stack.append(c)

        return len(stack) == 0
