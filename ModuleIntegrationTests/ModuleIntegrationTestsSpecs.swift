/*
 *  ModuleIntegrationTestsSpecs.swift
 *  MarkovModel
 *
 *  Created by DINEY B ALVES on 7/3/18.
 *  Copyright 2018 db-in. All rights reserved.
 */

import Quick
import Nimble
import MarkovModel

// MARK: - Definitions -

// MARK: - Type -

class ModuleIntegrationTestsSpecs : QuickSpec {

// MARK: - Properties

// MARK: - Protected Methods

// MARK: - Exposed Methods

// MARK: - Overridden Methods

	override func spec() {
		
		describe("MarkovModel as a Module") {
			
			context("With the public API for matrix") {
				
				it("Should return [0,1,1,0] given the transitions [A, B, A]") {
					let immutable = MarkovModel(transitions: ["A", "B", "A"])
					expect(immutable.matrix.next(given: "B")).to(equal("A"))
				}
			}
		}
	}
}
