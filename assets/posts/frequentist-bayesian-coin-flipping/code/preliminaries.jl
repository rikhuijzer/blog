# This file was generated, do not modify it. # hide
# hideall
using CSV
output_dir = @OUTPUT
write_csv(name, data) = CSV.write(joinpath(output_dir, "$name.csv"), data)
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p)