//
//  NullShape.swift
//  
//
//  Created by Greg Whatley on 4/27/23.
//

import Foundation

public struct NullShape: Shape {
    public let header: RecordHeader
    public let attributes: [String : String]?
    
    public init(from data: inout Data, withAttributes attr: [String: String]?) throws {
        header = try RecordHeader(from: &data)
        attributes = attr
    }
}
