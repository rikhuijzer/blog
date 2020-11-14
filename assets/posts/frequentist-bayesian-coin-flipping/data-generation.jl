# This file was generated, do not modify it. # hide
using Distributions
using Blog # hide
using Random

n = 80
Random.seed!(102)
p_true = 0.5
is_heads = rand(Bernoulli(p_true), n)
@show is_heads[1:6] # hide