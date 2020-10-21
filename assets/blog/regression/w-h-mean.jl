# This file was generated, do not modify it. # hide
m = mean(H) 
sum_sq = r2(sum((H .- m).^2))
p = plot(df, x = :W, y = :H,
  Geom.point,
  yintercept = [m], Geom.hline(style = :dot),
  xs = [1, 2], ys = [2, 3], Shape.vline()
)
p |> SVG(joinpath(@OUTPUT, "w-h-mean.svg")) # hide