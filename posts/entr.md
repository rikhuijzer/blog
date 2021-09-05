+++
title = "Entr"
published = "2019-10-29"
tags = ["shortcut", "compile", "run"]
rss = "A tool for executing commands automatically upon file changes."
image = "/assets/self.jpg"
+++

Having a compile and run shortcut seems like the most basic requirement for a developer.
Most fully fledged IDE's therefore include it.
For example, PyCharm will automatically detect the main file for the current Python project and run it with the correct virtual environment.
This is all nice and well until it does not work out of the box.
For example, when working with LaTeX most text editors can install a plugin which introduces a compile and run shortcut.
Or, if you are lucky you can write down some script at some place in the editor which will execute upon a certain key press.
This works as long as your static script is able to infer the correct file to execute.
If not then the editor command needs to be changed for each project.

With this post I would like to inform people about a simple solution, namely `entr`.
The [entr](http://eradman.com/entrproject/) tool can be set-up to execute a command if one or more files change.
The tool is available in at least the Ubuntu and Nix package managers.
For NixOS simply add `pkgs.entr` to `environment.systemPackages`.

## Examples

For running a Python program where the main function is located in `MyProject.py` use

```bash
find . -iname "*.py" | entr python MyProject.py
```

and for LaTeX

```bash
find . -iname "*.tex" -o -iname "*.bib" | entr latexmk -f -pdf
```

## Fine tuning

When using some shell with a reverse search this works reasonably convenient.
It can be more convenient by adding the command as an abbreviation.
(Or alias if you must, but this has [some drawbacks](https://www.sean.sh/log/when-an-alias-should-actually-be-an-abbr/).)
To your Fish shell init script you could add

```
abbr el 'find . -iname "*.tex" -o -iname "*.bib" | entr latexmk -f -pdf'
```

To speed up things even more when using Vim add the following shortcuts to the Vim configuration

```
nmap <C-s> :wa<CR>
imap <C-s> <ESC>:wa<CR>i
```
After setting these all open buffers will be saved when pressing `Ctrl + s`.
