# This file was generated, do not modify it. # hide
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