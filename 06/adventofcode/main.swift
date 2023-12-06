import Foundation

let document = input.split(whereSeparator: \.isNewline).map(String.init)

func part1() {
    let times = getIntValues(document[0])
    let distances = getIntValues(document[1])
    var numberOfWays = [Int]()
    for (time, distance) in zip(times, distances) {
        numberOfWays.append(toBeatRecord(time: time, distance: distance))
    }
    print(numberOfWays.reduce(1, *))
}

func part2() {
    let time = getIntValue(document[0])
    let distance = getIntValue(document[1])
    print(toBeatRecord(time: time, distance: distance))
}

part1() //140220
part2() //39570185

func getIntValues(_ string: String) -> [Int] {
    string.split(whereSeparator: \.isWhitespace)
        .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
}

func getIntValue(_ string: String) -> Int {
    Int(string.split(whereSeparator: \.isWhitespace)
        .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        .reduce("") { $0.appending("\($1)") })!
}

func toBeatRecord(time: Int, distance: Int) -> Int {
    var t = 0
    var i = 0
    while t <= time {
        if (time-t) * t > distance {
            i += 1
        }
        t += 1
    }
    return i
}

