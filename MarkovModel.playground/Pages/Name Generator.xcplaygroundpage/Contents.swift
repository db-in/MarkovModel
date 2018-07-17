import Foundation
import MarkovModel
import UIKit

/*:
# Name Generator using Markov Model
This example shows how we can generate names by training a Markov Model with a given language.
Languages have a very idiosyncratic way to compose names, not just because of different alphabets
but also culture, meaning, etc.

Our goal with this experiment is to not generate known names, but instead create completely
new names based on the characteristics of the given language.

For example:
- Serbian first names may tend to start with vogels and end the last name with `ić`;
- Chinese names may tend to use a larger spectrum of letters on the first name;
- German names, in general, may use more consonants than other languages.

So in order to respect those characteristics, our goal is to decompose the names by
forename/surname and based on the transition between letters we'll train the Markov Model
to generate new names.
*/

/*:
Defining typealias to our name tuples
*/
typealias NamesModel = (given: MarkovModel<Character>, family: MarkovModel<Character>)
typealias NameResult = (name: String, lastLetter: Character)

/*:
> ## Step 1 - Understanding the source files
Our goal is to give to Markov Model a sequence of letters (Character),
so we start by assuming each line of the source file is a new name.
*/
func buildNames(count: Int, file: String) -> String {
	
	let names = loadTextFile(fileName: file).components(separatedBy: "\n")
	let models = buildModels(with: names)
	var generatedNames = [String]()
	
	guard var letter = names.first?.first else {
		fatalError("There is no content in file \(file)")
	}
	
	(0...count).forEach { _ in
		let given = buildName(first: letter, matrix: models.given.chain)
		let family = buildName(first: given.lastLetter, matrix: models.family.chain)
		
		letter = given.lastLetter
		generatedNames.append("\(given.name) \(family.name)")
	}
	
	return generatedNames.joined(separator: "\n")
}

/*:
> ## Step 2 - Training the models
We'll create two models, one for the given names and one for the family names.
As we have one full name per line, we have to separate them now and create the models
based on the sequence of letters.

We reserve the capitular information (lower or upper case), it's important for the next step.
The `process` is the largest step, it might take several seconds to run.
*/
func buildModels(with names: [String]) -> NamesModel {
	var forenames = ""
	var surnames = ""
	
	names.forEach {
		let components = $0.components(separatedBy: .whitespaces)
		forenames += components.prefix(1)
		surnames += components.suffix(from: 1).joined()
	}
	
	return (MarkovModel(transitions: Array(forenames)),
			MarkovModel(transitions: Array(surnames)))
}

/*:
> ## Step 3 - Predicting the next letter
It's time to use all the information contained inside each name.

By using the lower case letter information, we can understand the structure of the names,
which letters they begin with, which letters they end with, how long they are, etc...
So that's how we cut off a name. As a fallback, we'll never allow a name longer than 15 letters.

- Experiment:
Try to switch the `process` between:
- predict (in this example, exact prediction does not fit our goal)
- random
- weightedRandom
*/
func buildName(first: Character, matrix: Matrix<Character>) -> NameResult {
	
	var letter = first
	var name = [letter]
	
	for _ in (0..<15) {
		letter = matrix.next(given: letter, process: .weightedRandom) ?? first
		
		guard letter.isLowerCase else {
			break
		}
		
		name.append(letter)
	}
	
	return (String(name), letter.upperCased)
}

/*:
> ## Step 4 - Select the input
There are 2 different inputs that you can play with and change the results entirely.

- The count of how many names will be generated;
- The input file's path.

- Experiment:
Try to switch the `file` to:
- Brazilian.txt
- Chinese.txt
- English.txt
- French.txt
- German.txt
- Serbian.txt
- Or import a new names from https://www.worldnamegenerator.com/

(you may have to clear them with Find & Replace regex: `\(.*?\)`)
*/
let randomNames = buildNames(count: 20, file: "Names/Serbian.txt")
print(randomNames)
