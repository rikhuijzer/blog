# This file was generated, do not modify it. # hide
using GLM

linear_model = lm(@formula(grade ~ age + recent), df)
println(linear_model) # hide