# This file was generated, do not modify it.

import MLDataUtils

using AlgebraOfGraphics
using Blog # hide
using CairoMakie
using CategoricalArrays
using DataFrames
using Distributions
using MLJ
using Suppressor # hide
using Random

n = 80
μ1 = 10
μ2 = 12
σ = 2

d1 = Normal(μ1, σ)
d2 = Normal(μ2, σ)

Random.seed!(123)
classes = categorical(rand(["A", "B"], n))

df = DataFrame(
    class = categorical(classes),
    U = [class == "A" ? rand(d1) : rand(d2) for class in classes],
    V = rand(Normal(100, 10), n)
)

first(df, 10)

fg = data(df) * mapping(:U, :V, color=:class)

Blog.makie_svg(@OUTPUT, "u-class", # hide
draw(fg)
; literate=true); # hide

using StableRNGs

rng = StableRNG(123)
train, test = MLJ.partition(eachindex(classes), 0.7; shuffle=true, rng)

@show length(train) # hide
@show length(test) # hide

LinearBinary = @load LinearBinaryClassifier pkg=GLM verbosity=0
logistic_model = LinearBinary();

DecisionTree = @load DecisionTreeClassifier pkg=DecisionTree verbosity=0
tree = DecisionTree()
forest_model = EnsembleModel(atom=tree, n=10);

logistic = machine(logistic_model, (U = df.U, V = df.V), df.class)
fit!(logistic; rows=train)
fitted_params(logistic).coef

forest = machine(forest_model, (U = df.U, V = df.V), df.class)
fit!(forest; rows=train);

logistic_predictions = predict_mode(logistic, rows=test)
forest_predictions = predict_mode(forest, rows=test)
truths = classes[test]

r3(x) = round(x; sigdigits=3)

accuracy(logistic_predictions, classes[test]) |> r3

accuracy(forest_predictions, classes[test]) |> r3

using MLJBase

logistic_predictions = MLJ.predict(logistic, rows=test)
logistic_fprs, logistic_tprs, _ = roc_curve(logistic_predictions, truths)
logistic_aoc = auc(logistic_predictions, truths) |> r3

forest_predictions = MLJ.predict(forest, rows=test)
forest_fprs, forest_tprs, _ = roc_curve(forest_predictions, truths)
forest_aoc = auc(forest_predictions, truths) |> r3

logistic_df = DataFrame(
    x = logistic_fprs,
    y = logistic_tprs,
    method = "logistic"
)

forest_df = DataFrame(
    x = forest_fprs,
    y = forest_tprs,
    method = "forest"
)

roc_df = vcat(logistic_df, forest_df)

fg = data(roc_df)
fg *= smooth() + visual(Scatter)
fg *= mapping(
    :x => "False positive rate estimate",
    :y => "True positive rate estimate",
    color=:method)

Blog.makie_svg(@OUTPUT, "roc", # hide
draw(fg)
; literate=true); # hide

Random.seed!(123)
rng = MersenneTwister(123)
indexes = shuffle(rng, eachindex(classes))
folds = MLDataUtils.kfolds(indexes, k = 8)

function fitted_accuracy(model, train, test)
    @suppress begin # hide
    forest = machine(model, (U = df.U, V = df.V), df.class)
    fit!(forest; rows=train)
    predictions = predict_mode(forest, rows=test)
    return accuracy(predictions, classes[test]) |> r3
    end # hide
end

accuracies = [fitted_accuracy(logistic_model, train, test) for (train, test) in folds]
accuracies, mean(accuracies) |> r3

accuracies = [fitted_accuracy(forest_model, train, test) for (train, test) in folds]
accuracies, mean(accuracies) |> r3

