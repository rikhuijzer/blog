# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

I = -6:0.1:6
xy = mapping([I] => :x, [logistic.(I)] => :y) * visual(Lines)

Blog.aog_og_image(draw(xy), "logistic") # hide
Blog.aog_svg(@OUTPUT, "logistic", # hide
draw(xy)
) # hide