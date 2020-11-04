# This file was generated, do not modify it. # hide
digits = [i % 2 != 0 ? 0 : 1 for i in I]
df[:Y_digit] = digits
m2 = lm(@formula(Y_digit ~ W), df)

write_svg("m2", # hide
plot(df, x = :W, y = :Y_digit,
  xmin = [wmin], xmax = [wmax],
  Geom.point,
  layer(x -> predict_value(m2, x), wmin, wmax),
  layer(y = predict(m2), Geom.point)
)
) # hide