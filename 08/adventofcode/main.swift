import Foundation

let navigataion = input
    .split(whereSeparator: \.isNewline)
    .map(String.init)

struct LeftRight {
    let left: String
    let right: String
}

let directions = Array(navigataion[0])
let network = navigataion
    .dropFirst()
    .reduce(into: Dictionary<String, LeftRight>()) { (d,s) in
        d[s.element] = LeftRight(left: s.leftRight.left, right: s.leftRight.right)
    }

func part1() {
    var steps = 0
    var index = 0
    var startNode = "AAA"
    while startNode != "ZZZ" {
        steps += 1
        guard let next = network[startNode] else { preconditionFailure() }
        switch directions[index] {
        case "R":
            startNode = next.right
        case "L":
            startNode = next.left
        default: preconditionFailure()
        }
        (index < directions.count-1) ? (index += 1) : (index = 0)
    }
    print(steps)
}

///https://www.reddit.com/r/adventofcode/comments/18df7px/2023_day_8_solutions/
///LCM
func part2() {
    let ghosts = network
        .filter { $0.key.hasSuffix("A") }
        .keys.map { $0 }
    
    var cycleNodes = [String: Int]()
    var directionIndex = 0
    var steps = [Int]()
    for ghost in ghosts {
        var startNode = ghost
        var step = 0
        while true {
            guard let currentNode = network[startNode] else { preconditionFailure() }
            step += 1
            
            switch directions[directionIndex] {
            case "R":
                startNode = currentNode.right
            case "L":
                startNode = currentNode.left
            default: preconditionFailure()
            }
            
            if startNode.hasSuffix("Z") {
                let cycle = cycleNodes[startNode] ?? 0
                if cycle == 1 { //already cycled
                    steps.append(step)
                    break
                } else {
                    cycleNodes[startNode] = 1
                    step = 0
                }
            }
            (directionIndex < directions.count-1) ? (directionIndex += 1) : (directionIndex = 0)
        }
    }
    
    let result = steps.reduce(0) { x, y in
        return x > 0 ? lcm(x, y) : y
    }
    print(result)
}

part1() //16043
part2() //15726453850399

extension String {
    var element: String {
        split(separator: "=")[0].trimmingCharacters(in: .whitespaces)
    }
    
    var leftRight: String {
        split(separator: "=")[1]
            .trimmingCharacters(in: .whitespaces)
    }
    
    var left: String {
        String(split(separator: ", ")[0].dropFirst())
    }
    
    var right: String {
        String(split(separator: ", ")[1].dropLast())
    }
}

///https://gist.github.com/aniltv06/6f3e9c6208e27a89259919eeb3c3d703
/*
 Returns the Greatest Common Divisor of two numbers.
 */
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/*
 Returns the least common multiple of two numbers.
 */
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}
