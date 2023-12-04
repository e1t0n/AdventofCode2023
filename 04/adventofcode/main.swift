import Foundation

let cards = input.split(whereSeparator: \.isNewline)
    .map { $0.split(separator: ":")[1].trimmingCharacters(in: .whitespaces) }

func part1() {
    var sum = 0
    for card in cards {
        let matches = card.numbersYouHave.intersection(card.winningNumbers).count
        sum += calculatePoints(point: 0, n: matches)
    }
    print(sum)
}

func part2() {
    var cardInstances: [Int: Int] = [:]
    for (idx, card) in cards.enumerated() {
        increment(&cardInstances, index: idx)
        let matches = card.numbersYouHave.intersection(card.winningNumbers).count
        guard matches > 0 else { continue }
        let copies = cardInstances[idx]!
        for _ in 0..<copies {
            for i in idx+1..<idx+1+matches {
                guard i < cards.count else { break }
                increment(&cardInstances, index: i)
            }
        }
    }
    
    let sum = cardInstances
        .map { $0.value }
        .reduce(0, +)
    print(sum)
}

func calculatePoints(point: Int, n: Int) -> Int {
    if n == 0 { return point }
    if point == 0 {
        return calculatePoints(point: 1, n: n-1)
    }
    return calculatePoints(point: point*2, n: n-1)
}

func increment(_ instances: inout [Int: Int], index: Int) {
    if instances[index] == nil {
        instances[index] = 1
    } else {
        instances[index] = instances[index]! + 1
    }
}

part1() //19135
part2() //5704953

extension String {
    var winningNumbers: Set<String> {
        Set(
            split(separator: "|")[0].trimmingCharacters(in: .whitespaces)
                .split(whereSeparator: \.isWhitespace)
                .map(String.init)
        )
    }
    
    var numbersYouHave: Set<String> {
        Set(
            split(separator: "|")[1].trimmingCharacters(in: .whitespaces)
                .split(whereSeparator: \.isWhitespace)
                .map(String.init)
        )
    }
}
