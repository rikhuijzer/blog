# This file was generated, do not modify it. # hide
uv = data(df) * mapping(:U, :V, color=:class)

Blog.aog_og_image(draw(uv), "random-forest") # hide
Blog.aog_svg(@OUTPUT, "u-class", # hide
draw(uv)
; literate=true); # hide