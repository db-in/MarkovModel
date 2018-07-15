# MarkovModel

[![Build Status](https://travis-ci.org/dineybomfim/MarkovModel.svg?branch=master)](https://travis-ci.org/Alamofire/Alamofire)
[![codecov](https://codecov.io/gh/dineybomfim/MarkovModel/branch/master/graph/badge.svg)](https://codecov.io/gh/dineybomfim/MarkovModel)
![POD](https://img.shields.io/badge/swift-4.1-red.svg)
<!--
[![CocoaPods](https://img.shields.io/cocoapods/at/MarkovModel.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/dt/MarkovModel.svg?label=pod-downloads)]()
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MarkovModel.svg)](https://img.shields.io/cocoapods/v/MarkovModel.svg)
[![Platform](https://img.shields.io/cocoapods/p/MarkovModel.svg?style=flat)](https://markovmodel.github.io/MarkovModel)-->
[![codebeat badge](https://codebeat.co/badges/366a5994-abec-4c41-8e64-6f71ff9eab33)](https://codebeat.co/projects/github-com-dineybomfim-markovmodel-master)

# Description
**MarkovModel** is a framework for ... `make an introduction for this component. Explaining the major business goals.`
https://en.wikipedia.org/wiki/Markov_model
Markov models
System state is fully observable

**Features**

- [x] Automatically creates Markov Chain based on a given sequence of transactions;
- [x] Allows manual matrix manipulation for mutating members;
- [x] Markov decision process with weighted random selection;
- [x] Next state prediction.

# Installation

#### CocoaPods:
[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Once you ready with CocoaPods, use this code in your `Podfile`:

```
pod 'MarkovModel'
```

# Requirements
Version | Language | Xcode | iOS
------- | -------- | ----- | ---
 1.0.0  | Swift 4.1  |  9.0  | 10.0

# Programming Guide
The Markov Model can be used to achieve many goals. This section will explain the usage while providing some possible scenarios.

* Traning the Model
* Feature-1
* Feature-2
* Feature-3

#### Training the Model
Start by importing the package in the file you want to use it. There are two options of working with the model. By instantiating or by traning it statically.

```
import MarkovModel
...
let model = MarkovModel(transitions: ["A", "B", "C", "A", "C"])
```

For very large amount of data (transitions), you may rather take the static approach, once it can train the model and work on it all at once in a closure.

```
import MarkovModel
...
MarkovModel.process(transitions: ["A", "B", "C", "A", "C"]) { model in
	// perform the operations on model
}
```

#### Calculating future states
Describe usage of Feature-1

```
// Some code for Feature-1
```

# FAQ
> Possible Question-1?

- Answer for Question-1
