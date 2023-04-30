//
//  URL.swift
//  
//
//  Created by Greg Whatley on 4/29/23.
//

import Foundation

extension URL {
    @inlinable func replacingPathExtension(with pathExtension: String) -> URL {
        deletingPathExtension().appendingPathExtension(pathExtension)
    }
}
