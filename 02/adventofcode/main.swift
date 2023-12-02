import Foundation

let games = input.split(whereSeparator: \.isNewline).map(String.init)

func part1() {
    let maxRed = 12
    let maxGreen = 13
    let maxBlue = 14
    var sum = 0
    games.forEach {
        let blue = $0.gameSets.maxCubeCount(for: "blue")
        let red = $0.gameSets.maxCubeCount(for: "red")
        let green = $0.gameSets.maxCubeCount(for: "green")
        if blue <= maxBlue, green <= maxGreen, red <= maxRed {
            sum += $0.gameID.intVal
        }
    }
    print(sum)
}

func part2() {
    var sum = 0
    games.forEach {
        let blue = $0.gameSets.maxCubeCount(for: "blue")
        let red = $0.gameSets.maxCubeCount(for: "red")
        let green = $0.gameSets.maxCubeCount(for: "green")
        sum += blue*red*green
    }
    print(sum)
}

part1() //2076
part2() //70950

//
extension String {
    var intVal: Int { Int(self)! }
    
    var gameID: String {
        components(separatedBy: ":")[0]
            .components(separatedBy: " ")[1]
    }
    
    var gameSets: [String] {
        components(separatedBy: ":")[1]
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

extension Array where Element == String {
    func maxCubeCount(for colour: String) -> Int {
        var max = 0
        for game in self {
            let count = game.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .reduce(0) { i, cube in
                    if cube.hasSuffix(colour) {
                        return i + Int(cube.components(separatedBy: " ")[0])!
                    }
                    return i
                }
            if count > max {
                max = count
            }
        }
        return max
    }
}
