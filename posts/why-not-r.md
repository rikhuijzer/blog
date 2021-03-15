+++
title = "Why programming in Julia is more productive than in R"
published = "2021-03-15"
tags = ["statistics", "julia", "R", "comparison"]
rss = "And why it is also more fun, that is, less frustrating"
+++

In this post, I will try to convince you that you can be more productive in one programming language than another.
Therefore, it will only partly be a technical posts.
Mostly, it will be about humans and how humans interact programming languages.
As a brief summary, [Julia](https://julialang.org/) is a language created in 2012 by a team at the Massachusetts Institute of Technology (MIT).
It aims to be as quick as low-level languages like C and C++, but be as easy to write as MATLAB or Python.
[R](https://www.r-project.org/), on the other hand, was created in 1993 by a team of statisticians and is now maintained by the R Core Team.
To give you an idea of the popularity of languages, according to [PYPL PopularitY of Programming Language](https://pypl.github.io/PYPL.html) the shares for some common languages and Julia at the time of writing are

Language | Share | First appearance
--- | --- | ---
Python | 30.17% | 1991
C/C++ | 6.71% | 1972
R | 3.81% | 1993
Julia | 0.35% | 2012

If you think that Julia is a bad language because no one is using it, then consider that languages are "not merely technolies, but habits of mind as well, and nothing changes slower" \citep{pGraham2003}.
Also, the growth for Julia even appears to be exponential based on statistics from the
[Julia forum](https://discourse.julialang.org/t/tiobe-index-rank-23-as-of-jan-2021/42730/15):

![Julia growth](/assets/discourse-growth.png)

So, why does this enormeous growth occur?
I think it is simply because Julia allows you to get things done.

\toc

## Consistency

Over time, languages add more and more capabilities or _features_ into a language.
For example, a basic language containing only functions will contain

```!
+(1, 1)
```

Then, language developers add infix operators:

```!
1 + 1
```

and lists/arrays with functions on them

```!
sum([1, 1, 1])
```

The longer a language exists, the more of these features will be built in.
However, the problem with languages is that **features cannot easily be removed**.
So, once you've added something, it will remain there forever unless you invest considerable effort into removing it.
With considerable effort, I mean that you need to convince the community of language users of not using a certain feature anymore which can be very laborious for the community.
For example, imagine that you manage a project of 1 million lines of code and you have to rewrite all occurrences of a certain pattern.
This is why it took many companies years to transition from Python 2 to Python 3.
Time in which the core Python language was introducing many language improvements while many companies remained stuck on the _old_ version.

This is a simple but effective reason why Julia is better than R.
Julia has been built from the ground up based on knowledge from R, Python, MATLAB on what **not** to do.
Although, this also means that Julia will be superceeded by an even better language.
At the time of writing, this better language doens't exist yet.
Compared to R, Julia is a much more consistent language, that is, it contains fewer cases where one function works in one way, while another works in a completely different way.
For example, a common thing in R is to load the `dplyr` package.
This package overwrites many functions from base R, including `filter`, `intersect` and `union`.
So, depending on whether you have loaded `dplyr`, `filter` is for filtering a `dataset` with

```
filter(dataset, group == "graduates")
```
or to filter a univariate or multivariate `timeseries` ([docs](https://rdrr.io/r/stats/filter.html))
```
filter(timeseries, rep(1, 3))
```

These kinds of inconsistencies make the language hard to use, because you have to remember lots of minute details about what to use when and how.
In this case, you have to remember to import `dplyr` or `tidyverse` or `filter` will give you a weird error.
In Julia, these problems are solved by using `types`.

## Types

To a computer scientist, it is hardly newsworthy that a good language needs types.
Coming back to the Python 2 to 3 transition mentioned above, adding type hints was also one of the main reasons for the painful transition.
Types allow the computer to verify your code.
For example, in Julia, we can make a function to double our input

```
double(x) = 2x
```

and use it

```
double(3)
```
```
6
```

Now, what if we pass some text instead of a number?

```
double("some text")
```
```
ERROR: MethodError: no method matching *(::Int64, ::String)
[...]
```

When your writing large programs, this isn't very clear.
We could have warned the user (or ourselve) much earlier by specifying that the input **should be a number**:

```
double(x::Number) = 2x
```
This makes the error much clearer
```
double("some text")
```
```
ERROR: MethodError: no method matching double(::String)
[...]
```

If we want, we can be even more clear by catching users who try to pass a `String`:

```
double(x::String) = error("This function only works for numbers")
```
```
ERROR: This function only works for numbers
```

(It don't advise to do this in practise, the point is that you could.)
This was a basic example, but types can go much further.
As an extreme example, you could define a type `OrderedArray` containing a list of numbers guaranteerd to be ordered.
Then, you can do all kinds of things on objects of this type without having to verify that the list is ordered.

This support for types **solves** the weirdness introduced in R by overriding `filter`.
In Julia, `filter` is extended for DataFrames, that is, when you load [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl), it will allow you to pass objects of the type `DataFrame` to `filter` while you can still use `filter` from Julia base on any type that is not a `DataFrame`:

**Base.filter:**

```!
filter(x -> 1 < x, [1, 2, 3])
```

**DataFrames.filter:**

```!
using DataFrames

df = DataFrame(A = [4, 5, 6])
filter([:A] => x -> 4 < x, df)
```

**Base.filter again:**

```!
using DataFrames

filter(x -> 1 < x, [1, 2, 3])
```

## In science

Julia is also much easier than R in scientific contexts.
Take the definition of functions.
In mathematical notation, we could define a function `y` as follows

$$ f(x) = 3x $$

In Julia, this would be

```
f(x) = 3x
```

whereas, in R, we have to write

```
f <- function(x) 3*x
```

It gets even worse when the equation involves non-UTF-8 symbols, such as greek symbols and sub- and superscripts.
For example,

$$ y_i(x, \beta_1, \epsilon) = \beta_1 x + \epsilon. $$

In Julia, the following is valid code[^1]

```!
yᵢ(x, β₁, ϵ) = β₁*x + ϵ
yᵢ(1, 2, 3)
```


Whereas, in R, you have to resort to something like

```
y_i <- function(x, beta_1, epsilon) { beta_1 * x + epsilon }
```

The effect of this becomes clear when looking at a real-world example:
\citet{tMcElreath2020} defines a multilevel model in mathematical form on page 402 as

$$
\begin{aligned}
  S_i &\sim \text{Binomial}(N_i, p_i) \\
  \text{logit}(p_i) &= \alpha_\text{TANK[i]} \\
  \alpha_\text{TANK[i]} &\sim \text{Normal}(1, 1.5) \text{ for } j = 1..48.
\end{aligned}
$$

and continues by defining it in R as

```
m13.1 <- ulam(
  alist(
    S ~ dbinom( N, p ) ,
    logit(p) <- a[tank] ,
    a[tank] ~ dnorm( 0, 1.5 )
  ), ... )
```

In Julia, we can stay much closer to the mathematical definition by writing

```
@model function reedfrogs(Nᵢ, i, Sᵢ)
    αₜₐₙₖ ~ filldist(Normal(0, 1.5), length(i))
    logit_pᵢ = αₜₐₙₖ[i]
    Sᵢ .~ BinomialLogit.(Nᵢ, logit_pᵢ)
end;
```

which is a [valid model](https://statisticalrethinkingjulia.github.io/TuringModels.jl/models/varying-intercepts-reedfrogs/) for [Turing.jl](https://github.com/TuringLang/Turing.jl/).
Here, the ordering of the lines is reversed for Julia which is arguably as good.
In the Julia model, variables are defined before they are used.

## Speed

As stated in the introduction, Julia aims to be fast.
This is true and false.
Actually, Julia is terrible at starting quickly; also known as the time to first plot issue.
Where R will spend a lot of time on compilation when installing packages, it will be quick to start after that.
In Julia, this is not the case.
You can quickly install packages, but they will take some time to (pre-)compile.
Luckily, Julia has [Revise.jl](https://github.com/timholy/Revise.jl).
With Revise, Julia will automatically update function definitions **while Julia is running**.
So, instead of making a change and restarting the program, you can keep everything running.
This makes the updating code - inspecting output cycle **ridicuolously fast**.
Also, you don't have to manually manage state as you have to do in R, that is, if you update code block 3, you don't have to ensure that you have ran code block 3 before running code block 5.
Revise will automatically track these changes for you.
Also, for long-running computations, you can be sure that Julia will outperform R in most cases, but this is not something I worry about daily, so I cannot go into details about this.

## Package management

Compare rikhuijzer/codex to rikhuijzer/Codex.jl.

## Conclusion

I don't think that R is bad language per se.
If Julia didn't exist, then I would, probably, be using R with great pleasure.
However, Julia does exists and solves many of the problems which R has.

## References

\biblabel{pGraham2003}{Graham, 2003}
Graham, P. (2003). Beating the averages.
<http://paulgraham.com/avg.html>.

\biblabel{tMcElreath2020}{McElreath (2020)}
McElreath, R. (2020). Statistical Rethinking: A Bayesian course with examples in R and Stan. CRC press.

\
\
[^1]: To get the unicode symbols, use the Julia REPL. For example, type `\beta<TAB>\_i<TAB>` to get βᵢ.
