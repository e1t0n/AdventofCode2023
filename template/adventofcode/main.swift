import Foundation

let content = try! String(contentsOf: Bundle.main.url(forResource: "sample", withExtension: "txt")!)
let grid = content.split(whereSeparator: \.isNewline)
