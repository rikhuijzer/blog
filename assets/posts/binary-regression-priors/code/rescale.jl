# This file was generated, do not modify it. # hide
# hideall
# Not used because it makes the analysis much more complex.
using MLDataUtils: rescale!

function rescale_data(df)
    out = DataFrame(df)
    rescale!(out, [:age, :recent, :grade])
    for col in [:age, :recent, :error, :grade] # hide
        out[!, col] = round.(out[!, col]; digits=3) # hide
    end # hide
    out
end

rescaled = rescale_data(df)
rescaled[!, :pass_num] = [p ? 1.0 : 0.0 for p in rescaled.pass]

write_csv("rescaled", # hide
first(rescaled, 8)
) # hide
# \tableinput{}{./code/rescaled.csv}