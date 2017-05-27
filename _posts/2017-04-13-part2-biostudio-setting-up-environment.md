---
layout:     post
author:     Michal Dyzma
title:      "Part 2: Setting up work environment"
date:       2017-04-13 01:15:08
comments:   true
categories: biostudio workflow python
keywords:   biostudio, workflow, python
---

In __Part 2__ I will set up and show how to manage virtual environments in python. Initiate version control and software versioning automation. Additionally I will set up continuous integration service using GitLab, which will include automatic testing with pytest and documentation creation. Code will run tests every time update has been pushed to the master branch of the software repository.

-----

#### About biostudio project

This is part of  what should develop to a series of articles on development process of _Biostudio_ - python GUI app. I will include best practices and solutions used in corporate projects. From preparing  software specifications to fully functional software deployed to the PyPI repository. Final product will be GUI application for Protein Data Bank ```.pdb``` files editor, which carry information about 3D structure of biological macro-molecules.

_Series consists of:_

* [Part 1: Application designs]({{site.url}}/2017/03/26/part1-biostudio-application-design/)
* [Part 2: Setting up work environment]({{site.url}}/2017/04/13/part2-biostudio-setting-up-environment/)

<!-- * [Part 3: Test Driven Development]({{site.url}}/2017/04/14/part3-biostudio-design-implementation-tdd/)
* [Part 4: Low Level Design implementation]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/)
 -->
-----


## Basic configuration


Platform| | **Linux 64 bit**
Python  | | **3.6.1**
Source  | | [link][biostudiosource]

<br>
{% include note.html content="I will run the code using docker virtualization technology or spin new VirtualBox Fedora or Ubuntu, to test how it works freshly out of the box. So I can be sure every piece of code was properly tested. Outputs from my tests will be pasted here, unless they are ridiculous long (hundreds of lines). Then I will truncate output to the bare minimum necessary to understand what is going on." %}



## Virtual environment

Before I start to write the code I will set up clean environment with Python interpreter. It is a common practice to start new projects with their own Python and packages in a sandbox. Environments are created by `virtualenv` package. It will automatically match main system interpreter found on system path, but it is possible to specify other version as well. To do that one has to specify `--python` flag and point to the executable of specific python version installed in the system. It is also good to separate program code and virtual environment own directory. The later may grow quite big and it makes no sens to keep all python packages, used during development, under our own project version control. Virtual environment may be anywhere on the disc and what I usually do is to create `.envs` folder in home directory and group all environments over there.

Call `virtualenv` and specify Python interpreter using `--python=/path/to/your/python`. I do not do this, because I use default Python present in the system:

{% highlight bash %}
mdyzma@devbox:~/.envs$ virtualenv biostudio # optionally --python=path/to/other/python/interpreter/python
    
Using base prefix '/home/mdyzma/anaconda3'
New python executable in /home/mdyzma/.envs/biostudio/bin/python
copying /home/mdyzma/anaconda3/bin/python => /home/mdyzma/.envs/biostudio/bin/python
Installing setuptools, pip, wheel...done.
{% endhighlight %}

All basic tools, which allow packages control (install, remove, update and create), were installed automatically. To start work in new environment, I need to activate it:

{% highlight bash %}
mdyzma@devbox:~/.envs$ source activate biostudio
#list packages in new environment
(biostudio) mdyzma@devbox:~/.envs$ pip list
appdirs (1.4.3)
packaging (16.8)
pip (9.0.1)
pyparsing (2.2.0)
setuptools (35.0.2)
six (1.10.0)
wheel (0.29.0)
{% endhighlight %}

Now I can install a different Python packages into specific virtualenv, eliminating the conflict with system Python. It is time to create basic development infrastructure.

* **Folders & files**
* **Dependencies**:
    - **coverage** - _tests coverage metrics_
    - **Sphinx** - _documentation_
    - **sphinx-autobuild** - _running docs live preview_
    - **numpydoc** - _convenient docstring style_
    - **bumpversion** - _control software version_
    - **pytest** and plug-ins - _unit tests_: 
        - **pytest-runner**
        - **pytest-cov**
    - **tox** - _generic virtualenv manager_

#### Folders and files

{% highlight bash %}
(biostudio) mdyzma@devbox:~/.envs$ cd
(biostudio) mdyzma@devbox:~$ mkdir -p biostudio/{docs,src/{common,fileandler/pdb,functional},tests/{common,filehandler/pdb,functional},uml}
(biostudio) mdyzma@devbox:~$tree biostudio

