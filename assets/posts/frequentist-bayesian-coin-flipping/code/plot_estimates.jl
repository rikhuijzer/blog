# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie

function plot_estimates(estimate_function; title="")
  draws = 2:4:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  lowers = [t.lower for t in estimates]
  uppers = [t.upper for t in estimates]
  df = (; draws, estimates, P=middles)
  layers = data(df) * visual(Scatter)
  df_middle = (; P=fill(0.5, length(draws) + 2), draws=[-1; draws; 83])
  layers += data(df_middle) * visual(Lines) * visual(linestyle=:dash)
  for (n, lower, upper) in zip(draws, lowers, uppers)
    df_bounds = (; P=[lower, upper], draws=[n, n])
    layers += data(df_bounds) * visual(Lines)
  end

  axis = (; yticks=0:20:80, limits=((-0.2, 1.2), nothing))
  map = mapping(:P => "Probability of heads", :draws => "Observed number of draws")
  draw(layers * map; axis)
end