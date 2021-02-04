+++
title = "Comparing means and SDs"
published = "27 June 2020"
tags = ["statistics", "rescaling", "variance", "feature scaling"]
rss = "Transforming means and SDs from numbers in different ranges to the same range."
+++

When comparing different papers it might be that the papers have numbers about the same thing, but that the numbers are on different scales.
Forr example, many different questionnaires exists measuring the same constructs such as the NEO-PI and the BFI both measure the Big Five personality traits.
Say, we want to compare reported means and standard deviations (SDs) for these questionnaires, which both use a Likert scale.

In this post, the equations to rescale reported means and standard deviations (SDs) to another scale are derived.
Before that, an example is worked trough to get an intuition of the problem.

\toc

## Preliminaries

In this post, I stick to the set theory convention of denoting sets by uppercase letters.
So, $|A|$ denotes the number of items in the set $A$ and $|a|$ denotes the absolute value of the number $a$.
To say that predicate $P_x$ holds for all elements in $X$, I use the notation $\forall_t[t \in T : P_x]$, for example: if $X$ contains all integers above 3, then we can write $\forall_x[x \in X : 3 < x]$.

For some study, let the set of participants and questions be respectively denoted by $P$ and $Q$ with $|P| = n$ and $|Q| = v$.
Let the set of responses be denoted by $R$ with $|R| = n \cdot v$ and let $T$ denote the set of the summed scores per participant, that is, $T = \{ t_1, t_2, \ldots, t_n \}$, see the table below.

| $P$ | $q_1$ | $q_2$ | ... | $q_v$ | Total
--- | --- | --- | --- | --- | ---
$p_1$ | $r_{11}$ | $r_{12}$ | ... | $r_{1v}$ | $t_1 = \sum_{q \in Q} \: r_{1q}$
$p_2$ | $r_{21}$ | $r_{22}$ | ... | $r_{2v}$ | $t_2 = \sum_{q \in Q} \: r_{2q}$
... | ... | ... | ... | ... | ...
$p_n$ | $r_{n1}$ | $r_{n2}$ | ... | $r_{nv}$ | $t_n = \sum_{q \in Q} \: r_{nq}$

Let $m$ and $s$ denote respectively the reported mean and sample SD.
We assume that the papers calculated the mean and SD with

$$ m = mean(T) = \frac{\sum T}{|P|} $$

and

$$ s = sd(T) = \sqrt{Var(T)} = \sqrt{\frac{1}{n - 1} \sum_{p \in P} (t_p - m)^2}. $$

Note here that Bessel's correction is applied, because $\frac{1}{n - 1}$ instead of $\frac{1}{n}$.
This seems to be the default way to calculate the standard deviation.

## An example with numbers

Lets consider one study consisting of only one question and three participants.
Each response $u \in U$ is an integer ($\mathbb{Z}$) in the range [1, 3], that is, $\forall_u[u \in U : u \in \mathbb{Z} \land 1 \leq u \leq 3]$.
So, the lower and upper bound of $u$ are respectively $u_l = 1$ and $u_u = 3$.

| $P$ | $U$ | Total
--- | --- | ---
$p_1$ | 3 | 3
$p_2$ | 1 | 1
$p_3$ | 2 | 2

