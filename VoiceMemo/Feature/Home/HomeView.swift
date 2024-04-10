//
//  HomeView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var path: Path
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $homeViewModel.selectedTab) {
             TodoListView()
                    .tabItem {
                        Image(homeViewModel.selectedTab == .todo ? "todoIcon_selected" : "todoIcon")
                    }
                    .tag(Tab.todo)
                
                MemoListView()
                       .tabItem {
                           Image(homeViewModel.selectedTab == .memo ? "memoIcon_selected" : "memoIcon")
                       }
                       .tag(Tab.memo)
                
                VoiceMemoView()
                       .tabItem {
                           Image(homeViewModel.selectedTab == .voiceMemo ? "recordIcon_selected" : "recordIcon")
                       }
                       .tag(Tab.voiceMemo)
                
                TimerView()
                       .tabItem {
                           Image(homeViewModel.selectedTab == .timer ? "timerIcon_selected" : "timerIcon")
                       }
                       .tag(Tab.timer)
                
                SettingView()
                       .tabItem {
                           Image(homeViewModel.selectedTab == .setting ? "settingIcon_selected" : "settingIcon")
                       }
                       .tag(Tab.setting)
            }
        }
    }
}

// MARK: - Separator View
private struct SeperatorLineView: View {
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      Rectangle()
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(height: 10)
        .padding(.bottom, 60)
    }
  }
}

#Preview {
    HomeView()
        .environmentObject(Path())
        .environmentObject(TodoListViewModel())
        .environmentObject(MemoListViewModel())
}
