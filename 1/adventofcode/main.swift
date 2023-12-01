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
        .map { Int($0)! }
        .reduce(0, +)
            
    print(result)
}

part1(calibrationValues) //55538

