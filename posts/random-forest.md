+++
title = "Random forest classification in Julia"
published = "2021-01-21"
tags = ["simulating data", "machine learning"]
rss = "Fitting a random forest classifier and reporting accuracy metrics."
showall = true
reeval = true
+++

Below is example code for fitting and evaluating a linear regression and random forest classifier in Julia.
If code in this post doesn't work for you, then check that you're using the right [versions](/#versions).
I've used both models to have a baseline for the random forest.
The model is evaluated on a mock variable $U$ generated from two distributions, namely

$$
\begin{aligned}
d_1 &= \text{Normal}(\mu_1, \sigma) \: \: \text{and} \\
d_2 &= \text{Normal}(\mu_2, \sigma),
\end{aligned}
$$

where $\mu_1 = 10$, $\mu_2 = 12$ and $\sigma = 2$.
The random variable $V$ is just noise meant to fool the classifier.

This data isn't meant to show that random forests are good classifiers.
One way to do that would be to have more variables than observations \citep{pBiau2016}.

\toc

\literate{random-forest.jl}

## References

\biblabel{pBiau2016}{Biau & Scornet, 2016}
Biau, G., Scornet, E. (2016).
A Random Forest Guided Tour. 
TEST 25, 197–227 (2016). 
<https://doi.org/10.1007/s11749-016-0481-7>
