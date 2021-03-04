# This file was generated, do not modify it. # hide
using StableRNGs

rng = StableRNG(123)
train, test = MLJ.partition(eachindex(classes), 0.7; shuffle=true, rng)

@show length(train) # hide
@show length(test) # hide