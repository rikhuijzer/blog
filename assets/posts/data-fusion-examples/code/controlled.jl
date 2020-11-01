# This file was generated, do not modify it. # hide
# hideall
print_dag("controlle", "150px", raw"""
\node (X) [label = left:X, point];
\node (Y) [label = right:Y, point, right = of X];

\path (X) edge (Y);
""")