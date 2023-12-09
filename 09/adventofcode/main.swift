import Foundation

let reports = input.split(whereSeparator: \.isNewline)
    .map { $0.split(whereSeparator: \.isWhitespace)
            .map(String.init)
            .compactMap(Int.init)
    }

func part1() {
    var sum = 0
    for report in reports {
        sum += calculateDiffsA(report)
    }
    print(sum)
}

func part2() {
    var sum = 0
    for report in reports {
        let s = calculateDiffsB(report)
        sum += s
    }
    print(sum)
}

part1() //1969958987
part2() //1068

func calculateDiffsA(_ report: [Int], sum: Int = 0) -> Int {
    let diffs = zip(report.dropFirst(), report).map { $0 - $1 }
    if diffs.filter({ $0 == 0 }).count == diffs.count  {
        return sum + report.last!
    } else {
        return calculateDiffsA(diffs, sum: sum + report.last!)
    }
}

func calculateDiffsB(_ report: [Int], sum: Int = 0) -> Int {
    let diffs = zip(report.dropFirst(), report).map { $0 - $1 }
    if diffs.filter({ $0 == 0 }).count == diffs.count  {
        return report.first!
    } else {
        let res = calculateDiffsB(diffs, sum: sum)
        return report.first! - res
    }
}