biostudio/
├── docs
├── src
│   ├── common
│   ├── filehandler
│   │   └── pdb
│   └── functional
├── tests
│   ├── common
│   ├── filehandler
│   │   └── pdb
│   └── functional
└── uml

12 directories, 0 files
{% endhighlight %}

Tests folder resembles structure of `src/`, which is advised way to write unit tests and separate test files from the source.
I will add few necessary files to the main folder, which will help to keep things organized and ship it later to the PyPI repo:
    
* `README.md`
* `LICENSE`
* `setup.py`
* `setup.cfg`
* `tox.ini`

... and `__init__.py` files in each sub-folders of `src/` to make python packages out of them. Later more configuration files will be added, to govern some automation pipelines. I also added `.gitkeep` hidden files to each empty directory, so Git will not ignore them when I push initial folder structure to version control. Later `.gitkeep` was appended to `.gitignore` file to make them "invisible" (see: [here](#vcs)) once folders are no longer empty.


Finally skeleton of `biostudio` project is as follows:

{% highlight bash %}
(biostudio) mdyzma@devbox:~$tree biostudio
biostudio/
│   LICENSE
│   README.md
│   setup.cfg
│   setup.py
│   tox.ini
│
├───docs
├───src
│   │   biostudio.py
│   │   __init__.py
│   │
│   ├───common
│   │       __init__.py
│   │
│   ├───filehandler
│   │   │   __init__.py
│   │   │
│   │   └───pdb
│   │           __init__.py
│   │
│   └───functional
│           __init__.py
│
├───tests
│   │   test_biostudio.py
│   │
│   ├───common
│   ├───filehandler
│   │   └───pdb
│   └───functional
└───uml
{% endhighlight %}


#### Dependencies with pip and requirements.txt 

It’s easy to get a Python project off the ground simply by using pip to install dependent packages as you go. This works fine as long as you’re the only one working on the project. As soon as someone else wants to run your code, they’ll need to go through the process of figuring which dependencies the project needs and installing them all by hand. It is problem prone and can lead to some very hard to spot program misbehavior. To prevent this, I will define a `requirements.txt` file that stores all of my project’s dependencies. My current requirements file looks like this:
    
{% highlight bash %}
# requiremnts.txt
Sphinx
sphinx-autobuild
numpydoc
bumpversion
coverage
pytest
pytest-runner
pytest-cov
tox
{% endhighlight %}

I do not include packages versions, therefore latest will be downloaded and installed by pip (including their dependencies).

{% highlight bash %}
(biostudio) mdyzma@devbox:~$ pip install -r requirements.txt
{% endhighlight %}

It may take some time, since pip manages all the dependencies for each package and their dependencies as well. It is OK, since I create new project from the scratch. When dealing with legacy code, I would have to put more constrains and specify versions for each package, so that there would be no ambiguity and development environment will reflect exactly the one used during program creation, or specified in the SDD. Now I will create such file for future me or other dev team:

{% highlight bash %}
(biostudio) mdyzma@devbox:~$ pip freeze > requirements.txt
# Listing created file
(biostudio) mdyzma@devbox:~/biostudio$ cat requirements.txt 
alabaster==0.7.10
appdirs==1.4.3
argh==0.26.2
Babel==2.4.0
bumpversion==0.5.3
certifi==2017.4.17
chardet==3.0.3
coverage==4.4.1
docutils==0.13.1
idna==2.5
imagesize==0.7.1
Jinja2==2.9.6
livereload==2.5.1
MarkupSafe==1.0
numpydoc==0.6.0
packaging==16.8
pathtools==0.1.2
pluggy==0.4.0
port-for==0.3.1
py==1.4.33
Pygments==2.2.0
pyparsing==2.2.0
pytest==3.1.0
pytest-cov==2.5.1
pytest-runner==2.11.1
pytz==2017.2
PyYAML==3.12
requests==2.16.0
six==1.10.0
snowballstemmer==1.2.1
Sphinx==1.6.1
sphinx-autobuild==0.6.0
sphinxcontrib-websupport==1.0.1
tornado==4.5.1
tox==2.7.0
typing==3.6.1
urllib3==1.21.1
virtualenv==15.1.0
watchdog==0.8.3
{% endhighlight %}

{% include note.html content="To reduce memory usage it is possible to add `--no-cache-dir` flag during dependencies installation. This way pip will not store downloaded packages for future use." %}

Lots of this packages are dependencies from the first list of requirements. This list does not contain all packages from environment, some of them are by default present in the system, therefore were not included in freeze. I could delete all other and leave only few initial, which will install their own dependencies anyway, but it would be a lot of unnecessary work. Simply typing `pip freeze` is all I need to create list of dependencies for my project. Less work, the better.

For more on pip requirements refer to this pep documentation [section][pip].

## Documentation

Another vital aspect of application development is documentation. There are three levels of documentation I will write:

* project- or distribution-level documentation
* API documentation
* code comments

First one is usually written separately from the code (in `docs/`). It is intended to give high-level information on a project, such as installation instructions, examples, and so on. The second,  API-level documentation, summarizes how functions, methods, classes, or modules should be used. It is usually prepared along with the code using Python docstrings. The third level of documentation is in the form of code comments. Such comments help explain how a piece of code works. In this part I will focus on automation of tedious process of **project documentation** and **API documentation** production. This usually goes to the client. Comments are vital part of the project, but I usually treat them as "internal use only". Unless I publish source as well, as in case of this open-source project.

Lets start:

{% highlight bash %}
sphinx-quickstart

> sphinx-quickstart
Welcome to the Sphinx 1.5.1 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Enter the root path for documentation.
> Root path for the documentation [.]:

You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]: y

Inside the root directory, two more directories will be created; "_templates"
for custom HTML templates and "_static" for custom stylesheets and other static
files. You can enter another prefix (such as ".") to replace the underscore.
> Name prefix for templates and static dir [_]:

The project name will occur in several places in the built documentation.
> Project name: biostudio
> Author name(s): Michal Dyzma

Sphinx has the notion of a "version" and a "release" for the
software. Each version can have multiple releases. For example, for
Python the version is something like 2.5 or 3.0, while the release is
something like 2.5.1 or 3.0a1.  If you dont need this dual structure,
just set both to the same value.
> Project version []: 0.0.0
> Project release [0.0.0]:

If the documents are to be written in a language other than English,
you can select a language here by its language code. Sphinx will then
translate text that it generates into that language.

For a list of supported codes, see
http://sphinx-doc.org/config.html#confval-language.
> Project language [en]:

The file name suffix for source files. Commonly, this is either ".txt"
or ".rst".  Only files with this suffix are considered documents.
> Source file suffix [.rst]:

One document is special in that it is considered the top node of the
"contents tree", that is, it is the root of the hierarchical structure
of the documents. Normally, this is "index", but if your "index"
document is a custom template, you can also set this to another filename.
> Name of your master document (without suffix) [index]:

Sphinx can also add configuration for epub output:
> Do you want to use the epub builder (y/n) [n]:

Please indicate if you want to use one of the following Sphinx extensions:
> autodoc: automatically insert docstrings from modules (y/n) [n]: y
> doctest: automatically test code snippets in doctest blocks (y/n) [n]:
> intersphinx: link between Sphinx documentation of different projects (y/n) [n]:
> todo: write "todo" entries that can be shown or hidden on build (y/n) [n]:
> coverage: checks for documentation coverage (y/n) [n]:
> imgmath: include math, rendered as PNG or SVG images (y/n) [n]:
> mathjax: include math, rendered in the browser by MathJax (y/n) [n]: y
> ifconfig: conditional inclusion of content based on config values (y/n) [n]:
> viewcode: include links to the source code of documented Python objects (y/n) [n]:
> githubpages: create .nojekyll file to publish the document on GitHub pages (y/n) [n]:

A Makefile and a Windows command file can be generated for you so that you
only have to run e.g. make html instead of invoking sphinx-build
directly.
> Create Makefile? (y/n) [y]:
> Create Windows command file? (y/n) [y]:

Creating file .\source\conf.py.
Creating file .\source\index.rst.
Creating file .\Makefile.
Creating file .\make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file .\source\index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or linkcheck.
{% endhighlight %}

## Software versioning

In many projects control over software version is done by hand. There is no need to say that there must be a better way. Book keeping is tedious and error prone. specially in teams with more than one person. Here I will use [bumpversion][bumpversion] package to control software version through out the project files. Also I will use semantic versioning scheme, which  is a recommended versioning convention. The release is represented by three numbers: MAJOR.MINOR.PATCH. The MAJOR number changes with introducing changes to the API, which are not backward compatible. MInor represents some new functionalities, but compatibility is kept. PATCH is incremented, when some bugs are fixed. There is very specific description of versioning and dependency specification in [PEP 440][pep440] Bumpversion uses `setup.cfg` file to keep track of places in the code, where it must be incremented when I change package version. 

Example of bumpversion configuration:

{% highlight bash %}
[bumpversion]
current_version = 0.0.0
commit = True
tag = True

[bumpversion:file:setup.py]
search = version='{current_version}'
replace = version='{new_version}'

[bumpversion:file:biostudio/__init__.py]
search = __version__ = '{current_version}'
replace = __version__ = '{new_version}'
{% endhighlight %}

Usual tox 

<a name="vcs"></a>

## Code management (VCS)

One of the most important aspect of 

#### Gitignore



## Automating stuff
<!-- 
### Build virtualenvs and test with tox

Now that I have virtualenvs for the projects, you’ll want an easy way to build the virtualenv and install all the dependencies from your requirements.txt file. An automatic way to set up virtualenvs is important for getting new users started with your project, and is also useful for enabling you to quickly and easily rebuild broken virtualenvs.

Tox is a Python tool for managing virtualenvs. It lets you quickly and easily build virtualenvs and automate running additional build steps like unit tests, documentation generation, and linting. When I download a new Python project at Knewton, I can just run tox, and it’ll build a new virtualenv, install all the dependencies, and run the unit tests. This really reduces setup friction, making it easy to contribute to any Python project at Knewton.

A tox.ini file at Knewton might look something like this:


[tox]
envlist=py27                         # We use only Python 2.7
indexserver =
     # We host our own PyPI (see below)
     default = https://python.internal.knewton.com/simple

[testenv]
deps = 
     -rrequirements.txt              # Pinned requirements (yes, no space)
commands=
     pipconflictchecker              # Check for any version conflicts
     py.test . {posargs}             # Run unit tests

Get started with tox at its home page.

Indicate transitive dependencies using install_requires

At some point, you may want to package your Python project with sdist or as a wheel, so that others can depend on it by installing it with pip. Dependency management gets a bit more complicated at this point, because pip actually doesn’t look at your requirements.txt file when installing your packaged project.

Instead, pip looks at the install_requires field in setup.py, so you should be sure to fill this out in order to make a project that others can easily install. In contrast to requirements.txt, this field should list only your direct dependencies. Although requirements in requirements.txt should generally be pinned to exact versions, requirements in install_requires should permit the largest possible ranges. If you’d like to understand these differences, “The Package Dependency Blues” does a great job of explaining requirements.txt and install_requires.4

The way tox handles requirements.txt and install_requires can be a bit confusing. First, tox installs requirements from the deps section of tox.ini. Then tox runs python setup.py install, which will install dependencies from your install_requires. Since your requirements.txt file should contain a superset of the packages in your install_requires, this second step should not install any requirements if you’ve filled out your deps section correctly.

Of course, now you have two different lists of requirements to maintain. If only there were a simple way to do so! Pip-compile, from pip-tools, is the most promising tool for keeping your requirements.txt and install_requires in sync. It’s not yet fully mature, but it’s very helpful for projects with many transitive dependencies.

Specify which versions of Python tools you want to support

If you’re using pip, virtualenv, and tox, then anyone with those tools should be able to build your project, right? Unfortunately, the answer is, “almost.” If someone is running a different version of pip, virtualenv, or tox, their build may work differently than yours. As an example, tox 1.x passes all environment variables through to the commands it’s running, but tox 2.x runs its tasks in an environment with only a whitelist of environment variables. This means that, if you had a script that tried to read the $EDITOR environment variable, it might work fine when built with tox 1.x, but fail with tox 2.x.

At Knewton, we take the approach of restricting the allowed versions of these tools. We have a script called “Python Doctor” that will check your versions of Python, pip, virtualenv, and tox to ensure that they’re within our band of accepted ranges.

For an open source project, this is a little more complicated because you can’t restrict the versions of the tools running on your contributors’ workstations. In this case, it’s a good idea to mention the versions of these tools with which your project can be built.5 Note that this only applies to tools that are installed in your global Python environment, which will not appear in your requirements.txt or install_requires. For example, tox or pip would not generally appear in a requirements.txt file.

Example README snippet:

To build this project, run `tox -r`. This project has been tested with tox >=1.8,<2. If you want to make your own virtualenv instead, we recommend using virtualenv >=13.

Control your packages with a PyPI server

By default, pip will install packages from the python.org pypi server. If you work at a place with proprietary code, you may wish to run your own PyPI server. This will allow you to install your own packages as easily as those from the main PyPI server.

It’s actually much easier to set this up than you might think: your PyPI server can be as simple as an HTTP server serving a folder that contains sdist’ed tarballs of your Python project!

By hosting your own PyPI server, you can make it easy to maintain forked versions of external libraries.

You can also use a PyPI server to encourage consistent builds and reduce version conflicts by limiting the ability to add new libraries to your organization’s PyPI server.

Learn more about setting up a PyPI server here.

Examples

I’ve added to Github two Python project templates that illustrate how to tie all of this together:

Python-project-template-with-pip-conflict-checker uses pip-conflict-checker to check for dependency conflicts. This is a slightly more reliable strategy, but will require a little more manual effort to keep your requirements files in sync.
Python-project-template-with-pip-compile uses pip-compile to simplify requirements management. Pip-compile is not yet a mature tool, but it makes it much easier to manage dependencies.
Conclusion

This is our strategy, but you’ll probably need to modify it to suit your own circumstances. Additionally, the Python community has been growing quickly recently, so it’s likely that some of these practices will be replaced in the next few years. If you’re reading this in 2018, hopefully there will be some easier ways to manage Python dependencies!

Notes

If you’re used to other dependency management systems, this may sound trivial. With Python, it’s not!
“Pip” stands for “pip installs packages.” Easy_install was formerly used for this, but nowadays pip is superior.
Pip is now included with Python 2 versions starting with 2.7.9, as well as Python 3 versions starting with 3.4.
A nagging aside: make sure to follow semantic versioning to make it easier for other projects to restrict the version of your project in their install_requires.
If you want to take this to the next level, you can specify your build tools programmatically too! Make a file called requirements-meta.txt that contains pinned versions of your build tools like tox. Then you’ll have a two-step build process:
Install your per-project build system. To do this, use your global tox or virtualenvwrapper to make a virtualenv with this pinned version of tox in it.
Use your per-project build system to build your project. To do this, run the tox that you just installed to run the project’s primary builds. If you understood this, great job!
What's this? You're reading N choose K, the Knewton tech blog. We're crafting the Knewton Adaptive Learning Platform that uses data from millions of students to continuously personalize the presentation of educational content according to learners' needs. Sound interesting? We're hiring.


## Automatic start


, this particular project will depend on. it is also advised to keep environments Luckily Python has very convenient tool to manage not only multiple Python instances, but instances with different versions. fresh
We will set up basic structure of our project. Basic boilerplate code for our can be generated automatically. It is usually very boring process of copying some files/folders and adjusting all variables to the needs of our project. Typical app may have dosens of places, where you need to put correct values to make it fully custom. Why not automate it? This is where cookiecutter comes t the resque.
## Dependency management
https://tech.knewton.com/blog/2015/09/best-practices-for-python-dependency-management/

## Cookiecutter

Nice package, which will make our work



## Continuous delivery




Virtual environment can be managed using two fantastic tools:

1) virtualenv
2) conda

