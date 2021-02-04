+++
title = "Predicates and reproducibility"
published = "11 May 2020"
tags = ["reproducibility", "statistics"]
rss = "Thinking about the layers above statistics."
+++

While reading texts on statistics and meta-science I kept noticing vagueness.
For example, there seems to be half a dozen definitions of replicability in papers since 2016.
In this text, I try to formalize the underlying structure.

*Edit 2020-11-01: The model below is basically the same, but poorer, than the causal models as presented by, for example, \citet{pearl2009}.*

Assume determinism.
Assume that for any function $f$ there is a set of predicates, or *context*, $C$ which need to hold for the function to hold, that is, return the correct answer.
Let this be denoted by $C \xRightarrow{a} f$.
For example, Bernoulli's equation solved for $\rho$ only holds for a context $C_b$ containing isentropic flows, that is, $C_b \Rightarrow \text{Bernoulli's equation}$, where $C_b$ contains isentropic flows.
There have been arguments that such contexts need to contain an (open-ended) list of negative conditions \citep{hoefer2003}.
Let these contexts and the contexts below also contain this list.

The goal of science is to come up with models which allow for making accurate predictions.
The scientific process consists of various steps to derive these models.
Let $\mathbb{C}$ be the context space, that is, all the possible contexts a scientist can choose to experiment in.
For some study $u$ let

- $C_u$ be the **context** (a set of predicates) which holds for study $u$,
- $s_u$ be the **sample** used by study $u$,
- $r_u$ be the **raw** data obtained from the sample,
-	$w_u$ be the **wrangled** data, that is, the cleaned data
- $m_u$ be statistics on $w_u$, such as the **mean**, and
- $(C_u' \Rightarrow f_u)$ be the reported model.

Note that $C_u \neq C_u'$; this usually is a generalization based on intuition of the researcher.
For example, a researcher omits the fact that a study on 20 patients only included patients with blue eyes, since that is not expected to affect the results.
The steps are chosen such that each step can be a potential source of error.

We can depict study $u$, with steps $1, 2, ..., 6$ as

$$ \mathbb{C} \xRightarrow{1} C_u \xRightarrow{2} s_u \xRightarrow{3} r_u \xRightarrow{4} w_u \xRightarrow{5} m_u \xRightarrow{6} (C_u' \Rightarrow f_u). $$

Most steps have well-known names.
Step 2 is called sampling, step 3 measuring, step 4 data cleaning or wrangling, step 5 calculating statistics, and step 6 inference.

\citet{goodman2016} introduce the following definitions for reproducibility.

- methods reproducibility: "the ability to implement, as exactly as possible, the experimental and computational procedures, with the same data and tools, to obtain the same results",
- results reproducibility: "the production of corroborating results in a new study, having followed the same experimental methods", and
- inferential reproducibility: "the making of knowledge claims of similar strenght from a study replication or reanalysis".

These definitions can also be stated as

- methods reproducibility: Obtaining the same results from having identical steps 4 and 5,
- results reproducibility: Obtaining the same results from having identical steps 1, 2, 3, 4 and 5,
- inferential reproducibility: Obtaining the same results from having identical steps 1, 2, 3, 4, 5 and 6.

## References

\biblabel{goodman2016}{Goodman et al. (2016)}
Goodman, S. N., Fanelli, D., & Ioannidis, J. P. A. (2016). What does research reproducibility mean? Science Translational Medicine, 8(341), 341ps12-341ps12. https://doi.org/10.1126/scitranslmed.aaf5027

\biblabel{hoefer2003}{Hoefer (2003)}
Hoefer, C. (2003). Causal Determinism. https://plato.stanford.edu/archives/spr2016/entries/determinism-causal/

\biblabel{pearl2009}{Pearl (2009)} 
Pearl, J. (2009). Causality. Cambridge university press.
