//
//  TodoStore.swift
//  SwiftUI_TodoExample
//
//  Created by higashi on 2020/03/05.
//  Copyright © 2020 jnphgs. All rights reserved.
//

import SwiftUI
import Combine

struct Todo: Identifiable {
    var id = UUID() // IdentifiableプロトコルはIDを持つ必要があります
    var title: String
    var completed: Bool
}

var testData: [Todo] = [
    Todo( title: "Do Something 1", completed: false),
    Todo( title: "Do Something 2", completed: false)
]
final class TodoStore: ObservableObject {
    // @Published をつけることで値が更新されたときに自動で通知し、依存するViewを更新できます
    @Published var todos: [Todo] = testData // 初期値にtestDataを渡していますが本来は必要ありません。
}
