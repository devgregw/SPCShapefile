//
//  PointShape.swift
//  
//
//  Created by Greg Whatley on 4/28/23.
//

import Foundation

public struct PointShape: Shape {
    public let header: RecordHeader
    public let attributes: [String : String]?
    public let cgPoint: CGPoint
    
    public init(from data: inout Data, withAttributes attr: [String: String]?) throws {
        header = try RecordHeader(from: &data)
        attributes = attr
        cgPoint = try data.nextPoint(endianness: .little)
    }
}
