//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayingLeftBtn: Bool
    let isDisplayingRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let rightBtnType: NavigationBtnType
    
    init(isDisplayingLeftBtn: Bool = true,
         isdDisplayingRightBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         rightBtnAction: @escaping () -> Void = {},
         rightBtnType: NavigationBtnType = .edit
    ) {
        self.isDisplayingLeftBtn = isDisplayingLeftBtn
        self.isDisplayingRightBtn = isdDisplayingRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack {
            if isDisplayingLeftBtn {
                Button {
                    leftBtnAction()
                } label: {
                    Image("leftArrow")
                }
            }
            
            Spacer()
            
            if isDisplayingRightBtn {
                Button {
                    rightBtnAction()
                } label: {
                    if rightBtnType == .close {
                        Image("close")
                    } else {
                        Text(rightBtnType.rawValue)
                            .foregroundStyle(Color.customBlack)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

#Preview {
    CustomNavigationBar()
}
