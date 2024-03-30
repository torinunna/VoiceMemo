//
//  OnboardingViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/30/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onBoardingContent: [OnboardingContent]
    
    init(onBoardingContent: [OnboardingContent] = [
        .init(imageFileName: "onboarding_1", title: "오늘의 할 일", subTitle: "To do list로 해야할 일을 한 눈에"),
        .init(imageFileName: "onboarding_2", title: "똑똑한 나만의 기록장", subTitle: "언제든지 생각을 기록"),
        .init(imageFileName: "onboarding_3", title: "하나라도 놓치지 않도록", subTitle: "음성 메모 기능으로 놓치지 않게"),
        .init(imageFileName: "onboarding_4", title: "정확한 시간의 경과", subTitle: "타이머 기능으로 원하는 시간을 확인")
    ]
    ) {
        self.onBoardingContent = onBoardingContent
    }
}
