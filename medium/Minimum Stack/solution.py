class MinStack:
    def __init__(self):
        self.min_stack = []
        self.stack = []
        self.size = 0

    def push(self, val: int) -> None:
        self.stack.append(val)
        if self.size > 0:
            min_val = min(val, self.min_stack[self.size - 1])
            self.min_stack.append(min_val)
        else:
            self.min_stack.append(val)
        self.size += 1

    def pop(self) -> None:
        self.stack.pop()
        self.min_stack.pop()
        self.size -= 1

    def top(self) -> int:
        return self.stack[self.size - 1]

    def getMin(self) -> int:
        return self.min_stack[self.size - 1]
