//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isdDisplayRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let rightBtnType: NavigationBtnType
    
    init(isDisplayLeftBtn: Bool = true,
         isdDisplayRightBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         rightBtnAction: @escaping () -> Void = {},
         rightBtnType: NavigationBtnType = .edit
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isdDisplayRightBtn = isdDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button {
                    leftBtnAction()
                } label: {
                    Image("leftArrow")
                }
            }
            
            Spacer()
            
            if isdDisplayRightBtn {
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
