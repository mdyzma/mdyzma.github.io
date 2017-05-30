---
layout:     post
author:     Michal Dyzma
title:      "Part 3: Automate stuff"
date:       2017-06-24 11:15:08
comments:   true
categories: biostudio implementation python
keywords:   biostudio, implementation, python
---

In __Part 3__ I will set up and managing virtual environments (development, production) with version control and software version automation. Additionally setting up continuous integration service using GitLab.

#### About biostudio project

This is part of  what should develop to a series of articles on development process of _Biostudio_ - python GUI app. I will include best practices and solutions used in corporate projects. From preparing  software specifications to fully functional software deployed to the PyPI repository. Final product will be GUI application for Protein Data Bank ```.pdb``` files editor, which carry information about 3D structure of biological macro-molecules.

_Series consists of:_

* [Part 1: Application designs]({{site.url}}/2017/03/26/part1-biostudio-application-design/)
* [Part 2: Setting up work environment]({{site.url}}/2017/05/28/part2-biostudio-setting-up-environment/)
* [Part 3: Automate stuff]({{site.url}}/2017/06/24/part3-biostudio-automate-stuff/)

<!-- 
* [Part 4: Low Level Design implementation]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/)
 -->
-----


## Basic configuration


Platform| | **Linux 64 bit** (Fedora or Ubuntu)
Python  | | **3.6.1**
Source  | | [link][bsproject]

<br>
{% include note.html content="I will run the code using docker virtualization technology or spin new VirtualBox of Fedora or Ubuntu, to test how it works freshly out of the box. So I can be sure every piece of code was properly tested. Outputs from my tests will be pasted here, unless they are ridiculous long (hundreds of lines). Then I will truncate output to the bare minimum necessary to understand what is going on." %}



## Setting virtual environment and version control


> if it ain't broke… Don't fix it

There is no need to convince anyone, that automated workflow can 



## Automate everything

According to Jazz
proper pipelineautomating 
**Tox** comes to the rescue. Tox is a Python tool for managing virtualenvs. It lets you quickly and easily build virtualenvs and automate running additional build steps like unit tests, documentation generation, and linting. When I download a new Python project at Knewton, I can just run tox, and it’ll build a new virtualenv, install all the dependencies, and run the unit tests. This really reduces setup effort, making it easy to contribute to any Python project by other developers.




And there is.. It is called **Continuous Integration**. At this point I have all necessary tools and command, which would allow me to manually build specific part of my application, by creating packages from particular git commits, or documentation. I can run suit of unit tests and check how some basic metrics of my code look like. I can do it using 5 or six terminal commands, and repeat them each time my work progress. But there is still room for improvement. I want system, which fires up application testing,  builds packages and updates documentation each time i push commits to the repository. Moreover I want to track progress of such pipeline and be able to identify steps which fail and quickly revert to latest stable build. 


#### GitLabCI


#### Read The Docs




Another vital aspect is documentation dissemination. It is hard to expect from users to download current source code, install all dependencies (sometimes very numerous) and build actual documentation themselves. [Read the docs web site][rtd] comes to the rescue. Every registered user can bind GitHub or GitLab repository with the service, and have automatic build system, which will sense changes in the repository and rebuild documentation every time push command was executed.

<!-- 

Now that I have virtualenvs for the projects, you’ll want an easy way to build the virtualenv and install all the dependencies from your requirements.txt file. An automatic way to set up virtualenvs is important for getting new users started with your project, and is also useful for enabling you to quickly and easily rebuild broken virtualenvs.

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
