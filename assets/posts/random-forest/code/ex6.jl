# This file was generated, do not modify it. # hide
logistic_predictions = predict_mode(logistic, rows=test)
forest_predictions = predict_mode(forest, rows=test)
truths = classes[test]

r3(x) = round(x; sigdigits=3)

accuracy(logistic_predictions, classes[test]) |> r3