import XCTest
@testable import SPCShapefile

final class SPCShapefileTests: XCTestCase {
    private func forEachMock(perform: (MockData) throws -> Void) rethrows {
        try MockData.allCases.forEach(perform)
    }
    
    func testShapefileParser() throws {
        try forEachMock {
            print("Testing shapefile parser: \($0)")
            let shp = try Shapefile(file: $0.shpFile, loadAttributes: false)
            XCTAssertTrue(shp.records.count > 0, "No shapes found in the test \($0).shp file")
        }
    }
    
    func testFullShapefileParser() throws {
        try forEachMock {
            print("Testing full shapefile parser: \($0)")
            let shp = try Shapefile(file: $0.shpFile)
            XCTAssertTrue(shp.records.count > 0, "No shapes found in the test \($0).shp file")
            XCTAssertTrue(shp.records.allSatisfy { $0.attributes != nil })
        }
    }
    
    func testFullShapefileParserData() throws {
        try forEachMock {
            print("Testing full shapefile parser w/ data: \($0)")
            let shp = try Shapefile(
                shpData: try .init(contentsOf: $0.shpFile),
                dbfData: try .init(contentsOf: $0.dbfFile)
            )
            XCTAssertTrue(shp.records.count > 0, "No shapes found in the test \($0).shp file")
            XCTAssertTrue(shp.records.allSatisfy { $0.attributes != nil })
        }
    }
    
    func testShapefileAttributes() throws {
        try forEachMock {
            print("Testing attributes parser: \($0)")
            let attrs = try ShapefileAttributesParser(file: $0.dbfFile)
            XCTAssertTrue(attrs.attributes.count > 0, "No attributes found in the test \($0).dbf file")
        }
    }
    
    func testShapePartitioning() throws {
        try forEachMock { mock in
            print("Testing partitioning: \(mock)")
            let shp = try Shapefile(file: mock.shpFile, loadAttributes: false)
            if let partitionable = shp.records.first(where: { $0 is PartitionableShape }) as? PartitionableShape {
                partitionable.partitioned.forEach { part in
                    if let first = part.first, let last = part.last {
                        XCTAssertEqual(first, last)
                    } else {
                        XCTFail("Unexpectedly received an empty partition in \(mock).shp")
                    }
                }
            } else {
                XCTFail("No partitionable shapes found in \(mock).shp")
            }
        }
    }
}
