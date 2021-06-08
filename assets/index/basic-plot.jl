# This file was generated, do not modify it. # hide
using Franklin # hide
using AlgebraOfGraphics, CairoMakie
output_dir = Franklin.@OUTPUT # hide

X = 1:30
df = (x=X, y=X.*2)
xy = data(df) * mapping(:x, :y)

# write_svg("basic-plot", # hide
# draw(xy)
# ) # hide