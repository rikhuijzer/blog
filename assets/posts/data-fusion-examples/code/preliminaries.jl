# This file was generated, do not modify it. # hide
# hideall
using Blog
using TikzPictures

"""
  print_graph(name::String, width::String, tex::String)

Print a causal graph with a name without extension `name`, width `width` (usually in `px`) and
the Tikz code `text`.
"""
function print_dag(name::String, width::String, text::String)
  tp = TikzPicture(text, options="scale=1.0", preamble=Blog.causal_preamble)
  out_path = @OUTPUT
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