import Foundation

let content = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
let grid = content.split(whereSeparator: \.isNewline)
    .map(Array.init)

struct Pos: Hashable, CustomStringConvertible {
    var col: Int
    var row: Int
    
    var description: String { "col:\(col),row:\(row)" }
    
    var right: Pos { Pos(col: col+1, row: row) }
    var left: Pos { Pos(col: col-1, row: row) }
    var up: Pos { Pos(col: col, row: row-1) }
    var down: Pos { Pos(col: col, row: row+1) }
}

enum Direction: String, Hashable {
    case up = "⬇️", down = "⬆️", left = "➡️", right = "⬅️"
}

func part1() {
    let energised = findEnergised(from: Pos(col: 0, row: 0), direction: .left)
    print(energised)
}

func part2() {
    let top = grid[0].enumerated()
        .map { findEnergised(from: Pos(col: $0.offset, row: 0), direction: .up) }
    let bottom = grid.last!.enumerated()
        .map { findEnergised(from: Pos(col: $0.offset, row: grid.count-1), direction: .down) }
    let left = grid
        .map { $0[0] }
        .enumerated()
        .map { findEnergised(from: Pos(col: 0, row: $0.offset), direction: .left) }
    let right = grid
        .map { $0.last! }
        .enumerated()
        .map { findEnergised(from: Pos(col: grid[0].count-1, row: $0.offset), direction: .right) }
    
    let max = [top, bottom, left, right].flatMap { $0 }.max()!
    print(max)
}

part1() //6921
part2() //7594

func findEnergised(from tilePos: Pos, direction: Direction) -> Int {
    var visited: [Pos: Set<Direction>] = [:]
    var energised: Set<Pos> = []
    var currentTiles: [(Pos, direction: Direction)] = [(tilePos, direction)]
    while let next = currentTiles.popLast() {
        let direction = next.direction
        let tile = next.0
        visited[tile] = visited[tile] ?? []
        guard !visited[tile]!.contains(direction) else { continue }
        visited[tile]!.insert(direction)
        energised.insert(Pos(col: tile.row, row: tile.col))
        
//        print(grid[tile.row][tile.col], tile, direction.rawValue)
        
        switch grid[tile.row][tile.col] {
        case "." where direction == .left && tile.col+1 < grid[0].count:
            currentTiles.append((tile.right, direction))
        case "." where direction == .right && tile.col-1 >= 0:
            currentTiles.append((tile.left, direction))
        case "." where direction == .up && tile.row+1 < grid.count:
            currentTiles.append((tile.down, direction))
        case "." where direction == .down && tile.row-1 >= 0:
            currentTiles.append((tile.up, direction))
            
        case "/" where direction == .left && tile.row-1 >= 0:
            currentTiles.append((tile.up, .down))
        case "/" where direction == .up && tile.col-1 >= 0:
            currentTiles.append((tile.left, .right))
        case "/" where direction == .right && tile.row+1 < grid.count:
            currentTiles.append((tile.down, .up))
        case "/" where direction == .down && tile.col+1 < grid[0].count:
            currentTiles.append((tile.right, .left))
            
        case "\\" where direction == .left && tile.row+1 < grid.count:
            currentTiles.append((tile.down, .up))
        case "\\" where direction == .down && tile.col-1 >= 0:
            currentTiles.append((tile.left, .right))
        case "\\" where direction == .up && tile.col+1 < grid[0].count:
            currentTiles.append((tile.right, .left))
        case "\\" where direction == .right && tile.row-1 >= 0:
            currentTiles.append((tile.up, .down))
            
        case "|" where direction == .right || direction == .left:
            if tile.row-1 >= 0 { currentTiles.append((tile.up, .down)) }
            if tile.row+1 < grid.count { currentTiles.append((tile.down, .up)) }
        case "|" where direction == .up && tile.row+1 < grid.count:
            currentTiles.append((tile.down, direction))
        case "|" where direction == .down && tile.row-1 >= 0:
            currentTiles.append((tile.up, direction))
            
        case "-" where direction == .up || direction == .down:
            if tile.col-1 >= 0 { currentTiles.append((tile.left, .right)) }
            if tile.col+1 < grid[0].count { currentTiles.append((tile.right, .left)) }
        case "-" where direction == .left && tile.col+1 < grid[0].count:
            currentTiles.append((tile.right, .left))
        case "-" where direction == .right && tile.col-1 >= 0:
            currentTiles.append((tile.left, .right))
            
        default: continue
        }
    }
    
    return energised.count
}
