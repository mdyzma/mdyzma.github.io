---
layout:     post
author:     Michal Dyzma
title:      SVM classifier for Iris Data Set
date:       2017-06-14 01:00:12 +0200
comments:   true
mathjakx:   false
categories: python SVM machine-learning
keywords:   python, SVM, machine-learning
---

<!-- ![banner][banner] -->
<br>
Beginning of my Machine Learning practical adventure. I intend to learn through practice. Language I chose is Python. My learning sessions will comprise of view repeatable exercises building classical data science pipeline. For this session I chose famous [__Iris Data Set__](https://archive.ics.uci.edu/ml/datasets/iris) to predict the flower class based on given attributes. Algorithm will be __SVM classifier__. When launched, command line interface will accept four numbers as an input (Petal Length, Petal Width, Sepal Length, Sepal width). Based on given numbers it will use trained model to classify unknown Iris to one of the species: _Iris setosa_,  _Iris virginica_ or _Iris versicolor_.

<br>
{% include note.html content="Source code from the article can be downloaded from this [GitHub repository](https://github.com/mdyzma/irispy)" %}

This is first of many sessions, which goal is to get familiar with machine learning methods and train how to produce additional value from raw data. Each learning session will comprise of four basic exercises:

1. Find data set
2. Clean the data
3. Choose and tune algorithm/algorithms
4. Visualize data

Sometimes I will use previously learned algorithm to do some benchmarks and compare their performance on different data sets.

## Support Vector Machine

“Support Vector Machine” (SVM) is a supervised machine learning algorithm which can be used for both classification or regression challenges. However, it is mostly used in classification problems. In this algorithm, we plot each data item as a point in n-dimensional space (where n is number of features you have) with the value of each feature being the value of a particular coordinate. Then, we perform classification by finding the hyper-plane that differentiate the two classes very well (look at the below snapshot).

## Project structure

Basic project structure is:

{% highlight bash %}
.
├── .gitignore
├── features
│   ├── environment.py
│   ├── iris.feature
│   └── steps
│       └── iris_steps.py
├── irisvmpy
│   ├── __init__.py
│   ├── iris.py
│   └── test_iris.py
├── LICENSE
└──  setup.py
{% endhighlight %}

## Setting pipeline







## Unit an acceptance tests

{% highlight bash %}
.
├── features
│   ├── environment.py
│   ├── iris.feature
│   └── steps
│       └── iris_steps.py
├── irisvmpy
│   ├── __init__.py
│   ├── iris.py
│   └── test_iris.py
...
{% endhighlight %}


## Command line interface



<br>
__irisvmp/iris.py__
{% highlight python %}
import click

@click.command()
@click.option('--petal-lenght', prompt='Petal Lenght',
              help='Unknown Iris Petal Lenght.', type=float)
@click.option('--petal-width', prompt='Petal Lenght',
              help='Unknown Iris Petal Width.', type=float)
@click.option('--sepal-lenght', prompt='Petal Lenght',
              help='Unknown Iris Sepal Lenght.', type=float)
@click.option('--sepal-width', prompt='Petal Lenght',
              help='Unknown Iris Sepal Width.', type=float)
def cli(petal_lenght, petal_width, sepal_lenght, sepal_width):
	click.echo("Iris Flower classifier\n")
	click.echo("\nCalculating result...")
	time.sleep(1)
	click.echo()
	click.echo("Your Petal Lenght is: {}".format(petal_lenght))
	click.echo("Your Petal Width  is: {}".format(petal_width))
	click.echo("Your Sepal Lenght is: {}".format(sepal_lenght))
	click.echo("Your Sepal Width  is: {}".format(sepal_width))
	click.echo()
	click.echo("Your flower seems to be fine representant of:")
	click.secho("{}".format(species), fg='green', bold=True)
# (Petal Length , Petal Width , Sepal Length , Sepal width

if __name__ == "__main__":
	cli()
{% endhighlight %}



##  Packaging


__setu.py__
{% highlight python %}
import codecs
try:
    codecs.lookup('mbcs')
except LookupError:
    ascii = codecs.lookup('ascii')
    func = lambda name, enc=ascii: {True: enc}.get(name=='mbcs')
    codecs.register(func)

from setuptools import setup, find_packages


requirements = [
	'scipy', 'numpy', 'scikit-learn', 'Click'
]

test_requirements=[
	'behave'
]

setup(
	name='irisvmpy',
	version='0.0.1',
	description='SVM classifier for iris data-set',
	author='Michal Dyzma',
	author_email='mdyzma@gmail.com',
	license='MIT',
	packages=find_packages(),
	install_requires=requirements,
	entry_points={
    	'console_scripts': [
        		'irisvmpy = irisvmpy.iris:cli',
        	],
        },
	classifiers=[
        'Development Status :: 1 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.6',
      ],
	zip_safe=False
)
{% endhighlight %}


<br>
{% include note.html content="Source code from the article can be downloaded from this [GitHub repository](https://github.com/mdyzma/irispy)" %}


<!-- Images -->

[banner]:   /assets/2017-05-12/banner.jpg
<!-- [iris_cli]: /assets/2017-05-12/iris_cli.png -->
