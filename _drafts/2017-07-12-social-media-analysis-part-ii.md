---
layout:     post
author:     Michal Dyzma
title:      Social media analysis with Flask, Part II
date:       2017-07-12 16:11:47
comments:   true
mathjax:    false
categories: python social-media Flask Jinja2 Flask-Login
keywords:   python, twitter, Flask, Jinja2, Flask-Login
---

![banner][banner]<br>
Flask application presenting social media accounts analysis in form of dashboard. It transforms various data sources into clear and concise report. __Part II__ describes creation of landing page and dashboard, with templates, login/register mechanism and data storage in development and production.

<br>
{% include note.html content="Source files for this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/md_analytics/releases/tag/v0.0.3)" %}

-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/) (Setting environment, flask, Travis CI/Heroku CD )
* [Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/) (Templates, login/register mechanism, data storage)
* [Social media analysis with Flask, Part III]({{site.url}}/2017/08/17/social-media-analysis-part-iii) (Twitter data analysis)

<!-- 
* [Social media analysis with Flask, Part IV]({{site.url}}/2017/09/09/social-media-analysis-part-iv/) (Twitter data analysis)
* [Social media analysis with Flask, Part V]({{site.url}}/2017/10/18/social-media-analysis-part-v/) (Facebook data analysis)
* [Social media analysis with Flask, Part VI]({{site.url}}/2017/11/05/social-media-analysis-part-vi/) (GitHub data analysis)
 -->
## Part II

