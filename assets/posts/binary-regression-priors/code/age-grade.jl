# This file was generated, do not modify it. # hide
# hideall
using AlgebraOfGraphics
using Blog # hide
using CairoMakie
using Makie

fig = Figure(; resolution=(800, 400))
lin = data(df) * linear()
scat = data(df) * visual(Scatter)
ag = lin * mapping(:age, :grade)
ag += scat * mapping(:age, :grade)
draw!(fig[1, 1], ag)
rg = lin * mapping(:recent, :grade)
rg += scat * mapping(:recent, :grade)
draw!(fig[1, 2], rg)

Blog.makie_svg(@OUTPUT, "age-grade", # hide
fig
) # hide