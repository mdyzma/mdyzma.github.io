---
layout:     post
author:     Michal Dyzma
title:      Calcium dynamics in the cell
date:       2017-06-10 09:47:13
comments:   true
mathjax:    true
categories: python systems-biology mathematical-modeling systems-biology
keywords:   python, systems biology, mathematical-modeling, systems-biology
---

Calcium not only builds our bones and teeth. It is also a very important signaling molecule, which is involved in nearly every aspect of the life. It coordinates spectrum of cellular responses, including very well known muscle contraction or blood clotting, to some mysterious but equally important, like nerve impulses facilitation, apoptosis or G-protein signal transduction. It acts on the most basic level of life, controlling proteins shape, enzyme activity and cellular organelles behavior in millisecond, second and minutes time frame. Its tracking in real time is very hard and sometimes impossible. Therefore scientists employed mathematical models, which try to describe reality in very simplistic way, to explain parts impossible to grasp with normal experimental techniques. In this article I will describe some calcium models, including very specific model, which was created during my PhD I did in 2009-2013 in Warsaw. Numerical analysis was done in Matlab. Unfortunately I do not have access to this package anymore, therefore I will implement and perform all numerical analysis in Python.

---
## Table of content

1. [Why is calcium so important?](#calcium_importance)
2. [What is MAM?](#mam)
    * [Mam ultrastructure](#mam_structure)
    * [Role of MAMs](#mam_apoptosis)
3. [Models of calcium dynamics](#models)
4. [Model of MAM](#model_mam)
    * [System of ODEs](#ode)
    * [Global Scaling factors](#scaling_factors)
    * [Reticular fluxes](#er)
    * [Mitochondrial fluxes](#mit)
5. [Python code to run ODEs](#python_ode)
6. [Results](#results)
7. [What does it mean?](#conclusions)

---


<a name="calcium_importance"></a>

## Why is calcium so important?

Eukaryotic cells maintain over 2000 fold difference of calcium ions concentration between cytosol and intracellular space. It means that for every atom of Ca<sup>2+</sup> in the cytosol (Cyt), there is 2000 calcium atoms outside of the cell. Also inside the cell calcium ions are stored in specific structures like endoplasmic reticulum (ER) or mitochondria (Mit). Nearly half of the energy produced by the cell is spend to maintain steep calcium gradient between inner and outer-cell environment.

![transdukcja][transdukcja]


<a name="mam"></a>

## What is MAM?



It is an acronym from Mitochondria-associated endoplasmic reticulum complexes or microdomains. Still it is hard to imagine. Calcium uptake and release from these organelles
determine the spatial and temporal parameters of Ca<sup>2+</sup> signaling events. In eukaryotic cells, membrane proteins that mediate signal transduction and protein secretion are often localized in
microdomains. For example according to Hajnoczky et.al.over 90% of calcium release channels are clustered within MAM structures. Recent experiments demonstrated that mitochondria and ER indeed form functional complexes with each other [25]. Proximity between them may lead to a spontaneous aggregation of specific chaperones and peptidic tethers which keep channel proteins and other transmembrane elements of ER and outer mitochondrial membrane (OMM) in close contact. These complexes are known as the mitochondria-associated ER membrane complexes - MAMs [24]. A scheme of
MAM is presented below:

<a name="mam_structure"></a>

### MAM ultrastructure

![mam][mam]

The distance between membranes in MAMs was estimated using electron tomography. It ranges from 10 nm for smooth ER to 25 nm for rough ER [27]. Appositions of ER and OMM are
stabilized by several proteins, including Ca<sup>2+</sup> channels VDAC-1 and IP3R type-3/RyR, sigma-1 receptor chaperone and autocrine motility factor receptor (AMF-R), forming ER-mitochondrion
interface. Molecular chaperones like glucose-regulated protein (grp75) link physically VDAC-1 and IP3R/RyR. There is also abundance of other proteins like: calreticulin (CRT), calnexin,
ERp44, ERp57, the cytosolic sorting protein (PACS-2) and other peptidic tethers that bind membranes together and stabilize the area of interaction either on ER and mitochondrion side.

Mitochondria posses very efficient machinery for Ca<sup>2+</sup> uptake and extrusion and are capable of accumulating large amounts of calcium ions. Furthermore, key dehydrolases of mitochondrial TCA cycle and some elements of ATP production are calcium regulated. Over last decade rapid interest arouse in the field of mitochondrial calcium dynamics. Experiments and mathematical models concerning calcium uptake, accumulation and release gave new answers to the fundamental questions about relevance of these organelles in the cell metabolism or in the control of cell death and aging. Development of new, organellestargeted calcium indicators and techniques for measuring Ca<sup>2+</sup> concentration, was a significant milestone in studying dynamic interplay between calcium storage organelles. The authors will present up to date information concerning the individual mechanisms of Ca<sup>2+</sup> transport in and out of mitochondria from a biological and mathematical point
of view, briefly reviewing the literature and discussing recently published experimental results and their implications.

<a name="mam_apoptosis"></a>

### Role of MAMs

First reports concerning the existence of physical interface between ER and mitochondria were announced 40 years ago by Dennis and Kennedy [29]. They called it “fraction x”. Fraction gave positive staining for enzymes characteristic for both organelles endoplasmic reticulum and mitochondria. Although molecular identification was not possible that days. 20 years later 
Rusinnol and colleges described “fraction x”, which mitochondria and endoplasmic reticulum complexes involved in lipids’ metabolism [?]. Term MAM (Mitochondria Associated Membrane Complex) was coined. Although it was known, that isolated mitochondria are able to take up vast amounts of calcium and three dehydrogenases of the TCA cycle are regulated by this ion[referencje], it was believed they do not play any significant role in calcium homeostasis. It was due to the fact, that mitochondrial uniporter half-activation constant is very high and exceeds cytosolic calcium concentration evoked by IP3-mediated Ca<sup>2+</sup> release 5-10 times (KD of 20–50 µM) [referencja, Shin2010] and a significant calcium uptake via uniporter was unlikely. Therefore its function was restricted to apoptotic conditions, when prolonged stimulation could lead to the large increase of cytosolic calcium concentration, mitochondria Ca<sup>2+</sup> uptake and PTP opening [Referencje]. To solve the puzzle, the existence of the specific microdomain between ER/mitochondria was postulated, in which Ca<sup>2+</sup> can rise to a sufficiently high level to activate mitochondrial uniporter [referencje]. Unfortunately such micro-domains were not demonstrated experimentally at that time. This changed with correlative studies by Giacomello et al. (2010) and Csordas et al. (2010). Authors targeted calcium sensitive probes to the outer mitochondrial membrane and successfully detected hot spots on 10% of the OMM surface.

They form sites of close contact also described as ’hot spots’, where signal transduction to the mitochondrium can be performed more efficiently. Using modified fluorescent probes targeted at these organelles surfaces, Csordas ( [26]) and Giacomello ( [28]) measured changes of calcium concentration upon IP3 activation in these specific structures. Their results indicate that during stimulation, calcium concentration in microdomains is 5 to 10-fold higher than in the bulk cytosol and may reach up to 10 µM. Small pockets containing high Ca<sup>2+</sup> concentration seem to be essential in activating mitochondrial uniporter, which has very high half saturation constant.


Apoptosis is a form of programmed cell death that eliminates damaged cells in a controlled manner in order to minimize disruption to neighboring cells. It is vital for embryonic development,
the immune system and tissue homeostasis. It is characterized by caspase (cysteine-dependent aspartate-specific protease) activation, chromatin condensation, nuclear fragmentation and formation of apoptotic bodies. Two main pathways of intracellular signaling lead to apoptosis: the extrinsic or death receptor pathway and the intrinsic or mitochondrial pathway. The two pathways differ in the initiator caspases that transmit the signal but later converge at the level of activation of executioner caspases (caspases-3, -6, and -7), which execute the cell death
process by cleaving a large number of cellular proteins to drive forward the biochemical events that culminate in cell death and dismantling of the cell. We will focus mainly on intrinsic
pathway, which involves mitochondria and complex interplay between ER and Mitochondria realized in microdomains, because it requires Ca<sup>2+</sup> accumulation leading to the PTP opening and cytochrome C release. Intrinsic apoptotic pathway Dependent on miochondria function and apoptosome activation by cytochrome C. Lysosomes are cellular compartments containing acid hydrolases and act as a degradative compartments. Lysosomal proteases are often associated with various cell death pathways. In order to induce apoptosis content of the lysosome must be released to the cytoplasm. Molecular mechanism of lysosomal membrane breakdown is poorly understood, but it seems that mitochondria play crucial role in cathepsin mediated apoptotic pathway After lysosomal membrane destabilization, proteolytic enzymes: cathepsins B,K,L and S are released to the cytosol and are able to influence apoptotic pathway upstream and downstream mitochondrial hub. Through the cleavage of p22 BID protein and degradation of BCL-2, BCL-XL and MCL1 cathepsins influence mitochondrial calcium homeosasis, leading to the mitohondrial membranes rupture and cytochrome c release. By degradating XIAP factor they facilitate activation of caspase 3 and 7 - so called executioner caspases hence influencing apoptosis downstream mitochondria.

<a name="models"></a>

## Models of calcium dynamics

First approaches relied on simple mechanistic models describing behavior of the calcium signaling toolkit. Simple equations to depict pumps, channels and transporters activity in the
cell compartments treated as well-mixed reactors. Activity may be depicted as simple linear function, although the non-linear kinetics of many transporters and channels is usually best
represented by Hill function or functions with Hill index between 1 and 2. And again there may be exceptions, when Hill index is much higher. 

These models successfully reproduced temporal dynamics, for IP3-induced Ca<sup>2+</sup> release (model of Meyer and Strayer [75], or Goldebeter [76]). However, with time rose the knowledge about variety of possible interactions calcium transducting machinery may be involved in. Therefore models evolved towards multi-site, multi-reaction sets of the rate equations able to determine amount of receptors in many different intermediate states [23,72]. One of the earliest of that was model presented by De Yong and Keizer [74]. More comprehensive reviews of most popular IP3R models are given by [73] and [72]. Such models were also created for mitochondrial calcium fluxes.


Creating a cellular model is particularly challenging task. It involves the use of computer simulations of the many subsystems such as cellular compartments, to track concentrations of signal transduction pathways, gene regulatory networks and sometimes metabolites and enzymes. Complex nature of to both analyze and visualize the complex connections of these cellular processes.developing efficient algorithms, data structures, visualization and communication tools to orchestrate the integration of large quantities of biological data with the goal of computer modeling. I would like to quote famous aphorism by statistician George Box:

> All models are wrong, but some of them are useful.



In very many cell types, the concentration of free intracellular calcium oscillates, with a period ranging from a few seconds to a few minutes. These calcium oscillations are thought to control a wide variety of cellular processes, and are often organised into intracellular and intercellular calcium waves (Tsien and Tsien, 1990; Berridge, 1990, 1997; Berridge et al., 2003; Clapham, 1995; Sneyd et al., 1995; Thomas et al., 1996; Falcke, 2004; Schuster et al., 2002).

When constructing mathematical models of calcium oscillations and waves it is crucial to keep two points firmly in mind:

Each cell type is different. The mechanisms that underlie calcium oscillations in one cell type might be, and usually are, quite different in detail from the mechanisms underlying oscillations in another cell type. Despite this, there is still a lot in common between cell types, and certain generalisations can be made. Carefully.
It is a relatively simple matter to write down a system of equations that exhibits oscillations. It is even relatively simple to fiddle the model until the oscillations look like the data. It is, however, much more difficult to use the model to say something interesting and new about the cellular physiology.



It is also directly associated with bioinformatics, computational biology and Artificial life.

It involves 

The complex network of biochemical reaction/transport processes and their spatial organization make the development of a predictive model of a living cell a grand challenge for the 21st century.

By means of a system of ordinary differential equations these models show the change in time (dynamical system) of the protein inside a single typical cell; this type of model is called a deterministic process (whereas a model describing a statistical distribution of protein concentrations in a population of cells is called a stochastic process).
To obtain these equations an iterative series of steps must be done: first the several models and observations are combined to form a consensus diagram and the appropriate kinetic laws are chosen to write the differential equations, such as rate kinetics for stoichiometric reactions, Michaelis-Menten kinetics for enzyme substrate reactions and Goldbeter–Koshland kinetics for ultrasensitive transcription factors, afterwards the parameters of the equations (rate constants, enzyme efficiency coefficients and Michaelis constants) must be fitted to match observations; when they cannot be fitted the kinetic equation is revised and when that is not possible the wiring diagram is modified. The parameters are fitted and validated using observations of both wild type and mutants, such as protein half-life and cell size.


In order to explain complexity of calcium dynamics in the cell, researchers began to apply a new approach – theoretical analysis based on mathematical models. It has become a very valuable
tool in exploiting already existing experimental results, as well as proposing new possibilities in mechanisms of calcium handling in the cells. Such analysis is useful especially in situations
where experiments reach boundaries of physical observation. In these cases only computational approach provides framework to study complete pathway of calcium signaling. One can study single stochastic events, like episodes of spontaneous channel activation (i.e blips and sparks), and extend analysis on the global phenomena where previously observed activity cumulates, resulting in calcium waves and fluctuations propagated through the cell .

<a name="model_mam"></a>

## Model of MAM

![scheme][scheme]


<a name="ode"></a>

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


<a name="scaling_factors"></a>

### Global Scaling factors

$$
\rho_i = \dfrac{V_{i}}{V_{Cyt}}
$$


$$
\beta_i = \dfrac{Ca_{i}}{Ca_i + Ca_iPr}
$$

<a name="er"></a>

### Reticular fluxes


<a name="mit"></a>

### Mitochondrial fluxes

Generally only two fluxes draw attention of the researchers from the mathematical point of view. Influx to the mitochondrium is realized by mitochondrial uniporter (MCU), while calcium exclusion by mitochondrial antiporter (NCX). Modeling the uniporter and mitochondria antiporter is based on the equations applied to enzymatic reactions. Uniporter is usually modeled by Hill function with coefficient equal 2 [77], while antiporter is reflected with composition of two hill functions, see equations. Where, Vuni=Vex are the maximal velocity of the uniporter, antiporter respectivelly. Ca<sub>Cyt</sub> is the cytosolic free calcium concentration, Ca<sub>Mit</sub> and, K<sub>Ca</sub>=K<sub>Ca</sub> denotes the dissociation constant of calcium of corresponding proteins and KNa for sodium ions of NCX, n is a Hill coefficient:

$$
J_{ex} = V_{ex} \frac{Ca_{cyt}^{n}}{K_{Ca} + Ca_{cyt}^{n}}\;\;\frac{Na_{cyt}}{K_{Na} + Na_{cyt}}
$$

$$
J_{uni} = V_{uni} \frac{Ca_{cyt}^n}{K_{Ca}^n + Ca_{cyt}^n}
$$


Indices in the first equation reflect stoichiometry of the anti-porter exchange, which is electrically neutral (one Ca<sup>2+</sup> ion for two Na+ ions). As mentioned above, Hill coefficient in the function describing MCU is usually equal n = 2, however some authors (see [21]) input very high Hill  indices in order to simulate step like kinetics and very high activation threshold for calcium of the uniporter. Both equations put together will give the net calcium flux ODE: 

$$
\frac{dCa_{mit}}{dt} = \frac{\beta}{\rho}\;\left(J_{uni} - J_{ex}\right)
$$


where beta is the ratio of free and total calcium concentrations in mitochondria, while rho denotes the volume ratio between the mitochondria and the cytosol. Although this general approach is
very efficient and allows to add to the model basic mitochondrial calcium dynamics, it neglects very important factor - a mitochondrial membrane potential delta phi m. Despite this liability such reproduce the major features of RaM presented inthe experimental literature. They simulated the Ca<sup>2+</sup> uptake profiles for a sustained Ca<sup>2+</sup> pulse and the increases in Ca<sup>2+</sup> uptake efficiency
for multiple pulses versus a single, sustained pulse.

Mitochondria have become large toggle switch in cellular faith determination. Several signalling pathways output is determined by mitochondria state. One of the key players in these
multipathway interplay is mitochondrial calcium dynamics. Last years focused on membrane structures (MAM’s), responsible for fine interactions of mitochondria, endoplasmic reticulum
and possibly other organelles. It appears that sites of close contact are involved in lipids metabolism, cellular energetic control and apoptotic signal processing. Mitochondrial calcium
dynamics drew large interest of researchers from many disciplines, i.e. mathematicians. First models of calcium dynamics in the cell were created in early 90’s. Dupont, Goldbeter, Atri, de
Young, Keizer, Falcke, Sneyd constructed models describing calcium flow between cytoplasm and endoplasmic reticulum in relation to the states of IP3R receptor or concentration of IP3.
In these early models mitochondria played role of simple buffers for free calcium ions. Later models, inherited modular structure and allowed to describe calcium dynamics in the cell and
in extracellular space, simply by combination of several modules, bound together in order to create specific configuration, appropriate for experimental data. Depending on how many
compartments were taken into account one could obtain single pool models - describe changes in the cytosol realized by two basic fluxes in- and out- of the cell plus fast buffering of free
calcium in the cytosol, two pool models - take into account one of the most important calcium store in the cell - endoplasmic reticulum or three pool model is the version describing complex
exchange of calcium ions between cytosol, ER and mitochondria. More compartments can be added if necessary. Ordinary differential equations. In early 2000 Marhl proposed three pool model, where calcium ions were dynamically exchanged between cytosol and mitochondria [21]. The progress made by other researchers constructing models of mitochondrial ion balance could be incorporated to the general overview of calcium evolution in the cell, making them useful to track cellular faith dependent on mitochondria condition and functioning.

<a name="python_ode"></a>

## Python code to run ODEs


<a name="results"></a>

## Results




<a name="conclusions"></a>

## What does it mean?


<!-- Images -->

[camca]: /assets/10-06-2017-camca.png
[ef-hand-ca]: /assets/10-06-2017-EF-hand-Ca.png
[mam]: /assets/10-06-2017-MAM.png
[mam-electro-1]: /assets/10-06-2017-MAM_electro_1.jpg
[mam-electro-1]: /assets/10-06-2017-MAM_picture1.png
[scheme]: /assets/10-06-2017-scheme.png
[transdukcja]: /assets/10-06-2017-transdukcja.png
[models-wiki]: http://www.scholarpedia.org/article/Models_of_calcium_dynamics
