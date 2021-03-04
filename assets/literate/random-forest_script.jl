# This file was generated, do not modify it.

import MLDataUtils

using CategoricalArrays
using DataFrames
using Distributions
using Gadfly
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
classes = CategoricalArray(rand(["A", "B"], n))

df = DataFrame(
    class = CategoricalArray(classes),
    U = [class == "A" ? rand(d1) : rand(d2) for class in classes],
    V = rand(Normal(100, 10), n)
)

first(df, 10)

write_svg(name, p) = draw(SVG(joinpath(@OUTPUT, "$name.svg")), p) # hide
write_svg("u-class", # hide
plot(df, x = :U, y = :V, color = :class)
); # hide

nothing # hide

using StableRNGs

rng = StableRNG(123)
train, test = MLJ.partition(eachindex(classes), 0.7; shuffle=true, rng)

@show length(train) # hide
@show length(test) # hide

LinearBinary = @load LinearBinaryClassifier pkg=GLM verbosity=0
logistic_model = LinearBinary();

DecisionTree = @load DecisionTreeClassifier verbosity=0
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

write_svg("roc", # hide
plot(x = logistic_fprs, y = logistic_tprs, color = ["logistic"],
    Coord.cartesian(ymin = 0, ymax = 1), # hide
    Guide.yticks(ticks = 0:0.1:1), # hide
    Guide.xlabel("False positive rate"),
    Guide.ylabel("True positive rate estimate"),
    Geom.smooth(method = :loess, smoothing = 0.99),
    layer(
        x = forest_fprs, y = forest_tprs, color = ["forest"],
        Geom.smooth(method = :loess, smoothing = 0.99),
    )
)
); # hide

nothing # hide

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

