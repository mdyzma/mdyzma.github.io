---
layout:     post
author:     Michal Dyzma
title:      Heroku Django application
date:       2017-06-24 13:07:08
comments:   true
mathjax:    false
categories: python django twitter heroku
keywords:   python, django, twitter, heroku
---


How to build Django application using Twitter REST API to pull data from this site and display them. Application documented with automatic tests and code quality metrics. Version control with git, continuous integration and Heroku deployment with GitLabCI, code coverage with [codecov.io][codecov], with main All according to [this][] document.

## What I need

Several things are necessary to compose working pipeline, wjicj will version control code, ingest changes and run tests, coverage and documentation, staging app to deploy on Heroku. I chode GitLabCI as a base for running all this operations. What I need is:

1. Accounts on gitLab, Heroku, 
2.


## Virtualenv


First of all lets prepare isolated virtual environment. If main python instance does not have `virtualenv` package:

{% highlight bash %}
> pip install virtualenv
{% endhighlight %}


I like to keep my virtual environment organized, therefore I always have `.envs` folder in home directory, where I put different envs from the projects:

{% highlight bash %}
> cd .envs && virtualenv heroku_twitt
...
Installing setuptools, pip, wheel...done.
{% endhighlight %}

Virtualenv will grab your default python and if you would like to change it use `--python=path/to/the/python`.
After that there is only one thing to do  - activate the environment and install dependencies. Activation process differs for UNIX type and Windows OS. If you are on Mac or Linux type:

{% highlight bash %}
> source ~/.envs/bin/activate
{% endhighlight %}

On Windows OS use:

{% highlight bash %}
> %~/.envs/bin/activate
{% endhighlight %}


List of requirements is short at the moment. Content of `requirements.txt`:

{% highlight bash %}
dj-database-url==0.4.2
Django==1.11.2
gunicorn==19.7.1
psycopg2==2.7.1
whitenoise==3.3.0
{% endhighlight %}

Install it with:

{% highlight bash %}
> pip install -r requirements.txt

Installing collected packages: dj-database-url, pytz, Django, gunicorn, psycopg2, whitenoise
Successfully installed Django-1.11.2 dj-database-url-0.4.2 gunicorn-19.7.1 psycopg2-2.7.1 pytz-2017.2 whitenoise-3.3.0
{% endhighlight %}

## Setting GitLab pipeline


Create `.gitlab-ci.yml` file.

{% highlight bash %}
git add .gitlab-ci.yml
git commit -m "Add .gitlab-ci.yml"
git push origin master
{% endhighlight %}

## Set Twitter application






## Django app and development server

### Getting started


### Setting pipeline for automatic tests

### Setting up Documentation



## Heroku deployment

[codecov]: https://codecov.io
