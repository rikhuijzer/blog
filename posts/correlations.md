+++
title = "Correlations"
published = "2020-01-24"
tags = ["statistics", "independence", "covariance"]
rss = "The equations and some examples for the Pearson correlation coefficient."
+++

Correlations are ubiquitous.
For example, news articles reporting that a research paper found no correlation between X and Y.
Also, it is related to (in)dependence, which plays an important role in linear regression.
This post will explain the Pearson correlation coefficient.
The explanation is mainly based on the book by \citet{hogg2018}.

In the context of a book on mathematical statistics certain variable names make sense.
However, in this post some names are changed to make the information more coherent.
One convention which is adhered to is that single values are lowercase, and multiple values are capitalized.
Furthermore, since in most empirical research we only need discrete statistics the continuous versions of formulas are omitted.

We start by defining some general notions.
Let $(X, Y)$ be a pair of random variables where each sample is added exactly once, and the variables have a bivariate distribution.
(A bivariate distribution is simply the combination of two distributions.
For two normal distributions the three dimensional frequency plot would look like a mountain.)
Denote the means of $X$ and $Y$ respectively by $\mu_X$ and $\mu_Y$.
In the situations below the expectation for some random variable $X$ equals the mean, that is, $E(X) = \mu_X$.
(The expectation equals the mean when the probabilities for all values in a random variable are the same.)

\toc

## Covariance
To understand the correlation coefficient we must first understand *covariance*.
Covariance is defined as

$$ cov(X,Y) = E[(X - \mu_X)(Y - \mu_Y)]. $$

