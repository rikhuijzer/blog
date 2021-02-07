+++
title = "A description of CI/CD without the sales departement"
published = "2021-02-07"
tags = ["automation", "workflows", "git"]
rss = "Linking computations to text"
+++

Continuous integrations (CI) and continous delivery (CD) allow software developers to make fewer mistakes by validating code changes automatically before applying them in the codebase.
This is, unhelpfully, elaborated on by [GitLab](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/): CI/CD is about ensuring "the delivery of CI-validated code [...] via structured deployment pipelines".

This sounds complex, but actually isn't.
In this post, I'll describe what CI/CD **actually** is.

CI arose from the need to test code changes automatically.
This is linked to Git.
Upon each code change, a server takes the code and runs all the tests.
When the tests pass, you can be more sure that the changes are correct;
when the tests fail, you know that something is broken.
This is particulary helpful for code reviews when deciding whether the changes should be merged in the codebase.

**TODO:** Add image with green GitHub checkmark on PR.

CD is also about running computations upon code changes.
This time however, the computations can do things like compiling the code into an executable.
The executable can then continuously be delivered to the end-user, hence the name CD.

Interestingly enough, this idea is much more powerful than just CI/CD, which is why GitHub calls it [GitHub Actions](https://github.com/home/) to "automate anything".
(You can read this as: *automate anything which can be controlled, directly or indirectly, from a computer capable of running the GitHub runner*.)
Like mentioned before, upon each code change we can

- run tests, and/or
- compile a program, 

but we can also

- generate a website (like the one you're looking at right now),
- generate a [book](https://github.com/hadley/r4ds), or
- run a backup.

**TODO:** Add Compose.jl image here.

In essence, CI/CD and Workflows are about **linking computations to text**.



(Actually, you can automate anything which can be managed by a GitHub runner; this includes most, but not all, systems.)

