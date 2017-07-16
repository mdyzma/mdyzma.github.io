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
{% include note.html content="Notebooks and related data files from this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/blog-src-files/tree/master/2017-03-03-jupyter-notebook-lab-book)" %}

## Install Anaconda

> _Data Science_ skills are essential for every decent researcher.

[Anaconda Python Distribution][anaconda] prepared by Continuum Analytics is the most comprehensive and free bundle of Python software dedicated to __Data Science__. 

I strongly recommended to use [Anaconda distribution][anaconda], which will install Python interpreter, the Jupyter Notebook, and several other packages commonly used in data science and this tutorial. If you choose Anaconda 3, your interpreter will be of version 3.6 (current version) or higher (3.7 alpha is already available). 

Execute script and just follow instructions from installation program (your current version may differ from the one listed here):

{% highlight bash %}
> wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh

--2017-03-03 19:36:37--  https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
Resolving repo.continuum.io (repo.continuum.io)... 104.16.18.10, 104.16.19.10, 2400:cb00:2048:1::6810:130a, ...
Connecting to repo.continuum.io (repo.continuum.io)|104.16.18.10|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 497343851 (474M) [application/x-sh]
Saving to: 'Anaconda3-4.3.1-Linux-x86_64.sh'

Anaconda3-4.3.1-Linux-x86_64.sh     100%[==========================================>] 474.30M  14.1MB/s in 34s

2017-03-03 19:37:12 (13.8 MB/s) - 'Anaconda3-4.3.1-Linux-x86_64.sh' saved [497343851/497343851]

> bash ./Anaconda3-4.3.1-Linux-x86_64.sh

{% endhighlight %}

To make sure software is up to date, run:

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

Last group of inputs is very important for users behind corporate proxy, which will block `conda` package lookup, unless correct settings are provided. Additionally one can alway use official python package manager `pip` in parallel to `conda`. Conda is able to sense origin of the package and shows this during package listing. Pip checks [PyPI][pypi] (Python Packages Index) repository for python packages (which stores nearly 110 000 packages). 


Another great part about Anaconda and Jupyter Notebook. It is cross-platform, which means, that Notebook files created on one system will open on other system with similar package configuration. 


## Jupyter Notebook / Jupyter Lab 

Jupyter Notebook allows to create and share documents that contain live code, equations, visualizations and explanatory text. Text may be written in markdown markup  language. Code can produce rich output such as images, videos, LaTeX, and JavaScript. Interactive widgets can be used to manipulate and visualize data in real time.
Alternatively you may add path to the existing Jupyter notebook file with `.ipybn` extension. If you add path to the notebook file ( extension ``.ipynb``), it will be opened in the location of the file. Jupyter automatically runs a local server.

{% highlight bash %}
> jupyter notebook

[I 21:09:38.658 NotebookApp] Serving notebooks from local directory: /home/mdyzma/
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

Package plan for installation in environment /home/mdyzma/anaconda3:

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

Jupyter Lab is new project of Jupyter team, which eventually will replace good old notebook, but currently it is in very early alpha release version and it is not recommended to be used in any serious project. It has built in file manager, image browser, documentation and many, many other. And one disadvantage: `ipywidgets` and `nbextensions` do not work yet or their functionality must be loaded through lab extensions system, which is not very convenient. Another handy extension is [`watermark`][watermark] package. It will timestamp notebooks and provide basic python configuration info. I will fetch latest version from GitHub:

{% highlight bash %}
> pip install -e git+https://github.com/rasbt/watermark#egg=watermark
Obtaining watermark from git+https://github.com/rasbt/watermark#egg=watermark
  Cloning https://github.com/rasbt/watermark to c:\users\michal\src\watermark
Requirement already satisfied: ipython in /home/mdyzma/anaconda3/lib/site-packages (from watermark)
Installing collected packages: watermark
  Running setup.py develop for watermark
Successfully installed watermark
{% endhighlight %}


Jupyter lab is not accessible in Anaconda distribution out of the box and must be installed. One can do it with default package manager from `conda-forge` channel:

{% highlight bash %}
> conda install -c conda-forge jupyterlab
Fetching package metadata .............
Solving package specifications: .

Package plan for installation in environment /home/mdyzma/anaconda3:

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

Simple `conda list` shows all packages installed in current environment. Main tools I will use in this tutorial include:

* `numpy` - array calculations
* `sympy` - symbolic mathematics
* `matplotlib` - 2D plotting
* `statsmodels` - statistical models
* `pandas` - data structures and analysis


