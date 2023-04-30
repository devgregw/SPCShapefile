//
//  MultiPointShape.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

public struct MultiPointShape: Shape {
    public let header: RecordHeader
    public let attributes: [String : String]?
    
    public let mbr: BoundingBox
    public let pointCount: UInt32
    public let points: [CGPoint]
    
    public init(from data: inout Data, withAttributes attr: [String: String]?) throws {
        header = try RecordHeader(from: &data)
        attributes = attr
        mbr = try BoundingBox(data: &data)
        
        pointCount = try data.next(UInt32.self, endianness: .little)
        
        points = try data.nextPoints(count: Int(pointCount), endianness: .little)
    }
}
