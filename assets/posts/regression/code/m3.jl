# This file was generated, do not modify it. # hide
m3 = glm(@formula(Y_digit ~ W), df, Binomial(), LogitLink())

df_pred = (W=df.W, Y_digit=[predict_value(m3, x) for x in df.W])
layers = data(df_pred) * smooth(degree=3)
layers += data(df_pred) * visual(Scatter)
layers += data(df) * visual(Scatter)

Blog.makie_svg(@OUTPUT, "m3", # hide
draw(layers * mapping(:W, :Y_digit))
) # hide