# This file was generated, do not modify it. # hide
using Gadfly

function plot_estimates(estimate_function; title="")
  draws = 2:4:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  plot(y = draws, 
    x = [t.middle for t in estimates],
    xmin = [t.lower for t in estimates],
    xmax = [t.upper for t in estimates],
    Geom.point, Geom.errorbar,
    Coord.cartesian(xmin = 0.0, xmax = 1.0),
    Guide.xlabel("Probability of heads"), Guide.ylabel("Observed number of draws"),
    Guide.title(title),
    layer(xintercept = [0.5], Geom.vline(color = "gray"))
  )
end