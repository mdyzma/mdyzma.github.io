---
layout:     post
author:     Michal Dyzma
title:      "Python, R and Julia in one Notebook!"
subtitle:   "Share best, from all."
date:       2017-04-23 14:51:25 +0200
comments:   true
categories: python R julia jupyter
keywords:   python, R, Julia, jupyter notebook, data science
---

It is hard to choose "right" language for data analysis, especially if you are beginner and do not want to go into details about strengths and weaknesses of particular solutions. Should I choose R or python (2 or 3), maybe Julia would be better?  What should I use? My answer is: use all of them! Take the best you can from each language and make it work. This post will show you how.


How to create versatile environment, in which different languages are available without changing editor or IDE and data may be passed between them? This post will show you how to do it with three most powerful languages used in Data Science: __Python 2__, __Python 3__, __R__ and __Julia__.

For demonstration I have chosen current versions of:

| Language              | | Version    |
|------------           | |---------   |
| [python 2][python2]    | | __2.7.13__ |
| [python 3][python3]    | | __3.6.1__  |
| [R][rlang]            | | __3.3.2__  |
| [Julia][julia]        | | __0.5.1__  |


## IPykernel

First we shall grab necessary tools. All languages presented above are multiplatform and can be installed in Windows, Linux and OSX machines. I strongly recommended to use [Anaconda distribution][anaconda], which will install python interpreter, the Jupyter Notebook, and several other packages commonly used in data science. If you choose to install Anaconda 2, your default python interpreter will be 2.7. Therefore it is safer to choose Anaconda 3 instead, since Python 2 support will drop in 2020 (according to [PEP 373][pep373]) and there will be no official bug fixes after that date.


If you are new to Python please check my post ["Work with data in Jupyer"]({{site.url}}/2017/04/14/python-for-biologists-work-with-data/) describing in details where to get Anaconda Python distribution and how to run Jupyter Notebook. 

Jupyter notebook is language agnostic platform. It is able to support nearly 100 different languages ((check [here][kernels])) via kernels, which provide is kernel is execution backend for Jupyter to invoke specifics language commands and direct response back to the browser. By default only ipython kernel is installed and runs out of the box. Other kernels must be installed and activated by user. By default installing Jupyter also installs `ipykernel` appropriate to your interpreter version. 

https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs

### Installing with conda

https://ipython.readthedocs.io/en/latest/install/kernel_install.html



### Installing with pip





## IRkernel

### conda

https://conda.io/docs/r-with-conda.html


#### other

We will soon submit the IRkernel package to CRAN. Until then, you can install it via the devtools package:

install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools'))
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec()  # to register the kernel in the current R installation

## IJulia kernel

Firs grab [Julia][julia] and install it on your machine. Run Julia app  (you will see prompt `julia>`) and type:

```Pkg.add("IJulia")```

Julia will download and install basic python environment based on [Miniconda][miniconda], which is local for Julia. Thanks to that you don't really need any python installed in your system. Julia will use its private python interpreter and minimal Jupyter installation to run notebook with it's kernel.

But we want to add IJulia kernel to existing Jupyter installation. to do that you need to set environmental variable `JUPYTER` to the value of your current jupyer program path before running `Pkg.add("IJulia")`.

On Windows with Anaconda 

Then you can run IJulia directly from Julia REPL with:


{% highlight julia %}
    using IJulia
    notebook()
{% endhighlight %}

~~~ julia
    using IJulia
    notebook()
~~~

If you use `notebook(detached=true)`, Julia will run notebook server in the background and you will be able to use or exit REPL without closing the notebook. By default, the notebook "dashboard" opens in your home directory, but you can open the dashboard in a different directory with `notebook(dir="/some/path")`.

You can also start IJulia kernel by running `jupyter notebook` and selecting specific kernel during notebook file creation.


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
[julia]:      https://julialang.org/downloads/
[jupyterlab]: https://github.com/jupyterlab/jupyterlab  
[pep373]:     https://www.python.org/dev/peps/pep-0373/
[miniconda]:  https://conda.io/miniconda.html
