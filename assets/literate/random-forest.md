<!--This file was generated, do not modify it.-->
## Data generation

```julia:ex1
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
```

```julia:ex2
uv = data(df) * mapping(:U, :V, color=:class)

Blog.makie_svg(@OUTPUT, "u-class", # hide
draw(uv)
; literate=true); # hide
```

\fig{u-class.svg}

## Train and test split

Training and evaluating (testing) on the same data is not particulary useful because we want to know how well our model generalizes.
For more information, see topics such as [overfitting](https://en.wikipedia.org/wiki/Overfitting).
Instead, we split the data up in a *train* and *test* set.

```julia:ex3
using StableRNGs

rng = StableRNG(123)
train, test = MLJ.partition(eachindex(classes), 0.7; shuffle=true, rng)

@show length(train) # hide
@show length(test) # hide
```

## Model fitting

```julia:ex4
LinearBinary = @load LinearBinaryClassifier pkg=GLM verbosity=0
logistic_model = LinearBinary();

DecisionTree = @load DecisionTreeClassifier pkg=DecisionTree verbosity=0
tree = DecisionTree()
forest_model = EnsembleModel(atom=tree, n=10);

logistic = machine(logistic_model, (U = df.U, V = df.V), df.class)
fit!(logistic; rows=train)
fitted_params(logistic).coef
```

The second coefficient in the linear model is close to zero.
This is exactly what the model should do since $V$ is random noise.

```julia:ex5
forest = machine(forest_model, (U = df.U, V = df.V), df.class)
fit!(forest; rows=train);
```

## Accuracy

Now that we have fitted the two models, we can compare the accuracies and plot the [receiver operating characteristic](https://en.wikipedia.org/wiki/Receiver_operating_characteristic).

```julia:ex6
logistic_predictions = predict_mode(logistic, rows=test)
forest_predictions = predict_mode(forest, rows=test)
truths = classes[test]

r3(x) = round(x; sigdigits=3)

accuracy(logistic_predictions, classes[test]) |> r3
```

```julia:ex7
accuracy(forest_predictions, classes[test]) |> r3
```

```julia:ex8
using MLJBase

logistic_predictions = MLJ.predict(logistic, rows=test)
logistic_fprs, logistic_tprs, _ = roc_curve(logistic_predictions, truths)
logistic_aoc = auc(logistic_predictions, truths) |> r3
```

```julia:ex9
forest_predictions = MLJ.predict(forest, rows=test)
forest_fprs, forest_tprs, _ = roc_curve(forest_predictions, truths)
forest_aoc = auc(forest_predictions, truths) |> r3
```

```julia:ex10
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

xy = data(roc_df)
xy *= smooth() + visual(Scatter)
xy *= mapping(
    :x => "False positive rate",
    :y => "True positive rate",
    color=:method)

Blog.makie_svg(@OUTPUT, "roc", # hide
draw(xy)
; literate=true); # hide
```

\fig{roc.svg}

## K-fold cross-validation

By doing a train and test split, we basically threw a part of the data away.
For small datasets, like the dataset in this example, that is not very efficient.
Therefore, we also do a [k-fold cross-validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#k-fold_cross-validation).

```julia:ex11
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
```

```julia:ex12
accuracies = [fitted_accuracy(forest_model, train, test) for (train, test) in folds]
accuracies, mean(accuracies) |> r3
```

