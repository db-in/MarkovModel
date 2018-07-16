import Foundation
import MarkovModel

/*:
# Text Generator using Markov Model
This example shows how we can generate text by training a Markov Model with a given book.
As it's purely based on probabilities of a sequence, the sentences may not be very meaningful,
however, they preserve grammar and can be hilarious sometimes.
*/

/*:
> ## Step 1 - Training the model
Our goal is to give to Markov Model a sequence of words,
so we clean-up and separate the text per word.

The `process` is the largest step, it might take several seconds to run.
*/
func buildText(starting: String, length: Int, file: String) -> String {
	var text = starting
	let strings = loadTextFile(fileName: file)
		.replacingOccurrences(of: "\n", with: " ")
		.components(separatedBy: " ")
	
	MarkovModel.process(transitions: strings) { matrix in
		buildWords(with: &text, length: length, chain: matrix)
	}
	
	return text
}

/*:
> ## Step 2 - Predicting the next state
Once we have the Markov Chain matrix, it's time to start predicting the next word.
There are few options to predict what the next word will be.

- Experiment:
Try to switch the `process` between:
- predict
- random
- weightedRandom
*/
func buildWords(with text: inout String, length: Int, chain: Matrix<String>) {
	var word = text
	(0...length).forEach { _ in
		if let next = chain.next(given: word, process: .weightedRandom) {
			text.append(" \(next)")
			word = next
		}
	}
}

/*:
> ## Step 3 - Select the input
There are 3 different inputs that you can play with and change the results entirely.

- The starting word;
- The length of the text;
- The input file's path.

- Experiment:
Try to switch the `file` to:
- Men Without Women.txt
- Harry Potter and the Sorcerer's Stone.txt
- The Fellowship of the Ring.txt
- The Return Of The King.txt
- Or import a new book from https://archive.org/
*/
let randomText = buildText(starting: "A", length: 200, file: "Books/The Return Of The King.txt")
print(randomText)
