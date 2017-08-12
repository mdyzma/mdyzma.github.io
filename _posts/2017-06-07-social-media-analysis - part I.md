---
layout:     post
author:     Michal Dyzma
title:      Social media analysis with Flask, Part I
date:       2017-06-07 16:11:47
comments:   true
mathjax:    false
categories: python social-media Flask machine-learning
keywords:   python, twitter, Flask, machine-learning
---

Flask application presenting social media accounts analysis in form of dashboard.  Application implements "oAuth sign in mechanisms", specific account data analysis (statistics, EDA, machine learning). It transforms various data sources into clear and concise report. Draws followers and friends network. It is Heroku-deployable. Under version control, tested and CI/CD ready.


-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/)
* Social media analysis with Flask, Part II (coming soon)

<!-- * [Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/) (unfinished) -->


## Part I

0. [Application description](#description)
1. [Setting up a development environment](#setting)
3. [Setting Flask application](#set_flask)
    * [Basic file/folder structure](#flask_structure)
    * [Install & test Flask](#install_test_flask)
    * [Requirements](#requirements)
    * [Configuration management](#config_management)

4. [Continuous integration](#set_cicd)
5. [Heroku deployment](#heroku)

-----

<a name="description"></a>

# Application description

Web application displaying properties of the twitter account. Analyzed properties include:

- time-line statistics
- posts semantic analysis
- account followers list (names, number of connections)
- account friends list (names, number of connections)
- followers graph (TBD)
- friends graph (TBD)

## Roles specification

Story to implement:
As a user I want to see results of my twitter account analysis in form of dashboard page.
Steps:

1. I go to “/” page
2. I see “Landing page” with "sign in" and register" buttons
3. I press “sign in” button
    * I am redirected to "/signin" page
    * I enter credentials
    * I am redirected to "/dashboard/user"
4. I press Register” button
    * I am redirected to "/register" page
    * I enter credentials
    * I am redirected to "/dashboard/user" page
5. I see "Connect <SocialMediaName>  account" button, where SocialMediaName is i.e. Twitter or Facebook
6. I follow oAuth flow authorization
7. I get redirected to “/dashboard/user/[SocialMediaName] page
8. I see :
    - timeline statistics (number of my posts, re-tweeted posts)
    - general assessment of all my posts (positive, neutral, negative)
    - social network analysis i.e. followers and/or friends statistics (counts of both groups)
    - a drop-down menu to display list of my:
        - if applicable - followers. Each contains: 
            - A name i.e. Twitter handle, like "__@foo__" or Facebook screen name
            - A number of followers following this person
            - A number of my followers, that this person follows (example, Bob and Rick follow me, Andrew follows both of them, the number is 2).
        - if applicable - my friends, each contains:
            - A Twitter handle, like "__@foo__" or Facebook screen name
            - A number of friends of this person
            - Common friends number
    - followers graph (users as nodes, connections as edges)
    - friends graph (users as nodes, connections as edges)
9. I can export chosen list to the JSON or CVS file
10. I can export chosen graph to 
9. I can log out from the session
10. When I log out I am directed to "/" page

## Other requirements

1. Application should be Heroku-deployable (please provide a link to the working deployment in the README).
2. Application should be documented.
    - Quick-start guide to deploy own version of the application
    - User manual how to operate deployed application
3. Application should be tested (min 90% test coverage)
4. Application should be Version controlled (git)



<a name="setting"></a>

# Setting up a development environment

Flask is written in Python, so before we can start writing Flask apps we must ensure that Python is installed. After Python we have to make sure we have all necessary packages. Simple `pip list` will show all installed packages. New Python distributions come with basic package manager `pip` and tools helping in packages distribution: `setuptools` and `wheel`.

{% highlight bash %}
[mdyzma@devbox ~]$ pip list
DEPRECATION: The default format will switch to columns in the future. You can use --format=(legacy|columns) (or define a format=(legacy|columns) in your pip.conf under the [list] section) to disable this warning.

pip (9.0.1)
setuptools (36.2.0)
wheel (0.30.0a0)
{% endhighlight %}

Another very important tool is `virtualenv`, which will help us to deal with dependency issues. Virtualenv makes it easy to control which versions of Python as well as the third-party packages are used by the project. Another consideration is that installing packages system-wide generally requires elevated privileges (sudo pip install bazz). By using virtualenvs, you can create Python environments and install packages as a regular user. But first virtualenv must be install in your system Python:

{% highlight bash %}
[mdyzma@devbox ~]# sudo pip install virtualenv
Collecting virtualenv
  Downloading virtualenv-15.1.0-py2.py3-none-any.whl (1.8MB)
    100% |################################| 1.8MB 290kB/s
Installing collected packages: virtualenv
Successfully installed virtualenv-15.1.0
{% endhighlight %}

## Virtual environments management

Now that we have the proper tools installed, we are ready to create our first Flask application. First of all we need virtual environment specific for our application. It is a good practice to separate environment working directory and application folder, to avoid putting large folders under version control. What I do usually is to create `.envs` folder in user's home directory and keep all virtual envs there.

{% highlight bash %}
[mdyzma@devbox /]$ virtualenv ~/.envs/md_analytics
New python executable in /home/mdyzma/.envs/md_analytics/bin/python2
Also creating executable in /home/mdyzma/.envs/md_analytics/bin/python
Installing setuptools, pip, wheel...done.
{% endhighlight %}

Now we can activate `md_analytics` virtual environment:

{% highlight bash %}
[mdyzma@devbox /]$ source ~/.envs/md_analytics/bin/activate
(md_analytics) [mdyzma@devbox /]$
{% endhighlight %}

From now on, whenever we want to work on our app and environment is not activated, we have to activate it first. Changed prompt will inform us that now we use "local" python. All packages installed in active environment will be connected to it. To deactivate environment simply type `source deactivate`.


<a name="set_flask"></a>

# Setting Flask application

Setting flask app is a multi-step process, which can be automated with some awesome python tools like [cookiecutter](https://github.com/audreyr/cookiecutter#python), but here we will go step by step to learn it in detail. First we will plan basic application structure, install Flask and test installation, then create automatic configuration mechanism, semi-automatic dependencies installation and finally continuous integration and deployment of the app on Heroku. All tested and under version control (on GitHub).


<a name="flask_structure"></a>

## Basic file/folder structure

It is not required from Flask application to follow particular folder structure like Django application. Only thing is, files should keep names understood by Flask. Although it is not required, it is advised to structure app a bit to speed up development, testing etc. Our twitter app follows this setup:


{% highlight python %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|-- .gitignore
|-- .travis.yml
|-- app.json
|-- app.py
|-- config.py
|-- docs
|   |-- make.bat
|   |-- Makefile
|   `-- source
|       |-- conf.py
|       |-- index.rst
|       |-- _static
|       `-- _templates
|-- LICENSE
|-- Procfile
|-- Procfile.windows
|-- README.md
|-- requirements.txt
|-- requirements
|   |-- dev.txt
|   `-- prod.txt
|-- static
|-- templates
|   |-- footer.html
|   |-- layout.html
|   `-- nav.html
|-- tests
|   |-- test_app.py
|   |-- test_config.py
|   `-- md_analytics
|       |-- test_acquisition.py
|       |-- test_followers.py
|       |-- test_friends.py
|       |-- test_oauth.py
|       `-- test_timeline.py
|       
`-- md_analytics
    |-- __init__.py
    |-- acquisition.py
    |-- followers.py
    |-- friends.py
    |-- oauth.py
    `-- timeline.py
{% endhighlight %}

Most of the files in this make up are self-explanatory. There are several files like `app.json` or `Procfile`which are elements of [Heroku](https://www.heroku.com) machinery. Rest belong to the elements of CI, which ensures consistency and regression compatibility. Detailed description is given in table below:

|-------------+-+--------------------------------------------------------------------------------------------|
|File         | | Description                                                                                |
|:------------|-|:-------------------------------------------------------------------------------------------|
| app.json    | | Orchestrates the different steps involved in getting an application deployed on Heroku.    |
| Procfile    | | Declares what commands are run by application on the Heroku platform.                      |
| app.py      | | Flask app                                                                                  |
| config.py   | | Flask configuration settings                                                               |
| .travis.yml | | Instructions for TravisCI service                                                          |
|-------------+-+--------------------------------------------------------------------------------------------|


<a name="install_test_flask"></a>

## Install & test Flask

Activate virtual environment and install `Flask` locally (command bellow will install this package and it's dependencies):

{% highlight bash %}
(md_analytics) [mdyzma@devbox /]$ pip install Flask
Collecting Flask
  Downloading Flask-0.12.2-py2.py3-none-any.whl (83kB)
    100% |################################| 92kB 388kB/s
    ...

Successfully installed Flask-0.12.2 Jinja2-2.9.6 MarkupSafe-1.0 Werkzeug-0.12.2 click-6.7 itsdangerous-0.24
{% endhighlight %}

Flask and its dependencies were installed. It is good to keep requirements in separate file, to ensure all necessary packages can be installed automatically and do not pollute application directory. 

Currently we have enough to run basic flask application. To test our environment lets write "Hello Flask" tryout. It will use basic routing mechanism to show "Hello Flask!" on the page. Create `md_analytics` folder and `app.py` file in it. In the app Python file type:


{% highlight python %}
from flask import Flask, 

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello, Flask!'

if __name__ == '__main__':
    app.run(debug=True)
{% endhighlight %}

This code creates instance of `Flask` class which is the central object in any Flask project. It has all utilities necessary to create dynamic WSGI app. Running it will initiate local server with single route answering all requests. Name of the view is index, since it is default name, that is looked up by browsers. When we enter domain address (127.0.0.1:5000 in this case) flask will make sure that `index` view is presented in response. Index view is whatever stands after `index()` return statement. If statement on the other hand is Python convention that ensures that the app will run properly when it is called as a Python script from bash.

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ python app.py
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 137-812-343
 127.0.0.1 - - [07/July/2017 13:19:25] "GET / HTTP/1.1" 200 -
 127.0.0.1 - - [07/July/2017 13:19:26] "GET /favicon.ico HTTP/1.1" 404 -
{% endhighlight %}

... should start server on [http://127.0.0.1:5000/](http://127.0.0.1:5000/) saying __Hello, Flask!__ Main page was served properly (code 200) and because we do not have `favicon.ico` file (yet!), browser could not find it, hence 404 error code.

Worked! We are ready to create "real" application and real unit tests. 

<a name="requirements"></a>

## Requirements

 CI services (including Heroku) need requirements file in application root folder. There is `requirements.txt` in our application, which contains link to requirements folder with several files specifying separate sets of packages for different environments in which application runs. Link leads specifically to the `requirements/prod.txt`. However during development we will install packages listed in `requirements/dev.txt`, which of course includes production dependencies:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|
|-- requirements
|   |-- dev.txt
|   `-- prod.txt
`-- requirements.txt
{% endhighlight %}

Now we will link `requirements/prod.txt` to the `requirements/dev.txt`, so that installing development dependencies will also install all required in production (which means when application runs after deployment).

{% highlight bash %}
# requirements.txt

-r requirements/prod.txt
{% endhighlight %}

{% highlight bash %}
# requirements/prod.txt

Flask==0.12.2
{% endhighlight %}

{% highlight bash %}
# requirements/dev.txt

-r prod.txt
{% endhighlight %}

Installing requirements is easy as calling:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ pip install -r requirements.txt
{% endhighlight %}

Calling main requirements is enough to get application up and running, however for development other packages may be needed (i.e. debug toolbar). In development environment it is better to call:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ pip install -r requirements/dev.txt
{% endhighlight %}

<a name="config_management"></a>

## Configuration management

Configuration package will manage different collections of application settings. Basic config class sets just some basic values. Environment specific setting are set in children classes.

{% highlight python %}
# config.py
import os

class BaseConfiguration(object):
    APPLICATION_DIR = os.path.dirname(os.path.realpath(__file__))
    SQLALCHEMY_DATABASE_URI = 'sqlite:///{}/twa.db'.format(APPLICATION_DIR)
    DEBUG = False
    SECRET_KEY = os.urandom(24)

class ProdConfiguration(BaseConfiguration):
    DEBUG = False

class DevConfiguration(BaseConfiguration):
    DEBUG = True
{% endhighlight %}

We can always add other values like API keys later.

Having configuration classes we can tell flask app to manage it dynamically. To do that we have to set environmental variable `APP_SETTINGS` with value related to the environment app is running. On Heroku server it will be `config.ProdConfiguration` on development environment it will be `config_app.DevConfiguration`. To set environmental variable in linux type: `export APP_SETTINGS=config_app.<NameOfClass> (i.e. export APP_SETTINGS=config_app.DevConfiguration) If we are going to employ environmental variable governing type of configuration, our `app.py` will be:

{% highlight python %}
import os
from flask import Flask
import config_app


app = Flask(__name__)
app.config.from_object(os.environ["APP_SETTINGS"])


@app.route('/')
def index():
    return '<h1>Welcome to Social media analytic tool</h1>'


if __name__ == '__main__':
    app.run()
{% endhighlight %}


<a name="set_cicd"></a>

# Continuous integration

We will use TravisCI, however it is also possible to build automatic system with GitLab, Jenkins or BuildBot. There are separate articles on this blog describing specific CI/CD options.

To set TravisCI we have to place `.travis.yaml` file in the application root directory. It will contain instructions for TravisCI service what language we use (Python), which versions (2.7, 3.6 and nightly build), how to test application, how to create basic metrics (like test coverage, which will be further processed by [Coveralls.io](https://coveralls.io) service) and finally how to deploy it to the Heroku upon successfully finishing all steps (for detail description of Heroku deployment, see [here](#heroku)). `.travis.yml` file will look similar to this:

{% highlight yml %}
# .travis.yml

language: python

python:
    - "2.7"
    - "3.5"
    - "3.6"
    - "nightly"

# command to install dependencies
install: "pip install -r requirements.txt"
# command to run tests
script: python -m pytest

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
    secure: j6wSWWI9Exgdi5B1sST5gOR/mPzJFtllnQVHcB5DeinDpN/XdJUWIzfP5FJVDtUF1qM3N/gdnhN4JkEgeHLNY+vDjhtI9/k8qOn2Gs5yah8a8vSW3/+p4r/WUNQWb3oh6KXc9mzVgV6EFUvLa205WZz0MDF/XPTbTbJqbYKfJxVSjUtHKEo3mmigkjB3bqF8i3QoAmkZX99K3C7mNFrgcGVpeC0EQSgN9Iqdkprlfy8dI6clirwsW6kOIq7zvFIsDTHeBK2piz+lQTPf7yFwmdnxL77K9UwBECmf2IOCpNnNwVevOP/8v1BZGTNhpgvan1OX4t1cd1q2u1nSN3UvC2WDVoDFOAm8wiY4eqcit/GHe9vdaVZKXTjqZ6p7s5FMah1za5hFSdbTUuTkJzUy1mJm7BgU5jnhN2IAf7A+ZZpYrgTrHqxK7b8qfX7sBoVJzbam1gHR7/SAw7qlc43rnEmr/rgWQmnQmHbiaRP1snybY2C5mMTXy4kRTcscYyslqvzn+OLHu/CKyyVaLk9kFDuXL0CjbO++F+W7CRcv9ssngJMFAvTXiX7L34spZk73C1gAqYmptwJglCrtAI29XjKW6uxxsSFbZV368T9BDSzlcZ+nMbYjDtD7ghkjmoHnTq/4qrYghbuFLf4gIX3lPWRZjc9j0rNarNZqZ0F5nuQ=

  app: md-analytics-stage
{% endhighlight %}

YML files are pretty simple to read, I suppose, the only mysterious part is deploy -> api_key. Lets examine this. Once you have registered to Heroku, you will be given API key (Heroku -> account settings). It is unwise to paste your key just like that to the `.travis.yml`. Therefore we will use Travis ruby gem to encrypt it (must have Ruby installed):

{% highlight python %}
(md_analytics) [mdyzma@devbox md_analytics]$ gem install travis
...
12 gems installed
(md_analytics) [mdyzma@devbox md_analytics]$ travis encrypt $(heroku auth:token) --add deploy.api_key
{% endhighlight %}

This appended `.travis.yml` file with encoded. The only thing left to be done is to connect `md_analytics` GitHub with TravisCI service:



<a name="heroku"></a>

# Heroku deployment


For deployment we will use Heroku service. It is good practice to stage changes first and check consistency, and after acceptance tests are over promote stage application to the deployment, where it is accessible for users.

To achieve that we have to create two separate applications. It can be done via Heroku web interface or command line interface. First we need to make sure [HerokuCLI](https://toolbelt.heroku.com) is installed. From my experience as Fedora user it is better to install Heroku official standalone version, instead of Heroku Ruby gem. After successful installation we can proceed and use it to create two separate applications. I called mine: `md-analytics-staging` for staging environment, where app is "finally tested" and `md-analytics` for production environment (app released for users). We will do it in three steps:

1. With HerokuCLI: create apps
2. create pipeline add apps to the pipeline 
2. push files manually to Heroku (later CI system will deploy app to the staging environment upon success. Then after inspecting it app can be manually promoted to `md-analytics`. 

Lets create applications on Heroku service and bind them with a pipeline (group of applications sharing same codebase). I assume we have an application running on local machine. First login to Heroku service:

{% highlight bash %}
[mdyzma@devbox md_analytics]$ heroku login
Enter your Heroku credentials:
Email: mdyzma@gmail.com
Password: ************
Two-factor code: ******
Logged in as mdyzma@gmail.com
{% endhighlight %}

First lets pull GitHub repository. Files will be pushed to the created Heroku application manually (once we configure Travis, it will be done automatically):

{% highlight bash %}
(md_analytics) [mdyzma@devbox ~]$ git clone https://github.com/mdyzma/md_analytics.git
(md_analytics) [mdyzma@devbox ~]$ cd md_analytics
(md_analytics) [mdyzma@devbox md_analytics]$
{% endhighlight %}

{% highlight bash %}
# staging 
(md_analytics) [mdyzma@devbox md_analytics]$ heroku create --region eu --buildpack heroku/python md-analytics
Creating md-analytics... done, region is eu
https://md-analytics.herokuapp.com/ | https://git.heroku.com/md-analytics.git

# ...and production
(md_analytics) [mdyzma@devbox md_analytics]$ heroku create --region eu --buildpack heroku/python md-analytics-stage
Creating md-analytics-stage... done, region is eu
https://md-analytics-stage.herokuapp.com/ | https://git.heroku.com/md-analytics-stage.git
{% endhighlight %}

Order in which apps are created is relevant, because HerokuCLI will add extra remote repository link for our app git, which will point to the Heroku. In fact it is important only if we push changes to Heroku manually (travis has specified app and branch in .yml file), but it is good to know which environment is being updated:


{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ git remote -v
heroku  https://git.heroku.com/md-analytics-stage.git (fetch)
heroku  https://git.heroku.com/md-analytics-stage.git (push)
origin  git@github.com:mdyzma/md_analytics.git (fetch)
origin  git@github.com:mdyzma/md_analytics.git (push)
{% endhighlight %}

As we can see in addition to the original GitHub `origin` repo, we have link to the `heroku`. 

We can also check present apps:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku apps
=== mdyzma@gmail.com Apps
md-analytics (eu)
md-analytics-stage (eu)
{% endhighlight %}

Created apps are empty. All we have is default Heroku message, that our WSGI python app was launched successfully:

![heroku_empty_app][h_empty]

Now we have to set environmental variables, our app relies on and upload application files to the remote location:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku config:set --app md-analytics-stage APP_SETTINGS=config_app.ProdConfiguration
Setting APP_SETTINGS... done
APP_SETTINGS: config_app.ProdConfiguration
{% endhighlight %}

To upload files directly from local master branch to remote heroku repo type:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ git push heroku master

git push heroku master
Counting objects: 50, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (45/45), done.
Writing objects: 100% (50/50), 12.04 KiB | 0 bytes/s, done.
Total 50 (delta 12), reused 4 (delta 0)
remote: Compressing source files... done.
remote: Building source:
remote:
remote: -----> Python app detected
remote: -----> Installing python-3.6.2
remote: -----> Installing pip
remote: -----> Installing requirements with pip
...
remote: -----> Discovering process types
remote:        Procfile declares types -> web
remote:
remote: -----> Compressing...
remote:        Done: 49.3M
remote: -----> Launching...
remote:        Released v3
remote:        https://md-analytics-stage.herokuapp.com/ deployed to Heroku
remote:
remote: Verifying deploy... done.
To https://git.heroku.com/md-analytics-stage.git
 * [new branch]      master -> master
{% endhighlight %}

And voila! App is running in our stage environment:

![heroku-first-stage-deployment][h_first]

After creating apps we can bind hem together in single pipeline. Lets do it from CLI tool. In order to work CLI  requires additional plug-in. Lets install it:

{% highlight python %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku plugins:install heroku-pipelines
Installing plugin heroku-pipelines... done
{% endhighlight %}


Now lets create new pipeline and point specific apps to their environments (HerokuCLI provides nice text interface):

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku pipelines:create -a md-analytics-stage
? Pipeline name md-analytics
? Stage of md-analytics-stage staging
Creating md-analytics pipeline... done
Adding md-analytics-stage to md-analytics pipeline as staging... done
{% endhighlight %}

And add production app, choosing production stage this time:


{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku pipelines:add -a md-analytics md-analytics
? Stage of md-analytics production
Adding md-analytics to md-analytics pipeline as production... done
{% endhighlight %}

Because app was launched without errors, I will promote staging environment to production.

![heroku-connect-gh][h_conn_gh]

 We can also connect Giuthub repository to activate automatic deployment options (with "wait for CI" and "automatic deployment" ticked). If we check Heroku dashboard now we should see:

![heroku-pipeline][h_pipeline]

Unfortunately promoting app does not copy environment's variables, therefore we have to set app specific variables for production as well:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ heroku config:set --app md-analytics APP_SETTINGS=config_app.ProdConfiguration
Setting APP_SETTINGS and restarting md-analytics... done, v4
APP_SETTINGS: config_app.ProdConfiguration
{% endhighlight %}

Now both - staging and production environments run Flask app flawlessly.
<a name="landing"></a>

# Summary

What we have is a Flask application with complete continuous integration and continuous deployment workflow up and running. Basic elements of the system are:

1. Code repository placed on [GitHub](https://github.com/mdyzma/md_analytics)
2. TravisCI continuous integration running pytests and passing app further
3. Two deployment environments on Heroku: [stage](https://git.heroku.com/md-analytics-stage.git) and [production](https://git.heroku.com/md-analytics.git) grouped in one pipeline

Application access for both environments:

* [https://md-analytics-stage.herokuapp.com](http://md-analytics-stage.herokuapp.com)
* [https://md-analytics.herokuapp.com](https://md-analytics.herokuapp.com)

Continue in:

### [Part 2: Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/)


{% highlight python %}
{% endhighlight %}


{% highlight python %}
{% endhighlight %}



<!-- Images -->

[tw_create_app]: /assets/07-06-2017/twitter-create-app.png
[tw_settings]:   /assets/07-06-2017/twitter-app-settings.png
[tw_tokens]:     /assets/07-06-2017/twitter-app-tokens.png
[hello_flask]:   /assets/07-06-2017/hello-flask.png
[h_pipeline]:    /assets/07-06-2017/heroku-pipeline.png
[h_empty]:       /assets/07-06-2017/heroku-empty-app.png
[h_first]:       /assets/07-06-2017/heroku-first-deployment.png
[h_conn_gh]:     /assets/07-06-2017/heroku-connect-github.png

