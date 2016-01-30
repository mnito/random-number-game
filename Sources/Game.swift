// {get} marks get only
protocol Game {
	var title: String {get}
	var rules: String {get}
	var wins: Int {get}
	var losses: Int {get}
	var games: Int {get}
}
