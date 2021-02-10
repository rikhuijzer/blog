# This file was generated, do not modify it. # hide
accuracies = [fitted_accuracy(forest_model, train, test) for (train, test) in folds]
accuracies, mean(accuracies) |> r3