0. [Jinja engine](#jinja-engine)
1. [Landing page](#landing-page)
2. [Login / Register forms](#login-register-forms)
    * [Login](#login)
    * [Register](#register)
3. [Dashboard](#dashboard)
    * [Template](#template)
4. [User data in application](#user-data-in-application)
    * [Password management](#password-management)
    * [User profile](#user-profile)
5. [Summary](#summary)

-----
 

## Jinja engine

Flask uses very powerful and flexible template engine called [__Jinja2__][jinja]. It allows to define website in small blocks, one by one, which are pieced together to form complete HTML pages. The power of Jinja 2 relies on possibility to push some portion of logic like iteration over list items or table rows, some flow control with `if` or `while` statements. But most important feature of Jinja is template inheritance mechanism similar to class inheritance in python. Basic layout template provides set of blocks, which can be overridden by the content of the specific page. Also changes, or bugs fixes are much easier, since the HTML for each part of the site exists in one place - template file.  Flask auto-magically finds templates in the app directory, but it is a good idea to structure files a bit. 

From organizational point of view, most preferable is modular packaging of files, that specific parts of our application can be moved and adopted to other projects as a whole with its own routing mechanism, static files and templates. Therefore we will write specific components like dashboard or user management will be placed in separate folders and will adopt Flask blueprints pattern.

The landing page is bound to the main endpoint of the app. All files related to this view will be placed in `app/` application folder. Additionally some blocks like navigation bar or head block may become quite complicated, therefore it is better to flatten template structure even more and incorporate them as separate files from `includes/`:

* __static__: all static files served by the app, including css styles, javascript, images or fonts.
* __templates__: folder with HTML blueprints, which allow dynamically generate page content
    * __includes__: folder containing partial HTML snippets for specific purpose i.e. navigation bar, footer, part of templates folder.

Finally lest focus a bit on the stack of tools which will be used in this application. Obviously back-end is Flask and gunicorn, to the front-end I would like to use two popular frameworks:  [Twitter Bootstrap 4][twb4] framework (two files: `bootstrap.min.css` and `bootstrap.min.js`). Additionally we can add standard JQuery library `jquery-3.2.1.slim.min.js`. For [Material Design for Bootstrap][mdb] we should copy `mdb.min.css`, `mdb.min.js`, and `tether.min.js`. They will spice up our web site and give lots of good solutions and javascript functionalities to it. Files are placed in appropriate static sub-folders:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|-- app/
|   |-- static/
|   |   |-- css/
|   |   |   |-- bootstrap.min.css
|   |   |   |-- mdb.min.css
|   |   |   `-- style.css
|   |   |
|   |   |-- font/
|   |   |
|   |   |-- img/
|   |   |
|   |   |-- js/
|   |   |   |-- bootstrap.min.js
|   |   |   |-- jquery-3.2.1.slim.min.js
|   |   |   |-- mdb.min.js
|   |   |   `-- tether.min.js
|   |   `-- favicon.ico
|   |
|   |-- templates/
|   |   |-- includes/
|   |   |   |-- footer.html
|   |   |   |-- head.html
|   |   |   |-- messages.html
|   |   |   `-- nav.html
|   |   |-- base.html
|   |   |-- home.html
|   |   |-- login.html
|   |   `-- register.html
|   |
|   |-- __init__.py
|   |-- app.py
|   |-- forms.py
|   |-- settings.py
|   `-- views.py
...
{% endhighlight %}


Most used Jinja elements, which structure template skeleton are {% raw %}`{% ... %}`{% endraw %} (statements) and {% raw %}`{{ ... }}`{% endraw %} (expressions). Statements provide different means of the work-flow control, for example `if`, `with` conditionals or `for` loops and some pre-defined Jinja tags i.e. `block`, `include`, `call`. Expressions, on the other hand, display dictionary based variables passed to the engine via Flask context mechanism. For more details, please refer to the [Jinja documentation][jinja].

In our template we have specified four large code blocks, which will be filled with details in children templates. The most basic template, the architectural foundation for each page on our site, is called `base.html`. It must contain all elements required by the browser to serve some layout common for entire project. It also includes links to the framework files used in the project (`css` and `js`). From our point of view most important sections are: 

* __head__ section - with necessary metadata for proper SEO and responsive design directives
* __body__
  * __nav__ section - where we place navigation bar common for all pages
  * __messages__ section - part displaying application messages to the user
  * __content__ block - different content on each page
  * __footer__ section - basic structural element with javascript links for all pages and extended footer information like site map, and other links


Base template with all the links to partial templates and code blocks should look similar to this:

__base.html__
{% highlight html linenos %}
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>{% raw %}{% block title %}{% endblock %}{% endraw %} | MD-Analytics</title>
        <!-- Head section meta from include -->
        {% raw %}{% include 'includes/head.html' ignore missing %}{% endraw %}
        {% raw %}{% block seo %}{% endblock %}{% endraw %}  
    </head>
    <body>
        <!-- Top navigation bar from include -->
        {% raw %}{% include 'includes/nav.html' ignore missing %}{% endraw %}
        <!-- Messages flashed to the user -->
        {% raw %}{% include 'includes/messages.html' ignore missing %}{% endraw %}
        <!-- Main content block -->
        {% raw %}{% block content %}{% endblock %}{% endraw %}
        <!-- Footer from include -->
        {% raw %}{% include 'includes/footer.html' ignore missing %}{% endraw %}
    </body>
</html>
{% endhighlight %}

Some fragments of HTML are moved to separate `html` files to keep main template lean and understandable. Fragments like main navigation bar or footer can be quite large and it could affect code readability. Base includes are located in `app/templates/includes/`.

Head include contains meta information common for entire project, like links to the style sheets  or fonts. Special part of page head section is enclosed in separate `seo` block. It will be responsible for SEO meta information (i.e. Google analytics) or  Open Graph tags and other `meta` properties used during linking specific page in social media. 


__head.html__
{% highlight html linenos %}
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Social media analytic tool">
<meta name="author" content="Michal Dyzma">
<!-- Fonts -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link href="https://fonts.googleapis.com/css?family='Fontdiner+Swanky'" rel="stylesheet">
<!-- Bootstrap CSS -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/bootstrap.min.css') }}{% endraw %}">
<!-- Bootstrap Material Design -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/mdb.min.css') }}{% endraw %}">
<!-- Your custom styles (optional) -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/style.css') }}{% endraw %}">
<link rel="shortcut icon" href="{% raw %}{{ url_for('static', filename='favicon.ico') }}{% endraw %}">
{% endhighlight %}


Main navigation bar is common for all pages in the app and will be fixed at the top of the site. It is pretty standard navigation bar, based on Bootstrap and MDB. There is also some Flask helper function enclosed inJinja variable `{{ url_for('index') }}` to manage finding url for main entry point for our application, which is index page.


__nav.html__
{% highlight html linenos %}
<nav class="navbar sticky-top navbar-expand-lg navbar-toggleable-md navbar-dark purple">
    <a class="navbar-brand" href="{{ url_for('index') }}">
        <strong style="font-family:'Fontdiner Swanky', cursive;;">MD ANALYTICS</strong>
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="http://md_analytics.readthedocs.io/en/latest/?badge=latest">Documentation</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="https://github.com/mdyzma/md_analytics">GitHub</a>
            </li>
        </ul>
    </div>
</nav>
{% endhighlight %}


Messages box, will display all communicates produced by application. It improves tremendously user experience with the app. It consists of simple div and some Jinja logic to manage messages produced by Flask:

__messages.html__
{% highlight html linenos %}
<div class="container">
    {% raw %}{% with messages = get_flashed_messages(with_categories=true) %}{% endraw %}
        {% raw %}{% if messages %}{% endraw %}
            {% raw %}{% for category, message in messages %}{% endraw %}
                <div class="alert alert-{{ category }} alert-dismissible" role="alert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    {% raw %}{{ message }}{% endraw %}
                </div>
            {% raw %}{% endfor %}{% endraw %}
        {% raw %}{% endif %}{% endraw %}
    {% raw %}{% endwith %}{% endraw %}
</div>
{% endhighlight %}

Footer part will be also common to all pages. Alongside necessary javascript links, it will include some extended information about policies, social media links, site map and other standard "footer content". For now it has only simple copyright tag.


__footer.html__
{% highlight html linenos %}
<footer>
    <div class="footer-copyright">
        &copy Michal Dyzma 2017
    </div>
</footer>
<!-- jQuery (jQuery may be replaced with other modern JS library to manipulate DOM i.e. `vue.js`) -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/jquery-3.2.1.slim.min.js') }}{% endraw %}"></script>
<!-- tether -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/tether.min.js') }}{% endraw %}"></script>
<!-- Bootstrap core JavaScript -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/bootstrap.min.js') }}{% endraw %}"></script>
<!-- MDB core JavaScript -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/mdb.min.js') }}{% endraw %}"></script>
{% endhighlight %}

Order of links is important. The latter file will overwrite same functionalities from the previous one. Putting it all together we are ready to create first page for our app - landing page! 

## Landing page


Landing page will be named `home.html`. Because it inherits all traits of `base.html` it will contain only elements which differ between this two templates. Rest will be inherited from base. First we should tell Jinja what template we are extending and populate current home template with site-specific content. In our case we will build simple jumbotron just for fun.


__home.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}

<!-- Title for each page -->
{% raw %}{% block title %}Home{% endblock %}{% endraw %}

<!-- Content -->
{% raw %}{% block content %}{% endraw %}
    <div class="jumbotron">
      <div class="container">
        <h1 class="display-3">What is your story?!</h1>
        <p>Learn what what kind of impression you left in the Web.</p>
        <p><a class="btn btn-primary btn-lg" href="#" role="button">Login &raquo;</a></p>
      </div>
    </div>
{% raw %}{% endblock %}{% endraw %}
{% endhighlight %}

It is time to expand main application to use templates created above:


__app/app.py__
{% highlight python linenos %}
# -----------------------------------------------------------------------------
# Standard Library Imports
# -----------------------------------------------------------------------------
import os
# -----------------------------------------------------------------------------
# Related Libraries Imports
# -----------------------------------------------------------------------------
from flask import Flask, render_template
from flask_debugtoolbar import DebugToolbarExtension
# -----------------------------------------------------------------------------
# Local Imports
# -----------------------------------------------------------------------------


def create_app(config_object=None):
    """An application factory, see here: http://flask.pocoo.org/docs/patterns/appfactories/.

    :param config_object: The configuration object to use.
    """
    app = Flask(__name__)
    app.config.from_object(config_object)

    toolbar = DebugToolbarExtension(app)
    app.logger.info("Debug toolbar activated")

    @app.route('/')
    def index():
        return render_template("home.html")

    return app

{% endhighlight %}

This file instead of displaying simple h1 tag (see [Social media analysis with Flask, Part I]({{site.url}}/2017/08/17/social-media-analysis-part-iii)) will render `home.html`, which should resemble this: 


![home][home]

As we can see it Bootstrap and MDB gave us nice look and responsive design (hamburger button which expands to full navigation bar). There is additional element on the page - a very nice tool to debug flask web applications called `Flask-debugtoolbar`. It should be listed in dev requirements and install automatically during environment configuration. It appears on the page as a button at the top of the page and allows to track current Flask session including app configuration, requests, routing, variables and many more.  

## Login, Register forms



### Login


__forms.py__
{% highlight python linenos %}
# some code
{% endhighlight %}


__login.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}

{% raw %}{% block content %}{% endblock %}{% endraw %}
{% endhighlight %}

### Register

__view.py__
{% highlight python linenos %}
# some code
{% endhighlight %}

__forms.py__
{% highlight python linenos %}
# some code
{% endhighlight %}


__register.html__
{% highlight html linenos %}
<!-- some code -->
{% raw %}{% extends "base.html" %}{% endraw %}

{% raw %}{% block content %}{% endblock %}{% endraw %}
{% endhighlight %}



### User data in application

### Password management

### User profile


## Dashboard

Basic structure of the dashboard component is contained in separate folder which gives very high modularity. Each module has its own routing mechanism located in `views.py` and own templates. If it is necessary we can include additional static folder with dashboard related javascript and css styles.

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|-- app/
|   |-- dashboard/
|   |   |
|   |   |-- static/
|   |   |
|   |   |-- teplates/
|   |   |   |
|   |   |   `-- dashboard.html
|   |   |
|   |   `-- views.py
...
{% endhighlight%}


### Template

__templates/dashboard.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}

{% raw %}{% block title %}Dashboard{% endblock %}{% endraw %}

{% raw %}{% block content %}{% endraw %}


    <h2>This is Dashboard page!</h2>


{% raw %}{% endblock %}{% endraw %}
{% endhighlight%}

__view.py__
{% highlight python linenos %}
# some code
{% endhighlight %}


## Summary


<!-- Links -->
[jinja]:  http://jinja.pocoo.org
[twb4]:   http://getbootstrap.com
[mdb]:    https://mdbootstrap.com/material-design-for-bootstrap/
[vue]:    https://vuejs.org

<!-- Images -->

[banner]:   /assets/2017-07-12/banner.png
[home]:     /assets/2017-07-12/home.png
