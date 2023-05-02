import Foundation

public struct Shapefile {
    /// Per the ESRI shapefile spec, all shapefiles begin with these 4 bytes.
    private static let expectedFileCode: UInt32 = 0x270a
    
    /// Length of the shapefile in 16-bit words
    public let fileLength: UInt32
    /// File version
    public let version: UInt32
    /// All non-null shapes are of this type
    public let shapeType: ShapeType
    
    /// Minimum bounding rectangle of all shapes in the file.
    public let mbr: BoundingBox
    /// Range of all shape elevations.
    public let elevation: ClosedRange<Double>
    /// Range of all shape measures.
    public let measure: ClosedRange<Double>
    
    /// The shapes contained in this file.
    public let records: [Shape]
    
    /// Creates a shapefile from an in-memory representation.
    /// - Parameters:
    ///   - shpData: Data buffer for the `shp` file.
    ///   - dbfData: Optional: Data buffer for the corresponding `dbf` file.
    public init(shpData: Data, dbfData: Data?) throws {
        let attributes: [[String: String]]?
        if let dbfData {
            attributes = try ShapefileAttributesParser(data: dbfData).attributes
        } else {
            attributes = nil
        }
        
        var data = shpData
        
        let fileCode = try data.next(UInt32.self, endianness: .big)
        guard Shapefile.expectedFileCode == fileCode else {
            throw ShapefileError.unexpectedFileCode
        }
        
        // After the file code, the spec says the next 20 bytes (5x UInt32) are unused.
        data = data.dropFirst(5 * 4)
        
        self.fileLength = try data.next(UInt32.self, endianness: .big)
        self.version = try data.next(UInt32.self, endianness: .little)
        
        guard let type = ShapeType(rawValue: try data.next(UInt32.self, endianness: .little)) else {
            throw ShapefileError.unknownShapeType
        }
        self.shapeType = type
        
        self.mbr = try BoundingBox(data: &data)
        
        let zRange = try data.next(Double.self, count: 2, endianness: .little)
        self.elevation = zRange[0] ... zRange[1]
        
        let mRange = try data.next(Double.self, count: 2, endianness: .little)
        self.measure = mRange[0] ... mRange[1]
        
        var shapes: [Shape] = []
        
        if let attributes {
            shapes = try attributes.map { attr in
                guard let shape = try makeShape(from: &data, withAttributes: attr) else {
                    throw ShapefileError.unexpectedEOF
                }
                return shape
            }
        } else {
            var shape: Shape? = try makeShape(from: &data, withAttributes: nil)
            repeat {
                if let shape {
                    shapes.append(shape)
                }
                shape = try makeShape(from: &data, withAttributes: nil)
            } while shape != nil
        }
        self.records = shapes
    }
    
    /// Creates a shapefile from a file URL.
    /// - Parameter file: A file URL pointing to the shapefile.
    /// - Parameter loadAttributes: Whether to load the shapefile's associated DBF attributes file. (Default: `true`)
    ///
    /// If `loadAttributes` is `true`, then another file with the same name as your shapefile, but with a `.dbf` extension,
    /// must exist in the same directory as the shapefile. For example, if you're opening `~/shapefile.shp`, then `~/shapefile.dbf`
    /// must also exist; otherwise, an error will be thrown. If `loadAttributes` is `false`, then this rule is not enforced and
    /// `attributes` will be `nil`.
    public init(file: URL, loadAttributes: Bool = true) throws {
        self = try .init(
            shpData: try .init(contentsOf: file),
            dbfData: loadAttributes ? try .init(contentsOf: file.replacingPathExtension(with: "dbf")) : nil
        )
    }
}
