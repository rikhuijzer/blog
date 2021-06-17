# This file was generated, do not modify it. # hide
# hideall
using CSV
write_csv(name, data) = CSV.write(joinpath(@OUTPUT, "$name.csv"), data)