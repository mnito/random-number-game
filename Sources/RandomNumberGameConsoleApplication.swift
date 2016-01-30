/**
* Random Number Game console view implemented in Swift
* @author Michael P. Nitowski <mpnitowski@gmail.com>
*/

public class RandomNumberGameConsoleApplication {
	//Defines class constants
	public struct Constants {
		static let defaultMin = 1
		static let defaultMax = 100
		static let defaultTries =	10
	}

	public struct Rules {
		var min: Int = Constants.defaultMin
		var max: Int = Constants.defaultMax
		var tries: Int = Constants.defaultTries
	}

	//Array of user commands for use in program
	private let baseCommands = ["exit", "reset", "help", "rules", "record", "game"]

	public var commands: String {
		var commands = "Commands:\n"
		for command in baseCommands {
			//\() for string interpolation
			commands += " \(command)\n"
		}
		return commands + "(+ aliases)\n"
	}

	private let game: RandomNumberGame
	private let showHelp: Bool

	//Help information before entry into main program
	public var help: String {
		return
			"Usage: RandomNumberGame [options...]\nOptions:"
				+ " -min MIN Minimum Random Number\n"
				+ " -max MAX Maximum Random Number\n"
				+ " -tries TRIES Amount of tries to guess\n"
	}

	public var header:String {
		return
			"\n" + ConsoleHelper.getHorizontalRule("=") + "\n"
				+ game.title + "\n"
				+ ConsoleHelper.getHorizontalRule("=") + "\n"
				+ game.rules + "\n"
				+ ConsoleHelper.getHorizontalRule() + "\n\n\n"
	}

	public var record: String {
		return
			ConsoleHelper.getHorizontalRule()
				+ "\nWins: \(self.game.wins)\nLosses: \(self.game.losses)"
				+ "\nGames: \(self.game.games)\n"
				+ ConsoleHelper.getHorizontalRule()
	}

	init(arguments: [String]) {
		ConsoleHelper.headerLength = 50
		let flags = ConsoleHelper.associateFlags(arguments,
			wordFlags:["min", "max", "tries", "help", "-help"])
		showHelp = flags["help"] != nil || flags["-help"] != nil
		//self.dynamicType gets current class name
		let rules = self.dynamicType.parseRules(flags)
		self.game = RandomNumberGame(min: rules.min, max: rules.max, maxTries: rules.tries)
	}

	//Sets rules from flags
	private class func parseRules(flags: [String: String]) -> Rules {
			var rules = Rules()
			if let minStr = flags["min"] {
				if let min = (Int(minStr)) {
					rules.min = min
				}
			}
			if let maxStr = flags["max"] {
				if let max = (Int(maxStr)) {
					rules.max = max
				}
			}
			if let triesStr = flags["tries"] {
				if let tries = (Int(triesStr)) {
					rules.tries = tries
				}
			}
			return rules
	}

	//Play again sequence after win or loss
	private func promptToPlayAgain() {
		print("[Play Again?] [Y/N] ", terminator: "")
		if let input = readLine() {
			if isRestart(input) {
				return restart()
			}
			if input == "N" || input == "n" || isExit(input) {
				return
			}
			if input == "Y" || input == "y" {
				return askForGuess()
			}
			displayCommandOutput(input)
			return promptToPlayAgain()
		}
	}

	//Displays information based on condition
	private func displayResult(result: RandomNumberGame.Condition) {
		switch(result) {
			case RandomNumberGame.Condition.Higher:
				print(" [Higher] [Tries Left: \(self.game.triesLeft)]")
			case RandomNumberGame.Condition.Lower:
				print(" [Lower] [Tries Left: \(self.game.triesLeft)]")
			case RandomNumberGame.Condition.Win:
				print("\nYou won!")
				print(record)
			case RandomNumberGame.Condition.Loss:
				print("\nYou lost!")
				print(record)
			default: true
		}
	}

	//Returns command output for valid command or returns nil for nothing
	//String? optional syntax
	public func getCommandOutput(command: String) -> String?
	{
		if (command == "help" || command == "commands") {
			return commands
		}
		if (command == "rules"	|| command == "directions"
				|| command == "how to play" || command == "instructions") {
			let hRule = ConsoleHelper.getHorizontalRule()
			return "\(hRule)\n\(game.rules)\n\(hRule)\n"
		}
		if (command == "record" || command == "games"
				|| command == "wins" || command == "losses") {
			return record
		}
		if (command == "game" || command == "title" || command == "name") {
			return game.title
		}
		return nil
	}

	public func isExit(command: String) -> Bool {
		return command == "exit" || command == ":exit"
	}

	public func isRestart(command: String) -> Bool {
		return command == "reset" || command == "restart"
	}

	//Unwraps optional if it is not nil and displays output
	public func displayCommandOutput(command: String) {
		if let output = getCommandOutput(command) {
			print(output)
		}
	}

	//Processes guess... catches exceptions
	public func guess(number: Int) -> RandomNumberGame.Condition {
		var result = RandomNumberGame.Condition.Unknown
		//Do catch is used instead of try catch
		do {
			//Try is used on throwing function
			result = try game.guess(number, validateRange: true)
		} catch RandomNumberGameError.OutOfRange.TooLow {
			print("[Below minimum value! Try again.]")
		} catch RandomNumberGameError.OutOfRange.TooHigh {
			print("[Above maximum value! Try again.]")
		} catch {
			print("[Something went wrong.]")
		}
		displayResult(result)
		return result
	}

	//Asks for user guess
	public func askForGuess() {
		//Use terminator parameter with print to not force newline
		print("Enter a guess. ", terminator: "")
		//Forced unwrapping of readLine
		let input = readLine()!
		//Make sure number is an integer
		guard let number = Int(input) else {
			//Special case commands
			if isRestart(input) {
				restart()
				return
			}
		 	if isExit(input) {
				return
			}
			//Process is regular command and continue to ask for guess
			displayCommandOutput(input)
			return askForGuess()
		}
		let result = guess(number)
		//Parentheses are required for multiline conditions
		if (result == RandomNumberGame.Condition.Lower
				|| result == RandomNumberGame.Condition.Higher
				|| result == RandomNumberGame.Condition.Unknown) {
			return askForGuess()
		}
		return promptToPlayAgain()
	}

	public func start() {
		print(header)
		askForGuess()
	}

	public func restart() {
		game.reset()
		start()
	}

	//Returns int for probably no good reason... felt right
	public func run() -> Int {
		//Displays help and exists if showHelp is true
		if showHelp == true {
			print(help)
			return 0
		}
		//Start main program
		start()
		return 0
	}
}
