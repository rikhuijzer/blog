+++
title = "A data-fusion example"
published = "1 November 2020"
tags = ["causality"]
description = "An example in causal data-fusion."
reeval = true
+++

```julia:preliminaries
# hideall
using Blog

out_path = @OUTPUT
graph_fn = Blog.print_graph_partial(out_path)
```
\output{preliminaries}

In the blog post on [correlations](/posts/correlations), I ended with the well-known mantra: "correlation does not imply causation".
Most of empirical science has been focussing on the correlations, because determining causation is hard.
However, \citet{pearl2018why} urges scientists to search for mechanisms, because it "is critical for science, as well as to everyday life, because different mechanisms call for different actions when circumstances change".
For example, we know that a lack of Vitamin C causes us to get scurvy, or not.
We can depict this as Vitamin C $\rightarrow$ scurvy.
Knowing this is very important, because without it we might think that bananas can cure scurvy \citep{pearl2018why} and send a trade ship on its way with bananas instead of oranges.
Alternatively, we could have found that ships with strawberries don't get scurvy (strawberries contain Vitamin C) and conclude that all red fruits can cure scurvy.

So, it is important to know the exact cause of things to make good decisions.
One of the easiest ways to determine cause and effect is via doing an intervention, denoted by the *do*-operator \citep{pearl2009}.
Looking back on the scurvy example, it can be rewritten as follows:
let Vitamin C be denoted by $X$ (the cause) and scurvy be denoted by $Y$ (the effect).
Then, we test whether scurvy is caused by a lack of Vitamin C by figuring out $P(Y | do(X))$.
This *do*-operator means that you would do an experiment where you change $X$ and only $X$ and then measure the effect on $Y$.
The "and only" part is important and can be obtained by doing a randomized controlled trial.
The idea of such a trial is to take two completely random subsets of your sample.
Then, for you subset you change $X$ and for the other subset you do not change $X$.
Apart from $X$, you don't try to change anything, so in medical settings the doctors are not even allowed who gets the medication since that could affect $Y$. 
(See the story of [Clever Hans](https://simple.wikipedia.org/wiki/Clever_Hans) for an example where observers affect the outcome by accident.)
If done correctly, a randomized trial removes the incoming causal arrows.
For example, without using randomization, it could be that the patients who get the medicin are actually cured by swimming in the sea $Z$.
We can depict this in a causal graph as

```julia:confounder
# hideall
graph_fn("confounder", "150px", raw"
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right = of X];
\node (Z) [label = above:Z, xshift=-1cm, point, above right = of X];

\path (X) edge (Y);
\path (Z) edge (X);
\path (Z) edge (Y);
")
```
\textoutput{confounder}

(Thanks to \citet{kumor2020} for code examples of these graphs.)
If the randomization is representative of the whole population and executed correctly, then we can say that the graph changed to

```julia:controlled
# hideall
graph_fn("controlled", "150px", raw"
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right = of X];

\path (X) edge (Y);
")
```
\textoutput{controlled}

which assumes that the two subsets are not fundamentally different.
Unfortunately, it is often not possible to apply a randomized trial since it could be too expensive, too time consuming or unethical.
For instance, it is a bad plan to to split a group in half and force one half of the group to smoke while tracking the group for 40 years to see whether smoking causes cancer.
Luckily, solutions exist to determine causation from observations alone \citep{bollen2013}.
Even better, \citet{bareinboim2016} summarizes how data from observational studies can be combined with randomized trials to find cause and effect; this can be useful to learn a causal effect about one population and apply it to another population.
This problem is similar to meta-analyses.
However, meta-analyses typically "'[average] out' differences (e.g., using inverse-variance weighting), which, in general, tends to blur, rather than exploit design distinctions among the available studies" \citep{bareinboim2016}.
For a longer discussion about the lack of effectiveness of meta-analyses, see \citet{vrieze2018}.

In this blog post, my aim is to look at some examples of combining observational and randomized controlled trail data in an attempt to figure out how and when it can be applied.

## Do-Calculus
Thanks to the *do*-calculus presented by \citep{pearl2009}, we can rewrite our graph without thinking. 
(By that, I mean that the calculus allows you to easily verify equivalences like $a + b = b + a$ for any $a$ and $b$.)
For arbitrary disjoint sets of nodes $X, Y, Z$ and $W$ in a causal DAG $G$, with $G_{\overline{X}}$  and $G_{\underline{X}}$ denoting the graph obtained by, respectively, deleting all arrows pointing to and emerging from nodes in $G$, we have \citep{bareinboim2016}

*Rule 1* (insertion/deletion of observations):
$$ P(y|do(x),z,w) = P(y|do(x),w) \: \text{if} \: (Y \perp Z|X, W)_{G_{\overline{X}}}. $$

*Rule 2* (action/observation exchange):
$$ P(y|do(x), do(z), w) = P(y|do(x), z, w) \: \text{if} \: (Y \perp Z|X, W)_{G_{\overline{X} \underline{Z}}}. $$

*Rule 3* (insertion/deletion of actions):
$$ P(y|do(x), do(z), w) = P(y|do(x), w) \: \text{if} \: (Y \perp Z|X, W)_{G_{\overline{X} \overline{Z^*}}}. $$

## Transportability
Scientific results are meant to be used across different populations.
This, according to \citet{pearl2014external}, is called *transportability*.
Specifically, it is about transfering causal effects from experimental studies to observational studies.
Here, I will mostly copy the example of \citep{bareinboim2016} and add some clarifications at the steps which I find unclear.
Consider an experimental source $\pi$ and an observational target $\pi^*$ population.
The variables are treatment $X$, outcome $Y$, age $Z$ and a set of unaccounted factors $S$.

```julia:first
# hideall
graph_fn("first", "150px", raw"
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right =of X];
\node (Z) [label = right:Z, xshift=-1cm, point, above right =of X];
\node (S) [label = above:S, yshift=-1.5cm, box, above =of Z];

\path (X) edge (Y);
\path (Z) edge (X);
\path (Z) edge (Y);
\path (S) edge (Z);

\path[bidirected] (X) edge[bend left=35] (Z);
\path[bidirected] (X) edge[bend left=35] (Y);

")
```
\textoutput{first}

The unaccounted factors create differences in age between $\pi$ and $\pi^*$.
These unaccounted factors are unknown, but it is known that they cause the differences in age between $\pi$ and $\pi^*$; that is why $S$ is denoted with a black box in the graph.
Note that this means that the graph is an overlapping of the graph of the source and target population.
Now, the query can be rewritten to \citep{bareinboim2016}

$$
\begin{aligned}
& Q \\
= \hspace{3mm} & \hspace{5mm} \{ \: \text{ By definition of $Q$. \: } \} \\
 & \sum_z P(y|do(x), S=s^*,z)P(z|S=s^*,do(x)) \\
= \hspace{3mm} & \hspace{5mm} \{ \: \text{By \textit{S}-admissibility. \: } \} \\
 & \sum_z P(y|do(x), z)P(z|S=s^*,do(x)) \\
= \hspace{3mm} & \hspace{5mm} \{ \: \text{By the 3rd rule of the \textit{do}-calculus.} \: \} \\
& \sum_z P(y|do(x), z) P(z|S = s^*) \\
= \hspace{3mm} & \hspace{5mm} \{ \: \text{By definition of the \textit{S}-node.} \: \} \\
& \sum_z P(y|do(x), z) P^*(z). 
\end{aligned}
$$

This is called a *transport formula*, because it explains "how experimental findings in $\pi$ are transported over to $\pi*$; the first factor is estimable from $\pi$ and the second one from $\pi^*$" \citep{bareinboim2016}.

## References

\biblabel{bareinboim2016}{Bareinboim & Pearl (2016)}
Bareinboim & Pearl. (2016).
Causal inference and the data-fusion problem.
<https://doi.org/10.1073/pnas.1510507113>.

\biblabel{bollen2013}{Bollen & Pearl (2013)}
Bollen & Pearl. (2013).
Eight Myths About Causality and Structural Equation Models.
<https://doi.org/10.1007/978-94-007-6094-3_15>.

\biblabel{kumor2020}{Kumor (2018)}
Kumor, D. (2018).
Causal Graphs in LaTeX.
<https://dkumor.com/posts/technical/2018/08/15/causal-tikz/>.

\biblabel{pearl2009}{Pearl (2009)} 
Pearl, J. (2009). Causality. Cambridge university press.
<https://doi.org/10.1017/CBO9780511803161>.

\biblabel{pearl2014external}{Pearl & Bareinboim (2014)}
Pearl & Bareinboim. (2014).
External Validity: From Do-Calculus to Transportability Across Populations.
Statistical Science.
<https://doi.org/10.1214/14-STS486>.
\biblabel{pearl2018why}{Pearl & Mackenzie (2006)} 
Pearl, J., & Mackenzie, D. (2018). 
The book of why: the new science of cause and effect. 
Basic Books.

\biblabel{vrieze2018}{de Vrieze (2018)}
de Vrieze, J. (2018, September 18).
Meta-analyses were supposed to end scientific debates. Often, they only cause more controversy.
Science Magazine.
<https://www.sciencemag.org/news/2018/09/meta-analyses-were-supposed-end-scientific-debates-often-they-only-cause-more>.
Accessed on 2020-11-01.
