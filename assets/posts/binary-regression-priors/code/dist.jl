# This file was generated, do not modify it. # hide
# hideall
df[!, :str_pass] = string.(df.pass)
fig = Figure(; resolution=(800, 400))
dens = data(df) * AlgebraOfGraphics.density()
ag = dens * mapping(:age; color=:str_pass)
axis = (ylabel="estimated density",)
draw!(fig[1, 1], ag; axis)
rg = dens * mapping(:recent; color=:str_pass)
draw!(fig[1, 2], rg; axis)

Blog.makie_svg(@OUTPUT, "dist", # hide
fig
) # hide