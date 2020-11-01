+++
title = "Frequentist and Bayesian coin flipping"
published = "24 October 2020"
description = "Comparing both statistical paradigms on a coin flipping example."
reeval = false
+++

To me, it is still unclear what exactly is the difference between Frequentist and Bayesian statistics.
Most explanations involve terms such as "likelihood", "uncertainty" and "prior probabilities".
Here, I'm going to show the difference between both statistical paradigms by using a coin flipping example.
In the examples, the effect of showing more data to both paradigms will be visualised.

\toc 

Lets start by generating some data from a fair coin flip, that is, the probability of heads is 0.5.

```julia:./data-generation.jl
using Revise # hide
using Distributions
using Blog # hide
using Random

n = 80
Random.seed!(102)
p_true = 0.5
is_heads = rand(Bernoulli(p_true), n)
@show is_heads[1:6] # hide
```

To give some intuition about the sample, the first six elements of `is_heads` are

\output{./data-generation.jl}

The Frequentist estimate for a one sample t-test after seeing $n$ samples can be calculated with

```julia:./frequentist_estimate.jl
using HypothesisTests

function frequentist_estimate(n)
  t_result = OneSampleTTest(float.(df[1:n, :is_heads]))
  t_lower, t_upper = confint(t_result)
  (lower = t_lower, middle = t_result.xbar, upper = t_upper)
end
```

For the Bayesian estimate, we can use the closed-form solution as shown by \citet{turing2020closed}.
This closed-form solution is not available for many real-world problems, but quite nice for this example.

```julia:/bayesian_beliefs.jl
# source: https://turing.ml
closed_form_prior = Beta(1, 1)
function update_belief(k)
  heads = sum(df[1:k-1, :is_heads])
  tails = k - heads
  updated_belief = Beta(closed_form_prior.α + tails, closed_form_prior.β + heads)
end
beliefs = [closed_form_prior; update_belief.(1:n)]
```

```julia:/bayesian_estimate.jl
function bayesian_estimate(n)
  distribution = beliefs[n]
  q(x) = x -> quantile(distribution, x)
  (lower = q(0.025), middle = mean(distribution), upper = q(0.975))
end
```

```julia:./plot_estimates.jl
using StatsPlots

function plot_estimates(estimate_function)
  draws = 2:3:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  errors = [(t.middle - abs(t.lower), abs(t.middle - abs(t.upper))) for t in estimates]
  plot(middles, draws, xerr=errors, xlims=(0,1),
    linecolor = :white,label="", # hide
    xlabel = "Probability of heads", ylabel = "Observed number of draws"
  )
  scatter!(middles, draws, label="estimated mean", color = Blog.blue)
  vline!([p_true], line = (1.5, :dash), color = Blog.blue, label = "true mean")
end
```

```julia:./plot_frequentist_estimates.jl
p = plot_estimates(frequentist_estimate)
store_image(p, name::String) = savefig(joinpath(@OUTPUT, "$name.svg")) # hide 
store_image(p, "frequentist-estimates") # hide
```
\output{./plot_frequentist_estimates.jl}
\fig{./frequentist-estimates.svg}

```julia:./plot_bayesian_estimates.jl
p = plot_estimates(bayesian_estimate)
store_image(p, "bayesian-estimates") # hide
```
\output{./plot_bayesian_estimates.jl}
\fig{./bayesian-estimates.svg}

If you don't have much programming experience, then you might be wondering how I came up with this pretty code which can neatly work for the Frequentist **and** Bayesian estimates.
The answer is: lots of trial and error, and moving text around.
Anyway, ...

## References 
\biblabel{turing2020closed}{The Turing Language (2020)}
The Turing Language (2020). 
Introduction to Turing.
<https://turing.ml/dev/tutorials/0-introduction/>.
