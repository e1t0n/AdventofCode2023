import Foundation

let image = sample
    .split(whereSeparator: \.isNewline)
    .map(String.init)
    .map(Array.init)

struct Point: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

func part1() {
    let expanded = transpose(expand(transpose(expand(image))))
    var galaxyCoord = [Point]()
    for (ir, row) in expanded.enumerated() {
        for (ic, column) in row.enumerated() {
            if column == "#" {
                galaxyCoord.append(.init(ic, ir))
            }
        }
    }
    
    var sum = 0
    for g1 in galaxyCoord {
        for g2 in galaxyCoord {
            sum += manhattanDistance(from: g1, to: g2)
        }
    }
    print(sum/2)
}

part1() //9681886

//https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-manhattan-distance-between-two-cgpoints
func manhattanDistance(from: Point, to: Point) -> Int {
    return (abs(from.x - to.x) + abs(from.y - to.y))
}

func expand(_ galaxy: [[Character]]) -> [[Character]] {
    galaxy
        .map { $0.contains("#") ? [$0] : [$0, $0] }
        .flatMap { $0 }
}

//https://github.com/antonio081014/LeetCode-CodeBase/blob/main/Swift/transpose-matrix.swift
func transpose(_ matrix: [[Character]]) -> [[Character]] {
    let n = matrix.count
    guard let m = matrix.first?.count else { return [] }
    var result = Array(repeating: Array(repeating: Character("-"), count: n), count: m)
    for x in 0 ..< n {
        for y in 0 ..< m {
            result[y][x] = matrix[x][y]
        }
    }
    return result
}
