---
layout:     post
author:     Michal Dyzma
title:      "Part 6: Application deployment"
subtitle:   Build and deploy app python package
date:       2017-04-17 01:18:53
comments:   true
categories: biostudio python PyPI setuptools
keywords:   python, biostudio, PyPI, setuptools
---

In __Part 6__ I will describe how to build python package, which can be installed on any Windows and Linux platform using popular python package managers like pip or conda.


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


