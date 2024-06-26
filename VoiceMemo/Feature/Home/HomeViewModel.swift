//
//  HomeViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/10/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceMemosCount: Int
    
    init(selectedTab: Tab = .voiceMemo, todosCount: Int = 0, memosCount: Int = 0, voiceMemosCount: Int = 0) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceMemosCount = voiceMemosCount
    }
}

extension HomeViewModel {
    func setTodosCount(_ count: Int) {
        todosCount = count
    }
    
    func setMemosCount(_ count: Int) {
        memosCount = count
    }
    func setVoiceMemosCount(_ count: Int) {
        voiceMemosCount = count
    }
    
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
