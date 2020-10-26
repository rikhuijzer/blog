+++
title = "About"
description = "About this website"
image = "/assets/about/output/basic-plot.svg"
+++

# About

\toc

## This website

This website is built with [Franklin.jl](https://github.com/tlienart/Franklin.jl) and the [Julia programming language](https://julialang.org/).
Most posts on this site contain math, plots and the code to reproduce the results.
Adding the code makes reading the posts more difficult.
However, most statistical calculations cannot be done by hand.
For example, fitting a simple linear model requires minimizing the sum of squares.
By adding the code, this blog aims to show that statistical results are not created by some magical procedure.

For example, a basic plot can be as simple as

```julia:./basic-plot.jl
using Gadfly

range = 1:30
p = plot(x = range, y = [x^2 for x in range]) 
p |> SVG(joinpath(@OUTPUT, "basic-plot.svg")) # hide
```
\output{./basic-plot.jl}
\fig{./basic-plot.svg}

The source code of this website is available on [GitHub](https://github.com/rikhuijzer/franklin-blog).

## Myself

I'm a PhD student at the Faculty of Behavioural and Social Sciences, University of Groningen.
~~~
<a href="mailto:t.h.huijzer@rug.nl">t.h.huijzer@rug.nl</a>
~~~

My education is computer science and engineering; specifically:

~~~
  <b>Eindhoven University of Technology</b><br>
  <b>MSc</b>, Computer Science and Engineering, Software Science, Mar 2019.<br>
  &nbsp;&nbsp;&nbsp;&nbsp;Thesis: "<a href=](https://research.tue.nl/en/studentTheses/automatical  ly-responding-to-customers">Automatically responding to customers</a>".<br>
  &nbsp;&nbsp;&nbsp;&nbsp;Committee: dr. Nikolay <a href="http://www.yakovets.ca">Yakovets</a>, dr. George Fletcher, and dr. Joaquin Vanschoren.&nbsp;&nbsp;<br>
  
  <br>
  <b>Eindhoven University of Technology</b><br>
  Premaster Computer Science and Engineering, Software Science, Feb 2017.<br>
  <br>
  <b>Hanze University of Applied Sciences</b><br>
  <b>Bsc</b>, Mechanical Engineering, Feb 2015.
~~~
