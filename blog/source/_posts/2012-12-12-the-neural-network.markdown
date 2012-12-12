---
layout: post
title: "The neural network"
date: 2012-12-12 20:24
comments: true
author: Antoine Pietri
categories: 
---

The main part of this project was to create a neural network which had to be
able to recognize the characters of a piece of text.

An artificial neural network, often just called a neural network, is a
mathematical model inspired by biological neural networks. A neural network
consists of an interconnected group of artificial neurons, and it processes
information using a connectionist approach to computation. In most cases a
neural network is an adaptive system that changes its structure during a
learning phase. Neural networks are used to model complex relationships between
inputs and outputs or to find patterns in data.

The word network in the term 'artificial neural network' refers to the
inter–connections between the neurons in the different layers of each system.
An example system has three layers. The first layer has input neurons, which
send data via synapses to the second layer of neurons, and then via more
synapses to the third layer of output neurons. More complex systems will have
more layers of neurons with some having increased layers of input neurons and
output neurons. The synapses store parameters called "weights" that manipulate
the data in the calculations.

## Learning : backpropagation

Backpropagation is a common method of training artificial neural networks so as
to minimize the objective function.
It requires a dataset of the desired output for many inputs, making up the
training set. It is most useful for feed-forward networks (networks that have
no feedback, or simply, that have no connections that loop).

For better understanding, the backpropagation learning algorithm can be divided
into two phases: propagation and weight update.

### Phase 1: Propagation

Each propagation involves the following steps:

* Forward propagation of a training pattern's input through the neural network
in order to generate the propagation's output activations.
* Backward propagation of the propagation's output activations through the
neural network using the training pattern's target in order to generate the
deltas of all output and hidden neurons.

### Phase 2: Weight update

For each weight-synapse follow the following steps:

* Multiply its output delta and input activation to get the gradient of the
weight.
* Bring the weight in the opposite direction of the gradient by subtracting a
ratio of it from the weight.

This ratio influences the speed and quality of learning; it is called the
learning rate. The sign of the gradient of a weight indicates where the error
is increasing, this is why the weight must be updated in the opposite
direction.

We then repeat the function until the result is satisfying.
