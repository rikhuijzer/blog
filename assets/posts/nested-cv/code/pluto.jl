# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/nested-cv.html"
html = read(path, String)
println("~~~
$html
~~~
")