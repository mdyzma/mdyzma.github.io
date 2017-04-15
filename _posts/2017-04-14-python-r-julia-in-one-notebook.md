---
layout:     post
author:     Michal Dyzma
title:      "Python, R and Julia in one notebook!"
date:       2017-04-14 14:51:25 +0200
comments:   true
categories: python R julia jupyter
keywords:   python, R, Julia, jupyter notebook
---

Goal
----
Create environment where different Jupyter kernels are available and data may be passed between them. Kernels chosen for demonstration: Python 2, Python 3, R and Julia.

Rationale
---------
What language, which program to chose for data science? Which one is better? Python? R? Maybe Julia? Which should I use? All have advantages and weaknesses. Python is more general programming language, R has strong community support in math and statistics. Julia is strongly typed, uber fast...

This question and answers often appear in discussions. So which one?

There is no good answer to this questions. If you want do big things use all tools available. Use best tools possible. Nothing more, nothing less.

If you struggle between using python or R, don't! Why not use both?! At the same time in the same notebook, passing data structures between languages and perform analysis with the best tools they can offer. With Jupyter notebook it is all possible. It is possible to add even more players to the game. Julia, Haskel, Lua, bash, Octave... Pick whatever you can... Currently Jupyter supports nearly 100 different kernels (check [here][kernels]).

For ther purpose of this small experiment I have chosen four most used kernels:

* python 2.x
* python 3.x
* R
* Julia


Let's do it
-----------






Whenever I am reading some data science related groups on reddit, quora or wykop (Polish site) i can often see 



{% highlight python %}
def print_hi(name)
  print("Hi, {0}".format(name))

print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

[kernels]: https://github.com/jupyter/jupyter/wiki/Jupyter-kernels
