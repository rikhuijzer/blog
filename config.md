+++
generate_rss = true
website_title = "Huijzer"
website_descr = "A blog about statistics, programming and more"
website_url = "https://huijzer.xyz"

author = "Rik Huijzer"

# Used in the footer.
day = today()

mintoclevel = 2
+++

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
