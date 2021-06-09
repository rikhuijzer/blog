# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

sdf = stack(df, [:A, :B, :C, :D])
fg = data(sdf) * mapping(:x, :value; color=:variable)

Blog.makie_svg(@OUTPUT, "plot", # hide
draw(fg)
) # hide