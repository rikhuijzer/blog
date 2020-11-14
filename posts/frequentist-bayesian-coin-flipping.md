+++
title = "Frequentist and Bayesian coin flipping"
published = "14 November 2020"
description = "Comparing both statistical paradigms on a coin flipping example."
reeval = true
+++

To me, it is still unclear what exactly is the difference between Frequentist and Bayesian statistics.
Most explanations involve terms such as "likelihood", "uncertainty" and "prior probabilities".
Here, I'm going to show the difference between both statistical paradigms by using a coin flipping example.
In the examples, the effect of showing more data to both paradigms will be visualised.

\toc 

Lets start by generating some data from a fair coin flip, that is, the probability of heads is 0.5.

```julia:preliminaries
# hideall
using CSV
output_dir = @OUTPUT
write_csv(name, data) = CSV.write(joinpath(output_dir, "$name.csv"), data)
write_svg(name::String, p) = savefig(joinpath(@OUTPUT, "$name.svg"))
```
\output{preliminaries}

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
  t_result = OneSampleTTest(is_heads[1:n])
  t_lower, t_upper = confint(t_result)
  (lower = t_lower, middle = t_result.xbar, upper = t_upper)
end
```

For the Bayesian estimate, we can use the closed-form solution as shown by \citet{turing2020closed}.
A closed-form solution is not available for many real-world problems, but quite useful for this example.

```julia:bayesian_beliefs
closed_form_prior = Beta(1, 1)
function update_belief(k)
  heads = sum(is_heads[1:k-1])
  tails = k - heads
  updated_belief = Beta(closed_form_prior.α + heads, closed_form_prior.β + tails)
end
beliefs = [closed_form_prior; update_belief.(1:n)]
```
\output{bayesian_beliefs}

```julia:/bayesian_estimate.jl
function bayesian_estimate(n)
  distribution = beliefs[n]
  q(x) = quantile(distribution, x)
  (lower = q(0.025), middle = mean(distribution), upper = q(0.975))
end
```

```julia:./plot_estimates.jl
using StatsPlots

function plot_estimates(estimate_function; title="")
  draws = 2:3:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  errors = [(t.middle - abs(t.lower), abs(t.middle - abs(t.upper))) for t in estimates]
  plot(middles, draws, xerr=errors, xlims=(0,1),
    title = title, 
    linecolor = :white,label="", # hide
    xlabel = "Probability of heads", ylabel = "Observed number of draws"
  )
  scatter!(middles, draws, label="estimated mean", color = Blog.blue)
  vline!([p_true], line = (1.5, :dash), color = Blog.blue, label = "true mean")
end
```

```julia:plot_frequentist_estimates
write_svg("frequentist-estimates", # hide
plot_estimates(frequentist_estimate, title = "Frequentist estimates")
) # hide 
```
\output{plot_frequentist_estimates}
\fig{frequentist-estimates.svg}

```julia:plot_bayesian_estimates
write_svg("bayesian-estimates", # hide
plot_estimates(bayesian_estimate, title = "Bayesian estimates")
) # hide
```
\output{plot_bayesian_estimates}
\fig{bayesian-estimates.svg}

If you don't have much programming experience, then you might be wondering how I came up with this pretty code which can neatly work for the Frequentist **and** Bayesian estimates.
The answer is: lots of trial and error, and moving text around.

Based on these plots, we can conclude two things.
Firstly, the Bayesian approach provides better estimates for small sample sizes.
The Bayesian approach successfully uses the fact that a probability should be between 0 and 1, which was given to the model via the `Beta(1, 1)` prior.
For increasingly larger sample sizes, the difference between both statistical paradigms vanish in this situation.
Secondly, collecting more and more samples until the result is significant is dangerous.
This approach is called *optional stopping*.
Around 25 samples, it would find that the data must come from a distribution with a mean higher than 0.5, whereas we know that this is false.

## References 
\biblabel{turing2020closed}{The Turing Language (2020)}
The Turing Language (2020). 
Introduction to Turing.
<https://turing.ml/dev/tutorials/0-introduction/>.
