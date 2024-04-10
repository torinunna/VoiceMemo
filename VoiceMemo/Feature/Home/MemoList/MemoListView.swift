//
//  MemoListView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/4/24.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayingLeftBtn: false,
                        rightBtnAction: {
                            memoListViewModel.navigationRightBtntapped()
                        },
                        rightBtnType: memoListViewModel.navigationRightBarBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if memoListViewModel.memos.isEmpty {
                    AnnouncementView()
                } else {
                    MemoListContentView()
                        .padding(.top, 20)
                }
            }
            
            AddMemoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "\(memoListViewModel.numOfRemovedMemos)개의 메모를 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayingAlert
          ) {
              Button(role: .destructive) {
                  memoListViewModel.isRemoved()
              } label: {
                  Text("확인")
              }
              Button(role: .cancel) {
                  
              } label: {
                  Text("취소")
              }
          }
    }
}

// MARK: - Title View
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해보세요!")
            } else {
                Text("\(memoListViewModel.memos.count)개의 메모가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - MemoList Annoucement View
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            Text("\"퇴근 9시간 전 메모\"")
            Text("\"코드 리뷰하고 퇴근\"")
            Text("\"밀린 알고리즘 공부\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - MemoContent View
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

// MARK: - Memo Cell View
private struct MemoCellView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoved: Bool
    private var memo: Memo
    
    fileprivate init(isRemoved: Bool = false, memo: Memo) {
        _isRemoved = State(initialValue: isRemoved)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button {
            path.paths.append(.memoView(isCreating: false, memo: memo))
        } label: {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.customBlack)
                        
                        Text(memo.convertedDate)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.customIconGray)
                    }
                    
                    Spacer()
                    
                    if memoListViewModel.isEditing {
                        Button {
                            isRemoved.toggle()
                            memoListViewModel.isCompleted(memo)
                        } label: {
                            isRemoved ? Image("selectedBox") : Image("unSelectedBox")
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - Add Memo Button
private struct AddMemoBtnView: View {
    @EnvironmentObject private var path: Path
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    path.paths.append(.memoView(isCreating: true, memo: nil))
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    MemoListView()
        .environmentObject(Path())
        .environmentObject(MemoListViewModel())
}
