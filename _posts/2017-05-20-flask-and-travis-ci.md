---
layout:     post
author:     Michal Dyzma
title:      Deploy Flask application with TravisCI
subtitle:   Setup various CI systems for python projects
date:       2017-05-20 18:40:53 +0200
comments:   true
categories: python devops TravisCI
keywords:   python, devops, TravisCI
---

TravisCI is very nice service, which allows to easily build your own  CI/CD platform using GitHub project and configuration file in YAML (YAML Ain't Markup Language) format. Easy to read by ordinary people not speaking binary. CI/CD stands for Continuous Integration and Continuous Deployment (or Delivery). Basic concepts in modern software engineering, which are fancy terms for automating entire software production  pipeline: from unit test, acceptance tests to deployment to the production server.


## TravisCI & GitHub integration

First thing first, register account on [https://travis-ci.org](https://travis-ci.org). The easiest way is to integrate TravisCI with your GitHub account. Go to the GitHub and initialize empty repository. Next go to the Travis profile page and sync repository. Your new project should appear on the list. Find it and enable webhook listening git repository changes on GitHub:

![webhook][webhook]

Now if you check GitHub's __settings tab -> Integration & services__, you will find Travis on the list of connected services:

![settings][settings]

Project s listed on your main Travis Profile, but says _"There is no build on the default branch yet."_. We need ``.travis.yaml`` in our project

## Travis YAML configuration file

To set TravisCI we have to place `.travis.yml` file in the application root directory. It will contain instructions for TravisCI service. Project structure should be similar to this:

{% highlight bash %}
[mdyzma@devbox GitHub]$ tree .
.
|-- travis_python_test/
    |-- .gitignore
    |-- .travis.yml
    |-- LICENSE
    `-- README.md
{% endhighlight %}

YAML is pretty easy to read and write. The most important parts of our CI system will be:

1. __language versions__ used to test app
2. app __dependencies installation__
3. running __code metrics__
    - test coverage
    - documentation coverage
    - pep8 standard consistency check (style guide)
4. running __unit tests__
5. running __acceptance test__
6. __build latest documentation__
7. __deployment to staging__ environment

First lets set language (Python obviously) and version of the interpreter:

__.travis.yml__
{% highlight yml %}
language: python

python:
    - "2.7"
    - "3.5"
    - "3.6"
    - "nightly"
{% endhighlight %}

## Requirements

Depending on your program this will cover 99.5% of all Python users. The 0.5% would cover exotic bio-it labs from the last century and European Space Agency data processing clusters.  Rest already uses Python v3.6 at least. Now let's install all the dependencies needed in our project.

It is best to keep dependencies organized in separate files. One for each environment. Main `requirements.txt` file contains link to the production environment dependencies (used by deployment service). For development purposes I will use superset of requirements from `requirements/dev.txt`


{% highlight bash %}
[mdyzma@devbox travis_python_test]$ tree .
.
|-- .gitignore
|-- .travis.yml
|-- LICENSE
|-- README.md
|
|-- requirements/
|   |-- dev.txt
|   `-- prod.txt
`-- requirements.txt
{% endhighlight %}

Now we will link `requirements/prod.txt` to the `requirements/dev.txt`, so that installing development dependencies will also install all required in production (which means when application is accessible for users). For simple web application requirements may look like this:

__requirements.txt__
{% highlight bash %}
# requirements.txt
# Included because many Paas's require a requirements.txt file in the project root
# Just installs the production requirements.
-r requirements/prod.txt
{% endhighlight %}

__requirements/prod.txt__
{% highlight bash %}
# requirements/prod.txt

# Everything needed in production
# Flask
Flask==0.12.2

# Deployment
gunicorn==19.7.1
{% endhighlight %}

We will add more dependencies while app grows.

__requirements/dev.txt__
{% highlight bash %}
# requirements/dev.txt

-r prod.txt

# Debug
Flask-DebugToolbar==0.10.1

# Test
behave==1.2.5
WebTest==2.0.27
#only in python 2.7
# mock==2.0.0

# PEP8
pylint==1.6.5

# Documentation
Sphinx==1.6.5
sphinx-autobuild==0.7.1
{% endhighlight %}


Installing requirements is easy:

{% highlight bash %}
[mdyzma@devbox GitHub]$ pip install -r requirements.txt
{% endhighlight %}

Calling main requirements is enough to get application up and running, however for development other packages may be needed (i.e. debug toolbar). In development environment it is better to call:

{% highlight bash %}
[mdyzma@devbox GitHub]$ pip install -r requirements/dev.txt
{% endhighlight %}

... and it is exactly what we are going to call in `.travis.yml` file:

__.travis.yml__
{% highlight yml %}
language: python

python:
    - "2.7"
    - "3.5"
    - "3.6"
    - "nightly"

# install dependencies
install: "pip install -r requirements/dev.txt"
{% endhighlight %}

Now when all dependencies were installed successful pipeline should proceed to create code metrics, particularly test coverage, docs coverage and code consistency with PEP8.

## Test coverage


## PEP8 consistency

This is usually resolved on the level of IDE. Most modern Python IDE's have style guide built in the code editor. Therefore, this step is usually skipped in many projects.

> A Foolish Consistency is the Hobgoblin of Little Minds

It is true what Rober Martin wrote: Codes are read much longer time than being written. This style guide exists for consistency. The most important thing is to know when you should break consistency, to keep software maintenance efficient. For example this PEP you should not break backward compatibility.  One of the modules allowing to test code styling is `pylint`. Text report of pylint module may look like this:


{% highlight bash %}
[mdyzma@devbox GitHub]$ pylint src

    Report
    ======
    76 statements analysed.

    Statistics by type
    ------------------

    +---------+-------+-----------+-----------+------------+---------+
    |type     |number |old number |difference |%documented |%badname |
    +=========+=======+===========+===========+============+=========+
    |module   |24     |NC         |NC         |62.50       |4.17     |
    +---------+-------+-----------+-----------+------------+---------+
    |class    |9      |NC         |NC         |77.78       |0.00     |
    +---------+-------+-----------+-----------+------------+---------+
    |method   |8      |NC         |NC         |87.50       |0.00     |
    +---------+-------+-----------+-----------+------------+---------+
    |function |1      |NC         |NC         |100.00      |0.00     |
    +---------+-------+-----------+-----------+------------+---------+

    Raw metrics
    -----------

    +----------+-------+------+---------+-----------+
    |type      |number |%     |previous |difference |
    +==========+=======+======+=========+===========+
    |code      |87     |23.97 |NC       |NC         |
    +----------+-------+------+---------+-----------+
    |docstring |22     |6.06  |NC       |NC         |
    +----------+-------+------+---------+-----------+
    |comment   |179    |49.31 |NC       |NC         |
    +----------+-------+------+---------+-----------+
    |empty     |75     |20.66 |NC       |NC         |
    +----------+-------+------+---------+-----------+

    Messages by category
    --------------------
    ... SKIPPPED ...

    % errors / warnings by module
    -----------------------------
    ... SKIPPPED ...

    Messages
    --------

    +-----------------------+------------+
    |message id             |occurrences |
    +=======================+============+
    |missing-docstring      |12          |
    +-----------------------+------------+
    |too-few-public-methods |9           |
    +-----------------------+------------+
    |invalid-name           |3           |
    +-----------------------+------------+
    |wrong-import-order     |1           |
    +-----------------------+------------+
    |no-self-use            |1           |
    +-----------------------+------------+



    Global evaluation
    -----------------
    Your code has been rated at 6.58/10

{% endhighlight %}

But it is better to redirect stdout to the file, where it can be checked in more civilized way: 

{% highlight bash %}
[mdyzma@devbox GitHub]$ pylint --output-format=html src > pylint_report.html
{% endhighlight %}

And this is exactly what goes to the CI/CD system:

__.travis.yml__
{% highlight yml %}
language: python

python:
    - "2.7"
    - "3.5"
    - "3.6"
    - "nightly"

# install dependencies
install: "pip install -r requirements/dev.txt"

# check style
pylint --output-format=html src > pylint_report.html

{% endhighlight %}

## Documentation

Project's documentation is placed in `docs/` folder and is based on excellent Python `Sphinx` module. Hearth of the documentation is `conf.py` file, where all extensions and static pages generator properties are configured.

{% highlight bash %}
[mdyzma@devbox travis_python_test]$ tree .
.
|-- .gitignore
|-- .travis.yml
|
|-- docs/
|   |-- make.bat
|   |-- Makefile
|   `-- source/
|       |-- _static/
|       |-- _templates/
|       |-- conf.py
|       `-- index.rst
|-- LICENSE
|-- README.md
|
|-- requirements/
|   |-- dev.txt
|   `-- prod.txt
`-- requirements.txt
{% endhighlight %}

Creating basic documentation stub out of the box.

{% highlight bash %}
[mdyzma@devbox docs]$ sphinx-quickstart
Welcome to the Sphinx 1.6.3 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

...
Creating file ./source/conf.py.
Creating file ./source/index.rst.
Creating file ./Makefile.
Creating file ./make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file ./source/index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or link check.
{% endhighlight %}

Following quick-start help, lets build basic html documentation:

{% highlight bash %}
[mdyzma@devbox docs]$ make html

Running Sphinx v1.6.5
loading pickled environment... done
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 0 source files that are out of date
updating environment: 0 added, 0 changed, 0 removed
looking for now-outdated files... none found
no targets are out of date.
build succeeded.

Build finished. The HTML pages are in build/html.
{% endhighlight %}

During development, we will need to build document frequently. Autobuild tool will manage this task and will run local server, which will rebuild sphinx documentation, when it detects changes in `.rst` files. To start server type:
    
{% highlight bash %}
[mdyzma@devbox docs]$ sphinx-autobuild source build\html

+--------- manually triggered build ---------------------------------------------
| Running Sphinx v1.6.5
| loading pickled environment... not yet created
| building [mo]: targets for 0 po files that are out of date
| building [html]: targets for 1 source files that are out of date
| updating environment: 1 added, 0 changed, 0 removed
| reading sources... [100%] index
|
| looking for now-outdated files... none found
| pickling environment... done
| checking consistency... done
| preparing documents... done
| writing output... [100%] index
|
| generating indices... genindex
| writing additional pages... search
| copying static files... done
| copying extra files... done
| dumping search index in English (code: en) ... done
| dumping object inventory... done
| build succeeded.
+--------------------------------------------------------------------------------

[I 171214 23:05:00 server:283] Serving on http://127.0.0.1:8000
[I 171214 23:05:00 handlers:60] Start watching changes
[I 171214 23:05:00 handlers:62] Start detecting changes
{% endhighlight %}

Now we should be able to check docs page in the browser under [http://127.0.0.1:8000](http://127.0.0.1:8000) address.

![docs][docs]

Additionally, we want to keep the latest documentation or even publish it online. But we do not need Travis do it. GitHub repository can be connected to the [ReadTheDocs](https://readthedocs.org) service, which will deploy our documentation on its servers whenever repo has been changed. No need to update `.travis.yml`.

## Application

Lets place basic Flask application in webapp directory:

{% highlight bash %}
[mdyzma@devbox travis_python_test]$ tree .
.
|-- .gitignore
|-- .travis.yml
|-- docs/
|-- LICENSE
|-- README.md
|-- requirements/
|-- requirements.txt
`-- webapp/
    |-- templates/
    |   |-- index.html
    |   `-- layout.html
    |-- __init__.py
    `-- app.py

{% endhighlight %}



## Tests

There are two types of tests I would like to put in project prototype:

- unit tests
- acceptance tests

Unit tests are bound to specific module, class or method/function, while acceptance tests are derived from „User Stories”. Unit tests can be programmed using python's STL module or very popular `pytest`. Acceptance tests use more natural language called gherkin and python library `behave`.

{% highlight bash %}
[mdyzma@devbox travis_python_test]$ tree .
.
|-- .gitignore
|-- .travis.yml
|-- docs/
|-- LICENSE
|-- README.md
|-- requirements/
|-- requirements.txt
|
|-- .behaverc
|
|-- tests/
|    `--features/
|       |-- environment.py
|       |--home.feature
|       `-- steps/
|          `--home_steps.py
`-- webapp/

{% endhighlight %}

Behave discovers basic settings file in form of windows ini, where  we can specify output format and features folder location. For better readability I usually place `features` inside `tests`.

__.behaverc__
{% highlight bash %}
[behave]
show_skipped = false
show_timings = false
default_format = pretty
paths = tests/features
{% endhighlight %}

Another configuration file is located in `features` and exposes web application context to the test environment.

__/features/environment.py__
{% highlight python %}
from webtest import TestApp

from webapp.app import app


def before_scenario(context, scenario):
    context.client = TestApp(app)


def after_scenario(context, scenario):
    del context.client
{% endhighlight %}

__features/home.feature__
{% highlight gherkin %}
Feature: Index page display

    Scenario: Navigation to Home Page
        When I navigate to Home Page
        Then Home Page should be displayed
{% endhighlight %}

__features/steps/home_steps.py__
{% highlight python %}
from behave import *

@when(u'I navigate to Home Page')
def step_impl(ctx):
    ctx.resp = ctx.client.get('/')

@then(u'{text} should be displayed')
def step_impl(ctx, text):
    assert text in ctx.resp
{% endhighlight %}


## Heroku deployment

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|
|-- docs/
|   |-- make.bat
|   |-- Makefile
|   `-- source/
|       |-- _static/
|       |-- _templates/
|       |-- conf.py
|       `-- index.rst
|
|-- app/
|   |-- static/
|   |-- templates/
|   |-- __init__.py
|   |-- app.py
|   `-- settings.py
|
|-- requirements/
|   |-- dev.txt
|   `-- prod.txt
|
|-- tests/
|   `-- app/
|       |-- test_app.py
|       `-- test_settings.py
|
|-- __init__.py
|-- .gitignore
|-- .travis.yml
|-- app.json
|-- LICENSE
|-- manage.py
|-- Procfile
|-- Procfile.windows
|-- README.md
`-- requirements.txt
{% endhighlight %}

Full `.travis.yml`file:

{% highlight yml %}
language: python

python:
    - "2.7"
    - "3.5"
    - "3.6"
    - "nightly"

# command to install dependencies
install: "pip install -r requirements/dev.txt"
# command to run tests
script: python -m pytest --cov=app tests/

after_success:
    - pip install coveralls
    - coverage run --source=flask_oauthlib setup.py -q nosetests
    - coveralls

branches:
  only:
    - master

deploy:
  provider: heroku
  api_key:
    secure: hqJqe/oeO5nQuX8WZkuxlu+Vwr/6OJYFCLN3CCSmaJ1LTaaxlqu89b/chj0evLadykgQMHLmsehW6v6WZlR44ZNxqsMRBk3ypn380jTH+4DNBtPQLEV5UySUGGRlKDBg6UHjNUmhb44vypE0+NpdjbEyYfwxjNXJhT3oogVMlOEiUsOfx/Tor9QA54bu92HhKQTvMHmCxzh4vq2e/e/YiB+x1pPFGqVE3G+KlGTBtjF8rRA7alrjfXUqVLS897tKjwJHtGQt84XNEcXPijlhZSk+M22LZbGo061oP6emhJBDvKqHcIcwa5pR4i9zVbv3XrLPU3icD7qvkSwvdtxnd6Goz4Ybomy4dB/iat46fWnPS0WUmlDHRFo4iKXQMnFLJ79ET/0/gfRrVi54sM/Dru4opFoh4zjld3lwjSAyoAJFlO61hakjtxAM8L3NVMeuiZvXkKjgFIgfCiLlDpK5xyDUhzLqwcOO5UazHwo/pXD32bJgzPbDHaoF1m1QMEhe4HnzHhQJveqaHHPzIXuImBwEJhrCgZjGLDxGx+D93KNY/dDDFItOOQ3493V2CUKjer35c9NOk6cr2kloDVIg4Qfe9Pzg3w9C5n0dakQuaVpHSEnG+oz6PjIIeIItgnYXzJBF5wvU0dWXUcZWmYiQuhjKwFnAfODDMAfPGXC/Yh8=
  app: md-analytics-stage
{% endhighlight %}



<!-- Images -->

[webhook]:    /assets/2017-05-20/webhook.png
[settings]:   /assets/2017-05-20/gh-settings.png
[rtd-connect]:/assets/2017-05-20/rtd-connect.png
[docs]:       /assets/2017-05-20/docs.png
