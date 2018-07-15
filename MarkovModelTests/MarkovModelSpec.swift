/*
 *	MarkovModelSpec.swift
 *	RoShamBoCore
 *
 *	Created by Diney Bomfim on 7/1/18.
 *	Copyright 2018 db-in. All rights reserved.
 */

import Quick
import Nimble
@testable import MarkovModel

// MARK: - Definitions -

enum WeatherMock {
	case sunny
	case rainy
	case snowy
	case windy
	case cloudy
}

extension WeatherMock {
	static var missingCases: [WeatherMock] = []
	static var twoSequences: [WeatherMock] = [.sunny, .rainy, .sunny,
											  .rainy, .sunny, .rainy]
	static var allSequences: [WeatherMock] = [.sunny, .rainy, .snowy, .windy, .cloudy,
											  .rainy, .rainy, .windy, .cloudy, .sunny,
											  .sunny, .sunny, .sunny, .cloudy, .sunny,
											  .windy, .rainy, .rainy, .snowy, .sunny,
											  .cloudy, .sunny, .rainy, .windy, .cloudy]
}

// MARK: - Type -

class MarkovModelSpec : QuickSpec {

// MARK: - Properties

// MARK: - Protected Methods

// MARK: - Exposed Methods

// MARK: - Overridden Methods

