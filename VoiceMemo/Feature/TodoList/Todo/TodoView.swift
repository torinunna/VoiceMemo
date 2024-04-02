//
//  TodoView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/1/24.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    path.paths.removeLast()
                },
                rightBtnAction: {
                    todoListViewModel.addTodo(
                        .init(title: todoViewModel.title, time: todoViewModel.time, date: todoViewModel.date, isSelected: false)
                    )
                    path.paths.removeAll()
                },
                rightBtnType: .create
            )
            
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            TimeInputView(todoViewModel: todoViewModel)
            
            DateInputView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
        }
    }
}

// MARK: - Title View
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("To do를 \n추가해 보세요.")
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - To do title View
private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요.", text: $todoViewModel.title)
    }
}

// MARK: - Time Input View
private struct TimeInputView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            DatePicker("", selection: $todoViewModel.time, displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - Date Input View
private struct DateInputView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("날짜")
                    .foregroundStyle(Color.customIconGray)
                
                Spacer()
            }
            
            HStack {
                Button {
                    todoViewModel.isDisplayingCalendar = true
                } label: {
                    Text("\(todoViewModel.date.formattedDate)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.customGreen)
                }
                .popover(isPresented: $todoViewModel.isDisplayingCalendar) {
                    DatePicker("", selection: $todoViewModel.date, displayedComponents: [.date])
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onChange(of: todoViewModel.date) { _ in
                            todoViewModel.isDisplayingCalendar(false)
                        }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TodoView()
}
