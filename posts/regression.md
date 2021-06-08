+++
title = "Simple and binary regression"
published = "2020-03-05"
tags = ["simulating data", "statistics"]
rss = "Applying a simple and binary (logistic) regression to simulated data."
reeval = true
+++

```julia:./preliminaries.jl
# hideall
import CSV
output_dir = @OUTPUT
write_csv(name, data) = CSV.write(joinpath(output_dir, "$name.csv"), data)
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p)
```

One of the most famous scientific discoveries was Newton's laws of motion.
The laws allowed people to make predictions.
For example, the acceleration for an object can be predicted given the applied force and the mass of the object.
Making predictions remains a popular endeavour.
This post explains the simplest way to predict an outcome for a new value, given a set of points.

To explain the concepts, data on apples and pears is generated.
Underlying relations for the generated data are known.
The known relations can be compared to the results from the regression.

\toc

## Generating data
The goal is to predict whether a fruit is an apple or a pear.
Say we have a sample of size $n$.
Say the sample consist of two properties for each fruit, namely

- height, and
- width.

The properties for the fruit at index $i$ are respectively denoted by $h_i$ and $w_i$.
Prediction will be done for the fruit type, which is denoted by $y_i$.
The sample indices can be visualised as follows.

I | H | W | Y
--- | --- | --- | ---
1 | $h_1$ | $w_1$ | $y_1$
2 | $h_2$ | $w_2$ | $y_2$
... | ... | ... | ...
$n$ | $h_n$ | $w_n$ | $y_n$

Let half of the elements be apples and half of the elements be pears.
So, $n$ is even.
Let

$$
y_{i} =
\begin{cases}
\text{apple} & \text{if $i$ is odd}, \: \text{and} \\
\text{pear} & \text{if $i$ is even}.
\end{cases}
$$

Let the height and fruit type be correlated.
To this end define

$$
h_{i} =
\begin{cases}
\text{one sample of size 1 drawn from } N(10, 1) & \text{if $Y_i$ is apple}, \: \text{and} \\
\text{one sample of size 1 drawn from } N(12, 1) & \text{if $Y_i$ is pear}.
\end{cases}
$$

Let the height and width also be correlated.
Define the width to be 0.6 times the height.
Specifically,

$$ w_i = 0.6 H_i. $$

In Julia, this can be defined as

```julia:generating_functions
using DataFrames
using Distributions
using Random
using Statistics

r_2(x) = round(x; digits=2)
Random.seed!(18)
n = 12
I = 1:n
Y = [i % 2 != 0 for i in I]
H = r_2.([y == "apple" ? rand(Normal(10, 1)) : rand(Normal(12, 1)) for y in Y])
W = r_2.([0.6h for h in H])

df = DataFrame(; I, H, W, Y)
write_csv("df", df) # hide
```
\output{generating_functions}
\tableinput{}{./df.csv}

## Simple linear regression

A *simple linear regression* fits a line through points in two dimensions.
It should be able to infer the relation between $H$ and $W$.

```julia:w-h
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

# These two are useful for plotting.
wmin = minimum(W) - 0.2
wmax = maximum(W) + 0.2

fg = data(df) * mapping(:W, :H)
Blog.makie_svg(@OUTPUT, "w-h", # hide
draw(fg)
) # hide
```
\textoutput{w-h}

The algorithmic way to fit a line is via the *method of least squares*.
Any straight line can be described by a linear equation of the form $y = p_1 x + p_0$, where the first parameter $p_0$ is the intercept with $y$ and the second parameter $p_1$ is the slope.
Adding an error $e$, and rewriting gives

$$
\begin{aligned}
y_i & = p_0 + p_1 x_i + e_i \\
e_i & = y_i - p_0 - p_1 x_i. \\
\end{aligned}
$$

An algorithm could now be defined to naively minimize the sum of all the errors

$$ S'(p_0, p_1) = \sum_{i=1}^n e_i, $$

with respect to the choice of $p_0$ and $p_1$.
This would not always result in a well fitted line because errors might cancel each other out.
For example, when $e_1 = 10$ and $e_2 = -10$, then $e_1 + e_2 = 0$.
This is solved by squaring the errors.
The method of least squares minimizes

$$ S_l(p_0, p_1) = \sum_{i=1}^n e_i^2 = \sum_{i=1}^n (y_i - p_0 - p_1 x_i)^2 $$

with respect to the choice of $p_0$ and $p_1$ \citep{rice2006}.
The simplest estimator for the points is the mean.
We can plot this and show horizontal lines for the errors.

```julia:w-h-mean
using GeometryBasics
# Linear and generalized linear models (GLMs).
using GLM

m = mean(H)
df_mean = (W=df.W, H=fill(m, nrow(df)))
# df_diff = (W=df.W, H=df.H-m)
# l = Line(Point(6.5, 11), Point(11, 11))
# df_diff = (; x=[l])

layers = data(df) * visual(Scatter)
layers += data(df_mean) * linear()
for (w, h) in zip(df.W, df.H)
  df_diff = (W=[w, w], H=[m, h])
  global layers += data(df_diff) * visual(Lines)
end
# fg += data(df_diff) * mapping(:l)

# yintercept = data([m]) * mapping(:x)

Blog.makie_svg(@OUTPUT, "w-h-mean", # hide
draw(layers * mapping(:W, :H))
) # hide
```
\textoutput{w-h-mean}

