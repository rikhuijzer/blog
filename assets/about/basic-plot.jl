# This file was generated, do not modify it. # hide
using Gadfly

range = 1:30
p = plot(x = range, y = [x^2 for x in range]) 
p |> SVG(joinpath(@OUTPUT, "basic-plot.svg")) # hide