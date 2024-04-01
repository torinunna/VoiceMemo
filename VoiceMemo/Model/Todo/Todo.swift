//
//  Todo.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import Foundation

struct Todo: Hashable {
    var title: String
    var time: Date
    var date: Date
    var isSelected: Bool
    
    var convertedDateAndTime: String {
        String("\(date.formattedDate) - \(time.formattedTime)에 알림")
    }
}