	override func spec() {
		
		let model = MarkovModel(transitions: WeatherMock.allSequences)
		let emptyModel = MarkovModel(transitions: WeatherMock.missingCases)
		var vector: Vector<WeatherMock>!
		var mutableModel: MarkovModel<WeatherMock>!
		
		describe("Testing MarkovModel Construction") {
			
			context("With valid transitions") {
				
				it("Should have the constructed matrix [.sunny: [.rainy: 3], .rainy: [.sunny: 2]]") {
					let matrix: Matrix<WeatherMock> = [.sunny: [.rainy: 3], .rainy: [.sunny: 2]]
					mutableModel = MarkovModel(transitions: WeatherMock.twoSequences)
					expect(mutableModel.matrix).to(equal(matrix))
				}
			}
			
			context("With invalid transitions") {
				
				it("Should have empty matrix") {
					mutableModel = MarkovModel(transitions: [])
					expect(mutableModel.matrix).to(equal([:]))
				}
			}
			
			context("With process Matrix") {
				
				it("Should construct the matrix in closure [.sunny: [.rainy: 3], .rainy: [.sunny: 2]]") {
					MarkovModel.process(transitions: WeatherMock.twoSequences) { matrix in
						expect(matrix).to(equal([.sunny: [.rainy: 3], .rainy: [.sunny: 2]]))
					}
				}
			}
		}
		
		describe("Testing MarkovChain decision process") {
			
			context("With probabilities") {
				
				it("Given sunny should be [.windy: 1, .sunny: 3, .rainy: 2, .cloudy: 2]") {
					vector = [.windy: 1, .sunny: 3, .rainy: 2, .cloudy: 2]
					expect(model.matrix.probabilities(given: .sunny)).to(equal(vector))
				}
				
				it("Given rainy should [.snowy: 2, .windy: 2, .rainy: 2]") {
					vector = [.snowy: 2, .windy: 2, .rainy: 2]
					expect(model.matrix.probabilities(given: .rainy)).to(equal(vector))
				}
				
				it("Given snowy should [.windy: 1, .sunny: 1]") {
					vector = [.windy: 1, .sunny: 1]
					expect(model.matrix.probabilities(given: .snowy)).to(equal(vector))
				}
				
				it("Given windy should [.cloudy: 3, .rainy: 1]") {
					vector = [.cloudy: 3, .rainy: 1]
					expect(model.matrix.probabilities(given: .windy)).to(equal(vector))
				}
				
				it("Given cloudy should [.sunny: 3, .rainy: 1]") {
					vector = [.sunny: 3, .rainy: 1]
					expect(model.matrix.probabilities(given: .cloudy)).to(equal(vector))
				}
			}
			
			context("With exact prediction for decision process") {
				
				it("Given sunny should next be sunny") {
					expect(model.matrix.next(given: .sunny)).to(equal(.sunny))
				}
				
				it("Given rainy should next be snowy") {
					expect(model.matrix.next(given: .rainy)).to(equal(.snowy))
				}
				
				it("Given snowy should next be windy") {
					expect(model.matrix.next(given: .snowy)).to(equal(.windy))
				}
				
				it("Given windy should next be cloudy") {
					expect(model.matrix.next(given: .windy)).to(equal(.cloudy))
				}
				
				it("Given cloudy should next be sunny") {
					expect(model.matrix.next(given: .cloudy)).to(equal(.sunny))
				}
			}
			
			context("With weighted random for decision process") {
				
				it("Given sunny, next should never be snowy") {
					expect(model.matrix.next(given: .sunny, process: .weightedRandom)).toNot(equal(.snowy))
				}
				
				it("Given snowy, next should never be rainy, cloudy or snowy") {
					expect(model.matrix.next(given: .snowy, process: .weightedRandom)).toNot(equal(.rainy))
					expect(model.matrix.next(given: .snowy, process: .weightedRandom)).toNot(equal(.cloudy))
					expect(model.matrix.next(given: .snowy, process: .weightedRandom)).toNot(equal(.snowy))
				}
				
				it("Given windy, next should never be sunny, snowy or windy") {
					expect(model.matrix.next(given: .windy, process: .weightedRandom)).toNot(equal(.sunny))
					expect(model.matrix.next(given: .windy, process: .weightedRandom)).toNot(equal(.snowy))
					expect(model.matrix.next(given: .windy, process: .weightedRandom)).toNot(equal(.windy))
				}
				
				it("Given cloudy, next should never be windy, snowy or cloudy") {
					expect(model.matrix.next(given: .cloudy, process: .weightedRandom)).toNot(equal(.windy))
					expect(model.matrix.next(given: .cloudy, process: .weightedRandom)).toNot(equal(.snowy))
					expect(model.matrix.next(given: .cloudy, process: .weightedRandom)).toNot(equal(.cloudy))
				}
			}
			
			context("With random for decision process") {
				
				it("Given sunny, next should never be snowy") {
					expect(model.matrix.next(given: .sunny, process: .random)).toNot(equal(.snowy))
				}
				
				it("Given snowy, next should never be rainy, cloudy or snowy") {
					expect(model.matrix.next(given: .snowy, process: .random)).toNot(equal(.rainy))
					expect(model.matrix.next(given: .snowy, process: .random)).toNot(equal(.cloudy))
					expect(model.matrix.next(given: .snowy, process: .random)).toNot(equal(.snowy))
				}
				
				it("Given windy, next should never be sunny, snowy or windy") {
					expect(model.matrix.next(given: .windy, process: .random)).toNot(equal(.sunny))
					expect(model.matrix.next(given: .windy, process: .random)).toNot(equal(.snowy))
					expect(model.matrix.next(given: .windy, process: .random)).toNot(equal(.windy))
				}
				
				it("Given cloudy, next should never be windy, snowy or cloudy") {
					expect(model.matrix.next(given: .cloudy, process: .random)).toNot(equal(.windy))
					expect(model.matrix.next(given: .cloudy, process: .random)).toNot(equal(.snowy))
					expect(model.matrix.next(given: .cloudy, process: .random)).toNot(equal(.cloudy))
				}
			}
		}
		
		describe("Testing an Empty MarkovChain") {
			
			context("With probabilities API") {
				
				it("Given non-existing state, should return itself") {
					expect(emptyModel.matrix.probabilities(given: .sunny)).to(equal([:]))
					expect(emptyModel.matrix.probabilities(given: .rainy)).to(equal([:]))
					expect(emptyModel.matrix.probabilities(given: .snowy)).to(equal([:]))
					expect(emptyModel.matrix.probabilities(given: .windy)).to(equal([:]))
					expect(emptyModel.matrix.probabilities(given: .cloudy)).to(equal([:]))
				}
			}
			
			context("With predict next API") {
				
				it("Given non-existing state, should return itself") {
					expect(emptyModel.matrix.next(given: .sunny)).to(beNil())
					expect(emptyModel.matrix.next(given: .rainy)).to(beNil())
					expect(emptyModel.matrix.next(given: .snowy)).to(beNil())
					expect(emptyModel.matrix.next(given: .windy)).to(beNil())
					expect(emptyModel.matrix.next(given: .cloudy)).to(beNil())
				}
			}
			
			context("With predict weighted random next API") {
				
				it("Given non-existing state, should return itself") {
					expect(emptyModel.matrix.next(given: .sunny, process: .weightedRandom)).to(beNil())
					expect(emptyModel.matrix.next(given: .rainy, process: .weightedRandom)).to(beNil())
					expect(emptyModel.matrix.next(given: .snowy, process: .weightedRandom)).to(beNil())
					expect(emptyModel.matrix.next(given: .windy, process: .weightedRandom)).to(beNil())
					expect(emptyModel.matrix.next(given: .cloudy, process: .weightedRandom)).to(beNil())
				}
			}
			
			context("With predict random next API") {
				
				it("Given non-existing state, should return itself") {
					expect(emptyModel.matrix.next(given: .sunny, process: .random)).to(beNil())
					expect(emptyModel.matrix.next(given: .rainy, process: .random)).to(beNil())
					expect(emptyModel.matrix.next(given: .snowy, process: .random)).to(beNil())
					expect(emptyModel.matrix.next(given: .windy, process: .random)).to(beNil())
					expect(emptyModel.matrix.next(given: .cloudy, process: .random)).to(beNil())
				}
			}
		}
	}
}
