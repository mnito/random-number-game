//Adds repeatStr function to String type
public extension String {
	public func repeatStr(times : Int) -> String {
		var str = ""
		//Use _ if you incrementor value not needed
		for _ in 1...times {
			str += self
		}
		return str
	}
}
