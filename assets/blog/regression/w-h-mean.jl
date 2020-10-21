# This file was generated, do not modify it. # hide
# hideall

m = mean(H) 
sum_sq = r2(sum((H .- m).^2))

function plot_lsq()
  p = plot(df, x = :W, y = :H,
    Geom.point,
    yintercept = [m], Geom.hline(style = :dot)
  ) 
  p |> SVG(joinpath(@OUTPUT, "w-h-mean.svg")) # hide 
end

plot_lsq()