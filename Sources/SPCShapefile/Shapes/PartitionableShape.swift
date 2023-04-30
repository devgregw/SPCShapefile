//
//  PartitionableShape.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

protocol PartitionableShape: Shape {
    var partCount: UInt32 { get }
    var pointCount: UInt32 { get }
    var parts: [UInt32] { get }
    var points: [CGPoint] { get }
    
    var partitioned: [ArraySlice<CGPoint>] { get }
}

extension PartitionableShape {
    var partitioned: [ArraySlice<CGPoint>] {
        parts
            .map { Int($0) }
            .enumerated()
            .map { (partIdx, startPointIdx) in
                let endPointIdx = partIdx == parts.count - 1 ? points.count : Int(parts[partIdx + 1])
                return points[startPointIdx..<endPointIdx]
            }
    }
}
