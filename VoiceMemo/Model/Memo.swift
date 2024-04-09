//
//  Memo.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/4/24.
//

import Foundation

struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID()
    
    var convertedDate: String {
        String("\(date.formattedDate) - \(date.formattedTime)")
    }
}
