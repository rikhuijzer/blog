# This file was generated, do not modify it. # hide
digits = [i % 2 != 0 ? 0 : 1 for i in I]
df[!, :Y_digit] = digits
m2 = lm(@formula(Y_digit ~ W), df)

df_pred = (W=df.W, Y_digit=[predict_value(m2, x) for x in df.W])
layers = data(df_pred) * visual(Lines)
layers += data(df_pred) * visual(Scatter)
layers += data(df) * visual(Scatter)

Blog.makie_svg(@OUTPUT, "m2", # hide
draw(layers * mapping(:W, :Y_digit))
) # hide