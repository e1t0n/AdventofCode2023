import Foundation

let field = input.split(whereSeparator: \.isNewline)
    .map(Array.init)

struct Pos: Equatable, Hashable {
    let x: Int
    let y: Int
    
    var north: Pos { Pos(x: x, y: y-1) }
    var south: Pos { Pos(x: x, y: y+1) }
    var east: Pos { Pos(x: x+1, y: y) }
    var west: Pos { Pos(x: x-1, y: y) }
}

enum Direction {
    case east, west, north, south
}

func part1() {
    var neighbours: [Pos] = []
    var visited: Set<Pos> = []
    let start = startPos(field)
    neighbours.append(start)
    
    while let p = neighbours.popLast() {
        guard !visited.contains(p) else { continue }
        
        let currentPipe = field[p.y][p.x]
        
        if p.east.x < field[0].count && currentPipe.isConnected(to: field[p.east.y][p.east.x], direction: .east) {
            neighbours.append(p.east)
            visited.insert(p)
        }
        
        if p.west.x >= 0 && currentPipe.isConnected(to: field[p.west.y][p.west.x], direction: .west) {
            neighbours.append(p.west)
            visited.insert(p)
        }
        
        if p.north.y >= 0 && currentPipe.isConnected(to: field[p.north.y][p.north.x], direction: .north) {
            neighbours.append(p.north)
            visited.insert(p)
        }
        
        if p.south.y < field.count && currentPipe.isConnected(to: field[p.south.y][p.south.x], direction: .south) {
            neighbours.append(p.south)
            visited.insert(p)
        }
    }
    
    print(visited.count/2)
}

part1()

func startPos(_ gird: [[Character]]) -> Pos {
    for (iy,y) in field.enumerated() {
        for (ix, x) in y.enumerated() {
            if x == "S" {
                return Pos(x:ix, y:iy)
            }
        }
    }
    preconditionFailure()
}

extension Character {
    func isConnected(to: Character, direction: Direction) -> Bool {
        switch direction {
        case .north where ["|", "L", "J", "S"].contains(self):
            return ["|", "7", "F"].contains(to)
        case .south where ["|", "7", "F", "S"].contains(self):
            return ["|", "J", "L"].contains(to)
        case .east where ["-", "L", "F", "S"].contains(self):
            return ["-", "J", "7"].contains(to)
        case .west where ["-", "7", "J", "S"].contains(self):
            return ["-", "L", "F"].contains(to)
        default: return false
        }
    }
}
