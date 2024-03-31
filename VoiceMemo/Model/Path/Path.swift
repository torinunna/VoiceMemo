//
//  Path.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import Foundation

class Path: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
