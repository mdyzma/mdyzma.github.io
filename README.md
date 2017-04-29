# Satatic page blog in jekyll

[Life preview](https://mdyzma.github.io)

This repo contains example blog generated with [jekyll](https://jekyllrb.com).

## Features

1. posts written in markdown
2. [jekyll-whiteglass](https://github.com/yous/whiteglass) theme
3. Google analytics, adwords integration
4. sharing buttons for  social media
5. disqus integration for each post


![blog][screen]

Share buttons and disqus:

![features][screen2]

[screen]: /assets/screen.png
[screen2]: /assets/screen2.png

## Install

Clone repository. You must have ruby and bundle gem installed.

``` gem install bundle```

Go to the blog directory and run:

```bundle install```

This should acquire and install all necessary gems. To preview blog locally type:

```bundle exec jekyll serve```

You can add `--watch` and `--drafts` options to make local server rebuild every time files are changed and to include posts located in `_drafts/` folder.


## Personalization
Some features require extra effort to make it run on your own blog. I tried to make it very smooth and painless. In the end entire personalization (except FB button) requires changing few variables in `_config.yml` file. 

### Google analytics and ad-sense

To enable Google tracking on your blog you need to replace `google_analytics` variable in `_config.yml` with the one provided to you by Google (format "UA-xxxxxxxx-x")

Similar modification is required to get custom Google ad-sense. Change `google_adsense` variable in `_config.yml`.

### Facebook share button

Facebook share requires app running on your account. Create app on Facebook for developers: https://developers.facebook.com

and populate `_config` settings:

```yml
facebook:
 app_id: <number>
 publisher: <name>
 admins: <name>
 ```
Information is available in your app dashboard in Settings tab.

### Disqus integration

Create account in discus and get you disqus short name. Change `_config.yml` variable `disqus` for your own. 

Please note, that disqus does not allow to change your short name. It is part of the unique link associated with the site presenting comments on your blog. Pick it with consideration. 
