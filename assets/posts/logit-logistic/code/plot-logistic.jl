# This file was generated, do not modify it. # hide
using Gadfly

write_svg("logistic", # hide
plot(y = [logistic], xmin = [-6], xmax = [6], 
	Geom.line, Stat.func, Guide.xlabel("x")
)
) # hide