# Part 2
#
# NOTE: using z3-solver lib

import z3

X, Y, Z, A, B, C = [], [], [], [], [], []

with open("input.txt", "r") as file:
    for line in file.read().splitlines():
        pos, vit = line.split(" @ ")
        x, y, z = pos.split(", ")
        a, b, c = vit.split(", ")
        X.append(int(x))
        Y.append(int(y))
        Z.append(int(z))
        A.append(int(a))
        B.append(int(b))
        C.append(int(c))


pos = z3.RealVector("pos", 3)
vel = z3.RealVector("vel", 3)
tim = z3.RealVector("tim", 3)

s = z3.Solver()

for i in range(3):
    s.add(pos[0] + tim[i] * vel[0] == X[i] + tim[i] * A[i])
    s.add(pos[1] + tim[i] * vel[1] == Y[i] + tim[i] * B[i])
    s.add(pos[2] + tim[i] * vel[2] == Z[i] + tim[i] * C[i])

s.check()

print(s.model().eval(sum(pos)))
# 652666650475950
