+++
title = "Home"
description = "Rik Huijzer - PhD student; writing blog posts about statistics and related topics."
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
For example, fitting a simple linear model requires minimizing the sum of squares.
By adding the code, this blog aims to show that statistical results are not created by some magical procedure.

For example, creating a plot can be as simple as writing

```julia:./basic-plot.jl
using Gadfly
output_dir = @OUTPUT # hide 
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p) # hide

range = 1:30
write_svg("basic-plot", # hide
plot(x = range, y = [x^2 for x in range]) 
) # hide
```
\output{./basic-plot.jl}
\fig{./basic-plot.svg}
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
using Pkg

io = IOBuffer()
Pkg.status(; io)
text = String(take!(io))
lines = split(text, '\n')[3:end-1]
lines_without_id = [l[14:end] for l in lines]
list = join(lines_without_id, '\n')
println(list)
```
\output{packages}
