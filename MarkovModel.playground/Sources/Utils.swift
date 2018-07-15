import Foundation

public func loadTextFile(fileName: String) -> String {
	let file = fileName.components(separatedBy: ".")
	guard let filePath = Bundle.main.path(forResource: file.first, ofType: file.last),
		let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
			fatalError("The file \(fileName) was not found")
	}
	
	return content
}

public extension Character {
	public var isLowerCase: Bool {
		let string = String(self)
		return string.lowercased() == string
	}
	
	public var upperCased: Character {
		return Character(String(self).uppercased())
	}
}
