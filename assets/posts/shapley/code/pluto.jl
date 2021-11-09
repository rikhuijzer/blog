# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/shapley.html"
html = read(path, String)
println("~~~
$html
~~~
")