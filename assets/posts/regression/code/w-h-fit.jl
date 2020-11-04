# This file was generated, do not modify it. # hide
m1 = lm(@formula(H ~ W), df)

# This is just a convenience function around `GLM.predict`.
predict_value(model, x) = 
  first(skipmissing(predict(model, DataFrame(W = [x]))))

write_svg("w-h-fit", # hide
plot(df, x = :W, y = :H, 
	# xviewmin = [wmin], xviewmax = [wmax], # hide
  Geom.point,
  layer(x -> predict_value(m1, x), wmin, wmax)
)
) # hide