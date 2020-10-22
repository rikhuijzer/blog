# This file was generated, do not modify it. # hide
using DataFrames
using Gadfly

function plot_distribution(probabilities::Array)::Plot
	df = DataFrame(n = 1:6, Pₙ = probabilities)
	plot(df, x = :n, y = :Pₙ,
		Geom.bar(position = :dodge),
		Theme(bar_spacing=2mm, default_color = "gray"),
		Guide.xticks(ticks = collect(1:6)),
		Guide.yticks(ticks = collect(0.2:0.2:1))
	)
end

p = plot_distribution([1/6, 1/6, 1/6, 1/6, 1/6, 1/6])
store_svg(name::String) = SVG(joinpath(@OUTPUT, "$name.svg"), 6inch, 2inch) # hide
p |> store_svg("unbiased") # hide