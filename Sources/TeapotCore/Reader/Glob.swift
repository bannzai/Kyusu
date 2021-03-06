//
//  Glob.swift
//  Commander
//
//  Created by Yudai.Hirose on 2019/06/12.
//

import Foundation
import Darwin

public struct Glob {
    private static let globFlags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
    
    public static func glob(pattern: String) -> [Path] {
        var gt = glob_t()
        let cPattern = strdup(pattern)
        defer {
            globfree(&gt)
            free(cPattern)
        }
        
        if Darwin.glob(cPattern, Glob.globFlags, nil, &gt) == 0 {
            let matchc = gt.gl_matchc
            return (0..<Int(matchc)).compactMap { index in
                String(validatingUTF8: gt.gl_pathv[index]!)
            }
        }
        
        // GLOB_NOMATCH
        return []
    }
}
