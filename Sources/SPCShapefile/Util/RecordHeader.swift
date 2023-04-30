//
//  RecordHeader.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

public struct RecordHeader: Codable {
    public let number: UInt32
    public let size: UInt32
    public let shapeType: ShapeType
    
    internal init(from data: inout Data) throws {
        let components = try data.next(UInt32.self, count: 2, endianness: .big)
        number = components[0]
        size = components[1]
        
        guard let type = ShapeType(rawValue: try data.next(UInt32.self, endianness: .little)) else {
            throw ShapefileError.unexpectedEOF
        }
        shapeType = type
    }
    
    internal init(nonmutating data: Data) throws {
        var copy = data.prefix(12)
        self = try .init(from: &copy)
    }
}
