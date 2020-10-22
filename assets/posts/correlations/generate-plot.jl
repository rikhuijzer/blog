# This file was generated, do not modify it. # hide
using Gadfly

sdf = stack(df, [:A, :B, :C, :D])
p = plot(sdf, x = :x, y = :value, 
  Guide.yticks(ticks = collect(2:8)), # hide
  color = :variable
)
store_svg(name::String) = SVG(joinpath(@OUTPUT, "$name.svg")) # hide
p |> store_svg("plot") # hide