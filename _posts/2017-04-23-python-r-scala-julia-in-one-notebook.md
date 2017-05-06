---
layout:     post
author:     Michal Dyzma
title:      "Python, R, Scala and Julia in one Notebook"
date:       2017-04-23 14:51:25 +0200
comments:   true
categories: python R Scala Julia jupyter-notebook
keywords:   python, R, Scala, Julia, jupyter notebook, data science
---

How to create versatile environment, in which different languages are available and able to communicate with each other? Without changing program you work with and where data may be passed between specific structures characteristic for specified languages? This post will show you how to do it with four most powerful languages used in Data Science: __Python__, __R__, __Scala__ and __Julia__.


## Introduction

It is hard to choose "right" language for data analysis, especially if you are beginner and do not want to go into details about strengths and weaknesses of particular solutions. Should I choose R or python (2 or 3), maybe Julia would be faster?  What should I use to work with large data sets? My answer is: use what you can! Take the best you can from several languages and make it work. This post will show you how.

> Use what you can! Take the best you can!

For demonstration I have chosen current versions of:


| Language              | | Version    |
|------------           | |---------   |
| [python 2][python2]   | | __2.7.13__ |
| [python 3][python3]   | | __3.6.1__  |
| [R][rlang]            | | __3.4.0__  |
| [Scala][scala]        | | __2.12.2__ |
| [Julia][julia]        | | __0.5.1__  |


## Procedure

We will follow this procedure to prepare work environment:

    1. install Python interpreter
    2. install R language
    3. install Scala and sbt
    4. 
1.2 install python 2 in env
2.1 install R z condy
2.2 install R z RSTUDIO
3.1 Install Scala language or sbt
3.2 install iscala
4.1 Install Julia language
4.2 install ijulia

So our goal is to: install Python, Scala, Julia and R on our machine. Additionally to run notebooks in languages other than Python, such as R, Scala or Julia, we need to install specific middle-ware called kernels. 

First we shall grab necessary tools - compilers and interpreters for each language (linked in table above). All languages presented here are multi-platform and can be installed on Windows, Linux and OSX machines. 

## Python interpreter

I assume you have basic knowledge of python flavors available today and their strengths and weaknesses. In this tutorial basic python is __python 3__ running on __fedora 25__ workstation. 

Moreover I have chosen specific distribution of python, prepared by Continuum Analytics called [Anaconda][anaconda]. It is the most comprehensive and free bundle of python software dedicated to do __Data Science__.

<!-- {% include note.html content = "Python 3 only" %} -->

I strongly recommended to use [Anaconda distribution][anaconda], which will install python interpreter, the Jupyter Notebook, and several other packages commonly used in data science. If you choose Anaconda 3, your interpreter will be of version 3.6 (current version) or higher. 

Python branch 2.7.x is currently considered a legacy code and it's support will drop in 2020 (see: [PEP 373][pep373]). There will be no official bug fixes after that date. Additionally most of the currently used libraries are able to run on python 3. Unless you have some obscure dependency, there is no excuse not to use python 3. Python 2 is included here just for the sake of keeping backward compatibility with some old scripts,  and to demonstrate how to manage different python versions.

> There is no excuse not to use Python 3 anymore. Grab it! Use it!

In many Linux distributions python 3.x is accessible by using `python3` command, but it cumbersome to manage both python versions and calls to them from the system level. There is much easier way to manage python instances and it is called __virtual environments__.



Python 2 interpreter

Python 3 interpreter

Scala / sbt

R-lang

Scala compiler


