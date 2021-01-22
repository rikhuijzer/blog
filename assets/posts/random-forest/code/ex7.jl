# This file was generated, do not modify it. # hide
forest = machine(forest_model, (U = df.U, V = df.V), df.class)
fit!(forest; rows=train);