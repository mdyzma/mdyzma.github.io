---
layout:     post
author:     Michal Dyzma
title:      Scrapping Polish weather Institute (IMGW)
date:       2017-04-20 01:15:08
comments:   true
mathjax:    false
categories: python web-scrapping
keywords:   python, web-scrapping
---


IMGW stands for Institute of Meteorology and Water management ([Instytut Meteorologii i Gospodarki Wodnej][imgw]). This article will focus on scrapping data from IMGW API and plotting it. 


## First iteration - make it work

Data from IMGW are accessible via their [web site][imgw-dane]. It is useful, but it may be difficult to get data for 10 or 30 years from specific station and date and data type. Their API accepts only specific urls to display data. It also allows to provide some parameters to get `csv` data delimited with a `;` (it is not a joke...). Anyway lets go to work...







<!-- Links -->

[imgw]:      http://www.imgw.pl/en/
[imgw-dane]: https://dane.imgw.pl
