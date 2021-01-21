# ## Data generation

import MLDataUtils

using CategoricalArrays
using DataFrames
using Distributions
using Gadfly
using Random
using MLJ
using StableRNGs

n = 100
μ1 = 10
μ2 = 12
σ = 2

d1 = Normal(μ1, σ)
d2 = Normal(μ2, σ)

Random.seed!(123)
classes = CategoricalArray(rand(["A", "B"], n))

df = DataFrame(
    class = CategoricalArray(classes),
    U = [class == "A" ? rand(d1) : rand(d2) for class in classes],
    V = rand(Normal(100, 10), n)
)

first(df, 10)

#

write_svg(name, p) = draw(SVG(joinpath(@OUTPUT, "$name.svg")), p) # hide
write_svg("u-class", # hide
plot(df, x = :U, y = :V, color = :class)
); # hide

nothing # hide

# \fig{u-class.svg}

# ## Train and test split

rng = StableRNG(123)
train, test = MLJ.partition(eachindex(classes), 0.7, shuffle=true; rng)

train[1:10]
length(train)
length(test)

## fprs, tprs, ts = roc_curve(ŷ, y) = roc(ŷ, y)
## plot(fprs, tprs)

# ## Model

forest_model = EnsembleModel(atom=(@load DecisionTreeClassifier), n=10);

forest = machine(forest_model, (U = df.U, V = df.V), df.class)

fit!(forest; rows=train)

class_pred = predict_mode(forest, rows=test)

r3(x) = round(x; sigdigits=3)

@show accuracy(class_pred, classes[test]) |> r3

# ## K-fold cross-validation

# folds = MLDataUtils.kfolds(df, k = 5);
