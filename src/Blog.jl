# This file is required for Julia packages.
module Blog

# Don't export methods to avoid confusing readers of the code.
# export

"""
    blue

Blue from ColorBrewer's "Blues".
"""
blue = "#3182bd"

function foo()
    println("this is foo")
end

"""
    causal_preamble

Preamble to be used for causal graphs.
Source: https://dkumor.com/posts/technical/2018/08/15/causal-tikz/.
"""
causal_preamble = raw"""
\usepackage{tikz}
\usetikzlibrary{shapes,decorations,arrows,calc,arrows.meta,fit,positioning}
\tikzset{
    -Latex,auto,node distance =1 cm and 1 cm,semithick,
    state/.style ={ellipse, draw, minimum width = 0.7 cm},
    point/.style = {circle, draw, inner sep=0.04cm,fill,node contents={}},
    bidirected/.style={Latex-Latex,dashed},
    el/.style = {inner sep=2pt, align=left, sloped}
}
"""

end # module
