# This file was generated, do not modify it. # hide
# hideall

tp = TikzPicture(raw"""
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right = of X];
\node (Z) [label = above:Z, xshift=-0.5cm, point, above right = of X];

\path (X) edge (Y);
\path (Z) edge (X);
\path (Z) edge (Y);
""", options="scale=1.0", preamble=Blog.causal_preamble)
save(SVG(joinpath(@OUTPUT, "confounder")), tp)