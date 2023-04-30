//
//  ShapefileError.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

public enum ShapefileError: Error {
    case unexpectedFileCode
    case unexpectedEOF
    case unknownShapeType
    case unsupportedShapeType
    case dataSizeMismatch(got: Int, expected: Int, message: String)
}
