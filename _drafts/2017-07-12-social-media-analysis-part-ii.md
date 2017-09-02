---
layout:     post
author:     Michal Dyzma
title:      Social media analysis with Flask, Part II
date:       2017-07-12 16:11:47
comments:   true
mathjax:    false
categories: python social-media Flask machine-learning
keywords:   python, twitter, Flask, machine-learning
---

![banner][banner]<br>
Flask application presenting social media accounts analysis in form of dashboard. It transforms various data sources into clear and concise report. __Part II__ describes creation of landing page and dashboard, with templates, login/register mechanism and data storage in development and production.

<br>
{% include note.html content="Source files for this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/md_analytics/releases/tag/v0.0.3)" %}

-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/) (Setting environment, flask, Travis CI/Heroku CD )
* [Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/) (unfinished) (templates, login/register mechanism, data storage)


## Part I

0. [Basic template](#basic-template)
1. [Landing page](#landing-page)
2. [Login / Register forms](#login-register-forms)
    * [Login](#login)
    * [Register](#register)
3. [Dashboard template](#dashboard-template)
4. [User data in application](#user-data-in-application)
    * [Password management](#password-management)
    * [User profile](#user-profile)
5. [Summary](#summary)

-----


## Basic template

Flask uses very powerful and flexible template engine called [__Jinja2__][jinja]. It allows to define website in small blocks, one by one, which are pieced together to form complete HTML pages. The power of Jinja2 relies on possibility to push some portion of logic (i.e. iteration over list items or table rows). Also changes, or bugs fixes are much easier, since the HTML for each part of the site exists in only one place - template file. But most important feature of Jinja is template inheritance. Flask automagically finds templates in the app directory, but it is a good idea to structure files a bit. 

{% highlight bash %}


{% endhighlight %}



Our basic template, which will render very simple landing page contains:



## Landing page


## Login, Register forms

### Login

### Register




## Dashboard template

## User data in application

### Password management

### User profile

## Summary

Before an application can use a third party OAuth provider (i.e Twitter) we need to register it. For Twitter the location is [https://apps.twitter.com](https://apps.twitter.com). We have to follow Twitter app creator and provide the app name, description, website and callback URL. For the last two we can enter placeholders like _http://example.com_ and _http://127.0.0.1:5000/dashboard/user_. Second address specifies where Twitter should direct app after authentication.

<!-- # TBD

<a name="app"></a>

# Creating Twitter Application

To get started, make sure you have a Twitter [developers account](https://apps.twitter.com/). Create new app:

![create-twitter-app][create_app]

Fill in details, using unique twitter app name and set temporary placeholder address for it. As a return address point to the localhost [http://127.0.0.1:5000/dashboard](http://127.0.0.1:5000/dashboard). This will change in production, but will suffice during development.

Press "Keys and Access Tokens". You will see your __consumer key__ and __consumer secret__ which you will need for your app later. Current app settings are not from any real app and will be removed after development is finished. Therefore I do not bother 

![app-tokens][app_tokens] -->



<!-- Links -->
[jinja]:   http://jinja.pocoo.org


<!-- Images -->

[banner]:       /assets/2017-07-12/banner.png
