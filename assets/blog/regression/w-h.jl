# This file was generated, do not modify it. # hide
using Gadfly

p = plot(df, x = :W, y = :H)
p |> SVG(joinpath(@OUTPUT, "w-h.svg")) # hide