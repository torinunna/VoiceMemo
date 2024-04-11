//
//  AddMemoButton.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/11/24.
//

import SwiftUI

// MARK: - 1
public struct AddMemoButton: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 2
extension View {
    public func addMemoButton(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 3
public struct AddButtonView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(@ViewBuilder content: () -> Content, action: @escaping () -> Void) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        action()
                    } label: {
                        Image("writeBtn")
                    }
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}
