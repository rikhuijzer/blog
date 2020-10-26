# This file was generated, do not modify it. # hide
using HypothesisTests

function frequentist_estimate(n)
  t_result = OneSampleTTest(float.(df[1:n, :is_heads]))
  t_lower, t_upper = confint(t_result)
  (lower = t_lower, middle = t_result.xbar, upper = t_upper)
end