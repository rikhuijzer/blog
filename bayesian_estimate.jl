# This file was generated, do not modify it. # hide
function bayesian_estimate(n)
  distribution = beliefs[n]
  q(x) = quantile(distribution, x)
  (lower = q(0.025), middle = mean(distribution), upper = q(0.975))
end