Here I will use virtualenv. Lets create clean environment with latest python 3:

```virtualenv ```


What language, which program to chose for data science? Which one is better? Python? R? Maybe Julia? Which should I use? All have advantages and weaknesses. Python is more general programming language, R has strong community support in math and statistics. Julia is strongly typed, uber fast...


# CI and workflow

> Automate everything you can

# Documentation automation

### GitLab pages

### Read-the-docks

###GitHub pages



There is no need to convince anyone, that automated workflow can 

# Docker

https://jpetazzo.github.io/2013/12/01/docker-python-pip-requirements/

Efficient management Python projects dependencies with Docker
 Discuss on Hacker News
There are many ways to handle Python app dependencies with Docker. Here is an overview of the most common ones – with a twist.

In our examples, we will make the following assumptions:

you want to write a Dockerfile for a Python app;
the code is directly at the top of the repo (i.e. there’s a setup.py file at the root of the repo);
your app requires Flask (and possibly other dependencies).
Using your distro’s packages
This is the easiest method, but it has some pretty strict requirements.

The Python dependencies that you need must be packaged by your distro. (Obviously!)
Almost as obvious, but a bit more tricky: your distro has to carry the specific version that you need. You want Django 1.6 but your distro only have 1.5? Too bad!
You must be able to map the Python package name to the distro package name. Again, that sounds really obvious, and it’s not a big deal if you are familiar with your distro. For instance, on Debian/Ubuntu, in most cases, Python package xxx will be packaged as python-xxx. But if you have to deal with a complex Python app with a large-ish requirements.txt file, things might be more tedious.
If you run multiple apps in the same environment, their requirements must not conflict with each other. For instance, if you install (on the same machine) a CMS system and a ticket tracking system both depending on different versions of Django, you’re in trouble.
The most common answer to those constraints is “just use virtualenv instead!”, and this is the generally accepted strategy. However, before ditching distro packages, let’s remember two key things!

