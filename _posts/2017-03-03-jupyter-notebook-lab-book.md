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

## Install Anaconda


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

Anaconda will install nearly 300 packages, including most important for this tutorial: Jupyter Notebook, ipython, pandas, numpy, statsmodels


## Anaconda channels

Some packages are distributed in repositories owned by groups other than Anaconda team. Repositories are called channels. One can indicate channel simply by choosing `-c` or `--channel` flag during invoking `conda install` command. Some of the channels are supported by continuum Analytics, like `conda-forge`, `omnia` or `r`. They are full of excellent packages developed by Anaconda community. Every time I mention I want to use other channel than default, conda will check this repositories for available packages. It is possible to add this channels to the `.condarc` file (see: [here][condarc]). First config file must be created by running `conda config` command. If other version of this file is placed in Anaconda installation root directory it will override  users home configuration. to notify package manager, that every time  I want to install something this channels should be checked. Order of repositories is important. In case packages are deployed to both repositories listed in channels section, last repository super-seeds all above it. Example file looks like this:

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

Last group of inputs is very important for users behind corporate proxy, which will block `conda` package lookup, unless correct settings are provided.

There is another great part about Anaconda and Jupyter Notebook. It is cross-platform, which means, that Notebook files created on one system will open on other system with similar package configuration. 


## Jupyter notebook / Jupyter Lab 

To start the notebook simply type `jupyter notebook` in your command line or terminal. 

Alternatively you may add path to the existing jupyter notebook file with `.ipybn` extension

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


Jupyter Lab is new project of Jupyter team, which eventually will replace good old notebook, but currently it is in very early alpha release version and it is not recommended to be used in any serious project. It has built in file manager, image browser, documentation and many, many other. And one disadvantage: `ipywidgets` do not work.

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

Lab environment can be started using `jupyter lab` command.. It should start in default browser under this address: [http://127.0.0.1:8888](http://localhost:8888/lab).

![lab][lab]

More information about this project and development plans can be found [here][jupyterlab].


## Other environments

There are several other environment to work with data. Some of them accessible from Anaconda Navigator program, which allow to handle packages, environment and channels from the level of window app. One of them is [Orange][orange], not installed, but ready to install using single button click or using shell command: `conda install -c conda-forge orange3`.

![Orange3][orange-view]


More general purpose python environment resembling Matlab/RStudio is [Spyder][spyder]. Also worth to try.

![Spyder][spyder-view]


Another great tool based on fantastic RStudio is creation of the Yhat company called [Rodeo][rodeo].

![Rodeo][rodeo-view]

I prefer Jupyter Notebook work, therefore I will not go further into details. I never used it, but maybe for someone it is more appealing. 

## Work with data

Anaconda already has plenty of tools to read and manipulate data. Main tools I will be using are: `numpy`, `pandas`, `h5py`, `sqlite3`. Numpy and pandas both have enormuouis documentation, which is worth to check.


### Text data


### Binary data

## Plotting in python




In [_"Practical Data Science Cookbook"_][data-science-cookbook] by Tony Ojeda authors distinguished five core activities in data analysis:

1. Stating thesis
2. Exploring the data
3. Building formal model/models
4. Interpreting the results
5. Communicating the results

All these activities may be successfully performed using python ecosystem. No doubt python has one of the best communities, active and contributing frequently with quality packages. I would risk statement, that python's community is even better, than R's, but I do not want to provoke another flame war.


## Data and biology

Biologist simply can not ignore data anymore. Huge amounts of data flow from each instrument from confocal microscope to RT-PCR every day. Equipment producers usually provide some tools to perform data analysis, but they lack flexibility. Data should be accessible and ready to use from any workstation, transform and visualize. Biology people must deal with them with ease and grace. Actually the problem isn't new. Astronomers faced it long time ago. Most of them started to use scripting languages to develop their own tools. Chemistry and pharmaceutical industry deal with it as well and now biologist face same problem. 


Data produced by biological experiments in time. ,- graph



Excel spreadsheet is simply not enough anymore. It lacks capabilities to properly hold large amounts of data, describe them and, what is most important, to exchange them with other collaborators.  Currently average MD experiments can produce hundreds of gigs of data. Average sequencing few gigs. From microscopy pictures to large MD trajectories you should be able to ingest, crack, visualize and share your data. Traditional statistical approach to analysis of the data is not enough and one needs to go deeper and deal with data more interactively, with more integrative insight. Currently in biology BigData is a big problem and is treated as such. But it is just a problem scientists are not ready to deal with. Giga- and tera- byte scale level requires large and expensive computational cluster or smart approach. Therefore, nowadays, basic _Data Science_ skills are essential for every decent researcher.

> Basic _Data Science_ skills are essential for every decent researcher.

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

## Numpy & Pandas

Cornerstones of any data science project. Basic pair if it comes to deal with data. In biology majority of numerical data come in form of vectors (series of values) or tables. These two are more than enough to 


### HDF5



### netCDF



## Biopandas




## Biopython



<!-- Links -->

[anaconda]:   https://www.continuum.io/DOWNLOADS
[condarc]:    https://conda.io/docs/config.html#the-conda-configuration-file-condarc
[jupyterlab]: https://github.com/jupyterlab/jupyterlab
[rodeo]:      https://www.yhat.com/products/rodeo
[orange]:     https://orange.biolab.si
[spyder]:     https://pythonhosted.org/spyder/
[data-science-cookbook]: https://www.packtpub.com/mapt/book/big_data_and_business_intelligence/9781783980246


<!-- Images -->


[notebook]:   /assets/03-03-2017-jupyter-notebook.png
[lab]:        /assets/03-03-2017-jupyter-lab.png
[orange-view]:/assets/03-03-2017-orange.png
[spyder-view]:/assets/03-03-2017-spyder.png
[rodeo-view]: /assets/03-03-2017-rodeo.png
