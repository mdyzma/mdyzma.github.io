---
layout:     post
author:     Michal Dyzma
title:      Calcium dynamics in the cell
date:       2017-06-10 09:47:13
comments:   true
mathjax:    true
categories: python systems-biology mathematical-modeling
keywords:   python, systems biology, mathematical-modeling
---

Calcium not only builds our bones and teeth. It is also a very important signaling molecule, which is involved in nearly every aspect of the life. It coordinates spectrum of cellular responses, including very well known muscle contraction,  to some mysterious, but equally important like blood clotting, the transmission of nerve impulses, apoptosis or G-potein signal transduction. It acts on the most basic level of life, controlling proteins shape, enzyme activity and cellular organelles behavior. Its tracking in real time is very hard and sometimes impossible. Hence mathematical models, which try to explain parts impossible to explain with "normal experiment". I will explain specific model of calcium dynamics in cells with nucleus (eukaryotic), which I created during my PhD. Numerical analysis was done in Matlab. Unfortunately I do not have access to this package anymore, therefore I will implement and perform all numerical analysis in Python.

## Why is calcium so important?

Eukaryotic cells maintain over 2000 fold difference of calcium ions concentration between cytosol and intracellular space. It means that for every atom of Ca<sup>2+</sup> in the cytosol (Cyt), there is 2000 calcium atoms outside of the cell. Also inside the cell calcium ions are stored in specific structures like endoplasmic reticulum (ER) or mitochondria (Mit). Nearly half of the energy produced by the cell is spend to maintain steep calcium gradient between inner and outer-cell environment.



## How to study it?



### Microscopic observation



### Whole cell models

Creating a cellular model is particularly challenging task. It involves the use of computer simulations of the many subsystems such as cellular compartments, to track concentrations of signal transduction pathways, gene regulatory networks and sometimes metabolites and enzymes. Complex nature of to both analyze and visualize the complex connections of these cellular processes.developing efficient algorithms, data structures, visualization and communication tools to orchestrate the integration of large quantities of biological data with the goal of computer modeling. I would like to quote famous aphorism by statistician George Box:

> All models are wrong, but some of them are useful.

It is also directly associated with bioinformatics, computational biology and Artificial life.

It involves 

The complex network of biochemical reaction/transport processes and their spatial organization make the development of a predictive model of a living cell a grand challenge for the 21st century.

By means of a system of ordinary differential equations these models show the change in time (dynamical system) of the protein inside a single typical cell; this type of model is called a deterministic process (whereas a model describing a statistical distribution of protein concentrations in a population of cells is called a stochastic process).
To obtain these equations an iterative series of steps must be done: first the several models and observations are combined to form a consensus diagram and the appropriate kinetic laws are chosen to write the differential equations, such as rate kinetics for stoichiometric reactions, Michaelis-Menten kinetics for enzyme substrate reactions and Goldbeter–Koshland kinetics for ultrasensitive transcription factors, afterwards the parameters of the equations (rate constants, enzyme efficiency coefficients and Michaelis constants) must be fitted to match observations; when they cannot be fitted the kinetic equation is revised and when that is not possible the wiring diagram is modified. The parameters are fitted and validated using observations of both wild type and mutants, such as protein half-life and cell size.

## What is MAM?

It is an acronym from Mitochondria-associated endoplasmic reticulum
complexes or microdomains. Still it is hard to imagine. 

![mam][mam]

## MAM Model

### Heuristic model


![scheme][scheme]


### System of ODEs

$$
\frac{dCa_{Cyt}}{dt} = J_{ch}+J_{leak}-J_{pump}+J_{out}-J_{in} + k_-CaPr-k_+Ca_{Cyt}Pr\\
\frac{dCa_{ER}}{dt} = \frac{\beta_{ER}}{\rho_{ER}}\left(J_{pump}-J_{ch}
            -J_{leak} -J_{MAM}\right), \label{eq:2}\\
\frac{dCa_{Mit}}{dt} = \frac{\beta_{Mit}}{\rho_{Mit}}\left(J_{in}+J_{MAM}
            -J_{out}\right)\\
\frac{dCaPr}{dt} = k_+ Ca_{Cyt}Pr - k_-CaPr\\
\frac{dPr}{dt} = -k_+ Ca_{Cyt}Pr + k_-CaPr
$$

### Scaling factors

$$
\rho_i = \dfrac{V_{i}}{V_{Cyt}}
$$


$$
\beta_i = \dfrac{Ca_{i}}{Ca_i + Ca_iPr}
$$


### Fluxes definition



## What does it mean?


<!-- Images -->

[camca]: /assets/10-06-2017-camca.png
[ef-hand-ca]: /assets/10-06-2017-EF-hand-Ca.png
[mam]: /assets/10-06-2017-MAM.png
[mam-electro-1]: /assets/10-06-2017-MAM_electro_1.jpg
[mam-electro-1]: /assets/10-06-2017-MAM_picture1.png
[scheme]: /assets/10-06-2017-scheme.png
[transdukcja]: /assets/10-06-2017-transdukcja.png
