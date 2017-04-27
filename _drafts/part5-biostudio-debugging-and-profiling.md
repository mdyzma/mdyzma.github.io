---
layout:     post
author:     Michal Dyzma
title:      "Part  5: Debugging and profiling the code"
date:       2017-04-16 01:15:08
comments:   true
categories: biostudio implementation python
keywords:   biostudio, implementation, python
---

In __Part 5__ I will ...


## About project

This is series of articles explaining entire development process, including best practices and solutions used in corporate projects. From preparing  software specifications to fully functional software deployed to the PyPI repository. Final product will be GUI application for Protein Data Bank ```.pdb``` files editor, which carry information about molecule 3D structure.

-----
_Series consists of:_

* [Part 1: Application designs]({{site.url}}/2017/04/21/part1-biostudio-application-design/)
* [Part 2: Setting up work environment]({{site.url}}/2017/04/13/part2-biostudio-setting-up-environment/)
* [Part 3: Test Driven Development]({{site.url}}/2017/04/14/part3-biostudio-design-implementation-tdd/)
* [Part 4: Low Level Design implementation]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/)

-----


## Setting virtual environment and version control



Virtual environment can be managed using two fantastic tools:

1) virtualenv
2) conda

Here I will use virtualenv. Lets create clean environment with latest python 3:

```virtualenv ```

## IDE

What language, which program to chose for data science? Which one is better? Python? R? Maybe Julia? Which should I use? All have advantages and weaknesses. Python is more general programming language, R has strong community support in math and statistics. Julia is strongly typed, uber fast...


## CI and workflow

There is no need to convince anyone, that automated workflow can 
