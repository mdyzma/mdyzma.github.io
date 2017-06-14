---
layout:     post
author:     Michal Dyzma
title:      "Part 2: Setting up work environment"
date:       2017-05-28 01:15:08
comments:   true
categories: biostudio workflow python GitLab
keywords:   biostudio, workflow, python, GitLab
---

In __Part 2__ I will set up and show how to manage virtual environments in python. Initiate version control and software versioning automation. Additionally I will set up continuous integration service using GitLab, which will include automatic testing with pytest and documentation creation. Code will run tests every time update has been pushed to the master branch of the software repository.

-----

#### About biostudio project

This is part of  what should develop to a series of articles on development process of _Biostudio_ - python GUI app. I will include best practices and solutions used in corporate projects. From preparing  software specifications to fully functional software deployed to the PyPI repository. Final product will be GUI application for Protein Data Bank ```.pdb``` files editor, which carry information about 3D structure of biological macro-molecules.

_Series consists of:_

* [Part 1: Application designs]({{site.url}}/2017/03/26/part1-biostudio-application-design/)
* [Part 2: Setting up work environment]({{site.url}}/2017/05/28/part2-biostudio-setting-up-environment/)
* [Part 3: Automate everything]({{site.url}}/2017/06/24/part3-biostudio-automate-everything/)

<!-- 
* [Part 4: Low Level Design implementation]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/)
 -->

#### Basic configuration

Platform| | **Linux 64 bit** (Fedora or Ubuntu)
Python  | | **3.6.1**
Source  | | [link][bsproject]

<br>
{% include note.html content="I will run the code using docker virtualization technology or spin new VirtualBox of Fedora or Ubuntu, to test how it works freshly out of the box. So I can be sure every piece of code was properly tested. Outputs from my tests will be pasted here, unless they are ridiculous long (hundreds of lines). Then I will truncate output to the bare minimum necessary to understand what is going on." %}

-----

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
    - **pylint** - _code metrics and PEP8 coding standards_
    - **pytest** and plug-ins - _unit tests_: 
        - **pytest-runner**
        - **pytest-cov**
    - **tox** - _generic virtualenv manager_

#### Folders and files

{% highlight bash %}
(biostudio) mdyzma@devbox:~/.envs$ cd
(biostudio) mdyzma@devbox:~$ mkdir -p biostudio/{docs,src/{common,fileandler/pdb,functional},tests/{common,filehandler/pdb,functional},uml}
(biostudio) mdyzma@devbox:~$ cd biostudio/ &&  touch README.md LICENSE setup.py setup.cfg tox.ini
(biostudio) mdyzma@devbox:~$ find src -type d -exec touch {}/__init__.py \;
(biostudio) mdyzma@devbox:~$ find tests -type d -exec touch {}/.gitkeep \;
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
* `MANIFEST.in`
* `setup.py`
* `setup.cfg`
* `tox.ini`