Over two variables the covariance is a "measure of their joint variability, or their degree of association" \citep{rice2006}.
An example of this joint variability is shown in Example [1](#example1).

### Example 1

Let $A, B$ and $C$ be discrete random variables defined by respectively $f_A(x) = x + 1$, $f_B(x) = 0.5x + 3$, and $f_C(x) = 5$ for the range 1 to 7.
Let $D$ be the reverse of $A$.
The probabilities are chosen such that they are the same for all the values in these random variables.

```julia:./data-generation.jl
using DataFrames

range = 1:7
A = [x + 1 for x in range]
B = [0.5x + 3 for x in range]
C = [5 for x in range]
D = reverse(A)

df = DataFrame(x = range, A = A, B = B, C = C, D = D)
```
\output{./data-generation}

We can plot the variables to obtain the following figure.
Note that stack is needed to prepare the data for Gadfly, see Appendix [1](#appendix_1) for the effect of the `stack` function.

```julia:./generate-plot.jl
using Gadfly

sdf = stack(df, [:A, :B, :C, :D])
p = plot(sdf, x = :x, y = :value, 
  Guide.yticks(ticks = collect(2:8)), # hide
  color = :variable
)
store_svg(name::String) = SVG(joinpath(@OUTPUT, "$name.svg")) # hide
p |> store_svg("plot") # hide
```

\output{./generate-plot}
\fig{./plot.svg}

To get an intuition for the covariance, consider a negative covariance.
\citet{rice2006} states that the covariance will be negative if when $X$ is larger than its mean, $Y$ tends to be smaller than its mean.
To get a example of a perfect negative linear relationship look at $A$ and $D$.
When $A$ is larger than its mean, $D$ is smaller than its mean and vice versa.
Therefore $cov(A, D)$ should be negative.
We can manually check this:

$$ \mu_A = \mu_B = \mu_C = \mu_D = 5, $$

$$ (A - \mu_A) = [-3, -2, -1, 0, 1, 2, 3], \: \text{and} $$

$$ (D - \mu_D) = [3, 2, 1, 0, -1, -2, -3]. $$

So,

$$ (A - \mu_A)(D - \mu_D) = [-9, -4, -1, 0, -1, -4, -9], \: \text{and} $$

$$ \Sigma [(A - \mu_A)(D - \mu_D)] = -28. $$

Finally,

$$ cov(A, D) = \frac{-28}{7} = -4. $$

In this calculation we have ignored Bessel's correction.
With Bessel's correction the result would have been $cov(A, D) = \tfrac{-28}{n - 1} = \tfrac{-28}{6} \approx - 4.6$.
It can be observed that the negative result is caused by the fact that for each multiplication in $(A - \mu_A)(D - \mu_D)$ either $(A - \mu_A)$ is negative or $(D - \mu_D)$ is negative, hence $(A - \mu_A)(D - \mu_D)$ is negative.
The results for the other covariances when comparing with $A$ are

$$ cov(A, A) = 4, $$

$$ cov(A, B) = 2, \: \text{and} $$

$$ cov(A, C) = 0, $$

as calculated in Appendix [2](#appendix_2).
The numbers in Example [1](#example_1) are all integers.
In real world situations that is often not the case.
This will lead to rounding errors.
To minimise the rounding errors the covariance can be rewritten.
The rewrite uses the [linearity of expectation](https://brilliant.org/wiki/linearity-of-expectation/), that is, $E[X + Y] = E[X] + E[Y]$:

$$
\begin{aligned}
cov(X, Y) & = E((X - \mu_X)(Y - \mu_Y)) \\
& = E(XY - \mu_Y X - \mu_X Y + \mu_X \mu_Y) \\
& = E(XY) - \mu_Y E(X) - \mu_X E(Y) + \mu_X \mu_Y \\
& = E(XY) - \mu_X \mu_Y.
\end{aligned}
$$

To appreciate the efficacy of this rewrite we redo the calculation for $cov(A, D)$, see Example [2](#example_2).

### Example 2

$$ AD = [16, 21, 24, 25, 24, 21, 16], $$

$$ E(AD) = \text{mean}(AD) = \frac{\Sigma[AD]}{7} = 21, \: \text{and} $$

$$ \mu_A \mu_D = 5 \cdot 5 = 25. $$

So,

$$ cov(A, D) = 21 - 25 = -4, $$

as was also obtained from the earlier calculation.

## Variance and standard deviation
The next step in being able to explain the correlation coefficient is defining the *standard deviation*, which is defined in terms of the *variance*.
The variance is a "measure of the spread around a center" \citep{rice2006}.
The standard deviation is about how spread out the values of the random variable are, on average, about its expectation.

Formally, the variance of $X$ is

$$ \sigma_X^2 = E \{ [ X - E(X) ]^2 \}, $$

and the standard deviation of $X$ is

$$ \sigma_X = \sqrt{\sigma_X^2} = \sqrt{E \{ [ X - E(X) ]^2 \} }. $$

where $\sigma^2$ and $\sigma$ are the common denotations for these concepts.

## The correlation coefficient
The covariance can be used to get a sense of how much two variables are associated.
However, the size of the result depends not only on the strength of the association, but also on the data.
For example, if there is a huge size difference in the numbers in a variable, then the covariance could appear large while in fact the correlation is negligible.
The covariance is based on the dispersion of the values for two variables around their expectation.
So, to normalize the covariance we can divide it by the standard deviation.

The Pearson *correlation coefficient* between $X$ and $Y$ is defined as

$$ r = \frac{cov(X, Y)}{\sigma_X \sigma_Y}. $$

Note that the units cancel out, hence the correlation is dimensionless.
For the correlation coefficient it holds that $-1 \le r \le 1$, as can be shown by using the [Cauchy-Schwarz inequality](https://math.stackexchange.com/questions/564751).

To show that when $X$ and $Y$ are independent, then $r = 0$ reason as follows.
When $X$ and $Y$ are independent, then $E(XY) = E(X)E(Y)$.
We know that $cov(X, Y) = E(XY) - \mu_x \mu_Y$.
Since $\mu_x = E(X)$ and $\mu_y = E(Y)$, $cov(X, Y) = 0$, and by that $r = 0$.

For a set of sample data the correlation coefficient is usually denoted by $r$ \citep{gupta2014}.
The association is considered weak, moderate or strong when respectively $|r|$ is lower than 0.3, $|r|$ is in between 0.3 and 0.7, or $|r|$ is higher than 0.7.

## Conclusion
The coefficient reduces two sets of values to a number representing their relatedness.
As with any reduction you will lose information.
In this case the number does not say anything about how linear the relationship is.
Instead the correlation coefficient **assumes linearity**.
It can be observed from the calculation in Example [1](#example_1) that the reported number is meaningless if the variables are not reasonably linear.

If the correlation coefficient is -1 or 1 we know that the relationship is perfectly linear.
In that case values from $X$ can be used to determine values in $Y$ and vice versa.

Finally, it should be noted that correlation does not imply causation, or more clearly: "Causation causes correlation, but not necessarily the converse" \citep{gupta2014}

## References
\biblabel{hogg2018}{Hogg et al. (2018)} 
Hogg, R. V., McKean, J., & Craig, A. T. (2018).
Introduction to mathematical statistics.
Pearson Education.

\biblabel{gupta2014}{Gupta & Guttman (2014)}
Gupta, B. C., & Guttman, I. (2014).
Statistics and probability with applications for engineers and scientists.
John Wiley & Sons.

\biblabel{rice2006}{Rice (2006)}
Rice, J. A. (2006).
Mathematical statistics and data analysis.
Cengage Learning.

## Appendix 1

Before stacking, the DataFrame looks like
```julia:./before.jl
@show df # hide
```
\output{./before}

and after stacking, it has changed to
```julia:./after.jl
@show sdf # hide
```
\output{./after}

## Appendix 2

```julia:./mycov.jl
using Statistics

# Note that this function does not apply Bessel's correction.
function mycov(X, Y)
    min_mean_x(x)::Float64 = x - mean(X)
    min_mean_y(y)::Float64 = y - mean(Y)
    
    mean(min_mean_x.(X) .* min_mean_y.(Y))
end

@show mycov(A, A)
@show mycov(A, B)
@show mycov(A, C)
@show mycov(A, D)
```
\output{./mycov}
