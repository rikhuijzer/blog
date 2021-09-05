# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

sdf = stack(df, [:A, :B, :C, :D])
xv = data(sdf) * mapping(:x, :value; color=:variable)

Blog.aog_og_image(draw(xv), "correlations") # hide
Blog.aog_svg(@OUTPUT, "plot", # hide
draw(xv)
) # hide