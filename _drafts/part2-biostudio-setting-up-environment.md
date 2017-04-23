---
layout:     post
author:     Michal Dyzma
title:      "Part 2: Setting up work environment"
date:       2017-04-13 01:15:08
comments:   true
categories: biostudio workflow python
keywords:   biostudio, workflow, python
---

In __Part 2__ I will set up and show how to manage virtual environments for python (development, production). Initiate version control and software version automation system. Additionally I will set up continuous integration service using GitLab, which will include automatic testing and documentation update every time update s pushed to the master branch of the software repository.

## Introduction

This series describes entire development process, including best practices and solutions used in corporate projects. From describing  app specification to fully functional software deployed to the PyPI repository. Application for reading and editing ```.pdb``` files, which carry information about protein atoms localization in 3D space.

-----
_Please note, that this post is part of a series of articles. All articles are linked below:_

* [Part 1: Application design, good practices]({{site.url}}/2017/04/12/part1-biostudio-application-design/)
* [Part 2: Setting up work environment]({{site.url}}/2017/04/13/part2-biostudio-setting-up-environment/)
* [Part 3: Design implementation, TDD]({{site.url}}/2017/04/14/part3-biostudio-design-implementation-tdd/)
* [Part 4: Design implementation, continue]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle, issues, bugs, enhancements]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics - measuring code quality]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/)

----

## Setting virtual environment and version control/automation


Virtual environment can be managed using two fantastic tools:

1) virtualenv
2) conda

Here I will use virtualenv. Lets create clean environment with latest python 3:

```virtualenv ```

## IDE

What language, which program to chose for data science? Which one is better? Python? R? Maybe Julia? Which should I use? All have advantages and weaknesses. Python is more general programming language, R has strong community support in math and statistics. Julia is strongly typed, uber fast...


## CI and workflow

There is no need to convince anyone, that automated workflow can 

## Unit tests


## Documentation

Self documenting code from _docstrings_. In this project Sphinx framework will generate quality documentation each time update is being pushed to the project master.

__If you have any comments, or ideas how to improve this tutorial, please let me know by leaving a post below, or contacting me via email.__
