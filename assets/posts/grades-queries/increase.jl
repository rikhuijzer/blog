# This file was generated, do not modify it. # hide
write_csv("increase", # hide
@from i in person begin
  @left_outer_join j in grades_2019 on i.name equals j.name
  @left_outer_join k in grades_2020 on i.name equals k.name
  @select {i.name, j.grade_2019, k.grade_2020, 
    increase=k.grade_2020 - j.grade_2019}
  @collect DataFrame
end
) # hide