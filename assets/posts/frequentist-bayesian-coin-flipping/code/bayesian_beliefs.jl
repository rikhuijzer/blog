# This file was generated, do not modify it. # hide
closed_form_prior = Beta(1, 1)
function update_belief(k)
  heads = sum(is_heads[1:k-1])
  tails = k - heads
  updated_belief = Beta(closed_form_prior.α + heads, closed_form_prior.β + tails)
end
beliefs = [closed_form_prior; update_belief.(1:n)]