# This file was generated, do not modify it. # hide
using MLJBase

logistic_predictions = MLJ.predict(logistic, rows=test)
logistic_fprs, logistic_tprs, _ = roc_curve(logistic_predictions, truths)
logistic_aoc = auc(logistic_predictions, truths) |> r3