+++
title = "Combinations and permutations"
published = "2020-06-28"
tags = ["order", "statistics"]
rss = "Deriving the equations for combinations and permutations."
image = "/assets/self.jpg"
+++

Counting is simple except when there is a lot to be counted.
Combinations and permutations are such a case; they are about counting without replacement.
Suppose we want to count the number of possible results we can obtain from picking $k$ numbers, without replacement, from an equal or larger set of numbers, that is, from $n$ where $k \leq n$.
When the same set of numbers in different orders should be counted separately, then the count is called the number of *permutations*.
So, if we have some set of numbers and shuffle some numbers around, then we say that the numbers are **permuted**.
When the same set of numbers in different orders should be counted only once, then the count is called the number of *combinations*.
Which makes sense since it is only about the **combination** of numbers and not the order.

The equations for permutations and combinations can be derived as follows:
We can depict this little universe $U$ containing $n$ numbers as

$$ U = \{ 1, ..., n \} $$

and the set of $k$ drawn numbers as

$$ S_a = \{ s_1, ..., s_{k} \}. $$

We could split $U$ up into $U_a$ and $U_b$ since we know that $k \leq n$, 

$$ U_a = \{ 1, ..., k \}, U_b = \{ k+1, ..., n \} $$

and define $S$ to be the union of $S_a$ and $S_b$ such that $|S| = |U| = n$,

$$ S_a = \{ s_1, ..., s_k \}, S_b = \{ s_{k+1}, ..., s_n \}. $$

For the number of permutations, denoted by $P^n_k$, let us fill $S$ by drawing numbers from $U$.
Then, observe that to fill $s_1$ we can pick from $n$ numbers.
To fill $s_2$ we can pick from $n - 1$ numbers.
Continuing this, we can fill $S$ in $n \cdot (n - 1) \cdot \cdot \cdot 0 = n!$ different ways (where the order is important).
However, this was not the original goal.
Instead, we want to fill only $S_a$.
To this end, remove all the possibilities from $S_b$.
Note that $|S_a| = k$ and $|S_b| = n - k$.
So, the number of permutations is given by,

$$ P^n_k = \frac{n!}{(n-k)!}. $$

For the number of combinations, denoted by $C^n_k$ or ${n\choose k}$, we expect a smaller number of total possibilities since we ignore different orderings.
This smaller number is simply all the possible orderings for $S_a$, that is, $k!$.
So, the number of combinations is given by

$$ C^n_k = {n\choose k} = \frac{n!}{k!(n-k)!}. $$
