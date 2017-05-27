---
layout:     post
author:     Michal Dyzma
title:      "**Biostudio** Part 1: Application design"
date:       2017-04-21 11:18:53
comments:   true
categories: biostudio software-engineering python
keywords:   biostudio, software-design, agile, python
---


In __Part 1__ I will present process of application design. From collecting requirements to low level design describing specific algorithms and implementations. Final result should give something in form of _Software Design Document_  that can be easily transformed to professional SSD template which can be used for other projects.

## About biostudio project

This is part of  what should develop to a series of articles on development process of _Biostudio_ - python GUI app. It will include best practices and solutions used in corporate projects. From preparing  software specifications to fully functional software deployed to the PyPI repository. Final product will be GUI application for Protein Data Bank ```.pdb``` files editor, which carry information about molecule 3D structure.

<!-- {% include note.html content="Python version 3 is used throughout this material." %}  -->

-----
_Series consists of:_

* [Part 1: Application designs]({{site.url}}/2017/04/21/part1-biostudio-application-design/)

<!-- * [Part 2: Setting up work environment]({{site.url}}/2017/04/13/part2-biostudio-setting-up-environment/)
* [Part 3: Test Driven Development]({{site.url}}/2017/04/14/part3-biostudio-design-implementation-tdd/)
* [Part 4: Low Level Design implementation]({{site.url}}/2017/04/15/part4-biostudio-design-implementation-continue/)
* [Part 5: Debugging and profiling]({{site.url}}/2017/04/16/part5-biostudio-debugging-and-profiling/)
* [Part 6: Application deployment]({{site.url}}/2017/04/17/part6-biostudio-application-deployment/)
* [Part 7: Application life cycle]({{site.url}}/2017/04/18/part7-biostudio-application-lifecycle/)
* [Part 8: Code metrics]({{site.url}}/2017/04/19/part8-biostudio-code-metrics/) -->

-----

{% include note.html content="PYTHON 3!" %}

## Introduction

Simple fact is that it is not important what kind of methodology you use, as long as it allows you to deliver high quality software at the end of each development cycle (on time and on budget). Most of the small open-source projects is born as an idea in the head of one person, without any design documentation, requirements, with rudimentary diagrams drawn on the piece of paper in the notebook. The only automated task used from day one is usually source code control. This works in the beginning of the project, when single person handles all the tasks. Unfortunately it fails miserably when project gains popularity or grows bigger and requires more team members, who's work must be coordinated.

Maintaining project written by team of developers without any specs, design, common goal, and automatic delivery is a horrible idea, and should not happen at all, ever! It can be easily avoided, just by following already tested solutions, which can give you some decent control over the project. If you run company and try to sell product It is a MUST, and allows to promise and provide software, that will satisfy your customer.

In corporate projects one of the most important part of the project is : DOCUMENTATION. From the very beginning i.e software specification, to the final version of user's manual. Documentation must be maintained and updated. Period. Because it is time-consuming, dull and requires collaboration between many team members, writing documentation/comments is usually assigned to the new team members as a part of _getting familiar with the project_. It is a mistake in my humble opinion Due to this reasons documentation is generally incomplete
or out-of-date at any given time. There is one solution - writing documentation must be automatic process, triggered by code staging or release. Therefore one should try to write self-documenting code and keep specific branch in your delivery pipeline devoted to proper documentation production, which will guarantee that your documentation reflects at least comments in your code. We will deal with this problem in Part 2. In this article we will prepare __Software Design Document__ for our project I called biostudio.

<!-- 

, speci And it is fine, since there is only one person developing and maintaining it.   Once project grows, gains popularity and becomes developed by a griop some documentation generators are also in use. Book stories usually deal with two kinds of stories:

    1. Perfect projects delivered on time, with beautiful dashboards and velocity graphs etc...
    2. Perfect projects with some fake perturbations with perfect solutions showing crisis management.

This tutorial is nothing like that. We will utilize some good ideas related to good project management, with 
    in software-engineering books are full of fake projects and fake management issues related t laHowever some ideas were tested in practice and there is no use to develop wheel again. The best approach is to use someone else's experience, to improve our own process of efficient delivery of high quality software to the client.
 -->


