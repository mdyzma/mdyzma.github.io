---
layout:     post
author:     Michal Dyzma
title:      Setting Jenkins CI for python application
date:       2017-08-11 14:53:32
comments:   true
mathjakx:   false
categories: python devops Jenkins
keywords:   python, devops, Jenkins
---

Jenkins is a open source automation server which can run any task we can think of. It is used to automate all sorts of tasks such as building, testing, and deploying software. Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with the Java Runtime Environment installed. In this article I will show how to set up complete CI/CD pipeline for python application using Jenkins.

## Installing Jenkins & plugins

Installing the Git plugin

Installing a Jenkins slave

Creating your first Jenkins job

Building Docker containers using Jenkins

Deploying a Java application to Tomcat with zero downtime using Ansible

Continuous integration is one of the most powerful techniques you can use when developing software and it underpins a great deal of what many consider a DevOps tool-chain. Continuous integration (CI) essentially entails taking your code and building it on a frequent schedule and deploying it into a representative environment for the purpose of testing. This automated job should both build and test, if the tests are passed, you can deploy your software into a nominated environment. Without the ability to automate code deployment, you are left with an enormous piece of manual labor in your deployment pipeline. 

### Jenkins
https://jenkins.io

Unlike compiled languages, Python doesn’t need a "build" per se. Python projects can still benefit greatly from using Jenkins for continuous integration and delivery.

In the Python ecosystem there are tools which can be integrated into Jenkins for testing/reporting such as:

nose2 for executing unit tests and generating JUnit-compatible XML test reports and Cobertura-compatible code coverage reports.


http://www.alexconrad.org/2011/10/jenkins-and-python.html


http://bhfsteve.blogspot.be/2012/04/automated-python-unit-testing-code.html

https://tech.knewton.com/blog/2015/09/best-practices-for-python-dependency-management/
https://jpetazzo.github.io/2013/12/01/docker-python-pip-requirements/
https://github.com/pybuilder/pybuilder
https://www.blazemeter.com/blog/jenkins-vs-other-open-source-continuous-integration-servers
