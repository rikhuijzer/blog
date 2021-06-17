# This file was generated, do not modify it. # hide
# hideall
using CategoricalArrays

chns_df = DataFrame(chns)
chns_df[!, :chain] = categorical(chns_df.chain)
sdf = DataFrames.stack(chns_df, names(chns), variable_name=:parameter)
sdf = filter(:parameter => p -> p == "βₐ" || p == "βᵣ", sdf)

layer = data(sdf) * mapping(:value; color=:chain, col=:parameter)
dens = layer * AlgebraOfGraphics.density()
axis = (ylabel="density",)

Blog.makie_svg(@OUTPUT, "turingplot", # hide
draw(dens; axis)
) # hide