You can find detailed instructions about [R](http://www.jason-french.com/blog/2013/03/11/installing-r-in-linux/) or [Julia](https://julialang.org/downloads/platform.html) in blog posts I found in the Internet. If it comes to python...

## Kernels installation
### Installing additional Ipykernel


So, depending on which Anaconda version you had to compose new environment with additional python interpreter. To check conda versionfirst and which , you have to either install 


Anaconda team did great job keeping R language available almost out of the box. 



### Installing IRkernel with conda

Conda can access different repositories by specifying `--chanel` or `-c` flag when calling install option. To install most popular R packages ported to be used from python you can use official Continuum R repo:

```conda install -c r r-essentials```

This command should install dosens of R packages and will make R kernel available to you when you run jupyter notebook.  For more information go to [R with conda](https://conda.io/docs/r-with-conda.html).

Simple and efficient. If you want to go hard way check next section.

### Installing IRkernel from R

We will soon submit the IRkernel package to CRAN. Until then, you can install it via the devtools package:

{% highlight R %}
install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools', 'stringr'))
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec()  # to register the kernel in the current R installation
{% endhighlight %}

#### iScala kernel

https://datasciencevademecum.wordpress.com/2016/01/28/6-points-to-compare-python-and-scala-for-data-science-using-apache-spark/

Scala programs compile to JVM bytecodes. Their
run-time performance is usually on par with Java programs. Scala code can
call Java methods, access Java fields, inherit from Java classes, and implement Java interfaces. 

### Installing IJulia kernel


Firs grab __Julia__ and install it on your machine. Run Julia app  (you will see nice prompt `julia>`), then type:

```Pkg.add("IJulia")```

It will download and install basic python environment based on [Miniconda][miniconda], which is local for Julia. Thanks to that you don't really need any python installed in your system to run Julia Notebook. Julia will use its private python interpreter and minimal Jupyter installation to run notebook with it's kernel. You can run it at any time typing in Julia REPL:

{% highlight julia %}
    julia> using IJulia
    julia> notebook()
{% endhighlight %}

If you use `notebook(detached=true)`, Julia will run notebook server in the background and you will be able to use or exit REPL without closing the notebook. 

By default, the notebook "dashboard" opens in your home directory, but you can open the dashboard in a different directory with `notebook(dir="/some/path")`.


But we want to add IJulia kernel to existing Jupyter installation. to do that you need to set environmental variable `JUPYTER` to the value of your current jupyer program path before running `Pkg.add("IJulia")`.


## Managing kernels

Jupyter notebook is language agnostic platform. It is able to support nearly 100 different languages ((check [here][kernels])) via kernels, which provide is kernel is execution backend for Jupyter to invoke specifics language commands and direct response back to the browser. By default only ipython kernel is installed and runs out of the box. Other kernels must be installed and activated by user. By default installing Jupyter also installs `ipykernel` appropriate to your interpreter version. 

https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs



https://ipython.readthedocs.io/en/latest/install/kernel_install.html




## One to rule them all...

Once all kernels are installed, you can see the available kernels:


```jupyter kernelspec list ```

{% highlight bash %}
    > jupyter kernelspec list
    Available kernels:
        julia-0.5    C:\Users\MIDY\AppData\Roaming\jupyter\kernels\julia-0.5
        python2      C:\Users\MIDY\AppData\Roaming\jupyter\kernels\python2
        python3      C:\Users\MIDY\AppData\Roaming\jupyter\kernels\python3
        vpython      C:\Users\MIDY\AppData\Roaming\jupyter\kernels\vpython
        ir           C:\Users\MIDY\AppData\Local\Continuum\Anaconda2\share\jupyter\kernels\ir
{% endhighlight %}


What language, which program to chose for data science? Which one is better? Python? R? Maybe Julia? Which should I use? All have advantages and weaknesses. Python is more general programming language, R has strong community support in math and statistics. Julia is strongly typed, uber fast...

This question and answers often appear in discussions. So which one?

There is no good answer to this questions. If you want do big things use all tools available. Use best tools possible. Nothing more, nothing less.

If you struggle between using python or R, don't! Why not use both?! At the same time in the same notebook, passing data structures between languages and perform analysis with the best tools they can offer. With Jupyter notebook it is all possible. It is possible to add even more players to the game. Julia, Haskel, Lua, bash, Octave... Pick whatever you can... Currently Jupyter supports nearly 100 different kernels (check [here][kernels]).



{% highlight python %}
def print_hi(name)
  print("Hi, {0}".format(name))

print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}


<!-- Links -->
[anaconda]:   https://www.continuum.io/DOWNLOADS
[kernels]:    https://github.com/jupyter/jupyter/wiki/Jupyter-kernels
[python2]:    https://www.python.org/downloads/release/python-2713/
[python3]:    https://www.python.org/downloads/release/python-361/
[rlang]:      https://cloud.r-project.org
[scala]:      https://www.scala-lang.org/download/
[julia]:      https://julialang.org/downloads/
[jupyterlab]: https://github.com/jupyterlab/jupyterlab  
[pep373]:     https://www.python.org/dev/peps/pep-0373/
[miniconda]:  https://conda.io/miniconda.html

