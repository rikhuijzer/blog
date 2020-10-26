# This file was generated, do not modify it. # hide
write_csv("debug", # hide
@from i in person begin
  @join j in grades_2019 on i.name equals j.name
  @select {i, j}
  @collect DataFrame
end
) # hide