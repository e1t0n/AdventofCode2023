import Foundation

let content = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
let workflows = content
    .components(separatedBy: "\n")
    .split(separator: "")[0]
    .reduce(into:  [String: ([Rule], String)]()) { $0[$1.workflow] = ($1.jobs, $1.otherwise) }
let ratings = Array(content
    .components(separatedBy: "\n")
    .split(separator: "")[1])
    .map { ["s": $0.s, "x": $0.x, "m": $0.m, "a": $0.a] }

func part1() {
    let sum = ratings
        .reduce(0) {
            if work("in", rating: $1) {
                return $0 + $1.values.reduce(0, +)
            }
            return $0
        }
    print(sum)
}

part1() //575412

func work(_ flow: String, rating: [String: Int]) -> Bool {
    if flow == "R" { return false }
    if flow == "A" { return true }
    guard let rules = workflows[flow] else { preconditionFailure() }
    
    let operation: [String: (Int, Int) -> Bool] = ["<": (<), ">": (>)]
    for r in rules.0 {
        if operation[r.operand]!(rating[r.part]!, r.value) {
            return work(r.result, rating: rating)
        }
    }
    return work(rules.1, rating: rating)
}

extension String {
    var workflow: String { components(separatedBy: "{")[0] }
    var jobs: [Rule] {
        components(separatedBy: "{")[1]
            .replacingOccurrences(of: "}", with: "")
            .components(separatedBy: ",")
            .compactMap {
                if $0.contains(":") {
                    let result = $0.components(separatedBy: ":")[1]
                    let part = $0
                        .components(separatedBy: ":")[0]
                        .components(separatedBy: ["<", ">"])[0]
                    let value = $0
                        .components(separatedBy: ":")[0]
                        .components(separatedBy: ["<", ">"])[1]
                    let operand = $0
                        .components(separatedBy: ":")[0]
                        .contains(">") ? ">" : "<"
                    return Rule(part: part, operand: operand, value: Int(value)!, result: result)
                }
                return nil
            }
    }
    var otherwise: String {
        components(separatedBy: "{")[1]
            .replacingOccurrences(of: "}", with: "")
            .components(separatedBy: ",")
            .last!
    }
    var x: Int { Int(dropLast().dropFirst().components(separatedBy: "x=")[1].components(separatedBy: ",")[0])! }
    var m: Int { Int(dropLast().dropFirst().components(separatedBy: "m=")[1].components(separatedBy: ",")[0])! }
    var a: Int { Int(dropLast().dropFirst().components(separatedBy: "a=")[1].components(separatedBy: ",")[0])! }
    var s: Int { Int(dropLast().dropFirst().components(separatedBy: "s=")[1])! }
}

struct Rule {
    let part: String
    let operand: String
    let value: Int
    let result: String
}
