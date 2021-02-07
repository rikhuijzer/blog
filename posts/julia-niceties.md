+++
title = "Niceties in the Julia programming language"
published = "2019-12-03"
tags = ["map", "programming"]
rss = "A quick walk through some Julia syntax and interesting features."
+++

In general I'm quite amazed by the Julia programming language.
This blog post aims to be a demonstration of its niceties.
The post targets readers who have programming experience.
To aid in the rest of the examples we define a struct and its instantiation in a variable.

```
struct MyStruct
  a::Number
  b::Number
end

structs = [MyStruct(1, 2), MyStruct(3, 4)]
```

\toc

## Functions and methods
For object-oriented programmers the distinction between a function and a method is simple.
If it is inside a class it is a method, otherwise it is a function.
In Julia we can use *function overloading*.
This means that the types of the input parameters, or *signatures*, are used to determine what <thing> should be called.
In Julia these <things> are called *methods*.
For example we can define the following methods for the function `f`.

```
julia> f(a, b) = a * b
f (generic function with 1 method)

julia> f(2, 3)
6

julia> f(a::Int64, b::String) = string(a) * b
f (generic function with 2 methods)

julia> f(2, "3")
"23"
```

One of the distinguishing features of Julia is the *multiple dispatch*.
Basically, multiple dispatch creates an unique function in the LLVM assembly language for each signature.
```
julia> @code_llvm f(2, 3)
define i64 @julia_f_35436(i64, i64) {
top:
  %2 = mul i64 %1, %0
  ret i64 %2
}

julia> @code_llvm f(2, 3.0)
define double @julia_f_35477(i64, double) {
top:
  %2 = sitofp i64 %0 to double
  %3 = fmul double %2, %1
  ret double %3
}
```
Since Julia is dynamically compiled these LLVM functions are compiled only when called for the first time.
Pretty neat I would say.
However, for most of my use cases I'm spending most of my time on typing code and not waiting for the program to finish.
The next section goes into more high-level capabilities.

## Higher-order functions
Higher-order functions either take one or more functions as arguments or return a function.
Lets start by defining some functions on the `MyStruct` struct defined at the start of this post.
In the REPL or in Jupyter (IJulia) we can inspect the struct by using the built-in help.

```
julia> ?
help?> MyStruct
search: MyStruct

  No documentation found.

  Summary
  ≡≡≡≡≡≡≡≡≡

  struct MyStruct <: Any

  Fields
  ≡≡≡≡≡≡≡≡≡

  a :: Number
  b :: Number
```
We define the following methods.
```
julia> increase_a(ms::MyStruct) = MyStruct(ms.a + 1, ms.b)
julia> decrease_a(ms::MyStruct) = MyStruct(ms.a - 1, ms.b)
```

In object-oriented languages (OOP) we would have defined these methods in some class.
When using an IDE you find these methods by typing `MyStruct.` and wait for the autocomplete to show suggestions.
In Julia you can use `methodswith`.

```
julia> methodswith(MyStruct)
2-element Array{Method,1}:
  • increase_a(data::MyStruct) in Main at REPL[3]:1
  • decrease_a(data::MyStruct) in Main at REPL[4]:1
```

Well-known higher-order functions are `map`, `filter`, and `reduce`.
These are all available.
Next we demonstrate only `filter`, `map` and some syntactic sugar for `map`.
```
julia> structs
2-element Array{MyStruct,1}:
 MyStruct(1, 2)
 MyStruct(3, 4)

julia> filter(s -> s.a == 1, structs)
1-element Array{MyStruct,1}:
 MyStruct(1, 2)

julia> map(increase_a, structs)
2-element Array{MyStruct,1}:
 MyStruct(2, 2)
 MyStruct(4, 4)

julia> increase_a.(structs)
2-element Array{MyStruct,1}:
 MyStruct(2, 2)
 MyStruct(4, 4)

julia> increase_a.(increase_a.(structs))
2-element Array{MyStruct,1}:
 MyStruct(3, 2)
 MyStruct(5, 4)
```

Another use of applying functions is when you want to define conversions on a dataset.
Suppose we want to be able to specify one or more conversions and apply this to the complete dataset.
For example, lets define two simple functions and put them in an array:

```
julia> double(x) = 2x
double (generic function with 1 method)

julia> add(x) = x + 1
add (generic function with 1 method)

julia> conversions = [double, add]
2-element Array{Function,1}:
  double
  add
```

We want to be able to apply such an array of type `Array{Function,1}` to a dataset element.
Using `map` over the function elements is not a solution, since we want the input to be an array:
```
julia> input = [3, 4]
2-element Array{Int64,1}:
  3
  4
```

We could use a `for` loop, which would look something like
```
julia> for i in input
    result = i
    for func in conversions
      result = func(result)
    end
    println(result)
  end
```
(and prints the correct answers only in a Notebook and not on the REPL).
This is way too long, especially if we would include the code to put the elements in an output array.

A much cleaner way is to apply the function composition operator (`∘`) to chain the functions in one new function.
Since the function composition is a binary operator we can use reduce to call it on more than one pair.
```
julia> map(x -> reduce(∘, conversions)(x), input)
2-element Array{Int64,1}:
  8
  10
```
(again, works only in a Notebook.)
Note that the functions are applied in reverse order.

## Unpacking

Just like in Python, there is syntax to unpack collections.
For example, lets consider a tuple:
```
julia> c = (1, 2)
(1, 2)

julia> l = [c...]
2-element Array{Int64,1}:
 1
 2
```
This list can also be unpacked:
```
julia> [9, l...]
3-element Array{Int64,1}:
 9
 1
 2
```
The most useful applications are usually when passing parameters to functions.
```
julia> z(a, b, c) = "$a | $b | $c"
z (generic function with 1 method)

julia> z(c..., 4)
"1 | 2 | 4"
```
For named tuples, the names are ignored.
```
julia> z((b = 1, d = 2)..., 3)
"1 | 2 | 3"
```

## Metaprogramming
A simple example of metaprogramming in Julia are macros.
For example, we can use `show` to print a variable name and its value:
```
julia> x = 1
x = 1

julia> @show x
x = 1
1
```

Usually source code is written in one file and tests in another.
Suppose you want to write your tests right below the functions.
Ideally we only run the tests on request and not each time we import the code.
This can be realised by using macros and apply some tinkering.
A new `DTest` module could look as follows.
`DTest` here can be read as delayed test.

```
module DTest

all_dtests = Expr[]
export all_dtests

macro dtests(ex)
  push!(all_dtests, ex)
  esc(:(dtest() = foreach(eval, all_dtests)))
end
export @dtests

end # module
```
This module basically adds an `@dtest` macro which can be used from some client.
When the client code looks like
```
@dtest
  @test 1 == 2
end
```
then the expression `@test 1 == 2` is put in the `all_dtests` array and the function `dtest() = foreach(eval, all_dtests)` is defined.
We use `esc` to ensure that the function is evaluated in the context of `Client` and not in the context of `DTest` (so that `f` and `g` are available).

To demonstrate a full example lets define a new client module.
```
module Client

include("DTest.jl")
using .DTest

g(x) = 3x
@dtests begin
  @testset "g" begin
    @test g(2) == 6
  end
end

f(x) = 2x
export f
@dtests begin
  @testset "f" begin
    @test f(3) == 6
  end
end

end # module
```
We can use and test the module as follows.
```
julia> include("Client.jl")

julia> using .Client

julia> f(3)
6

julia> Client.dtest()
Test Summary: | Pass  Total
g             |    1      1
Test Summary: | Pass  Total
f             |    1      1
```
