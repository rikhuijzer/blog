# This file was generated, do not modify it. # hide
using Statistics
using StatsFuns: logistic
using Turing
# TODO: Use Bijectors Shift and Scale to work around the centering issue. # hide

@model function bayesian_model(ages, recents, grades, n)
    intercept ~ Normal(0, 5)

    βₐ ~ Normal(aₑ, 1)
    βᵣ ~ Normal(rₑ, 3)
    σ ~ truncated(Cauchy(0, 2), 0, Inf)

    μ = intercept .+ βₐ .* ages .+ βᵣ .* recents
    grades .~ Normal.(μ, σ)
end

n = nrow(df)
bm = bayesian_model(df.age, df.recent, df.grade, n)
chns = Turing.sample(bm, NUTS(), MCMCThreads(), 10_000, 3)
# show(stdout, MIME("text/plain"), chns) # hide