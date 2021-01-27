# This file was generated, do not modify it. # hide
# hideall
using Pkg

io = IOBuffer()
Pkg.status(; io)
text = String(take!(io))
lines = split(text, '\n')[3:end-1]
lines_without_id = [l[14:end] for l in lines]
list = join(lines_without_id, '\n')
println(list)