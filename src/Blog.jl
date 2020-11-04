# This file is required for Julia packages.
module Blog

using TikzPictures

# Don't export methods to avoid confusing readers of the code.
# export

"""
    blue

Blue from ColorBrewer's "Blues".
"""
blue = "#3182bd"

"""
    causal_preamble

Preamble to be used for causal graphs.
Source: https://dkumor.com/posts/technical/2018/08/15/causal-tikz/.
"""
causal_preamble = raw"""
\usepackage{tikz}
\usetikzlibrary{shapes,decorations,arrows,calc,arrows.meta,fit,positioning}
\tikzset{
    -Latex,auto,node distance =2 cm and 2 cm,semithick,
    state/.style ={ellipse, draw, minimum width = 0.7 cm},
    point/.style = {circle, draw, fill, inner sep=0.04cm, node contents={}},
    box/.style ={rectangle, draw, fill, node contents={}},
    bidirected/.style={Latex-Latex,dashed},
    el/.style = {inner sep=2pt, align=left, sloped}
}
"""

"""
  print_graph(name::String, width::String, tex::String, out_path::String)

Print a causal graph with a name without extension `name`, width `width` (usually in `px`) and
the Tikz code `text`.
The `out_path` is expected to be the output of `@OUTPUT`; use `print_graph_partial` as a 
convinience helper.
"""
function print_graph(name::String, width::String, text::String, out_path::String)
  tp = TikzPicture(text, options="scale=1.0", preamble=causal_preamble)
  save(SVG(joinpath(out_path, "$name.svg")), tp)
  println("""
  ~~~
  </div> 
  <div class=\"tikz\">
    <img src=\"/assets/posts/data-fusion-examples/code/output/$name.svg\" style=\"width:$width\" />
  </div>
  <div class=\"franklin-content\">
  ~~~
  """)
end

"""
    print_graph_partial(out_path)

Partial function application on `print_graph` to fix `out_path`.
"""
function print_graph_partial(out_path) 
    return function(name::String, width::String, tex::String)
        print_graph(name, width, tex, out_path)
    end
end

end # module
