# This file was generated, do not modify it. # hide
I = 0:0.01:1
df = (x=I, y=logit.(I))
xy = mapping([I] => :x, [logit.(I)] => :y) * visual(Lines)

Blog.aog_svg(@OUTPUT, "logit", # hide
draw(xy)
) # hide