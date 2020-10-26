# This file was generated, do not modify it. # hide
using DataFrames

person = DataFrame(name=["Bob", "Sally", "Bob 2", "Alice", "Hank"], age=[17, 18, 17, 20, 19])
write_csv("person", person) # hide