# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

# These two are useful for plotting.
wmin = minimum(W) - 0.2
wmax = maximum(W) + 0.2

fg = data(df) * mapping(:W, :H)
Blog.makie_svg(@OUTPUT, "w-h", # hide
draw(fg)
) # hide