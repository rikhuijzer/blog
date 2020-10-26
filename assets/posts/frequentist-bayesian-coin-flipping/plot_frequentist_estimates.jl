# This file was generated, do not modify it. # hide
p = plot_estimates(frequentist_estimate)
store_image(p, name::String) = savefig(joinpath(@OUTPUT, "$name.svg")) # hide 
store_image(p, "frequentist-estimates") # hide