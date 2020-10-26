# This file was generated, do not modify it. # hide
# source: https://turing.ml
closed_form_prior = Beta(1, 1)
function update_belief(k)
  heads = sum(df[1:k-1, :is_heads])
  tails = k - heads
  updated_belief = Beta(closed_form_prior.α + tails, closed_form_prior.β + heads)
end
beliefs = [closed_form_prior; update_belief.(1:n)]