import Foundation

let hands = input
    .split(whereSeparator: \.isNewline)
    .map(String.init)

func part1() {
    let result = hands
        .map { (r: getStrength($0.card), c: $0.card, b: $0.bid) }
        .sorted { a, b in
            if a.r < b.r { return true }
            if a.r == b.r {
                for (ac,bc) in zip(Array(a.c), Array(b.c)) {
                    if ac.power > bc.power { return true }
                    if ac.power == bc.power { continue }
                    return false
                }
                return true
            }
            return false
        }
        .enumerated()
        .map { ($0, $1) }
        .reduce(0) { $0 + ($1.0+1)*$1.1.b }
    
    print(result)
}

part1() //249638405

func getStrength(_ hand: String) -> Int {
    let count = hand.chars
        .reduce(into: Dictionary<Character, Int>()) { dict, c in
            dict[c] = (dict[c] ?? 0) + 1
        }
    
    switch count.max(by: { $0.value < $1.value })!.value {
    case 5: return 6
    case 4: return 5
    case 3 where count.filter { $0.value == 2 }.count == 1: return 4
    case 3: return 3
    case 2 where count.filter { $0.value == 2 }.count == 2: return 2
    case 2: return 1
    case 1: return 0
    default: preconditionFailure()
    }
}

extension Character {
    var power: Int {
        let power: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
        return power.firstIndex(of: self)!
    }
}

extension String {
    
    var chars: [Character] {
        Array(self)
    }
    
    var card: String {
        String(split(whereSeparator: \.isWhitespace)[0])
    }
    
    var bid: Int {
        Int(String(split(whereSeparator: \.isWhitespace)[1]))!
    }
}
