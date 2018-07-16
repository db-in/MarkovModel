/*
 *	MatrixSpec.swift
 *	RoShamBoCore
 *
 *	Created by Diney Bomfim on 6/27/18.
 *	Copyright 2018 db-in. All rights reserved.
 */

import Quick
import Nimble
@testable import MarkovModel

// MARK: - Definitions -

extension Int {
	
	func percent(of value: Int) -> Int {
		return Int(Double(self) * Double(value) / 100.0)
	}
}

// MARK: - Type -

class MatrixSpec : QuickSpec {

// MARK: - Properties

// MARK: - Protected Methods

// MARK: - Exposed Methods

// MARK: - Overridden Methods

	override func spec() {
		
		describe("Testing random vector") {
			
			context("With filled array") {
				
				it("Should return 1, 2 or 3") {
					expect([1,2,3].randomElement).toNot(equal(0))
				}
			}
			
			context("With empty array") {
				
				it("Should return nil") {
					expect([Int]().randomElement).to(beNil())
				}
			}
		}
		
		describe("Testing Weighted Random Index vector") {
			
			context("With a weigthed random index for normalized vector [1, 2, 4, 3]") {
				
				it("Should present most likely 10% = 0, 20% = 1, 40% = 2, 30% = 3") {
					let totalRuns = 10000
					let vector = [1, 2, 4, 3]
					let results = (0...totalRuns).map() { _ in vector.weightedRandomIndex }
					let counts = NSCountedSet(array: results)
					
					// Give them 5% error margin
					expect(counts.count(for: 0)).to(beLessThan(15.percent(of: totalRuns)))
					expect(counts.count(for: 1)).to(beLessThan(25.percent(of: totalRuns)))
					expect(counts.count(for: 2)).to(beLessThan(45.percent(of: totalRuns)))
					expect(counts.count(for: 3)).to(beLessThan(35.percent(of: totalRuns)))
				}
			}
			
			context("With a weigthed random index for non-normalized vector [20, 5, 10, 8]") {
				
				it("Should present most likely 46% = 0, 11% = 1, 23% = 2, 18% = 3") {
					let totalRuns = 10000
					let vector = [20, 5, 10, 8]
					let results = (0...totalRuns).map() { _ in vector.weightedRandomIndex }
					let counts = NSCountedSet(array: results)
					
					// Give them 5% error margin
					expect(counts.count(for: 0)).to(beLessThan(51.percent(of: totalRuns)))
					expect(counts.count(for: 1)).to(beLessThan(16.percent(of: totalRuns)))
					expect(counts.count(for: 2)).to(beLessThan(28.percent(of: totalRuns)))
					expect(counts.count(for: 3)).to(beLessThan(23.percent(of: totalRuns)))
				}
			}
			
			context("With empty array") {
				
				it("Should return nil") {
					expect([Int]().weightedRandomIndex).to(equal(-1))
				}
			}
		}
		
		describe("Testing description on matrix") {
			
			context("With the vector [1, 2, 1, 2]") {
				
				it("Should present the description correctly") {
					let matrix = [1, 2, 1, 2].makeTransitionsMatrix()
					let string = "   2     1    \n\n| 0.00  1.00 |  2   \n|            |\n| 1.00  0.00 |  1   "
					expect(matrix.description).to(equal(string))
				}
			}
		}
		
		describe("Testing states of a matrix") {
			
			context("With the vector [1, 2, 1, 2]") {
				
				it("Should output [1, 2]") {
					let array = [1, 2, 1, 2]
					let matrix = array.makeTransitionsMatrix()
					expect(matrix.uniqueStates).to(equal(Array(Set(array))))
				}
			}
		}
	}
}
