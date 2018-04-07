---
layout:     post
author:     Michal Dyzma
title:      Machine Learning Basics: Support Vector Machine classifier
date:       2017-06-14 01:00:12 +0200
comments:   true
mathjax:    true
categories: python SVM machine-learning
keywords:   python, SVM, machine-learning
---

<!-- ![banner][banner] -->
<br>
Beginning of my Machine Learning practical adventure. I intend to learn through practice. Language I chose is Python. My learning sessions will comprise of view repeatable exercises building classical data science pipeline. For this session I chose famous [__Iris Data Set__](https://archive.ics.uci.edu/ml/datasets/iris) to predict the flower class based on given attributes. Algorithm will be __SVM classifier__. When launched, command line interface will accept four numbers as an input (Petal Length, Petal Width, Sepal Length, Sepal width). Based on given numbers it will use trained model to classify unknown Iris to one of the species: _Iris setosa_,  _Iris virginica_ or _Iris versicolor_.

<!-- <br>
{% include note.html content="Source code from the article can be downloaded from this [**GitHub repository**](https://github.com/mdyzma/irispy)" %}
 -->
This is first of many sessions, which goal is to get familiar with machine learning methods and train how to produce additional value from raw data. Each learning session will comprise of four basic exercises:

1. Find data set
2. Clean the data
3. Choose and tune algorithm/algorithms
4. Visualize data

Sometimes I will use previously learned algorithm to do some benchmarks and compare their performance on different data sets.

## Support Vector Machine

“Support Vector Machine” (SVM) is a supervised machine learning algorithm which can be used for both classification or regression challenges. However, it is mostly used in classification problems. To be more exact it is usually used to address multi-class classification problems. 

What is multi-class classification? 

Lets imagine an animal with several features like:

* body temperature (cold/warm - blooded)
* size 
* number of legs

Now based on this few features we can predict what class (we have 3 classes: reptile, mammal, arthropod) of animal we are dealing with. For example:


temperature  | size  | legs | animal
-----------  | ----  | ---- | ------
cold-blooded | big   | 4    | reptile
warm-blooded | big   | 4    | mammal
cold-blooded | small | 8    | arthropod
cold-blooded | small | 6    | arthropod

Several features were evaluated and as a result test cases were assigned to specific category called class.


How SVM classifier Works?

SVM works on a dataset consisting of features and labels. It is used to build a model to predict classes for new examples. It assigns new example/data points to one of the available classes.

There are 2 kinds of SVM classifiers:

1. Linear SVM Classifier
2. Non-Linear SVM Classifier


In the linear classifier model, training data, plotted in space, are expected to be separated by an apparent gap. Algorithm predicts a straight hyperplane dividing 2 classes. The primary focus while drawing the hyperplane is on maximizing the distance from hyperplane to the nearest data point of either class. The drawn hyperplane is called a maximum-margin hyperplane.

Unfortunately, in real world situation, datasets are usually more complicated. Single data points are more dispersed and tend to penetrate borders between classes. In such situations separation of data into different classes with a straight linear hyperplane is impossible. To solve it, Non-Linear Classifiers were invented. In Non-Linear SVM Classification, data points are plotted in a higher dimensional space, which allows to separate data with high precision.



<!-- In mathematical therms we can say that given a data set \\(D = \{xi, yi\}^m_1\\), where \\(x_i \in R\\).

\\(n, y_i \in \{1, 2, ..., k\}\\), the task of
multiclass classification is to learn a model that outputs a single class label y
given an example \\(x\\). -->



This is based on several In short it is problem which based on multiple features evaluated together is able to to assign described (categorized) subject to one category.categorize like  In this algorithm, we plot each data item as a point in n-dimensional space (where n is number of features you have) with the value of each feature being the value of a particular coordinate. Then, we perform classification by finding the hyper-plane that differentiate the two classes very well (look at the below snapshot).




## Program structure






<br>
{% include note.html content="Source code from the article can be downloaded from this [**GitHub repository**](https://github.com/mdyzma/irispy)" %}


<!-- Images -->

[banner]:   /assets/2017-05-12/banner.jpg
<!-- [iris_cli]: /assets/2017-05-12/iris_cli.png -->
