---
layout:     post
author:     Michal Dyzma
title:      Setting Jenkins CI for python application
subtitle:   Setup various CI systems for python projects
date:       2017-10-14 14:53:32 +0200
comments:   true
categories: python devops Jenkins
keywords:   python, devops, Jenkins
---

Jenkins is an open source automation server. It can run any task with sophisticated set of rules regarding source control and/or dependencies between jobs. It is used to automate all sorts of tasks such as building, testing, and deploying software. Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with the Java Runtime Environment installed. In this article I will show how to set up automatic CI/CD pipelines for python applications using Jenkins.


<br>
{% include note.html content="Source code from the article can be downloaded from this [**GitHub repository** ](https://github.com/mdyzma/jenkins-python-test)" %}

## Project


## Jenkins

>"It works on my machine!"

Hom many times did you hear this sentence? Whenever I hear it, it is clear to me, that project has no Continuous Integration implemented. It is built and tested manually (at best) and it is always a bad idea.

Continuous integration is very powerful practice used during software development. And helps save tons of money. Bugs caught early cost ten times less, compared to the bugs spotted at production. Jenkins is considered one of the best DevOps tool, which maximizes chance to produce bug free software, which results in high quality software. It allows to quickly take the code, build it (step omitted in case of python packages, which usually do not require compilation step) on a frequent schedule and deploy into designated, representative environment for testing. Without the ability to automate code deployment, you are left with an enormous piece of manual, repetitive tasks in deployment pipeline:

1. Get current software version from source control server
2. Create test environment
3. Install dependencies
4. Test software (unit and acceptance tests)
5. Deploy

This is typical pipeline in most IT projects. Jenkins can help to automate this work. And not only automate, but to establish common baseline for all developers working in the project. What is baseline? It is entire projects configuration and dependencies i.e. third party packages used in computation, environmental variables and other settings characteristic for the project.

Additionally Jenkins is free and has over 1000 plugins, created by active community, which extend its functionality in every possible way. Plugins provide tools for many languages and functionalities developers around the world add for few decades now.

<br>
{% include note.html content="In this article I assume Jenkins is already installed in the system and runs on [http://localhost:8080](http://localhost:8080). If not, please follow instructions from [https://jenkins.io](https://jenkins.io)." %}

Jenkins fresh out of the box is not very appealing. When logged to the server, you should see following picture:

<br>
![jenkins-start][jenkins_start]

This is very basic view of Jenkins home page, which is crude and very old-school.