which are part of SciPy - python based scientific ecosystem. [Numpy][numpy] and [Pandas][pandas] alone have enormous documentations, which are worth to check. Huge advantage of notebook environment is that it allows to compute and manipulate data directly and export entire notebook in various formats, to share with other. There is also `JupyterHub`, providing access to the notebook for multiple users, which can be used as a official project documentation  in secure location and controlled access. Check [JupyterHub][jhub] documentation to learn more.


## Experiments examples:

To present power enclosed in python and jupyter notebook I will create several scenarios of typical experiments conducted in labs. It will cover data acquisition, modeling, visualization and data storage.


### Protein concentration

Example of simple experiment with data from VIS spectrophotometric experiment. Lets assume we have solution with protein colored by protein dye. For a uniform absorbing solution the proportion of light passing through is called the transmittance: \\(T\\), and the proportion of light absorbed by molecules in the medium is absorbance, \\(Abs\\). Experiment consists of three steps:

1. Determine the absorption spectra \\(\lambda_{max}\\)
2. Calculate the extinction coefficient (\\(\epsilon\\)) of the standards.
3. Determine the concentration of proteins in solution 




<!-- #### Theoretical background

For a uniform absorbing solution  the proportion of light passing through is called the transmittance: \\(T\\), and the proportion of light absorbed by molecules in the medium is absorbance, \\(Abs\\). 

Transmittance is defined as:

$$T =  \frac{I}{I_{o}} $$

where:

* \\(I_o\\) is intensity of the incident radiation entering the medium.
* \\(I\\) = intensity of the transmitted radiation leaving the medium.


T can be expressed as percent transmittance, \\(%T\\):

$$%T = \frac{I}{I_{o}} \times 100$$

The relationship between percent transmittance (\\(\%T\\)) and absorbance (\\(Abs\\)) is given by the following equation:

$$Abs = 2 - log (\%T) $$

From above equation we can see, that probe, which absorbs 100% of the light will have transmittance 100% and absorbance equal 2 \\((log_{10} 100 = 2)\\), while completely transparent sample will have absorbance 0. Therefore theoretical span of Absorbance values range from 0 to 2, however Beer-Lambert's law is most accurate in range 0.05 to 0.7 \\(Abs\\).

The Beer-Lambert Law states that Absorbance is proportional to the concentration of the absorbing molecules, the length of light-path through the medium and the molar extinction coefficient:

$$ Abs = \epsilon \cdot c \cdot l $$

where:

* \\(Abs\\) – absorbance
* \\(\epsilon\\) – light extinction coefficient at max absorption wavelength \\(\lambda_{max}\\)
* \\(c\\) – substance concentration
* \\(l\\) – length of light-path

 -->
#### Determine the absorption spectra

In order to obtain \\(\lambda_{max}\\) measure the absorbance of the diluted sample at 50 nm intervals between 350-700 nm. This will give an estimate of where the sample absorbs most (peaks) and least (valleys). I will generate them using python. Procedure requires that all measurements to be within 0-0.7 absorbance range. If maximal values are higher, sample should be diluted:

Data can be generated:

{% highlight python %}
# absorbance of the sample at 10 nm intervals between 350-700 nm.
x = range(350, 750, 10)

#random values in range 0 - 0.7
y = np.random.uniform(0, 0.7, len(x))
{% endhighlight %}


{% highlight python %}
df = pd.DataFrame(y, index=x, columns=['Absorbance'])
{% endhighlight %}


Or read from file:

{% highlight python %}
df = pd.read_csv("data/lambda_max.csv", header=None, names=["Absorbance"])
{% endhighlight %}


Pandas can ingest every text and binary data format, which fits RAM memory. This way I got table called DataFrame. To find basic statistics, lets call `describe()` method on data Frame. 

{% highlight python %}
df.describe()
       Absorbance
count   36.000000
mean     0.355109
std      0.176637
min      0.018094
25%      0.265485
50%      0.371752
75%      0.470539
max      0.683876
{% endhighlight %}


Find wavelength for which absorbance is highest (it is trivial for few arguments, but becomes more complex when amount of data grows):

{% highlight python %}
df['Absorbance'].argmax()
410
{% endhighlight %}

And plot it to get more direct data feel:

{% highlight python %}
ax = df.Absorbance.plot(title="$\lambda_{max}$ of the protein")
ax.set_ylabel("Absorbance")
{% endhighlight %} 

![lambda][lambda]

#### Calculate the extinction coefficient (\\(\epsilon\\)) of the standards.        

The Beer-Lambert Law states that Absorbance is proportional to the concentration of the absorbing molecules, the length of light-path through the medium and the molar extinction coefficient:

$$ Abs = \epsilon \cdot c \cdot l $$

where:

