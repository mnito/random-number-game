/**
* Substring implementation for String type
* @author Michael P. Nitowski <mpnitowski@gmail.com>
*/

public extension String {
	public func substring(start: Int, length: Int) -> String {
		//Allows for negative starts and lengths
		let _startIndex =  start >= 0 ? start : self.characters.count + start
		let _endIndex = length >= 0 ? length + _startIndex : self.characters.count + length
		var i = 0
		var str = ""
		//Chose this way because you do not need to import anything
		/* Loops through entire string - could become inefficient for larger
			start indexes */
		for c in self.characters {
			if i < _startIndex {
				i += 1
				continue
			}
			if i == _endIndex {
				break
			}
			str += String(c)
			i += 1
		}
		return str
	}

	public func substring(start: Int) -> String {
		return substring(start, length: self.characters.count)
	}
}
