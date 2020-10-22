@def title = "Highlights of my NixOS configuration"
@def published = "1 December 2019"
@def tags = ["libsecret", "fish"]

I have recently started paying attention to the time spent on fine-tuning my Linux installation.
My conclusion is that it is a lot.
Compared to Windows I save lots of time by using package managers to install software.
Still, I'm pretty sure that most readers spend (too) much time with the package managers as well.
This can be observed from the fact that most people know the basic `apt-get` commands by heart.

At the time of writing I'm happily running and tweaking NixOS for a few months.
NixOS allows me to define my operating system state in one configuration file `configuration.nix`.
I have been pedantic and will try to avoid configuring my system outside the configuration.
This way multiple computers are in the same state and I can set-up new computers in no time.
The only manual steps have been NixOS installation, Firefox configuration, user password configuration and applying a system specific configuration.
(The latter involves creating two symlinks.)

In general there are the following things which are great.

- Deterministic package system.
Packages are immutable and NixOS will basically create symlinks to the packages.
This has some great implications.
  - Easy rollbacks.
    NixOS will just symlink to the "old" version again.
  - System usable during upgrade.
    For example, a Firefox upgrade is basically getting a new immutable Firefox binary and symlinking to the new binary.
    The old binary remains available until it is garbage collected.
    So, in practise you use the old binary until you restart the program.
- Ease of contribution to package system.
It is relatively easy to contribute to the [Nix Packages collection](https://github.com/NixOS/nixpkgs).
This results in a large number of available and well-maintained packages.
Compared to the Debian packages it is a major improvement.
I'm often surprised by the fact that some obscure tool is actually available in NixOS.
- Nix expression language.
The Nix expression language is declarative.
It will basically read all the code and collect it in a data structure.
Only when this is complete the system state will be changed.
This means that the language does not care about order or duplication.
In effect this eases refactoring, and avoids checking "preconditions".
To explain the latter consider writing a script which assumes `ripgrep` to be installed.
The language allows for defining such requirements multiple times.
So, even when removing the `ripgrep` requirement at other places, it will still be available for my script.

Below are some of what I consider highlights of the configuration.

\toc 

## Font installation
Most Linux distributions lack pretty fonts.
You'll notice this when, for example, browsing the web.
I found installing fonts to be difficult at times, even in Ubuntu.
For NixOS it could not be easier:

```nix
# /etc/nixos/configuration.nix

fonts.fonts = with pkgs; [
  hermit
  source-code-pro
];
```

## Shell functions
At one point using abbreviations or aliases is not going to be enough and functions are needed.
This should be possible by defining Fish functions directly.
I have not yet been successful in doing that declaratively.
A workaround is as follows.
```nix
# /etc/nixos/configuration.nix

import = [
  ./scripts.nix
];
```
```nix
# /etc/nixos/scripts.nix

let
  fish-shebang = "#!${pkgs.fish}/bin/fish";
  define-script = name: script: pkgs.writeScriptBin name script;
  define-fish-script = name: script: define-script name (fish-shebang + "\n\n" + script);
in {
  environment.systemPackages = [
    (define-fish-script "decrypt-folder" ''
      if test (count $argv) -eq 0
        echo "usage: decrypt-folder <folder>"
        exit
      end

      set name (string replace -r "\.tar\.gz\.gpg" "" $argv[1])

      gpg $name.tar.gz.gpg
      tar -xzf $name.tar.gz
      rm $name.tar.gz
    '')

    (define-fish-script "git-add-commit-push" ''
      git add .
      git commit -m "$argv[1]"
      git push
    '')
  ];
}
```
For the latter it is convenient to add the abbreviation
```nix
abbr gacp 'git-add-commit-push'
```
to the Fish shell configuration.

Another great thing about this setup is the ease of looking up commands.
Often I find myself in need of some bash code which I have used in one of the scripts.
To see the code from the terminal in Fish, use `cat (which <script>)`.
For example, `cat (which git-add-commit-push)` gives

```
$ cat (which git-add-commit-push)
#!/nix/store/ajwff4bi6mp2n7517ps890rnk4xgzj4r-fish-3.0.2/bin/fish

git add .
git commit -m "$1"
git push
```

## Home Manager
Actually, [Home Manager](https://github.com/rycee/home-manager) is not the prettiest part of NixOS.
It seems to be an extension of the configuration provided by the vanilla operating system.
The installation instructions on Github advise to do all kind of mutation operations.
To avoid this we import the folder `home-manager` somewhere in our configuration.
```nix
# /etc/nixos/configuration.nix

imports = [
  ./home-manager
];
```
This works only if our folder contains a `default.nix` file.
So, lets create that and import home-manager.
Here the version (ref) is fixed to `19.09`.
(You can decide to not fix the version.
However, it might cause your system to suddenly break one day.)
The imports below the `fetchGit` line define specific home-manager configurations.
```nix
# /etc/nixos/home-manager/default.nix

imports = [
  "${builtins.fetchGit {
    url = "https://github.com/rycee/home-manager";
    ref = "f856c78a4a220f44b64ce5045f228cbb9d4d9f31";
  }}/nixos"

  ./git.nix
];
```

## Git credentials
Storing Git credentials took me way too long to figure out.
So, here it is.
To use the Git credential helper libsecret (gnome-keyring) write
```nix
# /etc/nixos/home-manager/git.nix

environment.systemPackages = [
  pkgs.gitAndTools.gitFull # gitFull contains libsecret.
]

home-manager.users.rik.programs.git = {
  enable = true;

  # Some omitted settings.

  extraConfig = {
    credential.helper = "libsecret";
  };
};
```

## R
The R programming language is a language with built-in support for package installations.
R is immutable in NixOS.
To install packages two wrappers are provided.
One for R and one for RStudio.
Next an example is given to configure R and RStudio with various packages from CRAN, and one package built from GitHub source.
Specifying the package from GitHub in the NixOS configuration avoids having to run `devtools::install_github("<repository>")` on each computer.

```nix
# /etc/nixos/r.nix
{ pkgs, ... }:
with pkgs;
let
  papajaBuildInputs = with rPackages; [
    afex
    base64enc
    beeswarm
    bookdown
    broom
    knitr
    rlang
    rmarkdown
    rmdfiltr
    yaml
  ];
  papaja = with rPackages; buildRPackage {
  name = "papaja";
  src = pkgs.fetchFromGitHub {
    owner = "crsh";
    repo = "papaja";
    rev = "b0a224a5e67e1afff084c46c2854ac6f82b12179";
    sha256 = "14pxnlgg7pzazpyx0hbv9mlvqdylylpb7p4yhh4w2wlcw6sn3rwj";
    };
    propagatedBuildInputs = papajaBuildInputs;
    nativeBuildInputs = papajaBuildInputs;
  };
  my-r-packages = with rPackages; [
    bookdown
    dplyr
    papaja
  ];
  R-with-my-packages = pkgs.rWrapper.override{
    packages = my-r-packages;
  };
  RStudio-with-my-packages = rstudioWrapper.override{
    packages = my-r-packages;
  };
in {
  environment.systemPackages = with pkgs; [
    R-with-my-packages
    RStudio-with-my-packages
  ];
}
```
