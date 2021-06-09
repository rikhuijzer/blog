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

fg = data(roc_df)
fg *= smooth() + visual(Scatter)
fg *= mapping(
    :x => "False positive rate estimate",
    :y => "True positive rate estimate",
    color=:method)

Blog.makie_svg(@OUTPUT, "roc", # hide
draw(fg)
; literate=true); # hide