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
Flask application presenting social media accounts analysis in form of dashboard. It transforms various data sources into clear and concise report. __Part II__ describes creation of landing page and dashboard, including blueprints pattern, jinja templates, login/register mechanism and data storage in development and production.

<br>
{% include note.html content="Source files for this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/md_analytics/releases/tag/v0.0.4)" %}

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


1. [Jinja engine](#jinja-engine)
2. [Layout](#layout)
3. [Landing page](#landing-page)
4. [Login / Register forms](#login-register-forms)
    * [Login](#login)
    * [Register](#register)
5. [Dashboard](#dashboard)
    * [Template](#template)
6. [User data in application](#user-data-in-application)
    * [Password management](#password-management)
    * [User profile](#user-profile)
7. [Summary](#summary)

-----


## Jinja engine

Flask uses very powerful and flexible template engine called [__Jinja2__][jinja]. It allows to define website in small blocks, one by one, which then are pieced together, to form complete HTML pages. The power of Jinja relies on possibility to push some portion of logic like iterations over containers or table rows, some flow control with `if` or `while` statements, some text processing capabilities like filtering, even mathematical operations and files handling. All this can be accedes from the web HTML template level. Still most important feature of Jinja is template inheritance mechanism similar to class inheritance in python. Basic layout template provides set of blocks, which can be overridden by the content of the specific page. Also changes, or bugs fixes are much easier, since the HTML for each part of the site exists in one place - template file.  Flask auto-magically finds templates in the app directory, but it is a good idea to structure files a bit. 

From organizational point of view, most preferable is modular packaging of files, that specific parts of our application can be moved and adopted to other projects as a whole with its own routing mechanism, static files and templates. Therefore we will write specific components like dashboard or user management will be placed in separate folders and will adopt Flask blueprints pattern.

The landing page is bound to the main endpoint of the app. All files related to this view will be placed in `app/` application folder. Additionally some blocks like navigation bar or head block may become quite complicated, therefore it is better to flatten template structure even more and incorporate them as separate files from `templates/includes/`:

* __static__: all static files served by the app, including css styles, javascript, images or fonts.
* __templates__: folder with HTML blueprints, which allow dynamically generate page content
    * __includes__: folder containing partial HTML snippets for specific purpose i.e. navigation bar, footer, part of templates folder.

Finally lest focus a bit on the stack of tools which will be used in this application. Obviously back-end is Flask and gunicorn, to the front-end I would like to use two popular frameworks:  [Twitter Bootstrap 4][twb4] to make page responsive and nice without having to write extensive CSS and [Material Design for Bootstrap][mdb], to make things more beautiful. For Bootstrap framework we will need two files: `bootstrap.min.css` and `bootstrap.min.js`. Additionally we can add standard JQuery library `jquery-3.2.1.min.js`. For MDB we will need `mdb.min.css`, `mdb.min.js` and `popper.min.js`. They will spice up our web site and give lots of good solutions and javascript functionalities to it. Files should be placed in appropriate static sub-folders:

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
|   |   |   |-- jquery-3.2.1.min.js
|   |   |   |-- mdb.min.js
|   |   |   `-- popper.min.js
|   |   `-- favicon.ico
|   |
|   |-- templates/
|   |   |-- includes/
|   |   |   |-- footer.html
|   |   |   |-- meta.html
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


In templates we will use several Jinja elements, which will build dynamic structure skeleton. Most frequently used Jinja statements enclosed in {% raw %}`{% ... %}`{% endraw %} and Jinja expressions, enclosed in  {% raw %}`{{ ... }}`{% endraw %}. Statements provide different means of the work-flow control, for example `if`, `with` conditionals or `for` loops and some pre-defined Jinja tags i.e. `block`, `include`, `call`. Expressions, on the other hand, display dictionary based variables passed to the engine via Flask context mechanism. For more details, please refer to the [Jinja documentation][jinja].


## Layout

In our template we have specified several large code blocks, which will be filled with details in children templates. The most basic template, the architectural foundation for each page of our application, is called `base.html`. It contains all elements required by the browser to serve modern page and are common for entire project. It also includes links to the framework files used in the project (`.css` and `.js`). From our point of view most important sections are: 

* __head__ section:
  * __title__ - dynamic tab title
  * __meta__ - with necessary metadata and responsive design directives 
  * __seo__  - for proper SEO information like Open Graph and Twitter cards
  * __styles__ - place for custom css styles present at specific page
* __body__ :
  * __nav__ - where we place navigation bar common for all pages
  * __messages__ - part displaying application messages to the user
  * __intro__  - part specific for landing page
  * __content__ block - different content on each page
  * __footer__ section - basic structural element with extended footer information like site map, and other links


Base template with all the links to partial templates and code blocks should look similar to this:

__/templates/base.html__
{% highlight html linenos %}
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>{% raw %}{% block title %}{% endblock %}{% endraw %} | MD-Analytics</title>
        <!-- Head section meta from include -->
        {% raw %}{% include 'includes/meta.html' ignore missing %}{% endraw %}
        {% raw %}{% block seo %}{% endblock %}{% endraw %}
        {% raw %}{% block styles %}{% endblock %}{% endraw %} 
    </head>
    <body>
        <header>
            <!-- Top navigation bar from include -->
            {% raw %}{% include 'includes/nav.html' ignore missing %}{% endraw %}
            <!-- Messages flashed to the user -->
            {% raw %}{% include 'includes/messages.html' ignore missing %}{% endraw %}
            <!-- Landing page intro, carousel and other  -->
            {% raw %}{% block intro %}{% endblock %}{% endraw %}
        </header>
        <main>
            <!-- Main content block -->
            {% raw %}{% block content %}{% endblock %}{% endraw %}
        </main>
            <!-- Footer from include -->
            {% raw %}{% include 'includes/footer.html' ignore missing %}{% endraw %}
            <!-- jQuery (jQuery may be replaced with other modern JS library to manipulate DOM i.e. `vue.js`) -->
            <script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/jquery-3.2.1.min.js') }}{% endraw %}"></script>
            <!-- popper -->
            <script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/popper.min.js') }}{% endraw %}"></script>
            <!-- Bootstrap core JavaScript -->
            <script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/bootstrap.min.js') }}{% endraw %}"></script>
            <!-- MDB core JavaScript -->
            <script type="text/javascript" src="{% raw %}{{ url_for('static', filename='js/mdb.min.js') }}{% endraw %}"></script>
            <!--Google Maps-->
            <script src="https://maps.google.com/maps/api/js"></script>
            {% raw %}{% block scripts %}
            <!-- Smooth scrolling to the target anchor -->
                <script>
                    $('a').click(function(){
                        $('html, body').animate({
                            scrollTop: $( $(this).attr('href') ).offset().top
                        }, 500);
                        return false;
                    });
                </script>
            {% endblock %}{% endraw %}
    </body>
</html>
{% endhighlight %}


### Head section

Some fragments of HTML are moved to separate `html` files to keep main template lean and understandable. Fragments like main navigation bar or footer can be quite large and it could affect code readability. Base includes are located in `app/templates/includes/` and will be described separately.

Alongside large `meta.html` include there are other blocks building head section of the page. They will differ for specific pages. All special parts of head section are enclosed in separate code blocks: `title`, `seo` and `styles` blocks. Title dynamically manages page title on the tab. SEO is responsible for specific meta information related to page promoting in social media i.e Open Graph tags and other `meta` properties used during linking specific page in popular services. If people want to share it on Facebook, LinkedIn, WhatsApp etc, we can control the appearance of “sharing previews” of a website by means of Open Graph meta tags. There is also additional `styles` block, which is empty in basic template, but allows to incorporate additional css for each child page.

Meta part from head section of the page contains meta information common for entire project, like links to the style sheets or fonts, information for proper indexing by search engines or gathering page statistics i.e. from Google analytics:

__/templates/includes/meta.html__
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


Order of linked css is important. The latter file will overwrite same functionalities from the previous one.

### Body section

Body section contains several distinct blocks: `navbar.html`, `messages.html`, `intro` and `footer.html`. Last is `scripts` block which allows to include site specific JS scripts at the end of the page.

Main navigation bar is common for all pages in the app and will be fixed at the top of the site. It is pretty standard navigation bar, based on Bootstrap and MDB. There is also some Flask helper function enclosed in Jinja variable `{% raw %}{{ url_for('index') }}{% endraw %}` to manage finding url for main entry point for our application, which is landing page.


__/templates/includes/nav.html__
{% highlight html linenos %}
<nav class="navbar navbar-expand-lg navbar-dark elegant-color-dark justify-content-between">
    <a class="navbar-brand" href="{% raw %}{{ url_for('index') }}{% endraw %}">
        <strong style="font-family:'Fontdiner Swanky', cursive;">MD ANALYTICS</strong>
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
            <li class="nav-item">
                <a class="nav-link" href="#contact">Contact</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="#">Login</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Sign Up!</a>
            </li>
        </ul>
    </div>
</nav>
{% endhighlight %}


Messages box, will display all communicates produced by application. Every feedback improves tremendously user experience with the app. It consists of simple div and some Jinja logic to manage messages produced by Flask:

__/templates/includes/messages.html__
{% highlight html linenos %}
<div class="container">
    {% raw %}{% with messages = get_flashed_messages(with_categories=true) %}{% endraw %}
        {% raw %}{% if messages %}{% endraw %}
            {% raw %}{% for category, message in messages %}{% endraw %}
                <div class="alert alert-{% raw %}{{ category }}{% endraw %} alert-dismissible" role="alert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    {% raw %}{{ message }}{% endraw %}
                </div>
            {% raw %}{% endfor %}{% endraw %}
        {% raw %}{% endif %}{% endraw %}
    {% raw %}{% endwith %}{% endraw %}
</div>
{% endhighlight %}

Footer part will be also common to all pages. It will include some extended information about policies, social media links, site map and other standard "footer content". For now it has only simple copyright tag.  Alongside footer info at the end o the page we will link all necessary JS libraries located in __js__ Jinja code block.


__/templates/includes/footer.html__
{% highlight html linenos %}
<!--Footer-->
<footer class="page-footer blue center-on-small-only">
    <!--Footer Links-->
    <div class="container-fluid">
        <div class="row">
            <!--First column-->
            <div class="col-md-6">
                <h5 class="title">MD Analytics</h5>
                <p>Here you can use rows and columns here to organize your footer content.</p>
            </div>
            <!--/.First column-->
            <!--Second column-->
            <div class="col-md-6">
                <h5 class="title">Links</h5>
                <ul>
                    <li><a href="#!">Link 1</a></li>
                    <li><a href="#!">Link 2</a></li>
                    <li><a href="#!">Link 3</a></li>
                    <li><a href="#!">Link 4</a></li>
                </ul>
            </div>
            <!--/.Second column-->
        </div>
    </div>
    <!--/.Footer Links-->
    <!--Copyright-->
    <div class="footer-copyright">
        <div class="container-fluid">
            © 2015 Copyright: <a href="https://www.MDBootstrap.com"> MDBootstrap.com </a>
        </div>
    </div>
    <!--/.Copyright-->
</footer>
<!--/.Footer-->
{% endhighlight %}

This is just example. Exact code for footer can be downloaded from the GitHub repository.

Putting it all together we are ready to create first page for our app - landing page! 


## Landing page

Landing page is located in `templates/home.html`. Because it inherits all traits of `base.html` it will contain only elements which differ between this two templates. Rest will be provided from base. First we should tell Jinja what template we are extending and populate current home template with site-specific content.


__/templates/home.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}
<!-- Title for each page -->
{% raw %}{% block title %}Home{% endblock %}{% endraw %}
<!-- Site Specific Styles -->
{% raw %}{% block styles %}{% endraw %}
<style>
    /* TEMPLATE STYLES */
    .flex-center {
        color: #fff;
    }
    .intro-1 {
        background: url("https://mdbootstrap.com/img/Photos/Horizontal/Work/full page/img%20(2).jpg")no-repeat center center;
        background-size: cover;
    }
    .navbar .btn-group .dropdown-menu a:hover {
            color: #000 !important;
    }
    .navbar .btn-group .dropdown-menu a:active {
            color: #fff !important;
    }
</style>
{% raw %}{% endblock %}{% endraw %}
<!--Intro Section-->
{% raw %}{% block intro %}{% endraw %}
<section class="view intro-1 hm-black-strong">
    <div class="full-bg-img flex-center">
        <div class="container">
            <ul>
                <li>
                    <h1 class="h1-responsive font-bold wow fadeInDown" data-wow-delay="0.2s">What is your story?</h1></li>
                <li>
                    <p class="lead mt-4 mb-5 wow fadeInDown">Learn what kind of impression you left in the web...</p>
                </li>
                <li>
                    <a target="_blank" href="https://mdbootstrap.com/getting-started/" class="btn btn-primary btn-lg wow fadeInLeft" data-wow-delay="0.2s" rel="nofollow">Sign up!</a>
                    <a target="_blank" href="https://mdbootstrap.com/material-design-for-bootstrap/" class="btn btn-default btn-lg wow fadeInRight" data-wow-delay="0.2s" rel="nofollow">Learn more</a>
                </li>
            </ul>
        </div>
    </div>
</section>
<!--Section: Contact-->
<section id="contact pb-5">
    <div class="row">
        <!--First column-->
        <div class="col-md-8 mb-5">
            <div id="map-container" class="z-depth-1 wow fadeIn" style="height: 300px"></div>
        </div>
        <!--/First column-->
        <!--Second column-->
        <div class="col-md-4">
            <ul class="text-center list-unstyled">
                <li class="wow fadeIn" data-wow-delay="0.2s"><i class="fa fa-map-marker teal-text fa-lg"></i>
                    <p>Gen. Grochowskiego 10/28</p>
                    <p>Piaseczno, 05-500 , Poland</p>
                </li>
                <li class="wow fadeIn mt-5 pt-2" data-wow-delay="0.3s"><i class="fa fa-phone teal-text fa-lg"></i>
                    <p>+ 48 570 74 11 75</p>
                </li>
                <li class="wow fadeIn mt-5 pt-2" data-wow-delay="0.4s"><i class="fa fa-envelope teal-text fa-lg"></i>
                    <p>mdyzma@gmail.com</p>
                </li>
            </ul>
        </div>
        <!--/Second column-->
    </div>
</section>
<!--Section: Contact-->
{% raw %}{% endblock %}{% endraw %}
<!-- Content -->
{% raw %}{% block content %}{% endraw %}
<div class="container">
    <div class="divider-new pt-5">
        <h2 class="h2-responsive wow fadeIn" data-wow-delay="0.2s">About me</h2>
    </div>
    <!--Section: About-->
    <section id="about" class="text-center wow fadeIn" data-wow-delay="0.2s">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Velit explicabo assumenda eligendi ex exercitationem harum deleniti quaerat beatae ducimus dolor voluptates magnam, reiciendis pariatur culpa tempore quibusdam quidem, saepe eius.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Velit explicabo assumenda eligendi ex exercitationem harum deleniti quaerat beatae ducimus dolor voluptates magnam, reiciendis pariatur culpa tempore quibusdam quidem, saepe eius.</p>
    </section>
    <!--Section: About-->
</div>
{% raw %}{% endblock %}{% endraw %}

{% raw %}{% block scripts %}{% endraw %}
    {% raw %}{{ super() }}{% endraw %}
    <script>
        function init_map() {
            var var_location = new google.maps.LatLng(52.0690115, 21.0198418,);
            var var_mapoptions = {
                center: var_location,
                zoom: 15
            };
            var var_marker = new google.maps.Marker({
                position: var_location,
                map: var_map,
                title: "New York"
            });
            var var_map = new google.maps.Map(document.getElementById("map-container"),
                var_mapoptions);
            var_marker.setMap(var_map);
        }
        google.maps.event.addDomListener(window, 'load', init_map);
    </script>
{% raw %}{% endblock %}{% endraw %}
{% endhighlight %}

Careful reader noticed `{% raw %}{{ super() }}{% endraw %}` expression in scripts block. We placed some JS code to be present in all pages in base template. Calling `super()` allows to keep all previous content of the block from previous template and append new content to it. So we have smooth scrolling and Google maps map initialization.


Later one can add additional content like about section or nice cards with features description. I added About me description and five cards describing project, but it is just exemplary content. What is more important is backend part of the project. 

It is time to expand main application to use templates created above. First I will add Flask-debugtoolbar to the app, to get access to very handy tool, which monitors working app.


__/app/app.py__
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
    
    app = Flask(__name__)
    app.config.from_object(config_object)

    toolbar = DebugToolbarExtension(app)
    app.logger.debug("Debug toolbar activated")

    @app.route('/')
    def index():
        return render_template("home.html")

    return app

{% endhighlight %}

This file instead of displaying simple `h1` tag (like in [Social media analysis with Flask, Part I]({{site.url}}/2017/08/17/social-media-analysis-part-i)) will render full `home.html` page, which should resemble this: 


![home][home]

Obviously I am no web designer, but this simple stub should do the trick. Also we can see that  Bootstrap and MDB gave us nice look and responsive design (hamburger button which expands to full navigation bar when shrunk below 768 pixels, material style of the buttons and navigation bar). There is additional element on the page - a very nice tool to debug flask web applications called `Flask-debugtoolbar`. It should be listed in dev requirements and install automatically during environment configuration. It appears on the page as a button at the right top corner and allows to track current Flask session including app configuration, requests, routing, variables and many more.

![home-fdt][home_fdt]

## Login, Register forms


It is time to secure our app. Basic tools for us will be login and register forms, which will allow app to exchange information with the server. For getting info from the server app uses HTTP `GET` method, to send information to the server it uses `POST` method. Login and register forms will base on this two to communicate with the database, which will keep information about users. Only logged users will be allowed to see dashboard. In addition logged users can see their own profile with the data app is keeping about them. Lets start with login.

### Login


First lets create login page with all fields:

__/templates/login.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}



{% raw %}{% block content %}{% endblock %}{% endraw %}
{% endhighlight %}


__/app/forms.py__
{% highlight python linenos %}
# some code
{% endhighlight %}




### Register

__/app/views.py__
{% highlight python linenos %}
# some code
{% endhighlight %}

__/app/forms.py__
{% highlight python linenos %}
# some code
{% endhighlight %}


__/templates/register.html__
{% highlight html linenos %}
<!-- some code -->
{% raw %}{% extends "base.html" %}{% endraw %}

{% raw %}{% block content %}{% endblock %}{% endraw %}
{% endhighlight %}



## User data in application

### User page

{% highlight bash %}
(md_analytics) [mdyzma@devbox md_analytics]$ tree .
.
|-- app/
|   |-- user/
|   |   |
|   |   |-- static/
|   |   |
|   |   |-- templates/
|   |   |   |
|   |   |   `-- user.html
|   |   |
|   |   `-- views.py
...
{% endhighlight%}


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
|   |   |-- templates/
|   |   |   |
|   |   |   `-- dashboard.html
|   |   |
|   |   `-- views.py
...
{% endhighlight%}


### Template

__/dashboard/templates/dashboard.html__
{% highlight html linenos %}
{% raw %}{% extends "base.html" %}{% endraw %}

{% raw %}{% block title %}Dashboard{% endblock %}{% endraw %}

{% raw %}{% block content %}{% endraw %}


    <h2>This is Dashboard page!</h2>


{% raw %}{% endblock %}{% endraw %}
{% endhighlight%}

__/dashboard/views.py__
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
[home_fdt]: /assets/2017-07-12/home-fdt.png