True power of Jenkins is within its plugins to support building, deploying and automating any project. Very promising is set of plugins grouped under common name [**Blue Ocean**](https://jenkins.io/doc/book/blueocean/). It is new opening of the Jenkins UI. It has also lots of extensions integrating it with GitLab, GitHub or BitBucket, including very handy creators.

<br>
![jenkins-blue][jenkins_blue]

You can find basic tutorial about Blue Ocean UI functionalities on [Jenkins Blue Ocean tutorial](https://jenkins.io/doc/book/blueocean/getting-started/).

There are many ways of creating Jenkins pipeline:

* free style jobs combinations (not recomended)
* scripted pipelines
* declarative pipelines

In this post, but I will focus only on the last one, most recent and in accordance with best practices.


## Setting up Github project

First we need to create GitHub repository (with `LICENSE` and `.gitignore` for example) and add `Jenkinsfile` to it. Basic pipeline structure, recommended on [Jenkins pipeline tutorial](https://jenkins.io/doc/pipeline/tour/deployment/) is as follows:

<br>
__Jenkinsfile__
{% highlight groovy %}
pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
{% endhighlight %}

There are three default stages and some messages displayed on the screen after stages completion. As name indicates some will always be displayed, some upon success or failure. Post part can be used to communicate with developer to send message about project status.

<br>
Then we can connect our project with Jenkins. To do that I will use Blue Ocean creator. First one needs to connect GitHub account with Jenkins user account (add Personal Access Token), then connect GitHub account. More details about pipeline creation and adding GitHub  access token from scratch - [here](https://jenkins.io/doc/book/blueocean/creating-pipelines/). In general process can be summed up in three slides:

<br>
![First-step][creator_1]

<br>
After that creator leads to specific repository:

<br>
![Second-step][creator_2]

<br>
and finally, Jenkins will auto-discover all steps from `Jenkinsfile` present in the repository. Alternatively one can use  [Blue Ocean Pipeline Editor](https://jenkins.io/doc/book/blueocean/pipeline-editor/). Pipeline will be displayed on the screen:

<br>
![Third-step][creator_3]

<br>
Jenkins displayed also the messages from the `post` section, which meet criteria always, success and changed. Always will be displayed every time Jenkins finishes, success only when no errors were noted during pipeline processing. Changed only when previously status was different. There are also options processed when pipeline failed. Post part is very useful to send feedback to the team via e-mail or other medium like slack.

Finally one can check list of all projects. General list of all projects on Jenkins server looks like this:

<br>
![Projects-list][blue_proj]

<br>
When our project is ready we can start extending pipeline to fit our needs.

## Project steps

Unlike compiled languages, Python doesn’t need a "build" stage per se, but Python projects can still benefit greatly from using Jenkins for continuous integration and delivery. In Python ecosystem there are tools which can be integrated into Jenkins for testing and reporting (i.e. unit tests runners (`pytest`, `nose`) or code metrics reports creators (`pylint`, `Radon`).

<br>
Traditionally our basic pipeline will comprise of the following elements:

----

1. Creating test environment
    - automatic source code pull (from GitHub)
    - installing proper python version
    - installing dependencies
1. Running static code metrics:
    - various raw metrics:
    - tests coverage
    - errors and style check
1. Testing pulled source code
    - unit tests
    - acceptance tests
1. Building proper python distribution package (`.whl`, `.tar`, `.exe`)
1. Deploying to PyPI

----

It is time to rebuild our `Jenkinsfile` to reflect steps given above.

## Test environment

Jenkins uses its user account to create job description folder where it will store all metadata for our porject, including information pulled from `Jenkinsfile`. On debian derived OS it is placed in `/var/lib/jenkins/jobs/<project_name>`. This is our agent. There is another option, which allows using docker as an agent (very nice and clean solution, but this variant will not be described here). In general job folder on the disc will have following structure:

<br>
{% highlight bash %}
[mdyzma@devbox jenkins-python-test]$ tree /var/lib/jenkins/jobs/jenkins-python-test/branches/master
/var/lib/jenkins/jobs/jenkins-python-test/branches/master
├── builds
│   ├── 1
│   │   ├── 1.log
│   │   ├── 2.log
│   │   ├── 3.log
│   │   ├── 4.log
│   │   ├── build.xml
│   │   ├── changelog0.xml
│   │   ├── log
│   │   └── workflow
│   │       ├── 1.xml
│   │       ├── 2.xml
│   │       ├── 3.xml
│   │       └── 4.xml
│   ├── lastFailedBuild -> -1
│   ├── lastStableBuild -> 1
│   ├── lastSuccessfulBuild -> 1
│   └── legacyIds
├── config.xml
├── lastStable -> builds/lastStableBuild
├── lastSuccessful -> builds/lastSuccessfulBuild
├── name-utf8.txt
├── nextBuildNumber
└── scm-revision-hash.xml
{% endhighlight %}

<br>
Most important is `config.xml`, which is Jenkinsfile reflection and stores all steps, commands and logic translated to the xml format. Few years ago it was very important file, since it was used to back up all settings for Jenkins job and pipelines created via web UI. Currently all information is stored in Jenkinsfile.

Another thing is where Jenkins keeps local copy of project source files. Usually it is in `/var/lib/jenkins/workspace/`. This location is also accessible as a `$WORKSPACE` variable.

We will make Jenkins use python virtual environments accessible in the workspace of the project. The best solution is to install Miniconda and manage environments from the jenkins user level. Miniconda will expose `conda` package manager, which is also capable to easily manage python virtual environments.

First lets install Miniconda as jenkins user. Jenkins usually creates account without home directory, therefore we need to switch to the folders owned by jenkins user:

<br>
{% highlight bash %}
[mdyzma@devbox jenkins-python-test]$  sudo -u jenkins sh
[sudo] password for mdyzma: # sudo pass
$ cd /var/lib/jenkins
$ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
...
71% [====================================================>       ] 41.491.372   508KB/s  eta 39s

$ bash Miniconda3-latest-Linux-x86_64.sh

Welcome to Miniconda3 4.3.31

In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>> 
Miniconda3 will now be installed into this location:
/home/mdyzma/miniconda3

- Press ENTER to confirm the location
- Press CTRL-C to abort the installation
- Or specify a different location below

[/home/mdyzma/miniconda3] >>> /var/lib/jenkins/miniconda3
...
installation finished.
Do you wish the installer to prepend the Miniconda3 install location
to PATH in your /home/mdyzma/.bashrc ? [yes|no]
[no] >>>  #no
{% endhighlight %}

<br>
Modifying `.bashrc` of login shell user was pointless. Jenkins usually connects to the service via non-interactive shell, so neither `/etc/profile` nor `/etc/bash.bashrc` configurations have any effect. It means it doesn't run through the same set of scripts that alter the PATH environment variable for logged user (for example when ssh to the jenkins machine or logging to jenkins user via`sudo -u jenkins sh`). To make it work two things need to be done:

1. change main Jenkins shell to bash (this will activate `source` command)
1. make conda path to be visible by jenkins server shell

 To activate `source` command we need to switch to Bourne-again shell (bash) as default shell. Go to __Manage Jenkins -> Configure System -> Shell -> Shell executable__, and input `/bin/bash` into the form. 

Still, we have to expose miniconda binaries to the non-login Jenkins profile. Declarative Pipelines support an environment directive, which allow to define environmental variables. Environment directive used in the top-level pipeline block will apply to all steps within the Pipeline (see: [Jenkins documentation](https://jenkins.io/doc/book/pipeline/syntax/#environment)). We will use it to modify PATH variable.

Now we can easily create and destroy python virtual environment within jenkins pipeline. We can also install all dependencies locally. The post block of the script will remove this environment when pipeline finishes.

Sadly, every time we call the sh command, jenkins will create new temporary shell. This means that if we use source activate in a sh it will be only sources in that shell session. Therefore, we have to activate env in each stage or new sh command we invoke.

<br>
__Jenkinsfile__
{% highlight groovy %}
pipeline {
    agent any

    environment{
        PATH="$PATH:/var/lib/jenkins/miniconda3/bin"
    }

    stages {
        stage('Build environment') {
            steps {
                sh '''conda create --yes -n ${BUILD_TAG} python
                      source activate ${BUILD_TAG} 
                      pip install -r requirements.txt
                    '''
            }
        }
        stage('Test environment') {
            steps {
                sh '''source activate ${BUILD_TAG} 
                      pip list
                      which pip
                      which python
                    '''
            }
        }
    }
    post {
        always {
            sh 'conda remove --yes -n ${BUILD_TAG} --all'
        }
    }
}
{% endhighlight %}

There is also possibility to create separate environment for different python versions (i.e. 2.7 branch). All is needed is python version in create command i.e.: `conda create --yes -n env_name python=2`.

`${BUILD_TAG}` is a string result form combination of `jenkins-${JOB_NAME}-${BUILD_NUMBER}` variables. Convenient to put into a resource file or for easier identification of virtual environment.

Quick peek at conda envs list shows, that system works (38 jobs ran and there is only one -  `root` environment):

{% highlight bash %}
[jenkins@devbox ~]$ conda env list
# conda environments:
#
root                  *  /var/lib/jenkins/miniconda3
{% endhighlight %}


<br>
![jenkins-38][jenkins_38]
## Static code metrics

In this part we will configure static code analysis tools to determine complexity and non-standard practices in the code base. To ensure top quality of the code we can check:

1. Raw code metrics:
    - SLOC, comment lines, blank lines, &c. (`clock` or `sloccount`)
    - Cyclomatic Complexity (i.e. McCabe’s Complexity)
    - the Maintainability Index (a Visual Studio metric)
1. Test coverage (`coverage` or `pytest-cov`, )
1. Style and error check (`pylint`)

There is large diversity of formats among tools. They can produce reports as JSON, HTML and sometimes XML, therefore we have to process all types to create desired result.

Coverage and pytest-cov produce XML outputs. Best option for this tool would be XML format in combination with [JUnit Plugin](https://wiki.jenkins.io/display/JENKINS/JUnit+Plugin).
 
Pylint can generate its own output files, which can be read by [Violation Columns Plugin](https://wiki.jenkins.io/display/JENKINS/Violation+Columns+Plugin).


Radon generates JSON outputs, which are the most problematic of them all. One of possible options is to use allure tool to prepare nice HTML report from specific JSON. Obtained HTML can be presented by general purpose [HTML Publisher Plugin](https://wiki.jenkins.io/display/JENKINS/HTML+Publisher+Plugin).

### Raw metrics

We will use `Radon` package to produce data in json format. Then json and report will be archived (moved to the `build/` folder). 

{% highlight groovy %}
...
    stages{
        stage('Static code metrics') {
            steps {
                echo "Raw metrics"
                sh  ''' source activate ${BUILD_TAG}
                        radon raw --json irisvmpy/ > raw_report.json
                        radon cc --json irisvmpy/ > cc_report.json
                        radon mi --json irisvmpy/ > mi_report.json
                    '''
            }
            post {
                success {
                    publishHTML target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: 'coverage',
                    reportFiles: 'index.html',
                    reportName: 'RCov Report'
                    ]
                }
            }
        }
    } 
    post {
        always {
            sh 'conda remove --yes -n ${BUILD_TAG} --all'
        }
        success {
            echo "build package"
        }
    }
...
{% endhighlight %}


### Test coverage report

Jenkins has very powerful JUnit Plugin. 

We can use GitHub account possibilities and publish reports in [codecov.io](https://codecov.io).

{% highlight groovy %}
...
        stage('Static code metrics') {
            steps {
                echo "Test coverage report"
                sh  ''' source activate ${BUILD_TAG}
                        radon raw --json irisvmpy/
                        radon cc --xml irisvmpy/
                        radon mi --json irisvmpy/ #cyclometric complexity
                    '''
            }
        }
...
{% endhighlight %}


### PEP8 & code metrics reports

{% highlight groovy %}
...
        stage('Static code metrics') {
            steps {
                echo "Error and style report"
                sh  ''' source activate ${BUILD_TAG}
                        radon raw --json irisvmpy/
                        radon cc --xml irisvmpy/
                        radon mi --json irisvmpy/ #cyclometric complexity
                    '''
            }
        }
...
{% endhighlight %}


## Testing

Two types of testing are essential:

1. Unit tests (`pytest` or `unittest`)
1. Acceptance tests (`behave`)

In case of more complex software integration tests may be added to the list. According to agile  "outside-in" approach first we should write acceptance tests (more general test), then precise unit tests (classic TDD)

### Unit tests

Application unit

{% highlight groovy %}
...
        stage('Unit tests') {
            steps {
                echo "Unit testing"
                sh  ''' source activate ${BUILD_TAG}
                        radon raw --json irisvmpy/
                        radon cc --xml irisvmpy/
                        radon mi --json irisvmpy/ #cyclometric complexity
                    '''
            }
        }
...
{% endhighlight %}


### Acceptance tests


{% highlight groovy %}
...
        stage('Acceptance tests') {
            steps {
                echo "Acceptance testing"
                sh  ''' source activate ${BUILD_TAG}
                        behave
                    '''
            }
        }
...
{% endhighlight %}


## Building python package

{% highlight groovy %}
...
    stages{
        stage('Build package') {
            steps {
                echo "Building package"
                sh  ''' source activate ${BUILD_TAG}
                        python setup.py bdist bdist_wheel  
                    '''
            }
        }
    }
    post {
        always {
            sh 'conda remove --yes -n ${BUILD_TAG} --all'
        }
        success {
            archiveArtifacts artifacts: '**/dist/*', fingerprint: true
        }
    }
...
{% endhighlight %}


## Deployment

Package, which passes tests will be uploaded to PyPI server.


## Summary

<br>
{% highlight groovy %}
pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr:'10'))
    }

    environment{
        PATH="$PATH:/var/lib/jenkins/miniconda3/bin"
    }

    triggers {
        pollSCM('H */4 * * 1-5')
    }

    stages {
        stage('Build environment') {
            steps {
                echo "Building virtualenv"
                sh  ''' conda create --yes -n ${BUILD_TAG} python
                        source activate ${BUILD_TAG}
                        pip install -r requirements/dev.txt
                    '''
            }
        }

        stage('Static code metrics') {
            steps {
                echo "Raw metrics"
                sh  ''' source activate ${BUILD_TAG}
                        radon raw --json irisvmpy > raw_report.json
                        radon cc --json irisvmpy > cc_report.json
                        radon mi --json irisvmpy > mi_report.json
                        sloccount --duplicates --wide irisvmpy > sloccount.sc
                    '''
                echo "Test coverage"
                sh  ''' source activate ${BUILD_TAG}
                        coverage run irisvmpy/iris.py 1 1 2 3
                        python -m coverage xml -o ./reports/coverage.xml
                    '''
                echo "Style check"
            }
        }
    }

    post {
        always {
            sh 'conda remove --yes -n ${BUILD_TAG} --all'
        }
        success {
            sh 'ls -las'
            sloccountPublish encoding: '', pattern: ''
            archive '*/reports/*'
            junit "*/reports/*.xml"
        }
    }
}
{% endhighlight %}




<br>
{% include note.html content="Source code from the article can be downloaded from this [**GitHub repository**](https://github.com/mdyzma/jenkins-python-test)" %}


<!-- Images -->

[jenkins_start]:   /assets/2017-10-14/jenkins.png
[jenkins_blue]:    /assets/2017-10-14/jenkins_blue.png
[creator_1]:       /assets/2017-10-14/creator_1.png
[creator_2]:       /assets/2017-10-14/creator_2.png
[creator_3]:       /assets/2017-10-14/creator_3.png
[blue_proj]:       /assets/2017-10-14/blue_projects.png
[jenkins_38]:      /assets/2017-10-14/jenkins_38.png