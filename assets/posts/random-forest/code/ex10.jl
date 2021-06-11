# This file was generated, do not modify it. # hide
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