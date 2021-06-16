+++
title = "Increasing predictive accuracy by using foreknowledge"
published = "2021-06-16"
tags = ["statistics", "priors"]
rss = "Using priors for binary logistic regression"
reeval = true
+++

Typically, when making predictions via a linear model, we fit the model on our data and make predictions from the fitted model.
However, this doesn't take much foreknowledge into account.
For example, when predicting a person's length given only the weight and gender, we already have an intuition about the effect size and direction.
Bayesian analysis should be able to incorporate this prior information.
In this blog post, I aim to figure out how much can be gained from using foreknowledge.
To do this, I generate data and fit a Bayesian binary regression.
Next, I compare the accuracy from the Bayesian model with a simple linear model.

## Data generation

Let's say that the data generation formula for the grade $g_i$ for some individual $i$, with age $a_i$ and recent grade $r_i$, is

```julia:genformula
# hideall
aₑ = 1.2
rₑ = 1.4

"""
\$\$
g_i = a_e * a_i + r_e * r_i + \\epsilon_i = $(aₑ) * a_i + $(rₑ) * r_i + \\epsilon_i
\$\$
""" |> print
```
\textoutput{genformula} where $a_e$ is the coefficient for the age, $r_e$ is a coefficient for the nationality and $\epsilon_i$ is some random noise for individual $i$.
Whether individual $i$ passes the course is given by

$$
p_i =
\begin{cases}
\text{true} & \text{if $31 \geq g_i$} \: \text{and} \\
\text{false} & \text{if $g_i < 31$}. \\
\end{cases}
$$

We generate data for $n$ individuals via

```julia:csv
# hideall
using CSV
write_csv(name, data) = CSV.write(joinpath(@OUTPUT, "$name.csv"), data)
```

```julia:generate
using DataFrames
using Random
using Turing
Random.seed!(1)

n = 80
sample(d::Distribution, n::Int) = round.(rand(d, n); digits=2)
A = sample(Normal(19, 1), n)
R = sample(Normal(6, 3), n)
E = sample(Normal(0, 1), n)
G = aₑ .* A + rₑ .* R .+ E
G = round.(G, digits=3)
P = [g < 31 for g in G]

df = DataFrame(age=A, recent=R, error=E, grade=G, pass=P)
write_csv("df", # hide
first(df, 8)
) # hide
```
\output{generate}
\tableinput{}{./code/df.csv}
