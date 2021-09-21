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

Hi!
I'm a PhD student at the University of Groningen.
See [about](/about) for more information about me.

Most posts on this site are about statistics and programming.
The posts contain math, plots and the code to reproduce the results.

For example, a simple plot looks as follows:

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
