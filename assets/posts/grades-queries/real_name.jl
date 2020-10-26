# This file was generated, do not modify it. # hide
results = @from i in person begin
  @left_outer_join j in grades_2019 on i.name equals j.name
  @left_outer_join k in grades_2020 on i.name equals k.name
  @let real_name = (k.name == "Bob 2") ? "Bob" : j.name
  @select {i.name, j.grade_2019, k.grade_2020, real_name} into s
  @group s by s.real_name into g
  @let all_grades = [g.grade_2019...; g.grade_2020...]
  @let pass = any([grade > 6 for grade in all_grades])
  @select {name = first(g.name), pass}
  @collect DataFrame
end
write_csv("real_name", results) # hide