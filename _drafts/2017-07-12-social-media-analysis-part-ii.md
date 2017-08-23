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

![banner][banner]

Flask application presenting social media accounts analysis in form of dashboard.  Application implements "oAuth sign in mechanisms", specific account data analysis (statistics, EDA, machine learning). It transforms various data sources into clear and concise report. This part describes creation of landing page and dashboard, with templates, login/register mechanism and data storage in development and production.

<br>
{% include note.html content="Source files for this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/md_analytics/releases/tag/v0.0.4)" %}

-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/) (Setting environment, flask, Travis CI/Heroku CD )
* Social media analysis with Flask, Part II (templates, login/register mechanism, data storage)

<!-- ({{site.url}}/2017/07/12/social-media-analysis-part-ii/) 

* [Social media analysis with Flask, Part III]({{site.url}}/2017/07/12/social-media-analysis-part-iii/) (Twitter analysis) (comming soon) -->


## Part II

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


# Basic template



# Landing page


# Login, Register forms

## Login

## Register




# Dashboard template

# User data in application

## Password management

## User profile

# Summary

Before an application can use a third party OAuth provider (i.e Twitter) we need to register it. For Twitter the location is [https://apps.twitter.com](https://apps.twitter.com). We have to follow Twitter app creator and provide the app name, description, website and callback URL. For the last two we can enter placeholders like _http://example.com_ and _http://127.0.0.1:5000/dashboard/user_. Second address specifies where Twitter should direct app after authentication.


<!-- Images -->

[banner]:  /assets/12-07-2017/banner.png