If we’re using Docker, most of those problems go away (just like when using virtualenv), because you can use different containers for different apps (and get rid of version conflicts). Also, if you need a more recent (or older) version of a package, you can use a more recenet (or older) version of the distro, and a moderate amount of luck will make sure that you can find the right thing. Just check e.g. http://packages.debian.org/ or http://packages.ubuntu.com/ to check version numbers first.
Sometimes, it happens that a specific Python dependency will be incompatible with your Python version, or some other library on your system. Example: I recently stumbled upon a version of simplejson which didn’t work with Python 3.2. This is less likely to occur with distro packages, because such problems will be caught by the packagers and the other users. Free QA!
So what does your Dockerfile look like?

# Use a specific version of Debian (because it has the exact Python for us)
FROM stackbrew/debian:jessie
RUN apt-get install -qy python3
RUN apt-get install -qy python3-flask
ADD . /myapp
WORKDIR /myapp
RUN python3 setup.py install
EXPOSE 8000
CMD myapp --port 8000
Pretty simple – especially if you don’t have too many requirements. Note how we apt-get install each package with a separate command. It creates more Docker layers, but that’s OK, and it means that if you add more dependencies later, the cache will be used. If you use a single line, each time you add a new package, everything will be downloaded and installed again.

requirements.txt
If you can’t use the packages of your distro (they don’t have that specific version that you absolutely need!), or if you are using some stuff which is just not packaged at all, here’s our “plan B”. In that situation, you will generally have a requirements.txt file, describing the dependencies of the app, pinned to specific versions. That kind of file can be generated with pip freeze, and those dependencies can then be installed with pip install -r requoirements.txt.

