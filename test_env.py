import os

os.environ["MY_VAR"] = "This is a value"

env = os.environ
d = dict(env)

for i in d:
    print(i + "=" + d[i])
