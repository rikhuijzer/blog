# This file was generated, do not modify it. # hide
using DataFrames
using Distributions
using Random
using Statistics

r_2(x) = round(x; digits=2)
Random.seed!(18)
n = 12
I = 1:n
Y = [i % 2 != 0 for i in I]
H = r_2.([y == "apple" ? rand(Normal(10, 1)) : rand(Normal(12, 1)) for y in Y])
W = r_2.([0.6h for h in H])

df = DataFrame(; I, H, W, Y)
write_csv("df", df) # hide