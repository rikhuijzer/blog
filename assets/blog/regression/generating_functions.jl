# This file was generated, do not modify it. # hide
using DataFrames
using Distributions
using Random
using Statistics

r2(x) = round(x; digits=2)
Random.seed!(123)
n = 18
I = 1:n
Y = [i % 2 != 0 for i in I]
H = r2.([y == "apple" ? rand(Normal(10, 1)) : rand(Normal(12, 1)) for y in Y])
W = r2.([0.6h for h in H])

df = DataFrame(I = I, H = H, W = W, Y = Y)
@show df