# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/collinear-bayes.html"
html = read(path, String)
println("~~~
$html
~~~
")
println("_This blog post was built via a Pluto.jl [notebook](posts/notebooks/collinear-bayes.html)_.")