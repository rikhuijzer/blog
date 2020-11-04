# This file was generated, do not modify it. # hide
# Linear and generalized linear models (GLMs).
using GLM

m = mean(H) 
write_svg("w-h-mean", # hide
plot(df, x = :W, y = :H,
  Geom.point,
  yintercept = [m], Geom.hline(),
  layer(xend = :W, yend = [m], Geom.segment())
)
) # hide