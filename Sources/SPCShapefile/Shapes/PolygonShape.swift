//
//  PolygonShape.swift
//  
//
//  Created by Greg Whatley on 4/28/23.
//

import Foundation

public struct PolygonShape: PartitionableShape {
    public let header: RecordHeader
    public let attributes: [String : String]?
    
    public let mbr: BoundingBox
    public let partCount: UInt32
    public let pointCount: UInt32
    public let parts: [UInt32]
    public let points: [CGPoint]
    
    public init(from data: inout Data, withAttributes attr: [String: String]?) throws {
        header = try RecordHeader(from: &data)
        attributes = attr
        mbr = try BoundingBox(data: &data)
        
        partCount = try data.next(UInt32.self, endianness: .little)
        pointCount = try data.next(UInt32.self, endianness: .little)
        
        parts = try data.next(UInt32.self, count: Int(partCount), endianness: .little)
        points = try data.nextPoints(count: Int(pointCount), endianness: .little)
    }
}
