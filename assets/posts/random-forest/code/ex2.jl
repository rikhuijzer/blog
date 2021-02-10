# This file was generated, do not modify it. # hide
write_svg(name, p) = draw(SVG(joinpath(tempdir(), "$name.svg")), p) # hide
write_svg("u-class", # hide
plot(df, x = :U, y = :V, color = :class)
); # hide

nothing # hide