That’s also the preferred solution when you want to use some dependencies straight from GitHub, BitBucket, or any other code repository, because pip supports that too.

Let’s see first what the Dockerfile will look like, and discuss the pros and cons of this approach.

FROM stackbrew/debian:jessie
RUN apt-get install -qy python3
RUN apt-get install -qy python3-pip
ADD . /myapp
WORKDIR /myapp
RUN pip-3.3 install -r requirements.txt
RUN pip-3.3 install .
EXPOSE 8000
CMD myapp --port 8000
While it looks similar to what we did earlier, there is actually a huge difference (apart from the fact that dependencies are no longer handled by Debian, but directly by pip). Dependencies are now installed after the ADD command. This is a big deal because as of Docker 0.7.1, the ADD command is not cached, which means that all subsequent commands are not cached, neither. So each time you build this Dockerfile, you end up re-installing all the dependencies, which could take some time.

This is a significant drawback, because development is now significantly slower, since each build can take minutes instead of seconds.

So how do we solve that problem? Well, let’s see!

Two Dockerfiles
A common workaround to ADD issue is to use two Dockerfiles. The first one installs your dependencies, the second one installs your code. They will look like this:

FROM stackbrew/debian:jessie
RUN apt-get install -qy python3
RUN apt-get install -qy python3-pip
ADD requirements.txt /
RUN pip-3.3 install -r requirements.txt
This first Dockerfile should be built with a specific name; e.g. docker build -t myapp .. Then, the second Dockerfile reuses it:

