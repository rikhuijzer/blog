# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

X = 1:30
df = (x=X, y=X.*2)
xy = data(df) * mapping(:x, :y)

Blog.makie_svg(@OUTPUT, "basic-plot", # hide
draw(xy)
) # hide