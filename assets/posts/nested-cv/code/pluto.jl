# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/nested-cv.jl"
log_path = "posts/notebooks/nested-cv.log"
@assert isfile(path)
@info "→ evaluating Pluto notebook at ($path)"
html = open(log_path, "w") do io
    redirect_stdout(io) do
        html = notebook2html(path)
        return html
    end
end
println("
~~~
$html
~~~
")
println("_This blog post was built via a Pluto.jl [notebook](posts/notebooks/nested-cv.jl)_.")