# This file was generated, do not modify it. # hide
using HypothesisTests

function frequentist_estimate(n)
  t_result = OneSampleTTest(is_heads[1:n])
  t_lower, t_upper = confint(t_result)
  (lower = t_lower, middle = t_result.xbar, upper = t_upper)
end