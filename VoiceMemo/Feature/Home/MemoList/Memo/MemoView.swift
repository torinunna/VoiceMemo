//
//  MemoView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/4/24.
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel: MemoViewModel
    @State var isCreating: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    leftBtnAction: {
                        path.paths.removeLast()
                    },
                    rightBtnAction: {
                        if isCreating {
                            memoListViewModel.addMemo(memoViewModel.memo)
                        } else {
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                        path.paths.removeLast()
                    },
                    rightBtnType: isCreating ? .create : .complete
                    )
                
                TitleInputView(memoViewModel: memoViewModel, isCreating: $isCreating)
                
                ContentInputView(memoViewModel: memoViewModel)
            }
            
            if !isCreating {
                DeleteMemoButtonView(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Title Input View
private struct TitleInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreating: Bool
    
    fileprivate init(memoViewModel: MemoViewModel, isCreating: Binding<Bool>) {
        self.memoViewModel = memoViewModel
        self._isCreating = isCreating
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $memoViewModel.memo.title)
            .font(.system(size: 30))
            .padding(.horizontal, 20)
            .focused($isTitleFieldFocused)
            .onAppear {
                if isCreating {
                    isTitleFieldFocused = true
                }
            }
    }
}

// MARK: - Content Input View
private struct ContentInputView: View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.customGray1)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Delete Memo Button View
private struct DeleteMemoButtonView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    memoListViewModel.deleteMemo(memoViewModel.memo)
                    path.paths.removeLast()
                } label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
    }
}

#Preview {
    MemoView(memoViewModel: .init(memo: .init(title: "", content: "", date: Date())))
}