```julia:w-h-mean2
# Linear and generalized linear models (GLMs).
using GLM

m = mean(H)
write_svg("w-h-mean", # hide
plot(df, x = :W, y = :H,
  Geom.point,
  yintercept = [m], Geom.hline(),
  layer(xend = :W, yend = [m], Geom.segment())
)
) # hide
```
\output{w-h-mean}
\fig{./w-h-mean.svg}

We can generalize the sum of squares error calculation to

$$ S(U, V) = \sum_{i=1}^n (u_i - v_i)^2, $$

for arrays $U$ and $V$.
```julia:define-s
S(U, V) = sum((U .- V).^2)
```
Then, the squared sum of the errors for this simplest estimator is
```julia:error-for-mean
println( # hide
r_2(S(H, repeat([mean(H)], length(H))))
) # hide
```
\output{error-for-mean}

This error cannot be compared to other errors, since it is not standardized.
A standardized metric would be the Pearson correlation coefficient $r$.
See the blog post on [correlations](/posts/correlations) for more information.

```julia:w-h-fit
m1 = lm(@formula(H ~ W), df)

# This is just a convenience function around `GLM.predict`.
predict_value(model, x) = 
  first(skipmissing(predict(model, DataFrame(W = [x]))))

write_svg("w-h-fit", # hide
plot(df, x = :W, y = :H, 
	# xviewmin = [wmin], xviewmax = [wmax], # hide
  Geom.point,
  layer(x -> predict_value(m1, x), wmin, wmax)
)
) # hide
```
\output{w-h-fit}
\fig{./w-h-fit.svg}

The intercept and slope for the fitted line are
```julia:slope-intercept
intercept(linear_model) = coef(linear_model)[1]
slope(linear_model) = coef(linear_model)[2]

@show r_2(intercept(m1)) # hide
@show r_2(slope(m1)) # hide 
```
\output{slope-intercept}

## Binary logistic regression
Next, lets try to estimate the relation between $Y$ and $W$.
The method of least squares is unable to calculate an error for "apple" and "pear".
A work-around is to encode "apple" as 0 and "pear" as 1.
A line can now be fitted.

```julia:m2
digits = [i % 2 != 0 ? 0 : 1 for i in I]
df[:, :Y_digit] = digits
m2 = lm(@formula(Y_digit ~ W), df)

write_svg("m2", # hide
plot(df, x = :W, y = :Y_digit,
  xmin = [wmin], xmax = [wmax],
  Geom.point,
  layer(x -> predict_value(m2, x), wmin, wmax),
  layer(y = predict(m2), Geom.point)
)
) # hide
```
\output{m2}
\fig{./m2.svg}

As can be observed, the model does not take into account that $Y$ is a binary variable.
The model even predicts values outside the expected range, that is, values outside the range 0 to 1.
A better fit is the logistic function.

```julia:m3
m3 = glm(@formula(Y_digit ~ W), df, Binomial(), LogitLink())

write_svg("m3", # hide
plot(df, x = :W, y = :Y_digit, 
  Geom.point,
  layer(x -> predict_value(m3, x), wmin, wmax),
  layer(y = predict(m3), Geom.point)
)
) # hide
```
\fig{./m3.svg}

The correlation coefficient $r$ should not be used to compare the models, since the logistic model only predicts the class. 
In other words, the logistic model is a classificatier.
Classification *accuracy* is a better metric:

$$ \text{accuracy} = \frac{\text{number of correct predictions}}{\text{total number of predictions}} . $$

```julia:accuracy
accuracy(trues, pred) = count(trues .== pred) / length(pred)
```

The threshold is set to 0.5 to get a binary prediction from both models.
More precisely: let $\text{pred}(x_i)$ denote the prediction for $y_i$, and $y_i'$ denote the binary prediction for $y_i$.
For each prediction

$$
y_i' =
\begin{cases}
1 & \text{if $0.5 < \text{pred}(x_i)$}, \: \text{and} \\
0 & \text{if $\text{pred}(x_i) \leq 0.5$}. \\
\end{cases}
$$

```julia:binary_values
binary_values(model) = [0.5 < x ? 1 : 0 for x in predict(model)]
```
The least squares error and accuracy for both models are as follows.

```julia:comparison
write_csv("comparison", # hide
DataFrame(
	model = ["Linear regression", "Logistic regression"],
	S = r_2.([S(digits, predict(m2)), S(digits, predict(m3))]),
	accuracy = r_2.([accuracy(digits, binary_values(m2)), accuracy(digits, binary_values(m3))])
)
) # hide
```
\output{comparison}
\tableinput{}{./comparison.csv}

As can be seen, the error is lower for the logistic regression.
However, for the accuracy both models score the same in this case.
This is due to the fact that there is only a very small area where the linear and logistic model make different predictions.
When this area becomes bigger (for example, when doing regression in multiple dimensions) or when more points lie in this area, then the accuracy for the logistic regression will be better compared to the linear regression.

## References
\biblabel{rice2006}{Rice (2006)} 
Rice, J. A. (2006).
Mathematical statistics and data analysis.
Cengage Learning.
