---
layout:     post
author:     Michal Dyzma
title:      "Python, R, Scala and Julia in one Notebook"
date:       2017-04-23 14:51:25 +0200
comments:   true
categories: python R Scala Julia jupyter-notebook
keywords:   python, R, Scala, Julia, jupyter notebook, data science
---

It is hard to choose "right" language for data analysis, especially if you are beginner and do not want to go into details about strengths and weaknesses of particular solutions. Should I choose R or python (2 or 3), maybe Julia would be better?  What should I use to work with large data set? My answer is: use what you can! Take the best you can from several languages and make it work. This post will show you how.


How to create versatile environment, in which different languages are available without changing program you work with and data may be passed between specific structures characteristic for specified languages? This post will show you how to do it with three most powerful languages used in Data Science: __Python__, __R__, __Scala__ and __Julia__.

For demonstration I have chosen current versions of:

| Language              | | Version    |
|------------           | |---------   |
| [python 2][python2]   | | __2.7.13__ |
| [python 3][python3]   | | __3.6.1__  |
| [R][rlang]            | | __3.4.0__  |
| [Scala][scala]        | | __2.12.2__ |
| [Julia][julia]        | | __0.5.1__  |

## Four horsemen of data science...


Procedura:
1.1  install anaconda3
1.2 install python 2 in env
2.1 install R z condy
2.2 install R z RSTUDIO
3.1 Install Scala language or sbt
3.2 install iscala
4.1 Install Julia language
4.2 install ijulia


And I saw when the Lamb opened one of the seals, and I heard, as it were the noise of thunder, one of the four beasts saying, Come and see.
And I saw, and behold a white horse

Python and R are well known in data science. They've been competing with each other for decades. Both languages have  There has been 


## Kernels installation

So our goal is to install python, Julia and R on our machines. To run notebooks in languages other than Python, such as R or Julia, we need to install additional middle-ware called kernels. 

First we shall grab necessary tools - compiler, interpreters for each language (linked in table above). All languages presented here are multi-platform and can be installed on Windows, Linux and OSX machines. You can find detailed instructions about [R](http://www.jason-french.com/blog/2013/03/11/installing-r-in-linux/) or [Julia](https://julialang.org/downloads/platform.html) in blog posts I found in the Internet. If it comes to python...

> There is no excuse not to use Python 3. Grab it! Use it!

I strongly recommended to use [Anaconda distribution][anaconda], which will install python interpreter, the Jupyter Notebook, and several other packages commonly used in data science. If you choose to install Anaconda 2, your default python interpreter will be 2.7.x, If you choose Anaconda 3, your interpreter will be of version 3.6 (current version) or higher. Python branch 2.x is currently considered a legacy code. You should definitely switch to Anaconda 3. First of all Python 2 support will drop in 2020 (according to [PEP 373][pep373]) and there will be no official bug fixes after that date. Second of all - most of the currently used libraries are able to use python 3. Unless you have some obscure dependency, there is no excuse not to use python 3. Python 2 is included here just for the sake of keeping backward compatibility with some old scripts, we may have.

In many Linux distributions python 3.x is accessible by using `python3` command, but it cumbersome to manage both python versions and calls to them from the system level. There is much easier way to manage python instances and it is called __virtual environments__.

{% highlight Bash %}
conda create -n python2 python=2.7 ipykernel
Fetching package metadata .............
Solving package specifications: .

Package plan for installation in environment C:\Users\admin\Anaconda3\envs\python2:

The following NEW packages will be INSTALLED:

    backports:           1.0-py27_0
    backports_abc:       0.5-py27_0
    colorama:            0.3.7-py27_0
    decorator:           4.0.11-py27_0
    enum34:              1.1.6-py27_0
    get_terminal_size:   1.0.0-py27_0
    ipykernel:           4.6.1-py27_0
    ipython:             5.3.0-py27_0
    ipython_genutils:    0.2.0-py27_0
    jupyter_client:      5.0.1-py27_0
    jupyter_core:        4.3.0-py27_0
    path.py:             10.3.1-py27_0
    pathlib2:            2.2.1-py27_0
    pickleshare:         0.7.4-py27_0
    pip:                 9.0.1-py27_1
    prompt_toolkit:      1.0.14-py27_0
    pygments:            2.2.0-py27_0
    python:              2.7.13-0
    python-dateutil:     2.6.0-py27_0
    pyzmq:               16.0.2-py27_0
    scandir:             1.5-py27_0
    setuptools:          27.2.0-py27_1
    simplegeneric:       0.8.1-py27_1
    singledispatch:      3.4.0.3-py27_0
    six:                 1.10.0-py27_0
    ssl_match_hostname:  3.4.0.2-py27_1
    tornado:             4.5.1-py27_0
    traitlets:           4.3.2-py27_0
    vs2008_runtime:      9.00.30729.5054-0
    wcwidth:             0.1.7-py27_0
    wheel:               0.29.0-py27_0
    win_unicode_console: 0.5-py27_0

Proceed ([y]/n)?
{% endhighlight %}

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



<!-- {:.mdtablestyle} -->



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
