+++
title = "Comparing means and SDs"
published = "27 June 2020"
tags = ["statistics", "rescaling", "variance", "transformation"]
rss = "Transforming means and SDs from different psychological scales to the same scale."
+++

Many different questionnaires exists measuring the same constructs.
For example, the NEO-PI and the BFI both measure the Big Five personality traits.
Say, we want to compare reported means and standard deviations (SDs) for these questionnaires, and both use a Likert scale.
This requires transforming the means and SDs to similar scales.
The formulas for these transformations are derived below.
We do this by first describing what numbers are reported by the studies.

In this post, I stick to the set theory convention of denoting sets by uppercase letters.
So, $|A|$ denotes the number of items in the set $A$ and $|a|$ denotes the absolute value of the number $a$.
For some study, let the set of participants and questions be denoted by $P$ and $Q$ respectively with $|P| = n$ and $|Q| = v$.
Let the set of responses be denoted by $R$ with $|R| = n \cdot v$ and let $T$ denote the set of the summed scores per participant.
We can depict the responses and sums as follows:

| $P$ | $q_1$ | $q_2$ | ... | $q_v$ | Total
--- | --- | --- | --- | --- | ---
$p_1$ | $r_{11}$ | $r_{12}$ | ... | $r_{1v}$ | $t_1 = \sum_{q \in Q} \: r_{1q}$
$p_2$ | $r_{21}$ | $r_{22}$ | ... | $r_{2v}$ | $t_2 = \sum_{q \in Q} \: r_{2q}$
... | ... | ... | ... | ... | ...
$p_n$ | $r_{n1}$ | $r_{n2}$ | ... | $r_{nv}$ | $t_n = \sum_{q \in Q} \: r_{nq}$

Let $m$ and $s$ denote respectively the reported mean and sample SD.
We assume that the papers calculated the mean and SD as follows:

$$ m = mean(T) = \frac{\sum T}{|P|} $$

and

$$ s = sd(T) = \sqrt{Var(T)} = \sqrt{\frac{1}{n - 1} \sum_{p \in P} (t_p - m)^2}. $$

Some studies report an averaged mean $\overline{m}$, that is,

$$ \overline{m} = \frac{m}{|Q|} = \frac{\sum T}{|P| \cdot |Q|}. $$

To scale the standard deviation, we can use the equation for a linear transformation of the variance.

Let $X$ be a random variable with finite mean $\mu$ and variance $\sigma^2$.
Then for all constants $a$ and $b$ \citep{hogg2018},

$$ Var(aX + b) = a^2 \cdot Var(X). $$

From which follows that, for a random variable $X$ and all constants $a$ and $b$,

$$ sd(aX + b) = \sqrt{Var(aX + b)} = \sqrt{a^2 \cdot Var(X)} = |a| \cdot sd(X). $$

So, for the averaged standard deviation $\overline{s}$,

$$ \overline{s} = \frac{sd(T)}{|Q|} $$

Next, we derive the equations for the transformations.
Let $l$ and $u$ be respectively the lower and upper bound for the Likert scale over all the answers, that is, $\forall_t [t \in T : l \leq t \leq u]$.
Let $k_l$ and $k_u$ be respectively the lower and upper bound for the Likert scale per answer, that is, $\forall_r [ r \in R : k_l \leq r \leq k_u]$.
We can transform the numbers by applying a transformation to each $t \in T$ to obtain the transformed total score $t_t$,

$$
t_t
  = \frac{t \cdot v - l}{u - l}
  = \frac{t \cdot v - (v \cdot k_l)}{(v \cdot k_u) - (v \cdot k_l)}
  = \frac{(t - k_l) \cdot v}{(k_u - k_l) \cdot v}
  = \frac{t - k_l}{k_u - k_l}.
$$

The transformed mean $m_t$ is now

$$
m_t
  = mean \left( \frac{T - k_l}{k_u - k_l} \right)
  = \frac{mean(T) - k_l}{k_u - k_l}
  = \frac{m - k_l}{k_u - k_l},
$$

which is known as [min-max normalisation](https://en.wikipedia.org/wiki/Feature_scaling).

The transformed SD $s_t$ is

$$
s_t
  = sd \left( \frac{T - k_l}{k_u - k_l} \right)
  = \frac{sd(T - k_l)}{|k_u - k_l|}
  = \frac{sd(T)}{k_u - k_l}.
$$

Note that I have not taken [Bessel's correction](https://en.wikipedia.org/wiki/Bessel%27s_correction) into account, which might be an issue for studies having small sample sizes.
I will add that as soon as I understand how to take that correction into account.

## References
\biblabel{hogg2018}{Hogg et al. (2018)} 
Hogg, R. V., McKean, J., & Craig, A. T. (2018). 
Introduction to mathematical statistics. 
Pearson Education.