... and `__init__.py` files in each sub-folders of `src/` to make python packages out of them. Later more configuration files will be added, to govern some automation pipelines. I also added `.gitkeep` hidden files to each empty directory, so Git will not ignore them when I push initial folder structure to version control. Later `.gitkeep` will be deleted or appended to `.gitignore` file to make them "invisible" (see: [here](#vcs)) once folders are no longer empty, they will be included as a part of my "push" to the version control system.


Finally skeleton of `biostudio` project is as follows:

{% highlight bash %}
(biostudio) mdyzma@devbox:~$tree biostudio
biostudio/
│   LICENSE
│   MANIFEST.in
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
# this listing does not show .gitkeep files, which are irrelevant for python app
{% endhighlight %}

If you work on legacy project entire structure will be given to you and all this can be substituted with simple `git clone` statement. For _Biostudio_ it might look like this:

{% highlight bash %}
git clone git@gitlab.com:mdyzma/biostudio.git 
{% endhighlight %}

For more details about remote repository and its access see [this section][#remote]

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

It may take some time, since pip manages all the dependencies for each package and their dependencies as well. As I mentioned before, it was not necessary to specify version for every package. Pip downloaded latest available from PyPI. In new projects, created from the scratch it may work, but only in initial stages of project development. When dealing with legacy code, one  have to put more constrains and specify versions for each package, so that there would be no ambiguity and development environment will reflect exactly the one used during program creation, or specified in the SDD. Now I will create such file for future me or other dev team:

{% highlight bash %}
(biostudio) mdyzma@devbox:~$ pip freeze > requirements.txt
# Listing created file
(biostudio) mdyzma@devbox:~/biostudio$ cat requirements.txt 
alabaster==0.7.10
appdirs==1.4.3
argh==0.26.2
astroid==1.5.2
Babel==2.4.0
bumpversion==0.5.3
certifi==2017.4.17
chardet==3.0.3
coverage==4.4.1
docutils==0.13.1
idna==2.5
imagesize==0.7.1
isort==4.2.5
Jinja2==2.9.6
lazy-object-proxy==1.3.1
livereload==2.5.1
MarkupSafe==1.0
mccabe==0.6.1
numpydoc==0.6.0
packaging==16.8
pathtools==0.1.2
pluggy==0.4.0
port-for==0.3.1
py==1.4.33
Pygments==2.2.0
pylint==1.7.1
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
wrapt==1.10.10
{% endhighlight %}

{% include note.html content="To reduce memory usage it is possible to add `--no-cache-dir` flag during dependencies installation. This way pip will not store downloaded packages in local cache directory for future use." %}

Lots of this packages are dependencies from the first list of requirements. This list does not contain all packages from environment, some of them are by default present in the system, therefore were not included in freeze. I could delete all other and leave only few initial, which will install their own dependencies anyway, but it would be a lot of unnecessary work. Simply typing `pip freeze` is all I need to create list of dependencies for my project. Less work, the better.

For more on pip requirements refer to this pep documentation [section][pip].

## Documentation

Another vital aspect of application development is documentation. There are three levels of documentation I will write:

* project- or distribution-level documentation
* API documentation
* code comments

First one is usually written separately from the code (in `docs/`). It is intended to give high-level information on a project, such as installation instructions, examples, and so on. The second,  API-level documentation, summarizes how functions, methods, classes, or modules should be used. It is usually prepared along with the code using Python docstrings. The third level of documentation is in the form of code comments. Such comments help explain how a piece of code works. In this part I will focus on automation of tedious process of **project documentation** and **API documentation** production. This usually goes to the client. Comments are vital part of the project, but I usually treat them as "internal use only". Unless I publish source as well, as in case of this open-source project.


#### Sphinx

I am using Sphinx package to create quality documentation, based on easy to write markup language called _reStructuredText_. `.rst` files will be used to create static website documentation (the same way this blog is created with ruby and jekyll and posts written in markdown). To start documentation I need to run Sphinx creator, which will guide me through setup process:


{% highlight bash %}
(biostudio) mdyzma@devbox:/docs$ sphinx-quickstart

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

Creating file ./source/conf.py.
Creating file ./source/index.rst.
Creating file ./Makefile.
Creating file ./make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file ./source/index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or linkcheck.
{% endhighlight %}

All settings were stored in `docs/source/conf.py`. Basic setup is not enough for me. I will modify `conf.py` and adjust it to the style I usually use when I am writing docstrings. To generate full actual version of documentation I run makefile generated for me by creator:

{% highlight bash %}
(biostudio) mdyzma@devbox:/docs$ make html

Running Sphinx v1.5.1
making output directory...
loading pickled environment... not yet created
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 11 source files that are out of date
updating environment: 11 added, 0 changed, 0 removed
reading sources... [100%] links
looking for now-outdated files... none found
pickling environment... done
checking consistency... done
preparing documents... done
writing output... [100%] links
generating indices... genindex
writing additional pages... search
copying static files... done
copying extra files... done
dumping search index in English (code: en) ... done
dumping object inventory... done
build succeeded.

Build finished. The HTML pages are in build/html.
{% endhighlight %}


## Software versioning


In many projects control over software version is done by hand. There is no need to say that there must be a better way. Book keeping is tedious and error prone, especially in teams with more than one person. Here I will use [bumpversion][bumpversion] package to control software version through out the project files. Also I will use semantic versioning scheme, which  is a recommended versioning convention. The release is represented by three numbers: MAJOR.MINOR.PATCH. The MAJOR number changes with introducing changes to the API, which are not backward compatible. MInor represents some new functionalities, but compatibility is kept. PATCH is incremented, when some bugs are fixed. There is very specific description of versioning and dependency specification in [PEP 440][pep440] Bumpversion uses `setup.cfg` file to keep track of places in the code, where it must be incremented when I change package version. 

Example of bumpversion configuration:

{% highlight bash %}
# setup.cfg file
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

It will search for sepcific phrases in indicated files and change them automatically and commit code to the version control system. To increment version I have to commit all changes and type:

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ bumpversion patch #or minor / major 
{% endhighlight %}

Comment for commit or tag can be added. See [bumpversion documentation][bumpversion] for details


<a name="vcs"></a>

## Code management (VCS)

having basic folder structure, documentation and few other aspects done, it is time to submit code to version control system (VCS). In this project I will use git.

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ git init

Initialized empty Git repository in /home/mdyzma/biostudio/.git/
(biostudio) mdyzma@devbox:~/biostudio$git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        .gitignore
        LICENSE
        MANIFEST.in
        README.md
        docs/
        setup.cfg
        setup.py
        src/
        tests/
        toc.ini
        uml/

nothing added to commit but untracked files present (use "git add" to track)
{% endhighlight %}

I will do as mighty git says:

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ git add .
# ... and check status again
(biostudio) mdyzma@devbox:~/biostudio$ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   .gitignore
        new file:   LICENSE
        new file:   MANIFEST.in
        new file:   README.md
        new file:   docs/Makefile
        new file:   docs/make.bat
        new file:   docs/source/_static/.gitkeep
        new file:   docs/source/_templates/.gitkeep
        new file:   docs/source/conf.py
        new file:   docs/source/index.rst
        new file:   setup.cfg
        new file:   setup.py
        new file:   src/__init__.py
        new file:   src/biostudio.py
        new file:   src/common/__init__.py
        new file:   src/filehandler/__init__.py
        new file:   src/filehandler/pdb/__init__.py
        new file:   src/functional/__init__.py
        new file:   tests/common/.gitkeep
        new file:   tests/filehandler/.gitkeep
        new file:   tests/functional/.gitkeep
        new file:   tests/test_biostudio.py
        new file:   toc.ini
        new file:   uml/.gitkeep

{% endhighlight %}

All changes were staged for commit. I will commit this and tag as `v0.0.0` - my very initial version of _Biostudio_.

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ git commit -m "Initial structure for biostudio"
[master (root-commit) 49cf9ed] Initial structure for biostudio
 24 files changed, 392 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 LICENSE
 create mode 100644 MANIFEST.in
 create mode 100644 README.md
 create mode 100644 docs/Makefile
 create mode 100644 docs/make.bat
 create mode 100644 docs/source/_static/.gitkeep
 create mode 100644 docs/source/_templates/.gitkeep
 create mode 100644 docs/source/conf.py
 create mode 100644 docs/source/index.rst
 create mode 100644 setup.cfg
 create mode 100644 setup.py
 create mode 100644 src/__init__.py
 create mode 100644 src/biostudio.py
 create mode 100644 src/common/__init__.py
 create mode 100644 src/filehandler/__init__.py
 create mode 100644 src/filehandler/pdb/__init__.py
 create mode 100644 src/functional/__init__.py
 create mode 100644 tests/common/.gitkeep
 create mode 100644 tests/filehandler/.gitkeep
 create mode 100644 tests/functional/.gitkeep
 create mode 100644 tests/test_biostudio.py
 create mode 100644 toc.ini
 create mode 100644 uml/.gitkeep
 create mode 100644 uml/class.puml
# ... and add tag
(biostudio) mdyzma@devbox:~/biostudio$ git tag -a v0.0.0 -m "Version 0: File&folder structure"
On branch master

{% endhighlight %}

Now if I check git status it will say:

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ git status
On branch master
nothing to commit, working tree clean
(biostudio) mdyzma@devbox:~/biostudio$ git tag
v0.0.0
(biostudio) mdyzma@devbox:~/biostudio$ git log
commit 49cf9ed6f9d0ca7356ebc134f79cc1672fa3df73
Author: Michal Dyzma <mdyzma@gmail.com>
Date:   Sun May 28 09:59:03 2017 +0200

    Initial structure for biostudio
{% endhighlight %}

All worked and files under git version control. Any change to source files will be tracked and may be saved.


#### Gitignore

I added `.gitignore` file, where I will put all files or folders I do not want to be included in my projects VCS. In fact I use my IDE plug-in to create it for me, with python specific entries added automatically. Currently almost every popular text editors or IDEs have this functionality.

<a name="remote"></a>

#### Remote repository

I intend to keep project on GitLab server, but it is possible to create local repositories with `git init --bare`. This kind of directory is used to clone/pull and push changes and is located locally on users system file. GitLab also allows to use its community version for free and set up own GitLab server. I described this process in [separate blog post]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/).

{% highlight bash %}
# adding remote repository named origin
(biostudio) mdyzma@devbox:~/biostudio$ git remote add origin git@gitlab.com:mdyzma/biostudio.git

# push local changes from master branch to remote origin repository (automatically named origin/master)
(biostudio) mdyzma@devbox:~/biostudio$ git push -u origin master
git push -u origin master
Enter passphrase for key '/c/Users/Michal/.ssh/id_rsa': # I use ssh authentication token
Counting objects: 19, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (15/15), done.
Writing objects: 100% (19/19), 5.58 KiB | 0 bytes/s, done.
Total 19 (delta 0), reused 0 (delta 0)
To gitlab.com:mdyzma/biostudio.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.

(biostudio) mdyzma@devbox:~/biostudio$ git push -u origin --tags
Enter passphrase for key '/c/Users/Michal/.ssh/id_rsa':
Counting objects: 1, done.
Writing objects: 100% (1/1), 182 bytes | 0 bytes/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To gitlab.com:mdyzma/biostudio.git
 * [new tag]         v0.0.0 -> v0.0.0
{% endhighlight %}

#### SSH Authentication

I mentioned I use SSH authentication token. 

## Unit tests

Application is developed using Test Driven Development (TDD) approach. Tests are grouped in package level folder `tests/` and mimics the `src/` folder structure. Tests use `pytest` module. To run entire suite use:

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ pytest
{% endhighlight %}

#### Coverage

Since development employs TDD, test coverage should be high, but this kind of analysis may give some additional insight and help in creating more complete test suit. Coverage will report how ,much code is covered by the unit tests. To get nice html report I use:

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ pytest --cov=src tests/
{% endhighlight %}

Writing unit tests will be described in [Part 3: Test Driven Development]({{site.url}}/2017/04/14/part3-biostudio-design-implementation-tdd/)

## Code analysis

Many IDEs come well equipped with code inspection and reformatting tools, bu there are also separate python packages, which will work in terminal and generate text or html reports on quality of the code (mostly Python style guide [PEP8][pep8] compliment and syntax errors). 


#### pylint

Pylint is a tool that inspects the code for errors and also warns you about coding standard violations. It is integrated with most of currently used IDEs either as a part of the software or available as a plugin. It can be used as a command-line tool as well.

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ pylint src
#or
(biostudio) mdyzma@devbox:~/biostudio$ pylint --output-format=html src > pylint_report.html
{% endhighlight %}


## Packaging

Hearth of the packaging is in `setup.py` and `setup.cfg` files. It contains all info regarding application like name, version, install dependencies, testing dependencies, entry points etc. Content of setup.py is described in detail in [this document](https://packaging.python.org/distributing/#setup-py). 

#### setup.cfg

{% highlight ini %}
[bumpversion]
current_version = 0.0.0
commit = True
tag = True

[bumpversion:file:setup.py]
search = version='{current_version}'
replace = version='{new_version}'

[bumpversion:file:src/__init__.py]
search = __version__ = '{current_version}'
replace = __version__ = '{new_version}'

[bumpversion:file:docs/source/conf.py]
search = version = '{current_version}'
replace = version = '{new_version}'

[bdist_wheel]
universal = 1

[flake8]
exclude = docs

[aliases]
test=pytest
{% endhighlight %}

#### setup.py

{% highlight python %}
from codecs import open
import os.path
from setuptools import (setup, find_packages)

here = os.path.abspath(os.path.dirname(__file__))

# Get the long description from the README file
with open(os.path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='Biostudio',
    version='0.0.0',
    description='A PDB python reader',
    long_description=long_description,
    url='https://gitlab.com/mdyzma/biostudio',
    author='Michal Dyzma',
    author_email='mdyzma@gmail.com',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    keywords='pdb editor',
    packages=find_packages(exclude=['docs', 'tests']),
    entry_points={},
    test_suite='tests',
    test_require=['pytest', 'pytest-runner', 'coverage', 'pytest-cov', 'pylint'],
    install_requires=[]
)
{% endhighlight %}



#### Creating packages

Binary distribution package may be universal wheel file `.whl`, or more traditional package distribution `.tar.gz`. They are called artifacts and their creation will be included into **Continuous Integration** pipeline. To build package manually:
    

{% highlight bash %}
(biostudio) mdyzma@devbox:~/biostudio$ python setup.py bdist_wheel bdist
{% endhighlight %}

Packages are located in **``dist/``** folder.

## Summary

In general, if I omit all listings, status checks and folder navigation, entire work can be enclosed in few commands in terminal. Some of them must be done only once during project preparation, some of them will be repeated with each iteration or task  progress. Here is list of most important commands used so far. I can wrap them up in some shell script i.e `start_script`:

1. Initial steps (only once):
    
{% highlight bash %}
#!/usr/bin/env bash

# Title: start_script
# Author: Michal Dyzma

# create virtual environment
virtualenv biostudio &&
source activate biostudio &&
pip install -r requirements.txt &&
# clone project from the git repository
# git clone git@gitlab.com:mdyzma/biostudio.git 
git remote add origin git@gitlab.com:mdyzma/biostudio.git

# ----------------------------------------------
# Following steps are optional and depend on the fact if I am creator of the project
mkdir -p biostudio/{docs,src/{common,fileandler/pdb,functional},tests/{common,filehandler/pdb,functional},uml} &&
cd biostudio/ &&  touch README.md LICENSE setup.py setup.cfg tox.ini
find src -type d -exec touch {}/__init__.py \; &&
find tests -type d -exec touch {}/.gitkeep \; &&
# ----------------------------------------------

cd docs && sphinx-quickstart
{% endhighlight %}


2. Used frequently every day when work progress will be saved and checked for consistency:

{% highlight bash %}
git add <filename>
git commit -m "Message"
bumpversion patch #or minor / major
git tag -a v{{MAJOR.MINOR.PATCH}} -m "This is my {{MAJOR.MINOR.PATCH}}"
git push origin master
{% endhighlight %}


3. Occasionally to build package, update documentation or check code metrics

{% highlight bash %}
pylint src
python -m pytest --cov=src tests/
cd docs &&  make html

python setup.py bdist bdist_wheel
{% endhighlight %}

If I add my source code to the system path by executing `pip instal -e .` I will not have to proceed `pytest` or  `coverage` with `python -m` command.

This is the essence of entire post. Each command in this three points forms single brick building entire application. Although it is not a problem to execute this commands every time I need them, it may be very confusing if this approach was adopted by entire team. Imagine each developer using different versions of the code, different test coverage and different stage of documentation production. All this must be combined somehow in common code repository, so everyone can pull current most up-to-date software and start to work on it. Also their local changes should update repository for everyone else.

In addition I will need several different virtual environments to test developed package with different Python versions. At least 3 or 4 for Python 3.X and maybe two for Python 2.6 and 2.7. Then I must install all production dependencies in every environment... Dependencies shouldn't change between iterations. System grows quickly and becomes very hard to maintain across development team. I will follow Raymond Hettinger's words, Python core developer, very talented speaker:

> There must be a better way

And there is. In next part I will focus on setting logical pipeline out of my building blocks and ensure each team member has access to the same pool of tests, dependencies etc. If you are interested how to integrate  Continuous Integration and Continuous Deployment into your workflow please check [Part 3: Automate everything]({{site.url}}/2017/06/24/part3-biostudio-automate-everything/).


**If you have any comments, or ideas how to improve this tutorial, please let me know by leaving a post below, or contacting me via email.**


<!-- Links -->
<!-- www -->

[pip]:         https://pip.pypa.io/en/stable/user_guide/#requirements-files
[pep440]:      https://www.python.org/dev/peps/pep-0440/
[pep8]:        https://pypi.python.org/pypi/pep8
[bumpversion]: https://pypi.python.org/pypi/bumpversion
[bsv0]:        https://gitlab.com/mdyzma/biostudio/tags/v0.0.0
[bsproject]:   https://gitlab.com/mdyzma/biostudio
[rtd]:         https://readthedocs.org
[gitlab]:      https://gitlab.com/
