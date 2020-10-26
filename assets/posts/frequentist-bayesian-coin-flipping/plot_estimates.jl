# This file was generated, do not modify it. # hide
using StatsPlots

function plot_estimates(estimate_function)
  draws = 2:3:80
  estimates = estimate_function.(draws)
  middles = [t.middle for t in estimates]
  errors = [(t.middle - abs(t.lower), abs(t.middle - abs(t.upper))) for t in estimates]
  plot(middles, draws, xerr=errors, xlims=(0,1),
    linecolor = :white,label="", # hide
    xlabel = "Probability of heads", ylabel = "Observed number of draws"
  )
  scatter!(middles, draws, label="estimated mean", color = Blog.blue)
  vline!([p_true], line = (1.5, :dash), color = Blog.blue, label = "true mean")
end