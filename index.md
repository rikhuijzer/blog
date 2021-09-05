+++
title = "Home"
rss = "Blog posts about statistics, research and related topics"
image = "/assets/self.jpg"
+++

~~~
<center>
<img class="avatar-image" src="/assets/self.jpg">
</center>
~~~

Most posts on this site are about statistics and programming.
The posts contain math, plots and the code to reproduce the results.
The code makes reading the posts more difficult.
However, most statistical calculations cannot be done by hand.
For example, fitting a linear model requires minimizing the sum of squares.
By adding the code, this blog aims to show that statistical results are not created by some magical procedure.

For example, creating a plot can be done in a few lines of code:

```julia:basic-plot
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

I = 1:30
xy = mapping([I] => :x, [I.*2] => :y)

Blog.aog_svg(@OUTPUT, "basic-plot", # hide
draw(xy)
) # hide
```
\textoutput{basic-plot}

The source code of this website is available on [GitHub](https://github.com/rikhuijzer/huijzer.xyz).

## Posts

{{blogposts}}

## Versions

```julia:version
# hideall
println(VERSION)
```

This website is built with Julia \textoutput{version} and

```julia:packages
# hideall
import Pkg

deps = [pair.second for pair in Pkg.dependencies()]
deps = filter(p -> p.is_direct_dep, deps)
deps = filter(p -> !isnothing(p.version), deps)
list = ["$(p.name) $(p.version)" for p in deps]
sort!(list)
println(join(list, '\n'))
```
\output{packages}
