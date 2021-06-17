# This file was generated, do not modify it. # hide
# hideall
r5(x) = round(x; digits=5)
coef_a = coef(linear_model)[2] |> r5
coef_r = coef(linear_model)[3] |> r5
"""
Notice how these estimated coefficients are close to the coefficients that we set for `age` and `recent`, namely \$a_e = $aₑ \\approx $coef_a \$ and \$ r_e = $rₑ \\approx $coef_r \$.
""" |> print