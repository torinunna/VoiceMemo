//
//  OnboardingView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/30/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var path = Path()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        NavigationStack(path: $path.paths) {
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
           TimerView()
                .navigationDestination(for: PathType.self) { pathType in
                    switch pathType {
                    case .homeView:
                        Text("Home")
                            .navigationBarBackButtonHidden()
                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                    case let .memoView(isCreating, memo):
                        MemoView(
                            memoViewModel: isCreating
                            ? .init(memo: .init(title: "", content: "", date: .now))
                            : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                            isCreating: isCreating
                        )
                        .navigationBarBackButtonHidden()
                        .environmentObject(memoListViewModel)
                    }
                }
        }
        .environmentObject(path)
    }
}

// MARK: - Onboarding Content View
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            StartButtonView()
        }
        .ignoresSafeArea()
    }
}

// MARK: - Onboarding Cell List View
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(onboardingViewModel: OnboardingViewModel, selectedIndex: Int = 0) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onBoardingContent.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0
            ? Color.customSky
            : Color.customBackgroundGreen
        )
        .clipped()
    }
}

// MARK: - Onboarding Cell View
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .clipShape(RoundedRectangle(cornerRadius: 0))
        }
        .shadow(radius: 10)
    }
}

// MARK: - Start Button View
private struct StartButtonView: View {
    @EnvironmentObject private var path: Path
    
    fileprivate var body: some View {
        Button {
            path.paths.append(.homeView)
        } label: {
            Text("시작하기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.customGreen)
            
            Image("startHome")
                .renderingMode(.template)
                .foregroundStyle(Color.customGreen)
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingView()
}
