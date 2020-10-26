# This file was generated, do not modify it. # hide
write_csv("normal_join", # hide
@from i in person begin
  @join j in grades_2019 on i.name equals j.name
  @select {i.name, i.age, j.grade_2019}
  @collect DataFrame
end
) # hide