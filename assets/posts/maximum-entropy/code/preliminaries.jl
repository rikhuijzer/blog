# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie
using DataFrames

function plot_distribution(probabilities::Array)
  np = mapping([1:6] => :n, [probabilities] => :P_n) * visual(BarPlot)
  axis = (; xticks=1:6, limits=(nothing, (0, 1)), height=200)
  draw(np; axis)
end