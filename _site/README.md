# Static page blog in jekyll

Blog can be seen [here](https://mdyzma.github.io).

This repo contains example blog generated with ruby static site generator:  [jekyll](https://jekyllrb.com) and liquid templating system.

## Features

### Posts written in markdown

```markdown

---
layout:     post
author:     Michal Dyzma
title:      Jupyter Notebook - python based lab book
date:       2017-04-14 17:28:54 +0200
comments:   true
categories: python jupyter-notebook data
keywords:   python, jupyter notebook, data
---

## Data and biology

Biologist simply can not ignore data anymore.

1. Stating thesis
2. Exploring the data
3. Building formal model/models
4. Interpreting the results
5. Communicating the results

```

### Jekyll-whiteglass theme

General, aesthetic view provided by [__jekyll-whiteglass__](https://github.com/yous/whiteglass) theme.

![theme][white-glass]


### Google analytics & adwords

![features][analytics]

### Sharing buttons for social media

![features][social]

### Disqus integration for each post

![features][disqus]

### Mathjax for LaTeX mathematical formulas

```latex
$$
\frac{\partial c_\gamma}{\partial t} = D_c \Delta c_\gamma + \phi(c) \delta_{\gamma} + \sum_{i=1}^n \left[ k^{-}_{i\gamma} b_{i\gamma} - k^{+}_{i\gamma} c (b^0_{i\gamma} -b_{i\gamma})\right]
$$

```


![features][mathjax]


### bootstrap 3.3.7 & jquery 3.2.1

* hamburger menu colapse
* scrolling navigation bar



## Install

Clone repository:

```
git clone https://github.com/mdyzma/mdyzma.github.io.git
```

You must have ruby and bundle gem installed. To automatically download and install all dependencies go to the blog folder and execute:

```
bundle install
```

This should acquire all necessary gems. To preview blog locally type:

```
bundle exec jekyll serve
```

You can add `--watch` and `--drafts` options to make local server rebuild every time files are changed and to include posts located in `_drafts/` folder.


## Personalization
Some features require extra effort to make it run on your own blog. I tried to make it very smooth and painless. In the end entire personalization (except FB button) requires changing few variables in `_config.yml` file. 

### Google analytics and ad-sense

To enable Google tracking on your blog you need to replace `google_analytics` variable in `_config.yml` with the one provided to you by Google (format "UA-xxxxxxxx-x")

Similar modification is required to get custom Google ad-sense. Change `google_adsense` variable in `_config.yml`.

### Facebook share button

Facebook share requires app running on your FB account. Create app on Facebook for developers: https://developers.facebook.com

and populate `_config` settings:

```yml
facebook:
 app_id: <number>
 publisher: <name>
 admins: <name>
 ```
Information is available in your app dashboard in Settings tab.

### Disqus integration

Create account in Discus service and get you disqus short name. Change `_config.yml` variable `disqus` for your own.

If you want to disable comments in specific post set header variable `comments` to `false` (default value given by template is `true`).

Please note, that disqus does not allow to change your short name. It is part of the unique link associated with the site presenting comments on your blog. Pick it with consideration. 


# LICENSE

The following directories and their contents are Copyright to Michal Dyzma and licensed under terms of GNU/FDL:

* `_posts/`
* `_drafts/`

All other directories and files are MIT licensed unless otherwise specified. Feel free to use jekyll boilerplate as you please. If you do use it, a link back would be appreciated, but is not required.


[white-glass]: /assets/white-glass.png
[social]: /assets/social-media.png
[disqus]: /assets/disqus.png
[mathjax]: /assets/mathjax.png
[analytics]: /assets/g-analytics.png
