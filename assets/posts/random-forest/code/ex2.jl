# This file was generated, do not modify it. # hide
fg = data(df) * mapping(:U, :V, color=:class)

Blog.makie_svg(@OUTPUT, "u-class", # hide
draw(fg)
; literate=true); # hide