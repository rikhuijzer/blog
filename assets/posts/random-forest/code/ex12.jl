# This file was generated, do not modify it. # hide
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