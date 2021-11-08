### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ b23a5b96-3800-11ec-1233-45aeb88838c7
begin
	using AlgebraOfGraphics
	using CairoMakie
	using CategoricalArrays
	using DataFrames
	using GLM
	using MLDataUtils: rescale!
	using Random: seed!
	using Statistics
	using StatsFuns
	using Turing
end

# ╔═╡ b0c366b1-1965-40c2-9f6c-00a6b5e6b574
# hideall
md"""
Typically, when making predictions via a linear model, we fit the model on our data and make predictions from the fitted model.
However, this doesn't take much foreknowledge into account.
For example, when predicting a person's length given only the weight and gender, we already have an intuition about the effect size and direction.
Bayesian analysis should be able to incorporate this prior information.

In this blog post, I aim to figure out whether foreknowledge can, in theory, increase model accuracy.
To do this, I generate data and fit a linear model and a Bayesian binary regression.
Next, I compare the accuracy of the model parameters from the linear and Bayesian model.
"""

# ╔═╡ 3183824b-443e-4836-8bd9-313c5461cf8f
# hideall
aₑ = 1.1;

# ╔═╡ 8a845273-3bfd-4d8a-a7fa-792a25d44f8a
# hideall
rₑ = 1.05;

# ╔═╡ 6163caca-2702-4351-8284-978d4cf89c67
# hideall
md"""
We define the model as $g_i = a_e * a_i + r_e * r_i + \epsilon_i = 1.1 * a_i + 1.05 * r_i + \epsilon_i$ where $a_e$ is the coefficient for the age, $r_e$ is a coefficient for the nationality and $\epsilon_i$ is some random noise for individual $i$.

We generate data for $n$ individuals via:
"""

# ╔═╡ 46ea7a83-1455-4ebf-a073-fda8ded120ef
function generate_data(i::Int)
  seed!(i)

  n = 120
  I = 1:n
  P = [i % 2 == 0 for i in I]
  r_2(x) = round(x; digits=2)

  A = r_2.([p ? rand(Normal(aₑ * 18, 1)) : rand(Normal(18, 1)) for p in P])
  R = r_2.([p ? rand(Normal(rₑ * 6, 3)) : rand(Normal(6, 3)) for p in P])
  E = r_2.(rand(Normal(0, 1), n))
  G = aₑ .* A + rₑ .* R .+ E
  G = r_2.(G)

  df = DataFrame(age=A, recent=R, error=E, grade=G, pass=P)
end;

# ╔═╡ 337bbef5-077c-4260-92bc-1259a9f63921
df = generate_data(1)

# ╔═╡ bc65dc46-c7a4-408f-98ed-419d0c683eaf
# hideall
let
	fig = Figure(; resolution=(800, 400))
	lin = data(df) * linear()
	scat = data(df) * visual(Scatter)
	ag = lin * mapping(:age, :grade)
	ag += scat * mapping(:age, :grade)
	draw!(fig[1, 1], ag)
	rg = lin * mapping(:recent, :grade)
	rg += scat * mapping(:recent, :grade)
	draw!(fig[1, 2], rg)
	fig
end

# ╔═╡ e9dbe406-317b-4b39-93d8-1cee81aeebe1
# hideall
md"""
## Linear regression

First, we fit a linear model and verify that the coefficients are estimated reasonably well.
Here, the only prior information that we give the model is the structure of the data, that is, a formula.
"""

# ╔═╡ 8ffa864e-bc05-4e45-86fe-fccb4686b808
linear_model = lm(@formula(grade ~ age + recent), df)

# ╔═╡ 88b9f4bf-6dad-4aac-9b84-3b3fe5ff2d94
r5(x) = round(x; digits=5)

# ╔═╡ eaad72ba-a4f0-4e24-8c03-83a3f260c686
coefa = coef(linear_model)[2] |> r5

# ╔═╡ 245f6b53-a5e0-4dac-a07d-8b85fa3ebe5c
coefr = coef(linear_model)[3] |> r5

# ╔═╡ 6d588f9b-94d7-404e-afbb-3d7991e0a56e
# hideall
md"""
Notice how these estimated coefficients are close to the coefficients that we set for `age` and `recent`, namely a\_e = $aₑ ≈ $coefa and r\_e = $rₑ ≈ $coefr, as expected.
"""

# ╔═╡ 692ce504-3e04-4d14-9a01-8acab6f1f9d9
# hideall
md"""
## Bayesian regression

For the Bayesian regression we fit a model via Turing.jl.
Now, we give the model information about the structure of the data as well as priors for the size of the coefficients.
For demonstration purposes, I've set the priors to the correct values.
This is reasonable because I was wondering whether finding a good prior could have a positive effect on the model accuracy.
"""

# ╔═╡ 95474322-7bbf-4998-be02-6645921061e9
function rescale_data(df)
    out = DataFrame(df)
    rescale!(out, [:age, :recent, :grade])
    for col in [:age, :recent, :error, :grade] # hide
        out[!, col] = round.(out[!, col]; digits=3) # hide
    end # hide
    out
end;

# ╔═╡ 28909290-1e52-4508-a477-b770de57c36e
rescaled = let
	rescaled = rescale_data(df)
	rescaled[!, :pass_num] = [p ? 1.0 : 0.0 for p in rescaled.pass]
end;

