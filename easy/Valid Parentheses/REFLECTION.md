# Details

Problem: Valid Parentheses
Problem number: 20
Rating: N/A

# What went well

I've done this problem a while ago so I remember how to do it somewhat. I knew that a O(n) solution requires a stack and hashmap. I recall the hashmap is for O(1) check if we have a closing Parentheses but no matching opening Parentheses. What I am noticing from these questions is that the stack is able to track the size so that we can see if what we are looking for is true if the stack is empty.

# What went wrong

After I finished my implementation I overlooked the condition I have:

```python
if not stack or mapping[c] != stack[len(stack) - 1]: return False
```

I accidentally made it

```python
if not stack or mapping[c] == stack[len(stack) - 1]: return False
```

also I accidentally was appending the closing Parentheses but I caught this quickly

# Closing Notes

it was very easy which makes sense for an easy problem but I am realizing how powerful the stack is.
