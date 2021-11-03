# This file was generated, do not modify it. # hide
# hideall

using PlutoStaticHTML: notebook2html

path = "posts/notebooks/frequentist-bayesian-coin-flipping.jl"
log_path = "posts/notebooks/frequentist-bayesian-coin-flipping.log"
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
println("_This blog post was built via a Pluto.jl [notebook](posts/notebooks/frequentist-bayesian-coin-flipping.jl)_.")