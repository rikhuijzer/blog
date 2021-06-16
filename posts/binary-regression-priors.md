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

\toc

## Data generation

Let's say that the data generation formula for the grade $g_i$ for some individual $i$, with age $a_i$ and recent grade $r_i$, is

```julia:genformula
# hideall
aₑ = 1.02
rₑ = 1.00

"""
\$\$
g_i = a_e * a_i + r_e * r_i + \\epsilon_i = $(aₑ) * a_i + $(rₑ) * r_i + \\epsilon_i
\$\$
""" |> print
```
\textoutput{genformula} where $a_e$ is the coefficient for the age, $r_e$ is a coefficient for the nationality and $\epsilon_i$ is some random noise for individual $i$.
An individual passes the course if the grade is 31 or higher.

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

We can see the positive correlations of `age` and `grade`, and `recent` and `grade`.

```julia:age-grade
# hideall
using AlgebraOfGraphics
using Blog # hide
using CairoMakie
using Makie

fig = Figure(; resolution=(800, 400))
lin = data(df) * linear()
scat = data(df) * visual(Scatter)
ag = lin * mapping(:age, :grade)
ag += scat * mapping(:age, :grade)
draw!(fig[1, 1], ag)
rg = lin * mapping(:recent, :grade)
rg += scat * mapping(:recent, :grade)
draw!(fig[1, 2], rg)

Blog.makie_svg(@OUTPUT, "age-grade", # hide
fig
) # hide
```
\textoutput{age-grade}

as well as the differences in densities when splitting the individuals on pass or fail:

```julia:dist
# hideall
df[!, :str_pass] = string.(df.pass)
fig = Figure(; resolution=(800, 400))
dens = data(df) * AlgebraOfGraphics.density()
ag = dens * mapping(:age; color=:str_pass)
draw!(fig[1, 1], ag)
rg = dens * mapping(:recent; color=:str_pass)
draw!(fig[1, 2], rg)

Blog.makie_svg(@OUTPUT, "dist", # hide
fig
) # hide
```
\textoutput{dist}

## Linear regression

First, we fit a linear model and see how accurate it is.
Here, the only prior information that we can give the model is the structure of the data, that is, the formula.

```julia:lm
using GLM

model = lm(@formula(grade ~ age + recent), df)
println(model)
```
\output{lm}

