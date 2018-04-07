---
layout:     post
author:     Michal Dyzma
title:      Making aliases on Windows
date:       2018-04-07 12:13:22 +0200
comments:   true
mathjax:    false
categories: windows aliases 
keywords:   windows, aliases
---

Short "How To" about emulating `alias` Linux functionality on Windows machine. My default box at work runs Windows OS. Corporate policy. I am creature of habits. Could not change them so drastically, therefore I decided to temper a bit with Windows to provide me at least some basic functionalities I am used to.



## Case

Provide Linux OS `alias` functionality on Windows. Most Linux distributions use `.bashrc` and higher rank files to store info about paths or user aliases. They are ready whenever user logs in. If changed, simple source or bash restart provides newest version. 

Personally I do not like to write long commands in bash i.e `git log --pretty=oneline --abbrev-commit --graph --branches` (I know git has it's own system of aliases). I also have bunch of shortcuts I use to navigate or manage files. I prefer to use simple `..` instead of `cd ..` or type simple `jn` instead of `jupyter notebook` etc... Also, I would like to have list of aliases stored permanently in my user files (for future modifications) and to have them accessible in every command line window, when it starts.



## Doskey

Windows command line tool has ``doskey`` which allows to create users own macros.

{% highlight bash %}
$ help doskey

DOSKEY [/REINSTALL] [/LISTSIZE=size] [/MACROS[:ALL | :exename]]
  [/HISTORY] [/INSERT | /OVERSTRIKE] [/EXENAME=exename] [/MACROFILE=filename]
  [macroname=[text]]

  /REINSTALL          Installs a new copy of Doskey.
  /LISTSIZE=size      Sets size of command history buffer.
  /MACROS             Displays all Doskey macros.
  /MACROS:ALL         Displays all Doskey macros for all executables which have

                      Doskey macros.
  /MACROS:exename     Displays all Doskey macros for the given executable.
  /HISTORY            Displays all commands stored in memory.
  /INSERT             Specifies that new text you type is inserted in old text.

  /OVERSTRIKE         Specifies that new text overwrites old text.
  /EXENAME=exename    Specifies the executable.
  /MACROFILE=filename Specifies a file of macros to install.
  macroname           Specifies a name for a macro you create.
  text                Specifies commands you want to record.

UP and DOWN ARROWS recall commands; ESC clears command line; F7 displays
command history; ALT+F7 clears command history; F8 searches command
history; F9 selects a command by number; ALT+F10 clears macro definitions.

The following are some special codes in Doskey macro definitions:
$T     Command separator.  Allows multiple commands in a macro.
$1-$9  Batch parameters.  Equivalent to %1-%9 in batch programs.
$*     Symbol replaced by everything following macro name on command line.It is great for most activities related to 
{% endhighlight %}


Great! I can put all handy aliases in the batch file. For example:

**C:\Users\MIDY\mydoskey.cmd**
{% highlight bash %}
doskey py27=cd %UserProfile%\py27_32\Scripts $T activate $T cd %UserProfile% $T jupyter lab
doskey today=python -c "import datetime;print(datetime.datetime.now())"
doskey jl=jupyter lab
doskey jn=jupyter notebook
doskey ..=cd ..
doskey ss=git status
doskey gl=git log --pretty=oneline --abbrev-commit --graph --branches
doskey gb=git checkout -b

cls

{% endhighlight %}

What do we have here? A command activating and running jupyer in specific environment, with specific python version. A `today` command invoking python interpreter to give me date and time at this moment. Shortcuts for too long jupyter commands, same with git. At the end of the script I invoke clean, to start with new prompt. 

Two pro-tips:

1. No spaces after and before `=`.
2. Do not name your `.cmd` file `doskey.cmd`. It confuses Windows :)

This way, when I execute `mydoskey.cmd` file, I will have handy shortcuts in current command line session. Wait... Just current session? How about brand new cmd window? Do I have to navigate to this file and execute it each time I want my aliases?! Like Raymond Hettinger used to say: There must be a better way. In Linux user aliases are stored in `.bashrc` and system provides them when user logs in. How to achieve it in Windows?

## Registry

How to make our aliases available automatically, when I start new cmd window? Well, we have got to go deeper and dig in system registry. So, I open Registry Editor (`Win+R` and `regedit`) and navigate to the **`Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor`**

![regedit][regedit]


Add new `REG_EXPAND_SZ` registry entry named **Autorun** with value pointing to my cmd file with aliases. Entry type is inner registry type for ASCII string. I did it like this:

![autorun][autorun]

{% highlight bash %}

{% endhighlight %}

<br>
And voila! Ready. Now whenever new command line starts I can see doskey commands running through the screen (`.cmd` file fired up by starting window and subsequent cleaning job) and I can start using them.


Happy coding!


<!-- Images -->

[regedit]:     /assets/2018-04-07/regedit.png
[autorun]:     /assets/2018-04-07/autorun.png
