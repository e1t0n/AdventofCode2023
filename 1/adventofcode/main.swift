import Foundation

let calibrationValues = input
    .split(whereSeparator: \.isNewline)
    .map { String($0) }

func part1(_ values: [String]) {
    let result = values
        .map {
            let value = $0.compactMap { Int(String($0)) != nil ? String($0) : nil }            
            return value.first! + value.last!
        }
        .map {
            return Int($0)!
        }
        .reduce(0, +)
            
    print(result)
}

func part2(_ values: [String]) {
    let spelled = ["one": "1ne", "two": "2wo", "three": "3hree", "four": "4our", "five": "5ive", "six": "6ix", "seven": "7even", "eight": "8ight", "nine": "9ine"]
    let result = values
        .map { value in
            var _value = value
            var ranges: [(Range<String.Index>, String)] = []
            spelled.forEach { (k, v) in
                if let range = value.range(of: k) {
                    ranges.append((range, k))
                }
            }
            ranges
                .sorted(by: { $0.0.lowerBound < $1.0.lowerBound })
                .forEach {
                    _value = _value.replacingOccurrences(of: $0.1, with: spelled[$0.1]!)
                }
            return _value
        }
    part1(result)
}

part1(calibrationValues) //55538
part2(calibrationValues) //54875
