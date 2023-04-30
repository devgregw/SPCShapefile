//
//  Data.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

extension Data {
    mutating func next<N: Numeric>(_: N.Type, endianness: Endianness) throws -> N {
        let expected = MemoryLayout<N>.size
        guard count >= expected else {
            throw ShapefileError.unexpectedEOF
        }
        
        defer {
            self = dropFirst(expected)
        }
        
        return try .init(prefix(expected), endianness: endianness)
    }
    
    mutating func next<N: Numeric>(_ type: N.Type, count: Int, endianness: Endianness) throws -> [N] {
        try (0..<count).map { _ in try next(type, endianness: endianness) }
    }
    
    mutating func nextPoint(endianness: Endianness) throws -> CGPoint {
        let components = try next(Double.self, count: 2, endianness: endianness)
        return .init(x: components[0], y: components[1])
    }
    
    mutating func nextPoints(count: Int, endianness: Endianness) throws -> [CGPoint] {
        var result: [CGPoint] = []
        for _ in 0..<count {
            result.append(try nextPoint(endianness: endianness))
        }
        return result
    }
    
    func chunked(maxLength: Int) -> [Data] {
        var copy = self
        var result: [Data] = []
        while !copy.isEmpty {
            let actualSize = Swift.min(copy.count, maxLength)
            defer {
                copy = copy.dropFirst(actualSize)
            }
            result.append(Data(copy.prefix(actualSize)))
        }
        return result
    }
}
