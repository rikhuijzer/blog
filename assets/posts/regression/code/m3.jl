# This file was generated, do not modify it. # hide
m3 = glm(@formula(Y_digit ~ W), df, Binomial(), LogitLink())

write_svg("m3", # hide
plot(df, x = :W, y = :Y_digit, 
  Geom.point,
  layer(x -> predict_value(m3, x), wmin, wmax),
  layer(y = predict(m3), Geom.point)
)
) # hide