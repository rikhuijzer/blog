+++
title = "The logit and logistic functions"
published = "4 November 2020"
tags = ["statistics"]
description = "Providing the definitions, some plots and useful values to remember."
+++
@def reeval = true

```julia:preliminaries
# hideall
output_dir = @OUTPUT
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p)
```

Linear regression works on real numbers $\mathbb{R}$, that is, the input and output are in $\mathbb{R}$. 
For probabilities, this is problematic because the linear regression will happily give a probability of $-934$, where we know that probabilities should always lie between $0$ and $1$.
This is only by definition, but it is an useful definition in practice.
Informally, the *logistic* function has been designed to convert values from real numbers to probabilities and the *logit* function is the inverse.

\toc 

## Logistic

The logistic function converts values from $(-\infty, \infty)$ to $(0, 1)$: 

$$ \text{logistic}(x) = \frac{1}{1 + e^{-x}}. $$

```julia:logistic
logistic(x) = 1 / (1 + exp(-x))
```
\output{logistic}

We can visualise this with

```julia:plot-logistic
using Gadfly

write_svg("logistic", # hide
plot(y = [logistic], xmin = [-6], xmax = [6], 
	Geom.line, Stat.func, Guide.xlabel("x")
)
) # hide
```
\output{plot-logistic}
\fig{logistic.svg}

Some people advise to remember the following numbers by heart.
$$
\begin{aligned}
\text{logistic}(-3) &\approx 0.05, \\
\text{logistic}(-1) &\approx \frac{1}{4}, \\
\text{logisitc}(1) &\approx \frac{3}{4}, \: \text{and} \\
\text{logistic}(3) &\approx 0.95.
\end{aligned}
$$

since 

```julia:logistic-numbers
@show logistic(-3) # hide
@show logistic(-1) # hide
@show logistic(1) # hide
@show logistic(3) # hide
```
\output{logistic-numbers}

## Logit

The inverse of the logistic function is the *logit* function, 

$$ \text{logit}(x) = \log(\frac{x}{1 - x}). $$

```julia:logit
logit(x) = log(x / (1 - x))
```

This function goes from $(0, 1)$ to $(- \infty, \infty)$.

```julia:plot-logit
write_svg("logit", # hide
plot(y = [logit], xmin = [0], xmax = [1],
	Geom.line, Stat.func, Guide.xlabel("x")
)
) # hide
```
\fig{logit.svg}
