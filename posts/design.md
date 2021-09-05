+++
title = "Design cheatsheet"
published = "2020-11-29"
tags = ["design"]
rss = "A summary of design tips and tricks."
image = "/assets/self.jpg"
+++

I like to complain that design can distract from the main topic and is therefore not important.
However, design is important.
If your site, presentation or article looks hideous, then you already are one step behind in convincing the audience.
The cheatsheet below can be used to quickly fix design mistakes.

\toc

## Colors

Suprisingly, you should [Never Use Black](https://ianstormtaylor.com/design-tip-never-use-black/).
Instead you can use a colors which are near black.
For example:

Tint | HTML color code | Example text
--- | --- | ---
Pure black | #000000 | ~~~<p style="color: #000000"> Lorem ipsum dolor sit amet </p> ~~~
Grey | #4D4D4D | ~~~<p style="color: #4D4D4D"> Lorem ipsum dolor sit amet </p> ~~~
Green | #506455 | ~~~<p style="color: #506455"> Lorem ipsum dolor sit amet </p> ~~~
Blue | #113654 | ~~~<p style="color: #113654"> Lorem ipsum dolor sit amet </p> ~~~
Pink | #564556 | ~~~<p style="color: #564556"> Lorem ipsum dolor sit amet </p> ~~~

## Spacing

~~~
<style>
li {
  font-size: 19px;
}
.less-narrow li {
  line-height: 40px;
}
.too-narrow {
  line-height: 18px;
}
</style>
~~~
More spacing is [more better](https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-1.html#rule-3-double-your-whitespace).
Compare 
~~~
<div class="too-narrow">
~~~
> - [Link 1](https://example.com)
> - [Link 2](https://example.com)
> - [Link 3](https://example.com)
~~~
</div>
~~~
to
~~~
<div class="less-narrow">
~~~
> - [Link 1](https://example.com)
> - [Link 2](https://example.com)
> - [Link 3](https://example.com)
~~~
</div>
~~~

For texts, compare

~~~
<div class="too-narrow">
~~~
> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
~~~
</div>
~~~

to

> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

## Fonts and sizes

The default font for most sites is too small.
For text-heavy pages, the default can be bumped easily to `18px` [or bigger](https://learnui.design/blog/mobile-desktop-website-font-size-guidelines.html).
Medium.com goes to `21px` on desktop and `18px` on mobile.
I would advise against optimizing your site to particular devices, because it complicates development considerably.
For more arguments against media queries, see [Media Queries are a Hack](https://ianstormtaylor.com/media-queries-are-a-hack/).

At the same time, decrease the font size for items which cannot wrap around and/or are not as important as the main text such as tables and code blocks.
Users should see the most important stuff first.
To see what users will see first, use the [squint test](https://learnui.design/blog/squint-test-ui-design-case-study.html).
