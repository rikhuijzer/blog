# This file was generated, do not modify it. # hide
using Query

write_csv("simple_join", # hide
@from i in person begin
  @left_outer_join j in grades_2019 on i.name equals j.name
  @select {i.name, i.age, j.grade_2019}
  @collect DataFrame
end
) # hide