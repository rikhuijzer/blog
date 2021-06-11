# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

I = -6:0.1:6
df = (x=I, y=logistic.(I))
xy = data(df) * mapping(:x, :y) * visual(Lines)

Blog.makie_svg(@OUTPUT, "logistic", # hide
draw(xy)
) # hide