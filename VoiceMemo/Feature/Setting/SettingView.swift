//
//  SettingView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/10/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            TotalCountView()
            
            Spacer()
                .frame(height: 40)
            
            TotalTabMoveView()
            
            Spacer()
        }
    }
}

// MARK: - Title View
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - Total Count View
private struct TotalCountView: View {
    fileprivate var body: some View {
        HStack {
            Spacer()
            
            TabCountView(title: "To Do", count: 0)
            
            Spacer()
                .frame(width: 70)
            
            TabCountView(title: "메모", count: 3)
            
            Spacer()
                .frame(width: 70)
            
            TabCountView(title: "음성 메모", count: 2)
            
            Spacer()
        }
    }
}

// MARK: - Tab Count View
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(Color.customBlack)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.customBlack)
        }
    }
}

// MARK: - Total Tab Move View
private struct TotalTabMoveView: View {
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray1)
                .frame(height: 1)
            
            TabMoveView(title: "To Do") {
                print("to do")
            }
            
            TabMoveView(title: "Memo") {
                print("memo")
            }
            
            TabMoveView(title: "Voice Memo") {
                print("voice memo")
            }
            
            TabMoveView(title: "Setting") {
                print("setting")
            }
            
            Rectangle()
                .fill(Color.customGray1)
                .frame(height: 1)
        }
    }
}

// MARK: - Tab Move View
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(title: String, tabAction: @escaping () -> Void) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button {
            tabAction()
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.customBlack)
                
                Spacer()
                
                Image("arrowRight")
            }
        }
        .padding(20)
    }
}

#Preview {
    SettingView()
}
