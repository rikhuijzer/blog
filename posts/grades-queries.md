+++
title = "Grades queries"
published = "26 October 2020"
rss = "Using SQL like query syntax in Julia."
+++

**EDIT:** 
*This query syntax is nice but can be very slow for many columns, which is quite annoying when using it in a project.
Instead, checkout Tom Kwong's DataFrames [cheat sheet](https://ahsmart.com/pub/data-wrangling-with-data-frames-jl-cheat-sheet/).*

Most data in the real-world is relational, that is, there are relationships in the data.
For example, a relation could be between a table containing person names and ages and another table containing person names and grades.
If both tables are about the same persons, then there is a relationship on name between the tables.
On these kinds of data, we want to do *queries*: a request for information from the data.
An interesting request could be "give all the names, ages and grades for all the persons".

This problem of combining tables should not be solved by simply putting all the data into one big table, since you will get empty cells.
According to my former databases professor, [Paul De Bra](http://wwwis.win.tue.nl/~debra/), you should try to avoid empty cells.
This makes sense when you imagine what happens if you are going to combine many tables.
For example, when combining two tables `A` and `B` on name where `B` is missing the names of 10 persons, then the combination will have empty cells for each missing person multiplied by every column in `B`.
If `B` contains 3 columns (for example, `:weight`, `:length` and `:age`), then this basic comination will already contain $10 * 3 = 30$ empty cells.
These cells are a waste of storage and are difficult to query.

So, it is important to be able to effectively query multiple tables.
In the rest of this post, I show ways to do this in Julia with the help of the Query package.

\toc

## Example data

Lets create some relational data for some fictional students who could do an exam in 2019 and 2020.

```julia:./preliminaries.jl
# hideall
import CSV
write_csv(name, data) = CSV.write(joinpath(@OUTPUT, "$name.csv"), data)
```

```julia:./person.jl
using DataFrames

person = DataFrame(name=["Bob", "Sally", "Bob 2", "Alice", "Hank"], age=[17, 18, 17, 20, 19])
write_csv("person", person) # hide
```
\output{./person.jl}
\tableinput{}{./person.csv}
```julia:./grades_2019.jl
grades_2019 = DataFrame(name=["Sally", "Bob", "Alice", "Hank"], grade_2019=[1, 5, 8.5, 4])
write_csv("grades_2019", grades_2019) # hide
```
\tableinput{}{./grades_2019.csv}

```julia:./grades_2020.jl
grades_2020 = DataFrame(name=["Bob 2", "Sally", "Hank"], grade_2020=[9.5, 9.5, 5])
write_csv("grades_2020", grades_2020) # hide
```
\tableinput{}{./grades_2020.csv}

## Naive approach

Say, we would like to obtain a table combining the names and ages with the grades of 2019.
A naive approach would be to write

```julia:./naive.jl
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
```

\tableinput{}{./naive.csv}

Now imagine having to combine multiple tables.
The code will quickly become tedious.

## Join

Instead, we can obtain the same output by using [Query.jl](https://github.com/queryverse/Query.jl).
The Query package has two styles.
One style is very similar to [dplyr](https://dplyr.tidyverse.org/) from Tidyverse.
The other style is Language Integrated Query (LINQ) style (documentation [here](https://www.queryverse.org/Query.jl/stable/linqquerycommands/)).
LINQ style is the style I'm using, since I find it the most intuitive of the two.
So, to obtain the previous table again, we can write

```julia:./simple_join.jl
using Query

write_csv("simple_join", # hide
@from i in person begin
  @left_outer_join j in grades_2019 on i.name equals j.name
  @select {i.name, i.age, j.grade_2019}
  @collect DataFrame
end
) # hide
```

\tableinput{}{./simple_join.csv}

Here, the `@left_outer_join` ensures that all the persons in `person` have one row in the final output. 
A normal `@join` would omit the row for Bob 2, because Bob 2 is not in the `grades_2019` table.
```julia:./normal_join.jl
write_csv("normal_join", # hide
@from i in person begin
  @join j in grades_2019 on i.name equals j.name
  @select {i.name, i.age, j.grade_2019}
  @collect DataFrame
end
) # hide
```
\tableinput{}{./normal_join.csv}

The joins can be combined to see who did the exam twice and by how much the grade is increased on the second try.

```julia:./increase.jl
write_csv("increase", # hide
@from i in person begin
  @left_outer_join j in grades_2019 on i.name equals j.name
  @left_outer_join k in grades_2020 on i.name equals k.name
  @select {i.name, j.grade_2019, k.grade_2020, 
    increase=k.grade_2020 - j.grade_2019}
  @collect DataFrame
end
) # hide
```
\tableinput{}{./increase.csv}

or who passed the course

```julia:./passed.jl
write_csv("passed", # hide
@from i in person begin
	@left_outer_join j in grades_2019 on i.name equals j.name
	@left_outer_join k in grades_2020 on i.name equals k.name		
	@select {i.name, passed=j.grade_2019 > 6 || k.grade_2020 > 6}
  @collect DataFrame
end
) # hide
```
\tableinput{}{./passed.csv}

## Debugging tips

Before going to more difficult examples, it is helpful to look what is happening inside the join.
Printing all the rows can aid in solving errors.

```julia:./debug.jl
write_csv("debug", # hide
@from i in person begin
  @join j in grades_2019 on i.name equals j.name
  @select {i, j}
  @collect DataFrame
end
) # hide
```
\tableinput{}{./debug.csv}

So, basically the join puts the two tables next to each other and inside the select we just get the name if we type `i.name`. 
Also note that the result of `i.name` would be the same as `j.name`, as expected.

## Grouping

Like in most real-world datasets, this dataset contains a mistake.
Bob complained that he had, in fact, passed the course.
His second grade is listed for the name Bob 2.
This, in LINQ, is called grouping. 
Basically, grouping can *group* multiple rows into one.
This example is, unfortunately, quite involved, but I was unable to come up with a simpler example for which the output makes sense too.

Lets first add a row to add a "real" name for every row so that these real names can be grouped.
Here, the `let` command is just a nice way to move the definition of `real_name`, `all_grades` and `pass` out of the `select`. 
The `into` command is required by `group` to clarify that we move on to a new variable.
Without `into`, multiple variables, such as `i` and `j`, can be accessed on the same line.
However, grouping throws some table rows away.
This means that variables from before the `group` aren't pointing to the same row as the variables after `group`. 
In the `select`, I have used `into s` to make `s.real_name` available to the `group` command.

```julia:./real_name.jl
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
```
\output{./real_name.jl}
\tableinput{}{./real_name.csv}

## Filtering and sorting

Of course, the most interesting part of this example is to obtain all the names for the people who passed the course and it would be nice to have this in alphabetical order.
Specifically, we want to filter such that we obtain only the people *where* `pass == true`.

```julia:./pass.jl
graduates = # hide
@from i in results begin
  @where i.pass == true
  @orderby ascending(i.name)
  @select {i.name}
  @collect DataFrame
end
write_csv("graduates", graduates) # hide
```
\output{./pass.jl}
\tableinput{}{./graduates.csv}

