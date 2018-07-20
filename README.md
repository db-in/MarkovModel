# MarkovModel

[![Build Status](https://travis-ci.org/dineybomfim/MarkovModel.svg?branch=master)](https://travis-ci.org/dineybomfim/MarkovModel)
[![codecov](https://codecov.io/gh/dineybomfim/MarkovModel/branch/master/graph/badge.svg)](https://codecov.io/gh/dineybomfim/MarkovModel)
[![codebeat badge](https://codebeat.co/badges/366a5994-abec-4c41-8e64-6f71ff9eab33)](https://codebeat.co/projects/github-com-dineybomfim-markovmodel-master)
![Version](https://img.shields.io/badge/swift-4.1-red.svg)
[![Platform](https://img.shields.io/cocoapods/p/MarkovModel.svg?style=flat)](https://markovmodel.github.io/MarkovModel)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MarkovModel.svg)](https://img.shields.io/cocoapods/v/MarkovModel.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Description
**MarkovModel** is a Swift framework that uses the power of Markov Model to process and calculate states in a known system. It can be used to achieve several goals in Machine Learning, games and others.
To know more about Markov Model, visit [https://wikipedia.org/wiki/Markov_model](https://wikipedia.org/wiki/Markov_model)

**Features**

- [x] Automatically creates Markov Chain based on a given sequence of transactions;
- [x] Allows manual matrix manipulation for mutating members;
- [x] Pretty printed matrix for debugging;
- [x] Markov decision process, including weighted random process;
- [x] Next state prediction;
- [x] [Full API documentation](https://db-in.github.io/MarkovModel/).

# Installation

### Using [CocoaPods](https://cocoapods.org)

Add to your **Podfile** file

```
pod 'MarkovModel'
```

### Using [Carthage](https://github.com/Carthage/Carthage)

Add to your **Cartfile** or **Cartfile.private** file

```
github "db-in/MarkovModel"
```

### Using [Swift Package Manager](https://swift.org/package-manager)

Add to your **Package.swift** file

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/db-in/MarkovModel.git"),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["MarkovModel"]),
    ]
)
```

# Requirements
Version | Language | Xcode | iOS
------- | -------- | ----- | ---
 1.0.0  | Swift 4.1  |  9.0  | 10.0

# Programming Guide
The Markov Model can be used to achieve many goals. This section will explain the usage while providing some possible scenarios.

* Traning the Model
* Decision Process
* Debugging

#### Training the Model
Start by importing the package in the file you want to use it. There are two options of working with the model. By instantiating or by traning it statically.

```
import MarkovModel
...
let markovModel = MarkovModel(transitions: ["A", "B", "C", "A", "C"])
```

For very large amount of data (transitions), you may rather take the static approach, once it can train the model and work on it all at once in a closure.

```
import MarkovModel
...
MarkovModel.process(transitions: ["A", "B", "C", "A", "C"]) { model in
	// perform the operations on model
}
```

#### Decision Process
For performance and better API design, all the Markov Decision Process algorithms are done in the matrix itself.
You can calculate any future state by calling `next`. There are 3 possible decision process options: `predict`, `random` and `weightedRandom`.

```
markovModel.chain.next(given: "B", process: .random)
```

You can ommit the process parameter and the default option will be `predict`.


```
markovModel.chain.next(given: "B")
```

Sometimes you may want to some column of the matrix itself. The method `probabilities` can be used to retrieve all the possible transitions from a given state.

```
markovModel.chain.probabilities(given: "B")
```
#### Decision Process
For performance and better API design, all the Markov Decision Process algorithms are done in the matrix itself.
You can calculate any future state by calling `next`. There are 3 possible decision process options: `predict`, `random` and `weightedRandom`.

```
let markovModel = MarkovModel(transitions: ["A", "A", "B"])
print(markovModel)
// or
print(markovModel.chain)

// It will print
   B     A    

| 0.00  0.50 |  B   
|            |
| 0.00  0.50 |  A   
```


# FAQ
> What about the states with zero transitions?

- For memmory safe and performance, they are not even considered by the `MarkovModel`, once they have no effect over the Decision Process.
