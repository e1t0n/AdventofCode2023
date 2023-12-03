import Foundation

let schematics = input
    .split(whereSeparator: \.isNewline)
    .map(String.init)
    .map(Array.init)

let coloumnCount = schematics.count
let rowCount = schematics[0].count

func part1() {
    var numbers = [String]()
    for (rowIdx, row) in schematics.enumerated() {
        var number = ""
        var isAdjacent = false
        for (colIdx, element) in row.enumerated() {
            if element.isWholeNumber {
                number.append(element)
                if isAdjacent == false {
                    isAdjacent = isAdjacentToSymbol(row: rowIdx, column: colIdx).result
                }
            } 
            else if element.isAnySymbol {
                if !number.isEmpty && isAdjacent {
                    numbers.append(number)
                }
                number = ""
                isAdjacent = false
            }
        }
        
        if !number.isEmpty && isAdjacent {
            numbers.append(number)
        }
    }
        
    let sum = numbers
        .compactMap { Int($0) }        
        .reduce(0, +)
    print(sum)
}

func part2() {
    var gears = [Position: [Int]]()
    for (rowIdx, row) in schematics.enumerated() {
        var number = ""
        var position: Position?
        var isAdjacent = false
        for (colIdx, element) in row.enumerated() {
            if element.isWholeNumber {
                number.append(element)
                if isAdjacent == false {
                    let result = isAdjacentToSymbol(row: rowIdx, column: colIdx)
                    if result.symbol?.isGear == true {
                        isAdjacent = true
                        position = result.position
                        if gears[result.position!] == nil {
                            gears[result.position!] = [Int]()
                        }
                    }
                }
            }
            else if element.isAnySymbol {
                if !number.isEmpty && isAdjacent {
                    gears[position!]!.append(number.intValue)
                }
                number = ""
                isAdjacent = false
                position = nil
            }
        }
        
        if !number.isEmpty && isAdjacent {
            gears[position!]!.append(number.intValue)
        }
    }
    
    let sum = gears
        .filter { $0.value.count > 1 }
        .map { $0.value.reduce(1, *) }
        .reduce(0, +)
    
    print(sum)
}

part1() //539713
part2() //84159075

struct Position: Hashable {
    let row: Int
    let col: Int
}

func isAdjacentToSymbol(row: Int, column: Int) -> (result: Bool, symbol: Character?, position: Position?) {
    guard schematics[row][column].isWholeNumber else { preconditionFailure() }
    let dcr = [(-1,-1),(-1,0), (-1,1),
               (0,-1),         (0,1),
               (1,-1), (1,0),  (1,1)]
    
    for d in dcr {
        if row+d.0 >= 0 && column+d.1 >= 0 &&
            row+d.0 < rowCount && column+d.1 < coloumnCount {
            let val = schematics[row+d.0][column+d.1]
            if val.isRequiredSymbol {
                return (true, val, Position(row: row+d.0, col: column+d.1))
            }
        }
    }
    return (false, nil, nil)
}

extension String {
    var intValue: Int { Int(self)! }
}

extension Character {
    var isGear: Bool { self == "*" }
    var isPeriod: Bool { self == "." }
    var isAnySymbol: Bool { !isWholeNumber }
    var isRequiredSymbol: Bool { !isPeriod && !isWholeNumber }
}
