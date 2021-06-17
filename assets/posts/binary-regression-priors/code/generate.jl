# This file was generated, do not modify it. # hide
using DataFrames
using Distributions
using Random

function generate_data(i::Int)
  Random.seed!(i)

  n = 120
  I = 1:n
  P = [i % 2 == 0 for i in I]
  r_2(x) = round(x; digits=2)
  r3(x) = round(x; digits=3)

  A = r_2.([p ? rand(Normal(aₑ * 18, 1)) : rand(Normal(18, 1)) for p in P])
  R = r_2.([p ? rand(Normal(rₑ * 6, 3)) : rand(Normal(6, 3)) for p in P])
  E = r_2.(rand(Normal(0, 1), n))
  G = aₑ .* A + rₑ .* R .+ E
  G = r_2.(G)

  df = DataFrame(age=A, recent=R, error=E, grade=G, pass=P)
end

df = generate_data(1)
write_csv("df", # hide
first(df, 8)
) # hide