# ╔═╡ 3e4922a5-6cf5-450c-b0e1-732c526d6c38
@model function bayesian_model(ages, recents, grades, n)
    intercept ~ Normal(0, 5)
    βₐ ~ Normal(aₑ, 1)
    βᵣ ~ Normal(rₑ, 3)
    σ ~ truncated(Cauchy(0, 2), 0, Inf)

    μ = intercept .+ βₐ * ages .+ βᵣ * recents
    grades ~ MvNormal(μ, σ)
end;

# ╔═╡ dc1dfc38-2b71-46f7-9e60-8e1c99355c19
chns = let
	n = nrow(df)
	bm = bayesian_model(df.age, df.recent, df.grade, n)
	chns = Turing.sample(bm, NUTS(), MCMCThreads(), 10_000, 3)
end;

# ╔═╡ b95c9c03-6da4-4b86-bdbe-0863f94b43af
# hideall
md"Let's plot the density for the coefficient estimates $\beta_a$ and $\beta_r$:"

# ╔═╡ 146d52d8-f35a-4cf1-82e9-ff987a46ef9f
# hideall
let
	chns_df = DataFrame(chns)
	chns_df[!, :chain] = categorical(chns_df.chain)
	sdf = DataFrames.stack(chns_df, names(chns), variable_name=:parameter)
	sdf = filter(:parameter => p -> p == "βₐ" || p == "βᵣ", sdf)

	layer = data(sdf) * mapping(:value; color=:chain, col=:parameter)
	dens = layer * AlgebraOfGraphics.density()
	axis = (ylabel="density",)

	draw(dens; axis)
end

# ╔═╡ 49c5d31a-217f-48e3-a487-ba4cf25474a9
# hideall
md"""
and compare the outputs from both models:
"""

# ╔═╡ b52f4815-de4a-4732-b303-ab59bcda3a44
# hideall
let
	chns_df = DataFrame(chns)
	r_2(x) = round(x; digits=2)
	r_3(x) = round(x; digits=3)
	coefaturing = mean(chns_df.βₐ)
	coefrturing = mean(chns_df.βᵣ)

	function coef_error(true_value, estimate)
		err = abs(true_value - estimate)
		part = err / true_value
		percentage = part * 100
		percentage = round(percentage; digits=1)
		percentage = "$percentage %"
	end

	linerra = coef_error(aₑ, coefa)
	linerrr = coef_error(rₑ, coefr)
	bayerra = coef_error(aₑ, coefaturing)
	bayerrr = coef_error(rₑ, coefrturing)

	md"""
	coefficient | true value | linear estimate | linear error | bayesian estimate | bayesian error
	--- | --- | --- | --- | --- | ---
	aₑ | $aₑ | $(coefa) | $linerra | $coefaturing | $bayerra
	rₑ | $rₑ | $(coefr) | $linerrr | $coefrturing | $bayerrr
	"""
end

# ╔═╡ a6bf48f4-26b7-4308-9cb1-bab61bcf016f
# hideall
md"""
## Conclusion

After giving the true coefficients to the Bayesian model in the form of priors, it does score better than the linear model.
However, the differences aren't very big.
This could be due to the particular random noise in this sample `E` or due to the relatively big sample size.
The more samples, the more likely it is that the data will overrule the prior.
In any way, there are real-world situations where gathering extra data is more expensive than gathering priors via reading papers.
In those cases, the increased accuracy introduced by using priors could have serious benefits.
"""

# ╔═╡ Cell order:
# ╠═b0c366b1-1965-40c2-9f6c-00a6b5e6b574
# ╠═b23a5b96-3800-11ec-1233-45aeb88838c7
# ╠═3183824b-443e-4836-8bd9-313c5461cf8f
# ╠═8a845273-3bfd-4d8a-a7fa-792a25d44f8a
# ╠═6163caca-2702-4351-8284-978d4cf89c67
# ╠═46ea7a83-1455-4ebf-a073-fda8ded120ef
# ╠═337bbef5-077c-4260-92bc-1259a9f63921
# ╠═bc65dc46-c7a4-408f-98ed-419d0c683eaf
# ╠═e9dbe406-317b-4b39-93d8-1cee81aeebe1
# ╠═8ffa864e-bc05-4e45-86fe-fccb4686b808
# ╠═88b9f4bf-6dad-4aac-9b84-3b3fe5ff2d94
# ╠═eaad72ba-a4f0-4e24-8c03-83a3f260c686
# ╠═245f6b53-a5e0-4dac-a07d-8b85fa3ebe5c
# ╠═6d588f9b-94d7-404e-afbb-3d7991e0a56e
# ╠═692ce504-3e04-4d14-9a01-8acab6f1f9d9
# ╠═95474322-7bbf-4998-be02-6645921061e9
# ╠═28909290-1e52-4508-a477-b770de57c36e
# ╠═3e4922a5-6cf5-450c-b0e1-732c526d6c38
# ╠═dc1dfc38-2b71-46f7-9e60-8e1c99355c19
# ╠═b95c9c03-6da4-4b86-bdbe-0863f94b43af
# ╠═146d52d8-f35a-4cf1-82e9-ff987a46ef9f
# ╠═49c5d31a-217f-48e3-a487-ba4cf25474a9
# ╠═b52f4815-de4a-4732-b303-ab59bcda3a44
# ╠═a6bf48f4-26b7-4308-9cb1-bab61bcf016f
