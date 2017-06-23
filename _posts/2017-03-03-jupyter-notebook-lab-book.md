---
layout:     post
author:     Michal Dyzma
title:      Jupyter Notebook - python based lab book
date:       2017-03-03 17:28:54 +0200
comments:   true
mathjax:    true
categories: python jupyter-notebook data
keywords:   python, jupyter notebook, data
---

Data analysis using **Jupyter Notebook**. Natural sciences more and more rely on skills related to Data Science. Experiments produce more and more data, and skilled researcher has to know how to deal with variety of data and sometime very large datasets. **Anaconda** Python Distribution offers large set of great tools to manipulate any kind of data "out of the box". Multitude of community packages allows to read, analyze and report all kinds of data produced by science. It is caused mostly by simple fact, that scientific community is developing it's tools mostly in Python. How to work with small and large data in python and make Jupyter Notebook your lab-book? Check this article. 


<br>
{% include note.html content="Notebooks, as well as all related data files, described in this article are located in my [GitHub repository](https://github.com/mdyzma/blog-src-files/tree/master/2017-03-03-jupyter-notebook-lab-book)" %}

## Install Anaconda

> _Data Science_ skills are essential for every decent researcher.

[Anaconda Python Distribution][anaconda] prepared by Continuum Analytics is the most comprehensive and free bundle of Python software dedicated to __Data Science__. 

I strongly recommended to use [Anaconda distribution][anaconda], which will install Python interpreter, the Jupyter Notebook, and several other packages commonly used in data science and this tutorial. If you choose Anaconda 3, your interpreter will be of version 3.6 (current version) or higher (3.7 alpha is already available). 

I will just follow instructions from installation page and simply execute downloaded script(your current version may differ from the one listed here):

{% highlight bash %}
> wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Windows-x86_64.sh

--2017-03-03 19:36:37--  https://repo.continuum.io/archive/Anaconda3-4.3.1-Windows-x86_64.sh
Resolving repo.continuum.io (repo.continuum.io)... 104.16.18.10, 104.16.19.10, 2400:cb00:2048:1::6810:130a, ...
Connecting to repo.continuum.io (repo.continuum.io)|104.16.18.10|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 497343851 (474M) [application/x-sh]
Saving to: 'Anaconda3-4.3.1-Windows-x86_64.sh'

Anaconda3-4.3.1-Windows-x86_64.sh     100%[==========================================>] 474.30M  14.1MB/s in 34s

2017-03-03 19:37:12 (13.8 MB/s) - 'Anaconda3-4.3.1-Windows-x86_64.sh' saved [497343851/497343851]
{% endhighlight %}

To make sure my software is up to date I shall run:

{% highlight bash %}
> conda update --all
{% endhighlight %}

Anaconda will install nearly 200 packages (182 to be exact), including most important for this tutorial: Jupyter Notebook, ipython, pandas, numpy, statsmodels


## Anaconda channels

`conda` is built in Anaconda package manager, which uses default, maintained by Contunuum Analytics python packages repository. Some packages are distributed in repositories owned by groups other than Anaconda team. Repositories are called channels. One can indicate channel simply by choosing `-c` or `--channel` flag during invoking `conda install` command. Some of the channels are supported by continuum Analytics, like `conda-forge`, `omnia` or `r`. They are full of excellent packages developed by Anaconda community. Every time I mention I want to use other channel than default, conda will check this repositories for available packages. It is possible to add this channels to the `.condarc` file (see: [here][condarc]). First config file must be created by running `conda config` command. If other version of this file is placed in Anaconda installation root directory it will override  users home configuration. to notify package manager, that every time  I want to install something this channels should be checked. Order of repositories is important. In case packages are deployed to both repositories listed in channels section, last repository super-seeds all above it. Example file looks like this:

{% highlight bash %}

channels:
    - omnia
    - conda-forge
    - r
    - defaults

show_channel_urls: True

proxy_servers:
    http: http://user:pass@corp.com:8080
    https: https://user:pass@corp.com:8080

{% endhighlight %}

Last group of inputs is very important for users behind corporate proxy, which will block `conda` package lookup, unless correct settings are provided. I can alway use official python package manager `pip`, which checks PyPI (Python Packages Index)


There is another great part about Anaconda and Jupyter Notebook. It is cross-platform, which means, that Notebook files created on one system will open on other system with similar package configuration. 


## Jupyter Notebook / Jupyter Lab 

