function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function hfun_timestamp_now()
    return string(Dates.now()) * "+00:00"
end

"""
    {{blogposts}}

Plug in the list of blog posts contained in the `/posts` folder.
Souce: <https://github.com/abhishalya/abhishalya.github.io>.
"""
function hfun_blogposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("posts")
    filter!(endswith(".md"), list)
    function sorter(p)
        ps  = splitext(p)[1]
        url = "/posts/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, :published)
        if isnothing(pubdate)
            return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
        end
        return Date(pubdate, dateformat"yyyy-mm-dd")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    write(io, """<ul class="blog-posts">""")
    for (i, post) in enumerate(list)
        if post == "index.md"
            continue
        end
        ps  = splitext(post)[1]
        write(io, "<li><span><i>")
        url = "/posts/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, :title)
        pubdate = pagevar(surl, :published)
        description = pagevar(surl, :rss_description)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"yyyy-mm-dd")
        end
        write(io, """$date</i></span><b><a href="$url">$title</a></b>""")
        write(io, """<li><i class="description">$description</i></li>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end

# Based on https://github.com/tlienart/Franklin.jl/pull/799.
function hfun_rss()
    rss = locvar(:rss)::String
    descr = fd2html(rss; internal=true, nop=true)
    Franklin.set_var!(Franklin.LOCAL_VARS, "rss_description", descr)
    return "<p>$descr</p>"
end

"""
    hfun_requiredfill(params::Vector{String})

Return the value for the field, just like `fill`, but throws an assertion error if the value is not given.
"""
function hfun_requiredfill(params::Vector{String})::String
    value = Franklin.hfun_fill(params)
    field = params[1]
    @assert(value != "", "Missing a value for the field $field")
    return value
end

"""
    lx_pluto(com, _)

Embed a Pluto notebook via:
https://github.com/rikhuijzer/PlutoHTML.jl
"""
function lx_pluto(com, _)
    file = string(Franklin.content(com.braces[1]))::String
    path = joinpath("posts", "notebooks", "$file.jl")
    log_path = joinpath("posts", "notebooks", "$file.log")

    return """
        ```julia:pluto
        # hideall

        using PlutoHTML: notebook2html

        path = "$path"
        log_path = "$log_path"
        @assert isfile(path)
        @info "→ evaluating Pluto notebook at (\$path)"
        html = open(log_path, "w") do io
            redirect_stdout(io) do
                html = notebook2html(path)
                return html
            end
        end
        println("~~~\n\$html\n~~~\n")
        ```
        \\textoutput{pluto}
        """
end
