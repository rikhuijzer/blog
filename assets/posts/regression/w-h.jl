# This file was generated, do not modify it. # hide
using Gadfly

# These two are useful for plotting.
wmin = minimum(W) - 0.2
wmax = maximum(W) + 0.2

write_svg("w-h", # hide
plot(df, x = :W, y = :H)
) # hide