FROM myapp
ADD . /myapp
WORKDIR /myapp
RUN pip-3.3 install .
EXPOSE 8000
CMD myapp --port 8000
Now, code modifications won’t cause all dependencies to be re-installed. However, if you change dependencies, you have to manually rebuild the first image, then the second.

This workaround is good, but has two drawbacks.

You have to remember to rebuild the first image when you update dependencies. That sounds obvious and easy, but what happens if someone else updates requirements.txt, and then you pull their changes from git? Are you sure that you will notice the change? Maybe you should setup a git hook to remind you?
Workflows like Trusted Builds get more complicated as well. It’s still possible to get full automation, though. You can put the first Dockerfile (and the requirements file) in a subdirectory of the repository, and create a first Trusted Build for e.g. username/myappbase, pointing at that subdirectory. Then create a second Trusted Build, e.g. username/myapp, pointing at the root directory, and using FROM username/myappbase.
I appreciate the convenience of being able to use two Dockerfiles, but at the same time, I believe that it makes the build process more complicated and error-prone.

So let’s see what else we could do!

One-by-one pip install
We are in a kind of catch 22: we want to pip install -r requirements.txt, but if we ADD requirements.txt we break caching, And we want caching.

What would McGyver do?

Instead of installing from requirements.txt, let’s install each package manually, with pip, with different RUN commands. That way, those commands can be properly cached. See the following Dockerfile:

