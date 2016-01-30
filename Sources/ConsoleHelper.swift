/**
* ConsoleHelper class
* @author Michael P. Nitowski <mpnitowski@gmail.com>
*
* Performs some basic display functions and contains useful tools
* for parsing command line arguments
*/

public class ConsoleHelper {
	public static var headerLength = 50

	public static func getHorizontalRule() -> String {
		let s = "-"
		return s.repeatStr(headerLength);
	}

	public static func getHorizontalRule(s: String) -> String {
		let factor = Int(headerLength / s.characters.count)
		return s.repeatStr(factor)
	}

	public static func associateFlags(arguments: [String]) -> [String: String] {
		var flagDict = [String: String]()
		var current = ""
		for argument in arguments {
			if(argument.substring(0, length: 1) == "-") {
				current = argument.substring(1)
				if(current.characters.count > 1) {
					for c in current.characters {
						current = String(c)
						flagDict[current] = current
					}
					continue
				}
				flagDict[current] = current
				continue
			}
			if(current != "") {
				flagDict[current] = argument
			}
		}
		return flagDict
	}

	//Set<String> to explictly define a set, not a dictionary or array
	public static func associateFlags(arguments: [String], wordFlags: Set<String>) -> [String: String] {
		var flagDict = [String: String]()
		var current = ""
		for argument in arguments {
			if argument.substring(0, length: 1) == "-" {
				current = argument.substring(1)
				//Contains is a set function
				if current.characters.count > 1 && !wordFlags.contains(current) {
					for c in current.characters {
						current = String(c)
						flagDict[current] = current
					}
					continue
				}
				flagDict[current] = current
				continue
			}
			if(current != "") {
				flagDict[current] = argument
			}
		}
		return flagDict
	}
}
