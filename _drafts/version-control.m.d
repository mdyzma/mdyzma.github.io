---
title: version-control.md
layout: post
---



## Version control

Everyone has files like `report_1`, `report_2` or `report_01_12_2016` etc. in project folders. Controlling version of the files helps to organize work and trace progress. Software developers have to trace it even more rigorous. Therefore version control systems (VCS) were created. They help to automatically store and keep track on versions of the source files. Why not use it in every day scientific activity. Currently most popular VCS is `git`. It can be installed from [here][git]. It is free. Just by learning 4-5 commands and adapting specific work-flow, one can start using git in every project. 

I will create test folder and start git repository. 

{% highlight bash %}
> mkdir test && cd test
{% endhighlight %}

Basic git commands:

{% highlight bash %}
> git init
Initialized empty Git repository in home/mdyzma/Documents/test/.git/
{% endhighlight %}

Now I shall add something to the folder, i.e. `README.md` file with project description and start tracing it:
{% highlight bash %}
> touch README.md
# Edit readme in text editor or simply
> echo "# Experiment 1" > README.md
# When we check file content
> cat README.md
"# Experiment 1"
{% endhighlight %}


If I ask git what changed:

{% highlight bash %}
> git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        README.md

nothing added to commit but untracked files present (use "git add" to track)
{% endhighlight %}

I have one untracked file (git figured out, that content of the folder changed). Now I need to add this file to the tracking system. It is simple as:

{% highlight bash %}
> git add README.md
{% endhighlight %}
 
Now if I ask git what changed:

{% highlight bash %}
> git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   README.md
{% endhighlight %}


Once I stop adding new content to the file I will add changed file again (to "stage it") and commit changes to the repository, to keep them there as a current snapshot. git allows me to go back to tis specific version of the file any time. 

{% highlight bash %}
> git commit -m "Added README to the project"
[master (root-commit) cf02fde] Added README to the project
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
{% endhighlight %}

Done! Now any change to the file will be tracked and the same set of instructions must be repeated to store changes:

1. change file
2. `git add <file>`
3. `git commit -m "Message"`

This is very basic introduction to git. Please refer to the [manual][git-man] to get more info about usage and configuration. Now I am going to create few notebooks describing typical biochemical experiments. The theory, data analysis, plots and figures will be presented in notebooks.
 
