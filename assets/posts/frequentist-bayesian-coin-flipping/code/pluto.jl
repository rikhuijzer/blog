# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/frequentist-bayesian-coin-flipping.html"
html = read(path, String)
println("~~~
$html
~~~
")
println("_This blog post was built via a Pluto.jl [notebook](posts/notebooks/frequentist-bayesian-coin-flipping.html)_.")