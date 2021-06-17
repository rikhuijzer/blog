# This file was generated, do not modify it. # hide
m1 = lm(@formula(H ~ W), df)

# This is just a convenience function around `GLM.predict`.
predict_value(model, x) =
  first(skipmissing(predict(model, DataFrame(W = [x]))))

df_pred = (W=wmin:wmax, H=[predict_value(m1, x) for x in wmin:wmax])
layers = data(df_pred) * visual(Lines)
layers += data(df)

Blog.aog_svg(@OUTPUT, "w-h-fit", # hide
draw(layers * mapping(:W, :H))
) # hide