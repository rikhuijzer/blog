# This file was generated, do not modify it. # hide
forest_predictions = MLJ.predict(forest, rows=test)
forest_fprs, forest_tprs, _ = roc_curve(forest_predictions, truths)
forest_aoc = auc(forest_predictions, truths) |> r3