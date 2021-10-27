function evaluate_notebook()
    notebook = Notebook([
        Cell("using CairoMakie"),
        Cell("lines(0:10, 0:10)"),
        Cell("x = 1 + 1"),
        Cell("x + 1")
    ])
    session = ServerSession()
    cells = [last(e) for e in notebook.cells_dict]
    update_run!(session, notebook, cells)
    return notebook
end

function filter_generated_html(html)
    lines = split(html, '\n')
    filter!(!contains("firebase"), lines)
    filter!(!contains("html lang"), lines)
    filter!(!contains("<head>"), lines)
    filter!(!contains("<title>"), lines)
    filter!(!contains("DOCTYPE"), lines)
    # filter!(!contains("<meta"), lines)
    filter!(!contains("</head>"), lines)
    filter!(!contains("</html>"), lines)
    lines = lstrip.(lines)
    html = join(lines, '\n')
    # html = replace(html, "<body class=" => "<div class=")
    # html = replace(html, "</body>" => "</div>")
    return html
end

"""
    notebook2html(notebook)

Convert Pluto notebook to HTML.
"""
function notebook2html()
    # notebook_file = "/home/rik/git/huijzer.xyz/posts/notebooks/nested-cv.jl"
    notebook_file = "/home/rik/Downloads/tmp.jl"
    notebook = load_notebook_nobackup(notebook_file)
    html = generate_html(notebook)
    return filter_generated_html(html)
end

function code_block(code)
    if code == ""
        return ""
    end
    return """<pre><code class="language-julia">$code</code></pre>"""
end

function output_block(code)
    return """<pre><code class="code-output">$code)</code></pre>"""
end

# Consider moving this code to Pluto.jl/Franklin.jl/FranklinUtils.jl once it works.
function _output2html(body, ::MIME"image/png")
    return "png"
end

function _output2html(body, ::MIME"text/plain")
    return output_block(body)
end

function _code2html(code::AbstractString)
    if contains(code, "# hideall")
        return ""
    end
    return code_block(code)
end

function _cell2html(cell::Cell)
    code = _code2html(cell.code)
    output = _output2html(cell.output.body, cell.output.mime)
    return """
        $code
        $output
        """
end

function evaluatednotebook2html(notebook)
    order = notebook.cell_order
    outputs = [_cell2html(notebook.cells_dict[cell_uuid]) for cell_uuid in order]
    return join(outputs, '\n')
end

function write_notebook2html()
    html = notebook2html()
    write("/home/rik/git/huijzer.xyz/posts/notebooks/tmp.html", html)
    return nothing
end

