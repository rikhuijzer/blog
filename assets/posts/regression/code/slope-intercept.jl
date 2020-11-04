# This file was generated, do not modify it. # hide
intercept(linear_model) = coef(linear_model)[1]
slope(linear_model) = coef(linear_model)[2]

@show r_2(intercept(m1)) # hide
@show r_2(slope(m1)) # hide