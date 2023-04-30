//
//  Numeric.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

extension Numeric {
    init(_ data: Data, endianness: Endianness) throws {
        var value: Self = .zero
        let data = endianness == .little ? data : Data(data.reversed())
        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        
        let expectedSize = MemoryLayout.size(ofValue: value)
        guard size == expectedSize else {
            throw ShapefileError.dataSizeMismatch(
                got: size,
                expected: expectedSize,
                message: "Expected to decode a \(expectedSize)-byte numeric value but \(size) were found."
            )
        }
        
        self = value
    }
}