Jupyter Notebook allows to create and share documents that contain live code, equations, visualizations and explanatory text. Text may be written in markdown markup  language. Code can produce rich output such as images, videos, LaTeX, and JavaScript. Interactive widgets can be used to manipulate and visualize data in real time.
Alternatively you may add path to the existing Jupyter notebook file with `.ipybn` extension. If you add path to the notebook file ( extension ``.ipynb``), it will be opened in the location of the file. Jupyter automatically runs a local server.

{% highlight bash %}
> jupyter notebook

[I 21:09:38.658 NotebookApp] Serving notebooks from local directory: C:\Users\Michal
[I 21:09:38.659 NotebookApp] 0 active kernels
[I 21:09:38.660 NotebookApp] The Jupyter Notebook is running at: http://localhost:8888/?token=c6a93623006ede30a579af4d7e693909abd90c98224916ee
[I 21:09:38.660 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation). [C 21:09:38.665 NotebookApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8888/?token=c6a93623006ede30a579af4d7e693909abd90c98224916ee
[I 21:09:39.005 NotebookApp] Accepting one-time-token-authenticated connection from ::1
{% endhighlight %}

It should start notebook server in your browser (default address: [http://127.0.0.1:8888](http://localhost:8888/tree)):

![notebook][notebook]

There is a handy collection of extensions that add functionality to the Jupyter notebook. Extensions are grouped in package [`nbextensions`][nbext], which is not included in fresh Anaconda installation and I will install it using conda:

{% highlight bash %}
> conda install -c conda-forge jupyter_contrib_nbextensions
Fetching package metadata .............
Solving package specifications: .

Package plan for installation in environment C:\Users\Michal\Anaconda3:

The following NEW packages will be INSTALLED:

    jupyter_contrib_core:              0.3.1-py36_0   conda-forge
    jupyter_contrib_nbextensions:      0.2.8-py36_1   conda-forge
    jupyter_highlight_selected_word:   0.0.10-py36_0  conda-forge
    jupyter_latex_envs:                1.3.8.2-py36_1 conda-forge
    jupyter_nbextensions_configurator: 0.2.5-py36_0   conda-forge

The following packages will be UPDATED:

    conda:                             4.3.21-py36_0              --> 4.3.21-py36_1 conda-forge

The following packages will be SUPERSEDED by a higher-priority channel:

    conda-env:                         2.6.0-0                    --> 2.6.0-0       conda-forge

Proceed ([y]/n)? y


conda-env-2.6. 100% |###############################| Time: 0:00:00 206.58 kB/s
conda-4.3.21-p 100% |###############################| Time: 0:00:01 281.65 kB/s
jupyter_contri 100% |###############################| Time: 0:00:00 417.99 kB/s
jupyter_highli 100% |###############################| Time: 0:00:00 793.82 kB/s
jupyter_latex_ 100% |###############################| Time: 0:00:02 324.68 kB/s
jupyter_nbexte 100% |###############################| Time: 0:00:01 442.23 kB/s
jupyter_contri 100% |###############################| Time: 0:00:03   5.47 MB/s
{% endhighlight %}

Because I used conda it will automatically register all extensions and copy necessary `javascript` and `css` files in Jupyter environment for me. If I used pip instead, I would have to fetch additional command: `jupyter contrib nbextension install --user`

Jupyter Lab is new project of Jupyter team, which eventually will replace good old notebook, but currently it is in very early alpha release version and it is not recommended to be used in any serious project. It has built in file manager, image browser, documentation and many, many other. And one disadvantage: `ipywidgets` and `nbextensions` do not work yet or their functionality must be loaded through lab extensions system, which is not very convenient.

Jupyter lab is not accessible in Anaconda distribution and must be installed. One can do it with default package manager:

{% highlight bash %}
> conda install -c conda-forge jupyterlab
Fetching package metadata .............
Solving package specifications: .

Package plan for installation in environment C:\Users\Michal\Anaconda3:

The following NEW packages will be INSTALLED:

    jupyterlab:          0.23.2-py36_0 conda-forge
    jupyterlab_launcher: 0.2.9-py36_0  conda-forge

The following packages will be SUPERSEDED by a higher-priority channel:

    conda:               4.3.21-py36_0             --> 4.3.21-py36_0 conda-forge
    conda-env:           2.6.0-0                   --> 2.6.0-0       conda-forge

Proceed ([y]/n)? y

conda-env-2.6. 100% |###############################| Time: 0:00:00  73.67 kB/s
conda-4.3.21-p 100% |###############################| Time: 0:00:01 378.40 kB/s
jupyterlab_lau 100% |###############################| Time: 0:00:00   1.18 MB/s
jupyterlab-0.2 100% |###############################| Time: 0:00:01   1.34 MB/s

{% endhighlight %}

Lab environment can be started using `jupyter lab` command. It should start in default browser under this address: [http://127.0.0.1:8888](http://localhost:8888/lab).

![lab][lab]

More information about this project and development plans can be found [here][jupyterlab].

Simple `conda list` shows all packages installed in current environment. In practice only handful of them are imported directly. Main tools I will use in this tutorial include:

* `numpy` - array calculations
* `sympy` - symbolic mathematics
* `matplotlib` - 2D plotting
* `statsmodels` - statistical models
* `pandas` - data structures and analysis


which are part of SciPy - python based scientific ecosystem. [Numpy][numpy] and [Pandas][pandas] alone have enormous documentations, which are worth to check. Huge advantage of notebook environment is that it allows to compute and manipulate data directly and export entire notebook in various formats, to share with other.


## Other environments

There are several other environment to work with data. Some of them accessible from Anaconda Navigator program, which allow to handle packages, environment and channels from the level of window app. One of them is [Orange][orange], not installed, but ready to install using single button click or using shell command: `conda install -c conda-forge orange3`.

![Anaconda Navigator][navigator]

![Orange3][orange-view]


More general purpose python environment resembling Matlab/RStudio is [Spyder][spyder]. Also worth to try.

![Spyder][spyder-view]


Another great tool based on fantastic RStudio is creation of the Yhat company called [Rodeo][rodeo].

![Rodeo][rodeo-view]

I prefer Jupyter Notebook to work, therefore I will not go further into details. I never used any of them for more serious work, but maybe for someone alternatives may be more appealing. 

## Version control

Everyone has files like `report_1`, `report_2` or `report_01_12_2016` etc. in our project folders. Versioning files helps to organize work and trace progress. Software developers have to trace it even more rigorous. Therefore version control systems (VCS) were created. They help to automatically store and keep track on versions of the source files. Why not use it in every day scientific activity. Currently most popular VCS is `git`. It can be installed from [here][git]. It is free. Just by learning 4-5 commands and adapting specific work-flow, one can start using git in every project. 

I will create test folder and start git repository. 

{% highlight bash %}
> mkdir test && cd test
{% endhighlight %}

Basic git commands:

{% highlight bash %}
> git init
Initialized empty Git repository in C:/Users/Michal/Documents/test/.git/
{% endhighlight %}

Now I shall add something to the folder, i.e. `README.md` file with project description and start tracing it:
{% highlight bash %}
> touch README.md
# Edit readme in text editor or simply
> echo "# Experiment 1" > README.md
# When we check file content
> cat README.md
"# Experiment 1"
{% endhighlight %}


If I ask git what changed:

{% highlight bash %}
> git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        README.md

nothing added to commit but untracked files present (use "git add" to track)
{% endhighlight %}

I have one untracked file (git figured out, that content of the folder changed). Now I need to add this file to the tracking system. It is simple as:

{% highlight bash %}
> git add README.md
{% endhighlight %}
 
Now if I ask git what changed:

{% highlight bash %}
> git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   README.md
{% endhighlight %}


Once I stop adding new content to the file I will add changed file again (to "stage it") and commit changes to the repository, to keep them there as a current snapshot. git allows me to go back to tis specific version of the file any time. 

{% highlight bash %}
> git commit -m "Added README to the project"
[master (root-commit) cf02fde] Added README to the project
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
{% endhighlight %}

Done! Now any change to the file will be tracked and the same set of instructions must be repeated to store changes:

1. change file
2. `git add <file>`
3. `git commit -m "Message"`

This is very basic introduction to git. Please refer to the [manual][git-man] to get more info about usage and configuration.Now I am going to create few notebooks describing typical biochemical experiments. The theory, data analysis, plots and figures will be presented in notebooks.

## Simple experiments



### Protein concentration


### Protein activity


### Determination of DNA Quality and Quantity

{% highlight bash %}

{% endhighlight %}


Lets imagine basic colorimetric experiment. In biology colorimetric techniques are used to measure 


### Text data

Data in biology are usually text based, grouped in columns, sometimes delimited with tabs, comas or other characters. For example It is like this in case o 


### Binary data

## Plotting in Python

### Matplotlib


### Bokeh / Seaborn

All these activities may be successfully performed using python ecosystem. No doubt python has one of the best communities, active and contributing frequently with quality packages.

<!-- ## Data and biology



Excel spreadsheet is simply not enough anymore. It lacks capabilities to properly hold large amounts of data, describe them and, what is most important, to exchange them with other collaborators.  Currently average MD experiments can produce hundreds of gigs of data. Average sequencing few gigs. From microscopy pictures to large MD trajectories you should be able to ingest, crack, visualize and share your data. Traditional statistical approach to analysis of the data is not enough and one needs to go deeper and deal with data more interactively, with more integrative insight. Currently in biology BigData is a big problem and is treated as such. But it is just a problem scientists are not ready to deal with. Giga- and tera- byte scale level requires large and expensive computational cluster or smart approach. Therefore, nowadays, basic _Data Science_ skills are essential for every decent researcher.



Python has very extensive toolkit to process various data in many different ways. What is more important - it is easy to learn. Lets take a closer look at some packages, that can be used in biology. Lets start small, to get comfortable to use python pipelines in every day analysis.

## Anaconda

Continuum Analytics developed great swiss-army toolkit to data science. It's name is [__Anaconda__][Anaconda]. It groups over 700 python programs called packages, which will help you get started with python and data science in no time. Also, it has huge advantage - it's free. There are competitive products like [Enthough Canopy's][Canopy] data science platform, or [Yhat's Rodeo][Rodeo], which also provide very decent software. In general they are all based on basic python data science tools like `numpy`, `pandas`, `dask`, `matplotlib`. Some of them have closed source original solutions to particular problems, some are based completely on freely available software. Feel free to try whatever suits you best. 

Why not pure python? Many packages included in Anaconda has non-trivial installation processes. Some parts of most frequently used packages (i.e numpy) are written in compiled languages like C/C++ or Fortran (hence their advantage over pure python solutions), therefore require specific compilers as well as some mathematical libraries like LAPAC, which must be linked during  compilation process. It is much easier to grab installer, in which all foreign dependencies are already compiled and shipped in form of binary files, and get going within few minutes, rather than deal with python __dependency hell__ for few days. Alternatively you can spend days trying to install all dependencies... The choice is yours.

How do we start working with python? In the beginning it good to see what you compute, experience the process itself, therefore I strongly recommend to start with `jupyter notebook`. Great tool to replace your lab-book, report files in various documents and data held in spreadsheets. 



This is our interactive window in browser, that allows us to talk to python interpreter. 

{% highlight python %}
{% raw %}
<title>{% if page.title %}{{ page.title }} - {{ site.title }}{% else %}{{ site.title }}{% endif %}</title>
{% endraw %}
{% endhighlight %}
 -->
## Numpy & Pandas

Cornerstones of any data science project. Basic pair if it comes to deal with data. In biology majority of numerical data come in form of vectors (series of values) or tables. These two are more than enough to do variety of tasks like fast and efficient calculations, reading multiple formats, data cleaning, manipulation and visualization too. Numpy provides fast vector operations


### HDF5



### netCDF



## Biopandas




## Biopython


All examples can be also downloaded in form of Jupyter Notebook file from [GitHub][github].



<!-- Links -->

[github]:     https://github.com/mdyzma/blog-src-files
[anaconda]:   https://www.continuum.io/DOWNLOADS
[condarc]:    https://conda.io/docs/config.html#the-conda-configuration-file-condarc
[jupyterlab]: https://github.com/jupyterlab/jupyterlab
[rodeo]:      https://www.yhat.com/products/rodeo
[orange]:     https://orange.biolab.si
[spyder]:     https://pythonhosted.org/spyder/
[numpy]:      http://www.numpy.org
[pandas]:     http://pandas.pydata.org
[nbext]:      https://github.com/ipython-contrib/jupyter_contrib_nbextensions
[git]:        https://git-scm.com
[git-man]:    https://git-scm.com/documentation

[data-science-cookbook]: https://www.packtpub.com/mapt/book/big_data_and_business_intelligence/9781783980246


<!-- Images -->

[notebook]:   /assets/03-03-2017-jupyter-notebook.png
[lab]:        /assets/03-03-2017-jupyter-lab.png
[nbext-view]: /assets/03-03-2017-nbextensions.png
[orange-view]:/assets/03-03-2017-orange.png
[spyder-view]:/assets/03-03-2017-spyder.png
[rodeo-view]: /assets/03-03-2017-rodeo.png
[navigator]:  /assets/03-03-2017-anaconda-navigator.png