* \\(Abs\\) – absorbance
* \\(\epsilon\\) – light extinction coefficient at max absorption wavelength \\(\lambda_{max}\\)
* \\(c\\) – substance concentration
* \\(l\\) – length of light-path

therefore \\(\epsilon\\) is equal to:

$$ \epsilon =  \frac{Abs_{410}}{c \cdot l} $$


{% highlight python %}
# Abs_410 = 0.683876
epsilon = 0.683876/(c*1)
{% endhighlight %}

where c is concentration of the standard.

#### Determine the concentration of proteins in solution using a colorimetry

Simply solve standard beer-Lamber equation for c, but first construct calibration curve from known samples.

##### Calibration curve

Consider the following example involving a set of six standard points (5, 10, 25, 30, 40, 50, 60, and 70 µg/mL). Absorbance: (0.106, 0.236, 0.544, 0.690, 0.791, 0.861, 0.882, 0.911). I have two collumn of x and y values of the calibration curve points.

|--------------+------------|
|Conc          | Absorbance |
|--------------+------------|
|5             | 0.106      |
|10            | 0.236      |
|25            | 0.544      |
|30            | 0.690      |
|40            | 0.791      |
|50            | 0.861      |
|60            | 0.882      |
|70            | 0.911      |
|--------------+------------|


Ploted :


{% highlight python %}
import matplotlib.pyplot as plt
plt.plot(concentration, absorbance, 'o', label='original data')
plt.grid(alpha=0.8)
{% endhighlight %}


![calibration-points][cal]

And fitted to the line: 

$$y = Ax + b$$

where:

\\(A\\) - is slope = 0.0124571906355
\\(b\\) - is intercept = 0.176051839465

{% highlight python %}
# Linear regression
from scipy import stats

slope, intercept, r_value, p_value, std_err = stats.linregress(concentration, absorbance)


plt.plot(concentration, absorbance, 'o', label='data points')
plt.plot(concentration, intercept + slope*concentration, 'r', label='fitted line')
plt.legend()
plt.grid(alpha=0.8)
{% endhighlight %}

For this set of points linear regression fitting seems to be suboptimal choice. \\(R^2 = 0.8754454029810919\\)

![calibration-points][cal_lin]

Polynomial fitting allows to  reflect character of the points much better. Fitting function creates list of coefficients for least-squares fit of the data points to the polynomial described by: \\(p(x) = c_0 + c_1 x + ... + c_n x_n\\). I shall fit data to the third degree polynomial. Coefficients are: 1.12600636e-06  -3.68738266e-04   3.40965628e-02  -6.29998061e-02. Therefore polynomial has form:

$$ y = 1.1 \times 10^{-6}x^3 - 3.6 \times 10^{-4}x^2 - 3.4 \times 10^{-2}x - 6.2 \times 10^{-2} $$

{% highlight python %}
#polynomial fit
import numpy.polynomial.polynomial as poly

coefs = poly.polyfit(concentration, absorbance, 3)
ffit = poly.polyval(concentration, coefs)

plt.plot(concentration, absorbance, 'o', label='data points')
plt.plot(concentration, ffit, 'r', label='fitted line')
plt.legend()
plt.grid(alpha=0.8)
{% endhighlight %}

![calibration-linear-fit][cal_poly]


Interpolation of the unknown sample is simple as resolving one of the functions in respect to x. In case of linear regression transformation is trivial (rounded to four digits after the ):

$$ x = \frac{(absorbance - intercept)}{slope} = \frac{(absorbance - 0.1760)}{0.0124}$$


FOr third degree polynomial it is little bit more complicated. Very crude approach is usage of Cardano's formula.



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

-----

Example Jupyter notebook can be downloaded from [GitHub][github].

-----

<!-- Links -->

[github]:     https://github.com/mdyzma/blog-src-files/tree/master/2017-03-03-jupyter-notebook-lab-book
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
[pypi]:       https://pypi.python.org/pypi
[jhub]:       https://jupyterhub.readthedocs.io/en/latest/
[watermark]:  https://github.com/rasbt/watermark

[data-science-cookbook]: https://www.packtpub.com/mapt/book/big_data_and_business_intelligence/9781783980246


<!-- Images -->

[notebook]:   /assets/03-03-2017/jupyter-notebook.png
[lab]:        /assets/03-03-2017/jupyter-lab.png
[nbext-view]: /assets/03-03-2017/nbextensions.png
[lambda]:     /assets/03-03-2017/lambda_max.png
[cal]:        /assets/03-03-2017/calibration-points.png
[cal_lin]:    /assets/03-03-2017/calibration-linear-fit.png
[cal_poly]:   /assets/03-03-2017/calibration-polynomial-fit.png
