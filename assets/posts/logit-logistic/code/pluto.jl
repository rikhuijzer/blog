# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/logit-logistic.html"
html = read(path, String)
println("~~~
$html
~~~
")