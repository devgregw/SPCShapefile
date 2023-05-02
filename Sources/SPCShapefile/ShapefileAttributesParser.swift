//
//  ShapefileAttributesParser.swift
//  
//
//  Created by Greg Whatley on 4/28/23.
//

import Foundation

fileprivate let headerSize = 32
fileprivate let headerTerminator = 0xD
fileprivate let fieldSubrecordSize = 32

struct ShapefileAttributesParser {
    typealias Field = (name: String, size: Int)
    
    let attributes: [[String: String]]
    
    /// Parses a `dbf` file from an in-memory representation
    /// - Parameter data: `dbf` file data buffer.
    init(data: Data) throws {
        let count = try UInt8(data[4..<8], endianness: .little)
        
        var data = data.dropFirst(headerSize)
        
        let fields: [Field] = data
            .prefix { $0 != headerTerminator }
            .chunked(maxLength: fieldSubrecordSize)
            .compactMap { chunk in
                guard let name = String(data: chunk.prefix { $0 > 0 }, encoding: .utf8) else {
                    return nil
                }
            
                return (name: name.trimmingCharacters(in: .whitespacesAndNewlines), size: Int(chunk[16]))
            }
        
        data = data.trimmingPrefix { $0 != headerTerminator }.dropFirst(2)
        
        self.attributes = (0..<count).map { _ in
            fields.reduce(into: [:]) { out, field in
                defer {
                    data = data.dropFirst(field.size)
                }
                if let value = String(data: data.prefix(field.size), encoding: .utf8) {
                    out[field.name] = value.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        guard count == attributes.count else {
            throw ShapefileError.dataSizeMismatch(
                got: attributes.count,
                expected: Int(count),
                message: "DBF header specified \(count) shapes, but there are \(attributes.count) subrecords."
            )
        }
        
        try attributes.forEach { dict in
            guard dict.count == fields.count else {
                throw ShapefileError.dataSizeMismatch(
                    got: dict.count,
                    expected: fields.count,
                    message: "DBF specified \(fields.count) field records, but there this record contains \(dict.count) records."
                )
            }
        }
    }
    
    /// Parses a `dbf` file given a file URL.
    /// - Parameter url: The file to open.
    init(file url: URL) throws {
        self = try .init(data: try .init(contentsOf: url))
    }
}
