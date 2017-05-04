---
layout:     post
author:     Michal Dyzma
title:      Jupyter Notebook - python based lab book
date:       2017-04-14 17:28:54 +0200
comments:   true
categories: python jupyter-notebook data
keywords:   python, jupyter notebook, data
---

Data analysis using Jupyter Notebook. I will mention biology and focus on work with data specific for biology, but  all the principles and tools described here may be applied in other projects and disciplines.


## Data analysis

Roger D. Peng in his book [_"The Art of Data Science"_](https://leanpub.com/artofdatascience) distinguished five core activities in data analysis:

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

## Jupyter notebook / Jupyter Lab 

To start the notebook simply type `jupyter notebook` in your command line or terminal. 

Alternatively you may add path to the existing jupyter notebook file with `.ipybn` extension

``` jupyter notebook 


< -- link to python r julia in one notebook



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

[Anaconda]: https://www.continuum.io/anaconda-overview
[Canopy]: https://www.enthought.com/products/canopy/
[Rodeo]: https://www.yhat.com/products/rodeo
