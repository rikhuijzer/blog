+++
title = "Writing checklist"
published = "29 July 2020"
tags = ["checklist", "writing"]
description = "A list to quickly check for common mistakes in writing."
+++

I keep forgetting lessons about writing.
After writing a text, my usual response is to declare it as near perfect and never look at it again.
In this text, I will describe a checklist, which I can use to quickly debunk the declaration.
I plan to improve this checklist over time.
Hopefully, text which passes the checklist in a few dozen years from now will, indeed, be near perfect.

The list is roughly ordered by importance.
The text should:

1. Ensure that the writing is [valuable to the community of readers](/posts/writing-effectively).
1. Be polite, that is, not contain a career limiting move. For example, do not "write papers proclaiming the superiority of your work and the pathetic inadequacy of the contributions of A, B, C, ..." \citep{wadge2020}.
1. Be made as simple as possible, but not simpler[^simple]. This is also known as [Occam's razor](https://en.wikipedia.org/wiki/Occam%27s_razor), [kill your darlings](https://thewritepractice.com/kill-your-darlings/) or the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle).
1. Be consistent. For example, either use the Oxford comma in the entire text or do not use it at all.
1. Avoid misspellings.
1. Avoid comma splices.
1. Flow naturally; just like a normal conversation. This is, for me, contradictory to [writing when programming](#writing-when-programming).
1. Provide a high-level overview of the text. This can be a summary, abstract, a few sentences in the introduction or a combination of these.
1. Prefer common collocations. A list of common collocations is [The Academic Collocation List](http://pearsonpte.com/wp-content/uploads/2014/07/AcademicCollocationList.pdf).
1. Use simple verbs, for example, prefer "stop" over "cease to move on" or "do not continue".
1. Avoid dying metaphors such as "stand shoulder to shoulder with" \citep{orwell1946}. Metaphors aim to "assist thought by evoking a visual image" \citep{orwell1946}. Dying metaphors do not evoke such an image anymore due to overuse \citep{orwell1946}.
1. Avoid pretentious diction such as dressing up simple statements, inappropriate adjectives and foreign words and expressions \citep{orwell1946}. For example, respectively "effective", "epic" and "status quo" \citep{orwell1946}.
1. Avoid meaningless words, that is, words for which no clear definition exists. For example, "democracy" and "freedom" have "several different meanings which cannot be reconciled with one another" \citep{orwell1946}.

## Writing when programming
In programming, one of the main goals is to avoid code duplication.
Code is deduplicated by introducing functions.
This deduplication is good, but can introduce functions which meaning can only be explained as a helper for deduplication.
For example,

```
f("A")
g("A")
f("B")
g("B")
...
```
is replaced by
```
process(s) = f(s); g(s)

process("A")
process("B")
...
```

Programmers are used to these kind of functions.
However, outside of programming duplication is allowed if it improves readability.
Synonyms should be used to avoid boring the reader with the duplicates.

[^simple]: This statement is likely to be attributed to Einstein \citep{quote2011}.

## References

\biblabel{orwell1946}{Orwell (1946)}
Orwell, George (1946).
Politics and the English Language.
Retrieved July 29, 2020, from <https://www.orwell.ru/library/essays/politics/english/e_polit>

\biblabel{wadge2020}{Wadge (2020)}
Wadge, B. (2020).
The Secret of Academic Success – or fun filled failure if you prefer.
Bill Wadge’s Blog.
Retrieved July 29, 2020, from <https://billwadge.wordpress.com/2020/02/06/the-secret-of-academic-success-or-fun-filled-failure-if-you-prefer>

\biblabel{quote2011}{Quote Investigator (2011)}
Quote Investigator. (2011).
Everything Should Be Made as Simple as Possible, But Not Simpler
Retrieved July 29, 2020, from <https://quoteinvestigator.com/2011/05/13/einstein-simple/>
