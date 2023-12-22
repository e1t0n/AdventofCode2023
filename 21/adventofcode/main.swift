import Foundation

let content = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
let grid = content.split(whereSeparator: \.isNewline)
    .map(Array.init)

func part1() {
    let start = findStart()
    var plots = Set<Point>()
    plots.insert(start)
    var steps = 64
    while steps > 0 {
        let visited = plots
        plots = Set<Point>()
        for next in visited {
            for p in [next.north, next.south, next.east, next.west] {
                guard p.x >= 0 && p.y >= 0 && p.y < grid.count && p.x < grid[0].count && (grid[p.y][p.x] == "." || grid[p.y][p.x] == "S") else { continue }
                plots.insert(p)
            }
        }
        steps -= 1
    }
    
    print(plots.count)
}

part1() //3776

func findStart() -> Point {
    for (y,row) in grid.enumerated() {
        for (x, col) in row.enumerated() {
            if col == "S" {
                return Point(x: x, y: y)
            }
        }
    }
    preconditionFailure()
}

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    var description: String { "(\(x),\(y))" }
    
    var south: Point { Point(x: x, y: y+1) }
    var north: Point { Point(x: x, y: y-1) }
    var east: Point { Point(x: x+1, y: y) }
    var west: Point { Point(x: x-1, y: y) }
}
