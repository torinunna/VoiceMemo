//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/4/24.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}
