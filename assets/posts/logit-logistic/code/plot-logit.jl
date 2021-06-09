# This file was generated, do not modify it. # hide
I = 0:0.01:1
df = (x=I, y=logit.(I))
fg = data(df) * mapping(:x, :y) * visual(Lines)

Blog.makie_svg(@OUTPUT, "logit", # hide
draw(fg)
) # hide