We can rescale these numbers to a normalized response $v \in V$ in the range [0, 1] by applying [min-max normalization](https://en.wikipedia.org/wiki/Feature_scaling),

$$ v = \frac{u - u_l}{u_u - u_l} = \frac{u - 1}{3 - 1} = \frac{u - 1}{2}. $$

The rescaled responses become

| $P$ | $V$ | Total
--- | --- | ---
$p_1$ | 1 | 1
$p_2$ | 0 | 0
$p_3$ | $\frac{1}{2}$ | $\frac{1}{2}$

Now, suppose that the study would have used a scale in the range [0, 5].
Let these responses be denoted by $w \in W$. 
We can rescale the normalized responses $v \in V$ in the range [0, 1] up to $w \in W$ in the range [0, 5] with

$$ w = v \cdot (w_u - w_l) + w_l = v \cdot (5 - 0) + 0 = 5v. $$ 

This results in

| $P$ | $W$ | Total
--- | --- | ---
$p_1$ | 5 | 5
$p_2$ | 0 | 0
$p_3$ | $2 \frac{1}{2}$ | $2 \frac{1}{2}$ 

Since we know all the responses, we can calculate the means and standard deviations:

responses | mean | sd
--- | --- | ---
$U$ | $2$ | $1$
$V$ | $\frac{1}{2}$ | $\frac{1}{2}$
$W$ | $2 \frac{1}{2}$ | $2 \frac{1}{2}$

Now, suppose that $U$ was part of a study reported in a paper and the scale of $V$ was the scale we have for our own study.
Of course, a typical study doesn't give us all responses $u \in U$.
Instead, we only have $mean(U)$ and $sd(U)$ and want to know $mean(W)$ and $sd(W)$.
This can be done by using the equations derived below.
We could first normalize the result, by Eq. \eqref{normalize mean},

$$ mean(V) = \frac{mean(U) - u_l}{u_u - u_l} = \frac{mean(U) - 1}{3 - 1} = \frac{2 - 1}{2} = \frac{1}{2} $$ 

and, by Eq. \eqref{normalize sd},

$$ sd(V) = \frac{sd(U)}{u_u - u_l} = \frac{sd(U)}{3 - 1} = \frac{1}{2}. $$

Next, we can rescale this to the range of $W$. 
By Eq. \eqref{denormalize mean},

$$ mean(W) = (w_u - w_l) \cdot mean(V) + w_l = (5 - 0) \cdot mean(V) + 0 = 5 \cdot \frac{1}{2} = 2 \frac{1}{2} $$

and, by Eq. \eqref{denormalize sd},

$$ sd(W) = (w_u - w_l) \cdot sd(V) = (5 - 0) \cdot \frac{1}{2} = 2 \frac{1}{2}. $$

We could also go from $U$ to $W$ in one step.
By Eq. \eqref{rescale mean},

$$ mean(W) = (w_u - w_l) \cdot \frac{mean(U) - u_l}{u_u - u_l} + g_l = (5 - 0) \cdot \frac{2 - 1}{3 - 1} + 0 = 2 \frac{1}{2}. $$

and, by Eq. \eqref{rescale sd},

$$ sd(W) = (w_u - w_l) \cdot \frac{sd(U)}{u_u - u_l} = (5 - 0) \cdot \frac{1}{3 - 1} = 2 \frac{1}{2}. $$

## Linear transformations

Consider a random variable $X$ with a finite mean and variance, and some constants $a$ and $b$.
Before we can derive the transformations, we need some equations to be able to move $a$ and $b$ out of $mean(aX + b)$ and $sd(aX + b)$.

For the mean, the transformation is quite straightforward,

$$ 
\begin{aligned}
mean(aX + b) &= \frac{\sum_{i=1}^{|X|} (ax_i + b)}{|X|} \\
  &= \frac{\sum_{i=1}^{|X|} (ax_i) + |X|b}{|X|} \\
  &= \frac{\sum_{i=1}^{|X|} (ax_i)}{|X|} + b \\
  &= \frac{a \sum_{i=1}^{|X|}(x_i)}{|X|} + b \\
  &= a \cdot \frac{\sum_{i=1}^{|X|}(x_i)}{|X|} + b \\
  &= a \cdot mean(x) + b. 
\end{aligned}
$$

Note that the position of constant $b$ makes intuitive sense: for example, if you add a constant $b$ to all the elements of a sample, then the mean will move by $b$.
To scale the standard deviation, we can use the equation for a linear transformation of the variance \citep{hogg2018},

$$ Var(aX + b) = a^2 \cdot Var(X). $$

We can use this to derive that

$$ sd(aX + b) = \sqrt{Var(aX + b)} = \sqrt{a^2 \cdot Var(X)} = |a| \cdot sd(X). $$

## Transformations

Next, we derive the equations for the transformations.
Let $l$ and $u$ be respectively the lower and upper bound for the Likert scale over all the answers; specifically, $\forall_t [t \in T : l \leq t \leq u]$.
Let $k_l$ and $k_u$ be respectively the lower and upper bound for the Likert scale per answer; specifically, $\forall_r [ r \in R : k_l \leq r \leq k_u]$.
Now, for the normalized mean $mean(T')$,

$$
mean(T')
  = mean \left( \frac{T - k_l}{k_u - k_l} \right)
  = \frac{mean(T - k_l)}{k_u - k_l}
  = \frac{mean(T) - k_l}{k_u - k_l}
  = \frac{mean(T) - k_l}{k_u - k_l}
  \label{normalize mean}
$$

and for the normalized SD $sd(T')$,

$$
sd(T')
  = sd \left( \frac{T - k_l}{k_u - k_l} \right)
  = \frac{sd(T - k_l)}{|k_u - k_l|}
  = \frac{sd(T)}{k_u - k_l}
  \label{normalize sd}
$$

where $|k_u - k_l| = k_u - k_l$ since we know that both are positive and $k_l < k_u$.

To change these normalized scores back to another scale in the range $[g_l, g_u]$, we can use

$$
mean(T'')
  = mean((g_u - g_l) \cdot T' + g_l) 
  = (g_u - g_l) \cdot mean(T') + g_l
  \label{denormalize mean}
$$

and

$$
sd(T'')
 = sd((g_u - g_l) \cdot T' + g_l)
 = (g_u - g_l) \cdot sd(T')
 \label{denormalize sd}
$$

We can also transform the mean and SD into one step from the range $[k_l, k_u]$ to $[g_l, g_u]$ with

$$ 
\begin{aligned}
mean(T'') &= (g_u - g_l) \cdot mean(T') + g_l \\
 &= (g_u - g_l) \cdot \frac{mean(T) - k_l}{k_u - k_l} + g_l
\end{aligned}
\label{rescale mean}
$$

and 
$$ 
\begin{aligned}
sd(T'') &= (g_u - g_l) \cdot sd(T') \\
 &= (g_u - g_l) \cdot \frac{sd(T')}{k_u - k_l}
\end{aligned}
\label{rescale sd}
$$

## References
\biblabel{hogg2018}{Hogg et al. (2018)} 
Hogg, R. V., McKean, J., & Craig, A. T. (2018). 
Introduction to mathematical statistics. 
Pearson Education.

