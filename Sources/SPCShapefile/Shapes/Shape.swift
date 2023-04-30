//
//  Shape.swift
//  
//
//  Created by Greg Whatley on 4/27/23.
//

import Foundation

public protocol Shape: Codable {
    var header: RecordHeader { get }
    var attributes: [String: String]? { get }
    
    init(from data: inout Data, withAttributes attr: [String: String]?) throws
}

internal func makeShape(from data: inout Data, withAttributes attr: [String: String]?) throws -> Shape? {
    guard let rawType = try? UInt32(data.dropFirst(8), endianness: .little) else {
        return nil
    }
    
    guard let underlyingType = ShapeType(rawValue: rawType)?.underlyingType else {
        throw ShapefileError.unknownShapeType
    }
    
    return try underlyingType.init(from: &data, withAttributes: attr)
}
