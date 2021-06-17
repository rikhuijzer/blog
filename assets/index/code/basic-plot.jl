# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

I = 1:30
xy = mapping([I] => :x, [I.*2] => :y)

Blog.aog_svg(@OUTPUT, "basic-plot", # hide
draw(xy)
) # hide