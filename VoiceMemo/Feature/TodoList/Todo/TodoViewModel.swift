//
//  TodoViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/1/24.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var date: Date
    @Published var isDisplayingCalendar: Bool
    
    init(title: String = "", time: Date = Date(), date: Date = Date(), isDisplayingCalendar: Bool = false) {
        self.title = title
        self.time = time
        self.date = date
        self.isDisplayingCalendar = isDisplayingCalendar
    }
}

extension TodoViewModel {
    func isDisplayingCalendar(_ isDisplaying: Bool) {
        isDisplayingCalendar = isDisplaying
    }
}
