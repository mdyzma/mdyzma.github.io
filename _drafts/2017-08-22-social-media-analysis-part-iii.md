---
layout:     post
author:     Michal Dyzma
title:      Social media analysis with Flask, Part III
date:       2017-08-22 23:05:15
comments:   true
mathjax:    false
categories: python social-media Flask machine-learning
keywords:   python, twitter, Flask, machine-learning
---

Flask application presenting social media accounts analysis in form of dashboard. It transforms various data sources into clear and concise report. __Part III__ describes Twitter oAuth mechanism and data collection via Twitter APIs.

<br>
{% include note.html content="Source files for this article can be downloaded from this [GitHub repository](https://github.com/mdyzma/md_analytics/releases/tag/v0.0.3)" %}

-----

## Series consists of:

* [Social media analysis with Flask, Part I]({{site.url}}/2017/06/07/social-media-analysis-part-I/) (Setting environment, flask, Travis CI/Heroku CD )
* [Social media analysis with Flask, Part II]({{site.url}}/2017/07/12/social-media-analysis-part-ii/) (templates, login/register mechanism, data storage)
* [Social media analysis with Flask, Part III]({{site.url}}/2017/08/17/social-media-analysis-part-iii) (Twitter data analysis)

<!-- 
* [Social media analysis with Flask, Part IV]({{site.url}}/2017/09/09/social-media-analysis-part-iv/) (Twitter data analysis)
* [Social media analysis with Flask, Part V]({{site.url}}/2017/10/18/social-media-analysis-part-v/) (Facebook data analysis)
* [Social media analysis with Flask, Part VI]({{site.url}}/2017/11/05/social-media-analysis-part-vi/) (GitHub data analysis)
 -->
## Part III


The authentication step is typically performed using the industry standard called Open Authorization (OAuth). The process is three legged, meaning that it involves three actors: a user, consumer (our application), and resource provider (the social media platform). The steps in the process are as follows:

The user agrees with the consumer to grant access to the social media platform.
As the user doesn't give their social media password directly to the consumer, the consumer has an initial exchange with the resource provider to generate a token and a secret. These are used to sign each request and prevent forgery.
The user is then redirected with the token to the resource provider, which will ask to confirm authorizing the consumer to access the user's data.
Depending on the nature of the social media platform, it will also ask to confirm whether the consumer can perform any action on the user's behalf, for example, post an update, share a link, and so on.
The resource provider issues a valid token for the consumer.
The token can then go back to the user confirming the access.

<!-- Images -->