FROM stackbrew/debian:jessie
RUN apt-get install -qy python3
RUN apt-get install -qy python3-pip
RUN pip-3.3 install Flask
RUN pip-3.3 install some-other-dependency
ADD . /myapp
WORKDIR /myapp
RUN pip-3.3 install .
EXPOSE 8000
CMD myapp --port 8000
Now we won’t reinstall dependencies each time we rebuild. Great. However, our dependencies are now duplicated in two places: in requirements.txt, and in Dockerfile. It’s not the end of the world, but if you update one of them without the other, confusion will ensue.

So this solution is nice from a build time and tooling perspective, but it doesn’t abide by “DRY” principles (Don’t Repeat Yourself), which is another way to say that it can be subtly error-prone as well.

Combo
I’m therefore suggesting to mix two of the previous solutions to solve the issue! Really, the idea is to install dependencies twice. Or rather, to install them the first time with RUN statements (which get cached), and execute pip install -r requirements.txt after the ADD. The latter won’t get cached, but pip is nice, and it won’t reinstall things that are already installed.

That way, you leverage the caching system of the Docker builder, but at the same time, if you update requirements.txt without updating Dockerfile, the pip install command will patch up your image anyway, by upgrading your dependencies to the right version. The build will just be slower until you update the Dockerfile, but that’s it.

The Dockerfile will look like this:

FROM stackbrew/debian:jessie
RUN apt-get install -qy python3
RUN apt-get install -qy python3-pip
RUN pip-3.3 install Flask
RUN pip-3.3 install some-other-dependency
ADD . /myapp
WORKDIR /myapp
RUN pip-3.3 install -r requirements.txt
RUN pip-3.3 install .
EXPOSE 8000
CMD myapp --port 8000
Virtualenv
If you followed carefully, you noticed that we mentioned virtualenv in the beginning of this post, but we haven’t used it so far. Is virtualenv useful with Docker? It depends!

On a regular machine (be it your local development machine or a deployment server), you will have multiple Python apps. If they rely only on Python dependencies that happen to be packaged by your distro, great. Otherwise, virtualenv will come to the rescue; either as a sidekick to your distro’s packages (by complementing them) or as a total replacement (if you create the virtualenv with --no-site-packages).

With Docker, you will generally deploy one single app per container; so why use virtualenv? It might still be useful to advert conflicts between Python libs installed as distro packages, and libs installed with pip. This is not very likely for simple projects, but if you have a bigger codebase with many dependencies, and also install distro packages bringing their own Python dependencies with them, it could happen.

Other points of view
There is no right or wrong solution for that matter. Depending on the size of your project, on the number of dependencies, and how their interact with your distro, one method can be better than another.

On that topic, I suggest that you read Nick Stinemates’ blog post about running Python apps with Docker, or Paul Tagliamonte blog post about the respective merits of apt and pip.


## Documentation

Self documenting code from _docstrings_. In this project Sphinx framework will generate quality documentation each time update is being pushed to the project master.

__If you have any comments, or ideas how to improve this tutorial, please let me know by leaving a post below, or contacting me via email.__
 -->
<!-- Links -->
<!-- www -->

[pip]:             https://pip.pypa.io/en/stable/user_guide/#requirements-files
[pep440]:          https://www.python.org/dev/peps/pep-0440/
[bumpversion]:     https://github.com/peritus/bumpversion
[biostudiosource]: https://gitlab.com/mdyzma/biostudio/tree/master
