//
//  BoundingBox.swift
//  
//
//  Created by Greg Whatley on 4/28/23.
//

import Foundation

public struct BoundingBox: Codable {
    public let xMin: Double
    public let yMin: Double
    public let xMax: Double
    public let yMax: Double
    
    internal init(data: inout Data) throws {
        let components = try data.next(Double.self, count: 4, endianness: .little)
        
        self.xMin = components[0]
        self.yMin = components[1]
        self.xMax = components[2]
        self.yMax = components[3]
    }
}
