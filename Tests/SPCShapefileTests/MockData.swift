//
//  MockData.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

@testable import SPCShapefile

enum MockData: String, CaseIterable {
    case categorical
    case hail
    case torn
    case wind
    case sighail
    case sigtorn
    case sigwind
    
    var shpFile: URL {
        Bundle.module.url(forResource: rawValue, withExtension: "shp")!
    }
    
    var dbfFile: URL {
        shpFile.replacingPathExtension(with: "dbf")
    }
}
