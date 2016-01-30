//Errors (exceptions) must extend ErrorType
public enum RandomNumberGameError : ErrorType {
	//Give more detail to error
	public enum OutOfRange : ErrorType {
		case TooLow, TooHigh
	}
}
