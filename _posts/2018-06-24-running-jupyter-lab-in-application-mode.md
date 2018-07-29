---
layout:     post
author:     Michal Dyzma
title:      Running Jupyter Lab in application mode
date:       2018-06-24 11:27:24
comments:   true
mathjax:    false
categories: python jupyter
keywords:   python, jupyter 
---

Usually Jupyter Lab runs local server and opens in default browser as a separate tab. It implies all web related parts of the browser, which shrink accessible workspace. One of the ways to make work in Jupyter more comfortable is to run it in app mode.

## App mode in Chrome

We can use Chrome properties and run it in app mode. It removes all UI elements related to web browsing. Running Jupyter Lab this way gives user more RStudio or Spyder like experience, resembling normal desktop applications. 

First we need to run our application with `--no-browser` option to prevent Jupyter Lab from running default system browser


{% highlight bash %}
$ jupyter lab --no-browser
{% endhighlight %}

... which should run application server:


{% highlight bash %}

[I 14:55:23.322 LabApp] JupyterLab beta preview extension loaded from /home/michal/Anaconda3/lib/site-packages/jupyterlab
[I 14:55:23.323 LabApp] JupyterLab application directory is /home/michal/Anaconda3/share/jupyter/lab
[W 14:55:23.326 LabApp] JupyterLab server extension not enabled, manually loading...
[I 14:55:23.326 LabApp] JupyterLab beta preview extension loaded from /home/michal/Anaconda3/lib/site-packages/jupyterlab
[I 14:55:23.326 LabApp] JupyterLab application directory is /home/michal/Anaconda3/share/jupyter/lab
[I 14:55:23.480 LabApp] Serving notebooks from local directory: /home/michal
[I 14:55:23.480 LabApp] 0 active kernels
[I 14:55:23.480 LabApp] The Jupyter Notebook is running at:
[I 14:55:23.481 LabApp] http://localhost:8888/?token=e090fabf5bce60f1db43eee1a5a533f7c00c9cac033f7d6e
[I 14:55:23.481 LabApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 14:55:23.485 LabApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8888/?token=e090fabf5bce60f1db43eee1a5a533f7c00c9cac033f7d6e&token=e090fabf5bce60f1db43eee1a5a533f7c00c9cac033f7d6e

{% endhighlight %}


Copy the URL with token and open another terminal to run Chrome application in the app mode. Location of Chrome executable may differ for particular distribution, but in .rpm family (CentOS, Fedora, RH) it is located in `/opt/google/chrome/google-chrome`. In Windows OS, executable resides in the standard app folder: `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`. When running chrome in app mode we need to specify URL to connect. We should paste URL copied from first terminal:




{% highlight bash %}

$ /opt/google/chrome/google-chrome --app=http://localhost:8888/?token=e090fabf5bce60f1db43eee1a5a533f7c00c9cac033f7d6e&token=e090fabf5bce60f1db43eee1a5a533f7c00c9cac033f7d6e
{% endhighlight %}

![jupyter_app][jupyter_app]


## Make it permanent

Copying URL and pasting it in other terminal instance is cumbersome and counterproductive. In order to make Jupyter Lab to always start this way we need to change jupyter settings. Depending on OS they are located in either `c:\Users\<User>\.jupyter` or `~/.jupyter` for Windows or Linux OS respectively. File with all jupyter options is named: `jupyter_notebook_config.py`. It is not created by default and sometimes we will need to create one for our jupyter app.

To create config file type:

{% highlight bash %}

$ jupyter-lab --generate-config
{% endhighlight %}

This should generate file located in `~/.jupyter/jupyter_notebook_config.py` or `%UserProfile%\.jupyter\jupyter_notebook_config.py`.

To make jupyter always running using chrome browser in app mode, we simply add this specific line somewhere in the file:



__RedHat Family Linux__
{% highlight python %}
#------------------------------------------------------------------------------
# NotebookApp(JupyterApp) configuration
#------------------------------------------------------------------------------

c.LabApp.browser = '/opt/google/chrome/google-chrome --app=%s'
{% endhighlight %}


__Windows__
{% highlight python %}
#------------------------------------------------------------------------------
# NotebookApp(JupyterApp) configuration
#------------------------------------------------------------------------------

c.LabApp.browser = '"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --app=%s'
{% endhighlight %}

Because Windows has spaces in "vendor" created folders it must be surrounded by additional double quotes around binary file location, to allow python evaluate path properly. String substitution will allow to capture current URL (with unique token) and place it in correct position when app starts.


Happy hacking!



[jupyter_app]:   /assets/2018-06-24/jupyter_app.png
