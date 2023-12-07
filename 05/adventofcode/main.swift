import Foundation
import Algorithms

let almanac = sample
    .split(whereSeparator: \.isNewline)
    .map(String.init)

func part1() {
    let ranges = getRanges(Array(almanac.dropFirst()))
    let seeds = almanac[0]
        .split(whereSeparator: \.isWhitespace)
        .map(String.init)
        .compactMap(Int.init)
    var min = Int.max
    for seed in seeds {
        var _seed = seed
        for range in ranges {
            for (s,d) in zip(range.s, range.d) {
                if s.contains(_seed) {
                    _seed = _seed - s.lowerBound + d.lowerBound
                    break
                }
            }
        }
        if _seed < min { min = _seed }
    }
    
    print(min)
}

part1() //424490994

func getRanges(_ mappings: [String]) -> [(s:[Range<Int>], d:[Range<Int>])] {
    var maps = [(s:[Range<Int>], d:[Range<Int>])]()
    var sourceRange: [Range<Int>] = []
    var destRange: [Range<Int>] = []
    for mapping in mappings {
        if mapping.contains("map:") {
            if !sourceRange.isEmpty, !destRange.isEmpty {
                maps.append((sourceRange, destRange))
            }
            sourceRange = [Range<Int>]()
            destRange = [Range<Int>]()
            continue
        }
        
        let end = Int(mapping.split(whereSeparator: \.isWhitespace)[2])!
        let source = Int(mapping.split(whereSeparator: \.isWhitespace)[1])!
        let dest = Int(mapping.split(whereSeparator: \.isWhitespace)[0])!
        sourceRange.append(source..<source+end)
        destRange.append(dest..<dest+end)
    }
    maps.append((sourceRange, destRange))
    return maps
}
