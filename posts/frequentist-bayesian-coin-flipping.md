+++
title = "Frequentist and Bayesian coin flipping"
published = "2020-11-14"
rss = "Comparing both statistical paradigms on a coin flipping example."
+++

To me, it is still unclear what exactly is the difference between Frequentist and Bayesian statistics.
Most explanations involve terms such as "likelihood", "uncertainty" and "prior probabilities".
Here, I'm going to show the difference between both statistical paradigms by using a coin flipping example.
In the examples, the effect of showing more data to both paradigms will be visualised.

\toc

## Generating data

Lets start by generating some data from a fair coin flip, that is, the probability of heads is 0.5.

```julia:preliminaries
# hideall
using CSV
write_csv(name, data) = CSV.write(joinpath(output_dir, "$name.csv"), data)
```
\output{preliminaries}

```julia:./data-generation.jl
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

## Calculate probability estimates

The Frequentist estimate for a one sample t-test after seeing $n$ samples can be calculated with

```julia:./frequentist_estimate.jl
using HypothesisTests

function frequentist_estimate(n)
  t_result = OneSampleTTest(is_heads[1:n])
  t_lower, t_upper = confint(t_result)
  (lower = t_lower, middle = t_result.xbar, upper = t_upper)
end
```

For the Bayesian estimate, we can use the closed-form solution \citep{turing2020closed}.
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

```julia:plot_estimates
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

function plot_estimates(estimate_function; title="")
  draws = 2:4:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  lowers = [t.lower for t in estimates]
  uppers = [t.upper for t in estimates]
  df = (; draws, estimates, P=middles)
  layers = data(df) * visual(Scatter)
  df_middle = (; P=fill(0.5, length(draws) + 2), draws=[-1; draws; 83])
  layers += data(df_middle) * visual(Lines) * visual(linestyle=:dash)
  for (n, lower, upper) in zip(draws, lowers, uppers)
    df_bounds = (; P=[lower, upper], draws=[n, n])
    layers += data(df_bounds) * visual(Lines)
  end

  axis = (; yticks=0:20:80, limits=((-0.2, 1.2), nothing), title)
  map = mapping(:P => "Probability of heads", :draws => "Observed number of draws")
  draw(layers * map; axis)
end
```
\output{plot_estimates}

```julia:plot_frequentist_estimates
Blog.aog_svg(@OUTPUT, "frequentist-estimates", # hide
plot_estimates(frequentist_estimate; title="Frequentist estimates")
) # hide
```
\textoutput{plot_frequentist_estimates}

```julia:plot_bayesian_estimates
Blog.aog_svg(@OUTPUT, "bayesian-estimates", # hide
plot_estimates(bayesian_estimate; title="Bayesian estimates")
) # hide
```
\textoutput{plot_bayesian_estimates}

## Conclusion

Based on these plots, we can conclude two things.
Firstly, the Bayesian approach provides better estimates for small sample sizes.
The Bayesian approach successfully uses the fact that a probability should be between 0 and 1, which was given to the model via the `Beta(1, 1)` prior.
For increasingly larger sample sizes, the difference between both statistical paradigms vanish in this situation.
Secondly, collecting more and more samples until the result is significant is dangerous.
This approach is called *optional stopping*.
Around 25 samples, it would find that the data must come from a distribution with a mean higher than 0.5, whereas we know that this is false.
\citet{tCumming2011} calls this the "dance of the $p$-values".

## References
\biblabel{tCumming2011}{Cumming (2011)}
Cumming, G. (2011).
Understanding the new statistics: Effect sizes, confidence intervals, and meta-analysis. 
Routledge.

\biblabel{turing2020closed}{The Turing Language, 2020}
The Turing Language (2020).
Introduction to Turing.
<https://turing.ml/dev/tutorials/0-introduction/>.
