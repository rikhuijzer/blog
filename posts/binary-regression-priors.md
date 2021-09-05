+++
title = "Increasing model accuracy by using foreknowledge"
published = "2021-06-16"
tags = ["statistics", "priors"]
rss = "Using priors for binary logistic regression"
image = "/assets/og-image/binary-regression-priors.png"
+++

Typically, when making predictions via a linear model, we fit the model on our data and make predictions from the fitted model.
However, this doesn't take much foreknowledge into account.
For example, when predicting a person's length given only the weight and gender, we already have an intuition about the effect size and direction.
Bayesian analysis should be able to incorporate this prior information.

In this blog post, I aim to figure out whether foreknowledge can, in theory, increase model accuracy.
To do this, I generate data and fit a linear model and a Bayesian binary regression.
Next, I compare the accuracy of the model parameters from the linear and Bayesian model.

\toc

## Data generation

Let's say that the data generation formula for the grade $g_i$ for some individual $i$, with age $a_i$ and recent grade $r_i$, is

```julia:genformula
# hideall
aₑ = 1.1
rₑ = 1.05

"""
\$\$
g_i = a_e * a_i + r_e * r_i + \\epsilon_i = $(aₑ) * a_i + $(rₑ) * r_i + \\epsilon_i
\$\$
""" |> print
```
\textoutput{genformula} where $a_e$ is the coefficient for the age, $r_e$ is a coefficient for the nationality and $\epsilon_i$ is some random noise for individual $i$.

We generate data for $n$ individuals via

```julia:csv
# hideall
using CSV
write_csv(name, data) = CSV.write(joinpath(@OUTPUT, "$name.csv"), data)
```

```julia:generate
using DataFrames
using Distributions
using Random

function generate_data(i::Int)
  Random.seed!(i)

  n = 120
  I = 1:n
  P = [i % 2 == 0 for i in I]
  r_2(x) = round(x; digits=2)

  A = r_2.([p ? rand(Normal(aₑ * 18, 1)) : rand(Normal(18, 1)) for p in P])
  R = r_2.([p ? rand(Normal(rₑ * 6, 3)) : rand(Normal(6, 3)) for p in P])
  E = r_2.(rand(Normal(0, 1), n))
  G = aₑ .* A + rₑ .* R .+ E
  G = r_2.(G)

  df = DataFrame(age=A, recent=R, error=E, grade=G, pass=P)
end

df = generate_data(1)
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
axis = (ylabel="estimated density",)
draw!(fig[1, 1], ag; axis)
rg = dens * mapping(:recent; color=:str_pass)
draw!(fig[1, 2], rg; axis)

Blog.makie_og_image(fig, "binary-regression-priors") # hide
Blog.makie_svg(@OUTPUT, "dist", # hide
fig
) # hide
```
\textoutput{dist}

## Linear regression

First, we fit a linear model and verify that the coefficients are estimated reasonably well.
Here, the only prior information that we give the model is the structure of the data, that is, a formula.

```julia:lm
using GLM

linear_model = lm(@formula(grade ~ age + recent), df)
println(linear_model) # hide
```
\output{lm}

```julia:note-coef
# hideall
r5(x) = round(x; digits=5)
coef_a = coef(linear_model)[2] |> r5
coef_r = coef(linear_model)[3] |> r5
"""
Notice how these estimated coefficients are close to the coefficients that we set for `age` and `recent`, namely \$a_e = $aₑ \\approx $coef_a \$ and \$ r_e = $rₑ \\approx $coef_r \$, as expected.
""" |> print
```
\textoutput{note-coef}

## Bayesian regression

For the Bayesian regression we fit a model via Turing.jl.
Now, we give the model information about the structure of the data as well as priors for the size of the coefficients.
For demonstration purposes, I've set the priors to the correct values.
This is reasonable because I was wondering whether finding a good prior could have a positive effect on the model accuracy.

```julia:rescale
# hideall
# Not used because it makes the analysis much more complex.
using MLDataUtils: rescale!

function rescale_data(df)
    out = DataFrame(df)
    rescale!(out, [:age, :recent, :grade])
    for col in [:age, :recent, :error, :grade] # hide
        out[!, col] = round.(out[!, col]; digits=3) # hide
    end # hide
    out
end

rescaled = rescale_data(df)
rescaled[!, :pass_num] = [p ? 1.0 : 0.0 for p in rescaled.pass]

write_csv("rescaled", # hide
first(rescaled, 8)
) # hide
# \tableinput{}{./code/rescaled.csv}
```
\output{rescale}

```julia:bayesian-model
using Statistics
using StatsFuns: logistic
using Turing

# TODO: Use Bijectors Shift and Scale to work around the centering issue. # hide

@model function bayesian_model(ages, recents, grades, n)
    intercept ~ Normal(0, 5)
    βₐ ~ Normal(aₑ, 1)
    βᵣ ~ Normal(rₑ, 3)
    σ ~ truncated(Cauchy(0, 2), 0, Inf)

    μ = intercept .+ βₐ * ages .+ βᵣ * recents
    grades ~ MvNormal(μ, σ)
end

n = nrow(df)
bm = bayesian_model(df.age, df.recent, df.grade, n)
chns = Turing.sample(bm, NUTS(), MCMCThreads(), 10_000, 3)
# show(stdout, MIME("text/plain"), chns) # hide
```
\output{bayesian-model}

Lets plot the density for the coefficient estimates $\beta_a$ and $\beta_r$.

```julia:turingplot
# hideall
using CategoricalArrays

chns_df = DataFrame(chns)
chns_df[!, :chain] = categorical(chns_df.chain)
sdf = DataFrames.stack(chns_df, names(chns), variable_name=:parameter)
sdf = filter(:parameter => p -> p == "βₐ" || p == "βᵣ", sdf)

layer = data(sdf) * mapping(:value; color=:chain, col=:parameter)
dens = layer * AlgebraOfGraphics.density()
axis = (ylabel="density",)

Blog.makie_svg(@OUTPUT, "turingplot", # hide
draw(dens; axis)
) # hide
```
\textoutput{turingplot}

```julia:turing-coef
# hideall
r_2(x) = round(x; digits=2)
r_3(x) = round(x; digits=3)
coef_a_turing = mean(chns_df.βₐ)
coef_r_turing = mean(chns_df.βᵣ)

function coef_error(true_value, estimate)
    err = abs(true_value - estimate)
    part = err / true_value
    percentage = part * 100
    percentage = round(percentage; digits=1)
    percentage = "$percentage %"
end

lin_err_a = coef_error(aₑ, coef_a)
lin_err_r = coef_error(rₑ, coef_r)
bay_err_a = coef_error(aₑ, coef_a_turing)
bay_err_r = coef_error(rₑ, coef_r_turing)

"""
coefficient | true value | linear estimate | linear error | bayesian estimate | bayesian error
--- | --- | --- | --- | --- | ---
aₑ | $aₑ | $(coef_a |> r_3) | $lin_err_a | $(coef_a_turing |> r_3) | $bay_err_a
rₑ | $rₑ | $(coef_r |> r_3) | $lin_err_r | $(coef_r_turing |> r_3) | $bay_err_r
""" |> print
```
\textoutput{turing-coef}

## Conclusion

After giving the true coefficients to the Bayesian model in the form of priors, it does score better than the linear model.
However, the differences aren't very big.
This could be due to the particular random noise in this sample `E` or due to the relatively big sample size.
The more samples, the more likely it is that the data will overrule the prior.
In any way, there are real-world situations where gathering extra data is more expensive than gathering priors via reading papers.
In those cases, the increased accuracy introduced by using priors could have serious benefits.
