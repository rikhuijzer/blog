# This file was generated, do not modify it. # hide
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