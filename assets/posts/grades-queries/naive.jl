# This file was generated, do not modify it. # hide
function combine(row)
  name = row.name
  age = row.age
  matches = filter(x -> x.name == name, grades_2019)
  grade_2019 = nrow(matches) != 0 ? first(matches).grade_2019 : missing
  DataFrame(name = name, age = age, grade_2019 = grade_2019)
end
rows = combine.(eachrow(person))
write_csv("naive", # hide
vcat(rows...)
) # hide