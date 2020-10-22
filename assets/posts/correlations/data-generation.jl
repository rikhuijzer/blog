# This file was generated, do not modify it. # hide
using DataFrames

range = 1:7
A = [x + 1 for x in range]
B = [0.5x + 3 for x in range]
C = [5 for x in range]
D = reverse(A)

df = DataFrame(x = range, A = A, B = B, C = C, D = D)