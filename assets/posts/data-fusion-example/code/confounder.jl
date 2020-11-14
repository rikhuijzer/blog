# This file was generated, do not modify it. # hide
# hideall
graph_fn("confounder", "150px", raw"
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right = of X];
\node (Z) [label = above:Z, xshift=-1cm, point, above right = of X];

\path (X) edge (Y);
\path (Z) edge (X);
\path (Z) edge (Y);
")