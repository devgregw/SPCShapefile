//
//  ShapeType.swift
//  
//
//  Created by Greg Whatley on 4/27/23.
//

public enum ShapeType: UInt32, Codable {
    case null = 0
    
    case point = 1
    case polyline = 3
    case polygon = 5
    case multiPoint = 8
    
    case pointZ = 11
    case polylineZ = 13
    case polygonZ = 15
    case multiPointZ = 18
    
    case pointM = 21
    case polylineM = 23
    case polygonM = 25
    case multiPointM = 28
    
    case multiPatch = 31
    
    private static let typeMap: [ShapeType: Shape.Type] = [
        .null: NullShape.self,
        .point: PointShape.self,
        .polyline: PolylineShape.self,
        .polygon: PolygonShape.self,
        .multiPoint: MultiPointShape.self
    ]
    
    internal var underlyingType: Shape.Type? {
        ShapeType.typeMap[self]
    }
}
