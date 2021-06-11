# This file was generated, do not modify it. # hide
using AlgebraOfGraphics
using Blog # hide
using CairoMakie
using DataFrames

function plot_distribution(probabilities::Array)
  df = DataFrame(; n=1:6, P_n=probabilities)
  np = data(df) * mapping(:n, :P_n) * visual(BarPlot)
  axis = (; xticks=1:6, yticks=0.2:0.2:1)
  draw(np; axis)
end