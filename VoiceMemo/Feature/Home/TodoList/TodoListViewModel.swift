//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/31/24.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditing: Bool
    @Published var removedTodos: [Todo]
    @Published var isDisplayingAlert: Bool
    
    var numOfRemovedTodos: Int {
        return removedTodos.count
    }
    
    var navigationRightBarBtnMode: NavigationBtnType {
        isEditing ? .complete : .edit
    }
    
    init(todos: [Todo] = [], isEditing: Bool = false, removedTodos: [Todo] = [], isDisplayingAlert: Bool = false) {
        self.todos = todos
        self.isEditing = isEditing
        self.removedTodos = removedTodos
        self.isDisplayingAlert = isDisplayingAlert
    }
}

extension TodoListViewModel {
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].isSelected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func navigationRightBtnTapeed() {
        if isEditing {
            if removedTodos.isEmpty {
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
    
    func isCompleted(_ todo: Todo) {
        if let index = removedTodos.firstIndex(of: todo) {
            removedTodos.remove(at: index)
        } else {
            removedTodos.append(todo)
        }
    }
    
    func isRemoved() {
        todos.removeAll { todo in
            removedTodos.contains(todo)
        }
        removedTodos.removeAll()
        isEditing = false
    }
}