In this tutorial I will adopt elements of agile software development techniques with some necessary adjustments, which in fact resembles extreme programing paradigm. Obviously I will have to play roles of all partners involved in agile process. The client communicating requirements and making changes to the project, developers team responsible for preparing documentation and proper implementation, as well as project manager contacting assigning/managing tasks, software evolution and releases. There will be no budget constrains and budget planning. No effort or time estimation. No stand-up meetings etc...

I will do my best to follow good practices and guidelines in order to prepare best quality code, tests and documentation. I will put extra effort in preparing modern development environment automating several activities like testing, documentation generation and finally - deployment. Knowledge of this techniques will help you increase efficiency and stability of your own development process, reduce development time and make easier to include new team members in the project.

Employed technologies will also help to automate some management tasks like overall progress tracking, single tasks progress tracking, code metrics and end users feedback/bugs tracking.

Since it is agile methodology, each iteration will result in deploying new version of functional software, which should meet client criteria.

 To choose a technology platform and testing tools.
• To set up a simple, automated build.
• To work out stories that follow the INVEST principles [ddVMFH] (they
should be Independent, Negotiable, Valuable, Estimable, Small, and
Testable), with acceptance criteria.
You can then implement a strict process:
• Customers, analysts, and testers define acceptance criteria.
• Testers work with developers to automate acceptance tests based on the
acceptance criteria.
• Developers code behavior to fulfill the acceptance criteria.
• If any automated tests fail (whether unit, component, or acceptance tests),
developers make it a priority to fix them


## Initial requirements

The purpose of this project is to build a GUI desktop app responsible for reading, viewing and changing Protein Data Bank fies, holding information about proteins 3D structure. Application should work on Windows, Linux and/or MacOS operating system. Actually in the first sentence we have envisioned at least six requirements, which describe general features our app should have:


 1. GUI interface
 2. read ```pdb``` files
 3. display file's content
 4. edit/change
 5. we anticipate necessity to save changes
 6. platform agnostic 

t the project by doing some initial modeling where we envision the initial requirements for KSMS, in the form of user stories, as well as the initial architecture. A user story is a reminder to have a conversation with a project stakeholder, hence there are not a lot of details provided in the table. When we start working on a user story we work closely with the user, ideally getting them involved with the modeling effort via Agile Modeling's Active Stakeholder Participation practice. As we explore the requirement we capture UI-related ideas, business rules, and structural information (e.g. business entities, the relationships between them). We also implement the requirement, hopefully taking a TDD-based approach which enables us to do less detailed design modeling because the tests capture this critical information, in both our objects and the database. The system will be built using object technology (e.g. J2EE or C#) on the front end and relational technology (e.g. MySql, Oracle) on the back end - See more at: http://www.agiledata.org/essays/agileDataModeling.html#Iteration6
Scope of the project is o, from users perspective - what our software is supposed to do?



## Initial domain model



## High Level Design

High-level design (HLD) explains the architecture that would be used for developing a software product. The architecture diagram provides an overview of an entire system, identifying the main components that would be developed for the product and their interfaces. The HLD uses possibly nontechnical to mildly technical terms that should be understandable to the administrators of the system. In contrast, low-level design further exposes the logical detailed design of each of these elements for programmers.

A high-level design document or HLDD adds the necessary details to the current project description to represent a suitable model for coding. This document includes a high-level architecture diagram depicting the structure of the system, such as the database architecture, application architecture (layers), application flow (navigation), security architecture and technology architecture. 

A high-level design provides an overview of a solution, platform, system, product, service or process.
Such an overview is important in a multiproject development to make sure that each supporting component design will be compatible with its neighbouring designs and with the big picture.
The highest-level solution design should briefly describe all platforms, systems, products, services and processes that it depends on and include any important changes that need to be made to them.
In addition, there should be brief consideration of all significant commercial, legal, environmental, security, safety and technical risks, issues and assumptions.
The idea is to mention every work area briefly, clearly delegating the ownership of more detailed design activity whilst also encouraging effective collaboration between the various project teams.
Today, most high-level designs require contributions from a number of experts, representing many distinct professional disciplines.
Finally, every type of end-user should be identified in the high-level design and each contributing design should give due consideration to customer experience.


## Low Level Design

