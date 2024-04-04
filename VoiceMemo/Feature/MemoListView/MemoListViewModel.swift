//
//  MemoListViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/4/24.
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditing: Bool
    @Published var removedMemos: [Memo]
    @Published var isDisplayingAlert: Bool
    
    var numOfRemovedMemos: Int {
        return removedMemos.count
    }
    
    var navigationRightBarBtnMode: NavigationBtnType {
        isEditing ? .complete : .edit
    }
    
    init(memos: [Memo] = [], isEditing: Bool = false, removedMemos: [Memo] = [], isDisplayingAlert: Bool = false) {
        self.memos = memos
        self.isEditing = isEditing
        self.removedMemos = removedMemos
        self.isDisplayingAlert = isDisplayingAlert
    }
}

extension MemoListViewModel {
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    func deleteMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtntapped() {
        if isEditing {
            if removedMemos.isEmpty {
                isEditing = false
            } else {
                isCallingAlert(true)
            }
        } else {
            isEditing = true
        }
    }
    
    func isCallingAlert(_ isDisplaying: Bool) {
        isDisplayingAlert = isDisplaying
    }
    
    func isCompleted(_ memo: Memo) {
        if let index = removedMemos.firstIndex(of: memo) {
            removedMemos.remove(at: index)
        } else {
            removedMemos.append(memo)
        }
    }
    
    func isRemoved() {
        memos.removeAll { memo in
            removedMemos.contains(memo)
        }
        removedMemos.removeAll()
        isEditing = false
    }
}
