# This file was generated, do not modify it. # hide
using GeometryBasics
# Linear and generalized linear models (GLMs).
using GLM

layers = data(df) * visual(Scatter)

m = mean(H)
df_mean = (W=df.W, H=fill(m, nrow(df)))
layers += data(df_mean) * linear()

for (w, h) in zip(df.W, df.H)
  df_diff = (W=[w, w], H=[m, h])
  global layers += data(df_diff) * visual(Lines)
end

Blog.makie_svg(@OUTPUT, "w-h-mean", # hide
draw(layers * mapping(:W, :H))
) # hide