# This file was generated, do not modify it. # hide
using Gadfly
output_dir = @OUTPUT # hide 
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p) # hide

range = 1:30
write_svg("basic-plot", # hide
plot(x = range, y = [x^2 for x in range]) 
) # hide