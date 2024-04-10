//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var path: Path
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayingLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightBtnTapeed()
                        },
                        rightBtnType: todoListViewModel.navigationRightBarBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
            
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
            
            AddTodoBtnView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "\(todoListViewModel.numOfRemovedTodos)개의 To do 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayingAlert
          ) {
              Button(role: .destructive) {
                  todoListViewModel.isRemoved()
              } label: {
                  Text("확인")
              }
              Button(role: .cancel) {
                  
              } label: {
                  Text("취소")
              }
          }
          .onChange(of: todoListViewModel.todos) { todos in
              homeViewModel.setTodosCount(todos.count)
          }
    }
}

// MARK: - ToDoList Title View
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do를\n추가해보세요!")
            } else {
                Text("\(todoListViewModel.todos.count)개의 To do가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList Announcement View
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            Text("\"매일 운동하기!\"")
            Text("\"내일 9시 수강신청\"")
            Text("\"내일 점심 약속\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}


// MARK: - TodoList Content View
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할 일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

// MARK: - Todo Cell View
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoved: Bool
    private var todo: Todo
    
    fileprivate init(isRemoved: Bool = false, todo: Todo) {
        _isRemoved = State(initialValue: isRemoved)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditing {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        todo.isSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.isSelected ? Color.customIconGray : Color.customBlack)
                        .strikethrough(todo.isSelected)
            
                    Text(todo.convertedDateAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditing {
                    Button {
                        isRemoved.toggle()
                        todoListViewModel.isCompleted(todo)
                    } label: {
                        isRemoved ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - add Todo Button
private struct AddTodoBtnView: View {
    @EnvironmentObject private var path: Path
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    path.paths.append(.todoView)
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(Path())
        .environmentObject(TodoListViewModel())
}
