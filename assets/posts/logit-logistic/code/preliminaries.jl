# This file was generated, do not modify it. # hide
# hideall
output_dir = @OUTPUT
write_svg(name, p) = draw(SVG(joinpath(output_dir, "$name.svg")), p)