Low-level design (LLD) is a component-level design process that follows a step-by-step refinement process. This process can be used for designing data structures, required software architecture, source code and ultimately, performance algorithms. Overall, the data organization may be defined during requirement analysis and then refined during data design work. Post-build, each component is specified in detail.[1]
The LLD phase is the stage where the actual software components are designed.
During the detailed phase the logical and functional design is done and the design of application structure is developed during the high-level design phase.

A design is the order of a system that connects individual components. Often, it can interact with other systems. Design is important to achieve high reliability, low cost, and good maintain-ability.[2] We can distinguish two types of program design phases:
Architectural or high-level design
Detailed or low-level design
Structured flow charts and HIPO diagrams typify the class of software design tools and these provide a high-level overview of a program. The advantages of such a design tool is that it yields a design specification that is understandable to nonprogrammers and it provides a good pictorial display of the module dependencies.
A disadvantage is that it may be difficult for software developers to go from graphic-oriented representation of software design to implementation. Therefore, it is necessary to provide little insight into the algorithmic structure describing procedural steps to facilitate the early stages of software development (generally using PDLs).[3]


The goal of LLD or a low-level design document (LLDD) is to give the internal logical design of the actual program code. High-level design is created based on the low-level design. LLD describes the class diagrams with the methods and relations between classes and program specs. It describes the modules so that the programmer can directly code the program from the document.
A good low-level design document makes the program easy to develop when proper analysis is utilized to create a low-level design document. The code can then be developed directly from the low-level design document with minimal debugging and testing. Other advantages include lower cost and easier maintenance.

## From requirements to low-level-design

System 
language
technologies


To get UML graphs we wll use www.draw.io service.


The SDD usually contains the following information:
The data design describes structures that reside within the software. Attributes and relationships between data objects dictate the choice of data structures.
The architecture design uses information flowing characteristics, and maps them into the program structure. The transformation mapping method is applied to exhibit distinct boundaries between incoming and outgoing data. The data flow diagrams allocate control input, processing and output along three separate modules.
The interface design describes internal and external program interfaces, as well as the design of human interface. Internal and external interface designs are based on the information obtained from the analysis model.
The procedural design describes structured programming concepts using graphical, tabular and textual notations. These design mediums enable the designer to represent procedural detail, that facilitates translation to code. This blueprint for implementation forms the basis for all subsequent software engineering work.



####
## SDD elements pushed to project documentation


### Requierements
### Structurl design (component, class diagram,  are born 

Assumptions and Dependencies

Describe any assumptions or dependencies regarding the software and its use. These may concern such issues as:

Related software or hardware
Operating systems
End-user characteristics
Possible and/or probable changes in functionality
General Constraints

Describe any global limitations or constraints that have a significant impact on the design of the system's software (and describe the associated impact). Such constraints may be imposed by any of the following (the list is not exhaustive):

Hardware or software environment
End-user environment
Availability or volatility of resources
Standards compliance
Interoperability requirements
Interface/protocol requirements
Data repository and distribution requirements
Security requirements (or other such regulations)
Memory and other capacity limitations
Performance requirements
Network communications
Verification and validation requirements (testing)
Other means of addressing quality goals
Other requirements described in the requirements specification
Goals and Guidelines

Describe any goals, guidelines, principles, or priorities which dominate or embody the design of the system's software. Such goals might be:


Emphasis on speed versus memory use
working, looking, or "feeling" like an existing product


#### Good practices

The KISS principle ("Keep it simple stupid!")
THE DRY
YAGNI


#### 1) Do not systematically include the blog name in the title tag

source : [5 Common SEO Mistakes with Web Page Titles](http://sixrevisions.com/content-strategy/5-common-seo-mistakes-with-web-page-titles/)

The clean blog template include the blog name in every post title, which is bad :

{% highlight html %}
{% raw %}
<title>{% if page.title %}{{ page.title }} - {{ site.title }}{% else %}{{ site.title }}{% endif %}</title>
{% endraw %}
{% endhighlight %}

To continue check:

[Part 2: Setting up work environment]({{ site.url }}/2017/04/13/part2-biostudio-setting-up-environment/) 



__If you have any comments, or ideas how to improve this tutorial, please let me know by leaving a post below, or contacting me via email.__
