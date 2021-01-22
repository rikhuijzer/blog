+++
title = "Random forest classification in Julia"
published = "21 January 2021"
tags = ["simulating data", "machine learning"]
description = "Fitting a random forest classifier and reporting accuracy metrics"
showall = true
reeval = true
+++

Below is example code for fitting and evaluating a random forest classifier in Julia.
The model is evaluated on a mock variable $U$ generated from two distributions, namely

$$
\begin{aligned}
d_1 &= \text{Normal}(\mu_1, \sigma) \: \: \text{and} \\
d_2 &= \text{Normal}(\mu_2, \sigma),
\end{aligned}
$$

where $\mu_1 = 10$, $\mu_2 = 12$ and $\sigma = 2$.
The random variable $V$ is just noise meant to fool the classifier.

\toc 

\literate{random-forest.jl}

