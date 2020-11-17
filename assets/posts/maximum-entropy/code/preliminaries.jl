# This file was generated, do not modify it. # hide
using DataFrames
using Gadfly

output_dir = @OUTPUT
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg"), 6inch, 2inch), p)

function plot_distribution(probabilities::Array)::Plot
	df = DataFrame(n = 1:6, P_n = probabilities)
	plot(df, x = :n, y = :P_n,
    Geom.bar(position = :dodge),
		Theme(bar_spacing=2mm, default_color = "gray"),
		Guide.xticks(ticks = 1:6),
		Guide.yticks(ticks = 0.2:0.2:1)
	)
end