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

Flask uses very powerful and flexible template engine called [__Jinja2__][jinja]. It allows to define website in small blocks, one by one, which are pieced together to form complete HTML pages. The power of Jinja 2 relies on possibility to push some portion of logic like iteration over list items or table rows, some flow control with `if` or `while` statements. But most important feature of Jinja is template inheritance mechanism similar to class inheritance in python. Basic layout template provides set of blocks, which can be overridden by the content of the specific page. Also changes, or bugs fixes are much easier, since the HTML for each part of the site exists in one place - template file.  Flask auto-magically finds templates in the app directory, but it is a good idea to structure files a bit. From organizational point of view, most preferable is modular packaging of files, that specific parts of our application can be moved and adopted to other projects as a whole with its routing mechanism, static files and templates. The landing page is bound to the main endpoint of the app. All files related to this view will be placed in `md_analytics/` application folder. Additionally some blocks like navigation bar or head block may become quite complicated, therefore it is better to flatten template structure even more and incorporate them as separate files from `includes/`:

* __static__: all static files served by the app, including css styles, javascript, images or fonts.
* __templates__: folder with HTML blueprints, which allow dynamically generate page content
    * __includes__: folder containing partial HTML snippets for specific purpose i.e. navigation bar, footer, part of templates folder.

Finally lest focus a bit on the stack of tools which will be used in this application. Obviously back-end is Flask and gunicorn, to the front-end I would like to use two popular frameworks:  [Twitter Bootstrap 4][twb4] framework (two files: `bootstrap.min.css` and `bootstrap.min.js`). Additionally we can add standard JQuery library `jquery-3.2.1.slim.min.js`. For [Material Design for Bootstrap][mdb] we should copy `mdb.min.css`, `mdb.min.js`, and `tether.min.js`. They will spice up our web site and give lots of good solutions and javascript functionalities to it. Files placed in appropriate static sub-folders:

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|-- md_analytics/
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
|   |   |   `-- nav.html
|   |   |-- base.html
|   |   |-- index.html
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
        {% raw %}{% include {{ url_for('templates', filename='includes/head.html') }}{% endraw %}
        {% raw %}{% block seo %}{% endblock %}{% endraw %}  
    </head>
    <body>
        <!-- Top navigation bar from include -->
        {% raw %}{% include {{ url_for('templates', filename='includes/nav.html') }}{% endraw %}
        <!-- Messages flashed to the user -->
        {% raw %}{% include {{ url_for('templates', filename='includes/messages.html') }}{% endraw %}
        <!-- Main content block -->
        {% raw %}{% block content %}{% endblock %}{% endraw %}
        <!-- Footer from include -->
        {% raw %}{% include {{ url_for('templates', filename='includes/footer.html') }}{% endraw %}
    </body>
</html>
{% endhighlight %}

Some fragments of HTML are moved to separate `html` files (includes), to keep main template lean and understandable. Fragments like main navigation bar or footer can be quite large and it could affect template readability. Base includes are located in `md_analytics/templates/includes/` and should contain at least this.

Head include contains meta information common for entire project, like links to the style sheets  or fonts. Special part of page head section is enclosed in separate `seo` block. It will be responsible for SEO meta information (i.e. Google analytics) or  Open Graph tags and other `meta` properties used during linking specific page in social media. 


__head.html__
{% highlight html linenos %}
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Fonts -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
<link href="https://fonts.googleapis.com/css?family='Fontdiner+Swanky'" rel="stylesheet">
<!-- Bootstrap CSS -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/bootstrap.min.css') }}{% endraw %}">
<!-- Bootstrap Material Design -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/mdb.min.css') }}{% endraw %}">
<!-- Your custom styles (optional) -->
<link rel=stylesheet type=text/css href="{% raw %}{{ url_for('static', filename='css/style.css') }}{% endraw %}">
<link rel="shortcut icon" href="{% raw %}{{ url_for('static', filename='favicon.ico') }}{% endraw %}">
{% endhighlight %}


Main navigation bar is common for all pages in the app and will be fixed at the top of the site. It is pretty standard navigation bar, based on Bootstrap and MDB, with one exception - there is also some Jinja logic to manage login button, which look depends on user's status on the page (authenticated or not).


__nav.html__
{% highlight html linenos %}
<nav class="navbar navbar-toggleable-md navbar-dark bg-primary scrolling-navbar">
    <div class="container">
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#collapseEx2" aria-controls="collapseEx2" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
            <a class="navbar-brand" href="/">
                <strong style="font-family:'Fontdiner Swanky', cursive;;">MD-ANALYTICS</strong>
            </a>
        <div class="collapse navbar-collapse" id="collapseEx2">
            <ul class="navbar-nav navbar-left mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#">Documentation</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="https://github.com/mdyzma/md_analytics">GitHub</a>
                </li>
            </ul>
            <ul class="navbar-nav navbar-right">
            {% raw %}{% if current_user.is_authenticated %}{% endraw %}
                <!-- Some content for logged user here -->
            {% raw %}{% else %}{% endraw %}
                <div class="btn-group">
                    <a href="{% raw %}{{ url_for('login') }}{% endraw %}"><button class="btn btn-primary btn-lg" type="submit" name="submit" value="submit"><i class="fa fa-sign-in fa-fw fa-lg" aria-hidden="true"></i> Sign in!</button></a>
                </div>
            {% raw %}{% endif %}{% endraw %}
            </ul>
        </div>
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
    <div>
        &copy   Michal Dyzma 2017
    </div>
</footer>
<!-- jQuery (jQuery may be replaced with other modern JS library to manipulate DOM i.e. `vue.js`) -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/jquery-3.1.1.min.js') }}{% endraw %}"></script>
<!-- tether -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/tether.min.js') }}{% endraw %}"></script>
<!-- Bootstrap core JavaScript -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/bootstrap.min.js') }}{% endraw %}"></script>
<!-- MDB core JavaScript -->
<script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/mdb.min.js') }}{% endraw %}"></script>
{% endhighlight %}

Putting it all together we are ready to create first page for our app - landing page! 

## Landing page


Landing page will be named `index.html`. Because it inherits all traits of `base.html` it will contain only elements which differ between them. First we should tell Jinja what template we are extending and populate current index template with site-specific content:


__index.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}

<!-- Title for each page -->
{% raw %}{% block title %}Home{% endblock %}{% endraw %}

<!-- Content -->
{% raw %}{% block content %}
    <h1>Welcome to landing page!</h1>
{% endblock %}{% endraw %}
{% endhighlight %}


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




## Dashboard

### Template



## User data in application

### Password management

### User profile

## Summary


<!-- Links -->
[jinja]:  http://jinja.pocoo.org
[twb4]:   http://getbootstrap.com
[mdb]:    https://mdbootstrap.com/material-design-for-bootstrap/
[vue]:    https://vuejs.org

<!-- Images -->

[banner]:       /assets/2017-07-12/banner.png
