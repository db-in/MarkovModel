/*
 *	Matrix.swift
 *	MarkovModel
 *
 *	Created by Diney Bomfim on 6/27/18.
 *	Copyright 2018 db-in. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

public typealias Vector<T : Hashable> = [T : Int]
public typealias Matrix<T : Hashable> = [T : Vector<T>]

// MARK: - Extension - Array

public extension Array where Element == IntegerLiteralType {
	
	/// Given an vector of weighted probabilities, this property return a random index
	/// considering the given probabilities.
	/// The vector doesn't need to be normalized, every value will be taken into account.
	///
	///		let probabilities = [0.2, 0.3, 0.1, 0.4]
	///		(0...1000).forEach {
	///			print(probabilities.weightedRandomIndex)
	///		}
	///		// This is most likely to print: 20% = 0, 30% 1, 10% = 2, 40% = 3
	///
	///		Non-normalized vectors can also be used.
	public var weightedRandomIndex: Index {
		
		let sum = reduce(0, +)
		let max = UInt32.max
		let random = Element(Float(sum) * Float(arc4random_uniform(max)) / Float(max))
		var accumulated = Element(0.0)
		let first = enumerated().first {
			accumulated += $1
			return random < accumulated
		}
		
		return first?.offset ?? count - 1
	}
}

// MARK: - Definitions -

extension Array where Element : Hashable {
	
	/// Returns a random element in the given array.
	var randomElement: Element? {
		
		if isEmpty { return nil }
		
		let index = Int(arc4random_uniform(UInt32(count)))
		
		return self[index]
	}
	
	/// Builds up a states transition matrix based on an array of state transitions.
	/// The data structure is represented in a bi-dimensional dictionary where keys represent
	/// the `from` and `to` states.
	///
	/// - Parameters:
	///   - states: An ordered collection of states. They represent both coulmns and rows.
	///
	/// - Complexity: O(n), where **n** is the total length of all transitions.
	func makeTransitionsMatrix() -> Matrix<Element> {
		
		var changesMatrix = Matrix<Element>()

		guard var old = first else {
			return changesMatrix
		}

		suffix(from: 1).forEach { nextValue in
			var chain = changesMatrix[old] ?? Vector<Element>()
			chain[nextValue] = 1 + (chain[nextValue] ?? 0)
			changesMatrix[old] = chain
			old = nextValue
		}
		
		return changesMatrix
	}
}
