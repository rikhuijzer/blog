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
        return Date(pubdate, dateformat"d U Y")
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
        description = pagevar(surl, :rss)
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            date = Date(pubdate, dateformat"d U Y")
        end
        write(io, """$date</i></span><b><a href="$url">$title</a></b>""")
        write(io, """<li><i class="description">$description</i></li>""")
    end
    write(io, "</ul>")
    return String(take!(io))
end
