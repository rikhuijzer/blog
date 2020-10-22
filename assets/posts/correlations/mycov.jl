# This file was generated, do not modify it. # hide
using Statistics

# Note that unlike the Julia built-in function this function does not apply Bessel's correction.
function mycov(X, Y)
    min_mean_x(x)::Float64 = x - mean(X)
    min_mean_y(y)::Float64 = y - mean(Y)
    
    mean(min_mean_x.(X) .* min_mean_y.(Y))
end

@show mycov(A, A)
@show mycov(A, B)
@show mycov(A, C)
@show mycov(A, D)