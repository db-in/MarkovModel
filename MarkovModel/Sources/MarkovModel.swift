/*
 *	MarkovModel.swift
 *	RoShamBoCore
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
	
	/// The matrix is the essense of Markov Model. It represents the from-to states.
	///
	///		   From
	///		| 1 0 0 |
	///		| 0 1 0 | To
	///		| 0 0 1 |
	///
	/// The data is represented by a bi-dimensional dictionary of integer numbers in order
	/// to optimize memory and performance.
	public private(set) var matrix: Matrix<T>
	
// MARK: - Constructors
	
	/// Initialize a Markov Chain with an array of transitions, indicating the history of
	/// state transitions that the chain will be built upon.
	///
	/// - Parameter transitions: An array describing the sequence of consecutive transitions.
	///
	/// - Complexity: O(n), where *n* is the length of the **transitions**.
	public init(transitions: [T]) {
		matrix = transitions.makeTransitionsMatrix()
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

public extension Matrix {

	/// Given a current state, this method returns the probabilities of the next state.
	///
	/// - Parameter given: The current state.
	/// - Returns: A dictionary of the probabilities, where the states are the keys and the values
	///		are the probability from the current state.
	///
	/// - Complexity: O(1), regardless the matrix's size.
	public func probabilities(given: Key) -> Vector<Key> {
		return self[given] as? Vector<Key> ?? [:]
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
		guard let values = self[given] as? Vector<Key> else {
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
}
