import Foundation

let content = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!)
let grid = content.split(whereSeparator: \.isNewline)
    .map(Array.init)
    .map { $0.map { Int("\($0)")! } }

func part1() {
    let destination = Point(x: grid[0].count-1, y: grid.count-1)
    let start = Point(x: 0, y: 0)
    var nodes = PriorityQueue<City>(sort: { $0.heat < $1.heat })
    nodes.enqueue(element: City(start, heat: 0, direction: .none, 0))
    var visited = Set<City>()
    
    while let city = nodes.dequeue() {
        let point = city.p
        let direction = city.direction
        let count = city.count
        let heat = city.heat
                
        guard !visited.contains(city) else { continue }
        visited.insert(city)
        
        if point == destination {
            print(heat)
            break
        }
        
        let reverse: Point? = {
            switch direction {
            case .down: return point.up
            case .up: return point.down
            case .right: return point.left
            case .left: return point.right
            case .none: return nil
            }
        }()
        
        if count < 3 && direction != .none {
            switch direction {
            case .down where point.down.y < grid.count:
                nodes.enqueue(element: City(point.down, heat: heat + grid[point.down.y][point.down.x], direction: .down, count+1))
            case .up where point.up.y >= 0:
                nodes.enqueue(element: City(point.up, heat: heat + grid[point.up.y][point.up.x], direction: .up, count+1))
            case .left where point.left.x >= 0:
                nodes.enqueue(element: City(point.left, heat: heat + grid[point.left.y][point.left.x], direction: .left, count+1))
            case .right where point.right.x < grid[0].count:
                nodes.enqueue(element: City(point.right, heat: heat + grid[point.right.y][point.right.x], direction: .right, count+1))
            default: break
            }
        }
                
        if direction != .right && point.right.x < grid[0].count && reverse != point.right {
            nodes.enqueue(element: City(point.right, heat: heat + grid[point.right.y][point.right.x], direction: .right, 1))
        }
                
        if direction != .left && point.left.x >= 0 && reverse != point.left {
            nodes.enqueue(element: City(point.left, heat: heat + grid[point.left.y][point.left.x], direction: .left, 1))
        }
                
        if direction != .up && point.up.y >= 0 && reverse != point.up {
            nodes.enqueue(element: City(point.up, heat: heat + grid[point.up.y][point.up.x], direction: .up, 1))
        }
                
        if direction != .down && point.down.y < grid.count && reverse != point.down {
            nodes.enqueue(element: City(point.down, heat: heat + grid[point.down.y][point.down.x], direction: .down, 1))
        }
    }
}

//Took 10-15 mins
func part2() {
    let destination = Point(x: grid[0].count-1, y: grid.count-1)
    let start = Point(x: 0, y: 0)
    var nodes = PriorityQueue<City>(sort: { $0.heat < $1.heat })
    nodes.enqueue(element: City(start, heat: 0, direction: .none, 0))
    var visited = Set<City>()
    
    while let city = nodes.dequeue() {
        let point = city.p
        let direction = city.direction
        let count = city.count
        let heat = city.heat
        
        guard !visited.contains(city) else { continue }
        visited.insert(city)
//        print(grid[point.y][point.x], direction.rawValue, "count:", count)
        
        if point == destination && count >= 4 {
            print(heat)
            break
        }
        
        if count < 10 && direction != .none {
            switch direction {
            case .down where point.down.y < grid.count:
                nodes.enqueue(element: City(point.down, heat: heat + grid[point.down.y][point.down.x], direction: .down, count+1))
            case .up where point.up.y >= 0:
                nodes.enqueue(element: City(point.up, heat: heat + grid[point.up.y][point.up.x], direction: .up, count+1))
            case .left where point.left.x >= 0:
                nodes.enqueue(element: City(point.left, heat: heat + grid[point.left.y][point.left.x], direction: .left, count+1))
            case .right where point.right.x < grid[0].count:
                nodes.enqueue(element: City(point.right, heat: heat + grid[point.right.y][point.right.x], direction: .right, count+1))
            default: break
            }
        }
        
        let reverse: Point? = {
            switch direction {
            case .down: return point.up
            case .up: return point.down
            case .right: return point.left
            case .left: return point.right
            case .none: return nil
            }
        }()
        
        if count >= 4 || direction == .none {
            if direction != .right && point.right.x < grid[0].count && reverse != point.right {
                nodes.enqueue(element: City(point.right, heat: heat + grid[point.right.y][point.right.x], direction: .right, 1))
            }
            
            if direction != .left && point.left.x >= 0 && reverse != point.left {
                nodes.enqueue(element: City(point.left, heat: heat + grid[point.left.y][point.left.x], direction: .left, 1))
            }
            
            if direction != .up && point.up.y >= 0 && reverse != point.up {
                nodes.enqueue(element: City(point.up, heat: heat + grid[point.up.y][point.up.x], direction: .up, 1))
            }
            
            if direction != .down && point.down.y < grid.count && reverse != point.down {
                nodes.enqueue(element: City(point.down, heat: heat + grid[point.down.y][point.down.x], direction: .down, 1))
            }
        }
    }
}

part1() //771
part2() //930

struct City: Hashable {
    internal init(_ p: Point, heat: Int, direction: Direction, _ count: Int) {
        self.p = p
        self.direction = direction
        self.heat = heat
        self.count = count
    }
    
    let p: Point
    let direction: Direction
    let heat: Int
    let count: Int
}

struct Point: Hashable, CustomStringConvertible {
    var description: String { "(\(x),\(y))" }
    let x: Int
    let y: Int
    
    var down: Point { Point(x: x, y: y+1) }
    var up: Point { Point(x: x, y: y-1) }
    var right: Point { Point(x: x+1, y: y) }
    var left: Point { Point(x: x-1, y: y) }
}

enum Direction: String {
    case up = "⬆️", down = "⬇️", left = "⬅️", right = "➡️", `none` = "."
}
