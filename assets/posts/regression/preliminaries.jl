# This file was generated, do not modify it. # hide
# hideall
import CSV
write_csv(name, data) = CSV.write(joinpath(@OUTPUT, "$name.csv"), data)
write_svg(name, p) = draw(SVG(joinpath(@OUTPUT, "$name.svg")), p)