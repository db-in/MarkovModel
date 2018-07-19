/*
 *	MarkovModel.swift
 *	MarkovModel
 *
 *	Created by Diney Bomfim on 6/26/18.
 *	Copyright 2018 db-in. All rights reserved.
 */

import Foundation

// MARK: - Definitions -

/// Indicates the decision process for a given Markov Chain.
///
/// - predict: Exact prediction based on the most likely next state.
///		If there are two or more equal probabilities, the latest one will be taken.
/// - random: Fully random process, considering only the valid options.
/// - weightedRandom: Random process, considering the valid options and the probabilities.
public enum DecisionProcess {
	case predict
	case random
	case weightedRandom
}

// MARK: - Type -

/// This entity applies MarkovModel for fully observable models, using Markov Chain and Markov
/// decision process. [More about Markov Models.](https://en.wikipedia.org/wiki/Markov_model)
///
/// Given N possibles states, this entity calculates predictions of the next states given a
/// current state. It relies on calculations and operations between vector and matrix.
public struct MarkovModel<T : Hashable> {

// MARK: - Properties
	
	/// The Markov Chain is a matrix which is the essense of Markov Model.
	/// It represents the from-to states.
	///
	///		   From
	///		| 1 0 0 |
	///		| 0 1 0 | To
	///		| 0 0 1 |
	///
	/// The data is represented by a bi-dimensional dictionary of integer numbers in order
	/// to optimize memory and performance.
	public private(set) var chain: Matrix<T>
	
// MARK: - Constructors
	
	/// Initialize a Markov Chain with an array of transitions, indicating the history of
	/// state transitions that the chain will be built upon.
	///
	/// - Parameter transitions: An array describing the sequence of consecutive transitions.
	///
	/// - Complexity: O(n), where *n* is the length of the **transitions**.
	public init(transitions: [T]) {
		chain = transitions.makeTransitionsMatrix()
	}
	
	/// This method is dedicated for large transition data processing.
	///
	/// - Parameters:
	///   - transitions: An array describing the sequence of consecutive transitions.
	///   - completion: The closure in wich the matrix can be freely manipulated.
	///
	/// - Complexity: O(n), where *n* is the length of the **transitions**.
	public static func process(transitions: [T], completion: (Matrix<T>) -> Void) {
		completion(transitions.makeTransitionsMatrix())
	}
}

public extension Matrix where Value == Vector<Key> {

	/// All the unique states present in the current matrix.
	/// Even though it's a **from** or **to** state only, it will be counted as a unique state.
	///
	/// - Complexity: O(n log n),  where *n* is the matrix's size
	public var uniqueStates: [Key] {
		var result = Set<Key>(keys)
		forEach { result.formUnion(Array($0.value.keys)) }
		return Array(result)
	}
	
	/// Given a current state, this method returns the probabilities of the next state.
	///
	/// - Parameter given: The current state.
	/// - Returns: A dictionary of the probabilities, where the states are the keys and the values
	///		are the probability from the current state.
	///
	/// - Complexity: O(1), regardless the matrix's size.
	public func probabilities(given: Key) -> Vector<Key> {
		return self[given] ?? [:]
	}
	
	/// Given a current state, this method returns the next state, based on an input criteria.
	///
	/// - Parameters:
	///   - given: The current state
	///   - process: The decision process to calculate the next state.
	/// - Returns: The calculated next state.
	///
	/// - Complexity: O(n), where *n* is the length of the possible transitions
	///		for the given **states**.
	public func next(given: Key, process: DecisionProcess = .predict) -> Key? {
		guard let values = self[given] else {
			return nil
		}
		
		let column = Array(values)
		
		switch process {
		case .predict:
			return values.max(by: { $0.value < $1.value })?.key
		case .random:
			return column.map({ $0.key }).randomElement
		case .weightedRandom:
			let probabilities = column.map { $0.value }
			return column[probabilities.weightedRandomIndex].key
		}
	}
	
	/// A pretty printed representation of the matrix
	///
	///		        From
	///		| 1.00  0.00  0.00 |
	///		|                  |
	///		| 0.00  1.00  0.00 | To
	///		|                  |
	///		| 0.00  0.00  1.00 |
	public var description: String {
		
		guard (1..<10000) ~= count else {
			return "Due to performance reasons, description works from 1 to 100 states"
		}
		
		let states = uniqueStates
		let order = states.count
		let spaces = [String](repeating: " ", count: order * 6).joined()
		let allStates = states.map { " \(String(describing: $0).padding(to: 4, with: " ")) " }
		var rows = [String](repeating: "|", count: order)
		
		states.forEach {
			let columnVector = self[$0] ?? [:]
			var sum = Float(columnVector.values.reduce(0, +))
			
			sum = sum < 1.0 ? 1.0 : sum
			
			(0..<order).forEach {
				let value = Float(columnVector[states[$0]] ?? 0)
				rows[$0] += " \(String(format: "%.2f", value / sum)) "
			}
		}
		
		rows = (0..<order).map { "\(rows[$0])|\(allStates[$0])" }
		
		return " \(allStates.joined()) \n\n\(rows.joined(separator: "\n|\(spaces)|\n"))"
	}
}

// MARK: - Extension

extension MarkovModel : CustomStringConvertible {
	
	/// A pretty printed representation of the Markov Chain (matrix)
	///
	///		        From
	///		| 1.00  0.00  0.00 |
	///		|                  |
	///		| 0.00  1.00  0.00 | To
	///		|                  |
	///		| 0.00  0.00  1.00 |
	public var description: String {
		return chain.description
	}
}

// MARK: - Extension

private extension String {

	func padding(to length: Int, with pad: String) -> String {
		guard count < length else {
			return "\(self.padding(toLength: length, withPad: pad, startingAt: 0))"
		}

		let half = Float(length - count) / 2
		let left = String(repeating: " ", count: Int(half.rounded(.down)))
		let right = String(repeating: " ", count: Int(half.rounded(.up)))

		return "\(left)\(self)\(right)"
	}
}
