# This file was generated, do not modify it. # hide
# Linear and generalized linear models (GLMs).
using GLM

layers = data(df) * visual(Scatter)

m = mean(H)
df_mean = (W=df.W, H=fill(m, nrow(df)))
layers += data(df_mean) * linear() * visual(linestyle=:dash)

for (w, h) in zip(df.W, df.H)
  df_diff = (W=[w, w], H=[m, h])
  global layers += data(df_diff) * visual(Lines)
end

Blog.aog_svg(@OUTPUT, "w-h-mean", # hide
draw(layers * mapping(:W, :H))
) # hide