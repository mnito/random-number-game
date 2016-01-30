/**
* Random Number Game class implemented in Swift
* @author Michael P. Nitowski <mpnitowski@gmail.com>
*/

//Functions used for random number generation required OS support
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
	import Darwin
#else
	import Glibc
#endif

//: Game marks conformance with Game protocol
public class RandomNumberGame: Game {
	public enum Condition {
		case Win
		case Higher
		case Lower
		case Loss
		case Unknown
	}

	public var min = 0
	public var max = 100
	public var maxTries = 10

	private var number = 0
	public var tries = 0

	//private(set) so these variables cannot be modified outside this file
	private(set) var losses = 0
	private(set) var wins = 0

	//Computed property
	public var games: Int {
		return wins + losses
	}

	public var triesLeft: Int {
		return maxTries - tries
	}

	public var title: String {
		return "Random Number Game"
	}

	public var rules: String {
		let d = "Guess a random number between \(self.min) and \(self.max)!\n"
					+ "You have \(self.maxTries) tries. Good luck!"
		return d
	}

	init(min: Int, max: Int, maxTries: Int) {
		//Self keyword required to avoid conflict with method parameters
		self.min = min
		self.max = max
		self.maxTries = maxTries
		//Seed random number generator
		srandom(UInt32(time(nil)))
		newGame()
	}

	private func generateRandomNumber() {
		//explicit self keyword not required - no conflicting variables in scope
		number = min + (random() % (max - min + 1))
	}

	//Contains game logic
	//Do not want this to be overridden so it is declared as final
	final public func guess(number: Int) -> Condition {
		self.tries += 1
		if(number != self.number && tries >= maxTries) {
			losses += 1
			newGame()
			return Condition.Loss
		}
		if(number < self.number) {
			return Condition.Higher
		} else if(number > self.number) {
			return Condition.Lower
		}
		if(number == self.number) {
			self.wins += 1
			self.newGame()
			return Condition.Win
		}
		return Condition.Unknown
	}

	//guess with exception handling
	//Use throws keyword to declare that an Error can be thrown
	public func guess(number: Int, validateRange: Bool) throws -> Condition {
		/* guard statement does not allow code execution to continue in current
			scope if condition is not met */
		guard number >= self.min else {
			throw RandomNumberGameError.OutOfRange.TooLow
		}

		guard number <= self.max else {
			throw RandomNumberGameError.OutOfRange.TooHigh
		}

		return guess(number)
	}

	public func newGame() {
		tries = 0
		generateRandomNumber()
	}

	public func reset() {
		losses = 0
		wins = 0
		newGame()
	}
}
