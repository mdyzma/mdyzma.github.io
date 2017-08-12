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

Flask application presenting social media accounts analysis in form of dashboard.  Application implements "oAuth sign in mechanisms", specific account data analysis (statistics, EDA, machine learning). It transforms various data sources into clear and concise report. Draws followers and friends network. It is Heroku-deployable. Under version control, tested and CI/CD ready.


-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/)
* [Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/) (unfinished)


## PART II

1. [Data storage](#data_storage)
2. [Landing page](#landing)
    * [Login mechanism](#login)
    * [Register](#register)
3. [Account dashboard](#dashboard):
4. [Register with Twitter](#tw_register)
5. [Twitter oAuth mechanism](#oauth)
6. [Twitter data acquisition](#tw_data)
7. [Twitter data analysis](#tw_analysis)
    * [Timeline statistics](#tm_stats)
    * [Semantic analysis](#tm_semantic)
8. [Followers graph](#tw_folowers)
9. [Friends graph](#tw_friends)

-----


# Register with Twitter

Before an application can use a third party OAuth provider (i.e Twitter) we need to register it. For Twitter the location is [https://apps.twitter.com](https://apps.twitter.com). We have to follow Twitter app creator and provide the app name, description, website and callback URL. For the last two we can enter placeholders like _http://example.com_ and _http://127.0.0.1:5000/dashboard/user_. Second address specifies where Twitter should direct app after authentication.

<!-- # TBD

<a name="app"></a>

# Creating Twitter Application

To get started, make sure you have a Twitter [developers account](https://apps.twitter.com/). Create new app:

![create-twitter-app][create_app]

Fill in details, using unique twitter app name and set temporary placeholder address for it. As a return address point to the localhost [http://127.0.0.1:5000/dashboard](http://127.0.0.1:5000/dashboard). This will change in production, but will suffice during development.

Press "Keys and Access Tokens". You will see your __consumer key__ and __consumer secret__ which you will need for your app later. Current app settings are not from any real app and will be removed after development is finished. Therefore I do not bother 

![app-tokens][app_tokens] -->


# TBD

<!-- Images -->

[create_app]:   /assets/07-07-2017/create_twitter_app.png
[app_tokens]:   /assets/07-07-2017/twitter_app_tokens.png