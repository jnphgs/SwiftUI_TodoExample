//
//  ContentView.swift
//  SwiftUI_TodoExample
//
//  Created by higashi on 2020/03/05.
//  Copyright © 2020 jnphgs. All rights reserved.
//

import SwiftUI

struct Todo: Identifiable {
    var id = UUID() // IdentifiableプロトコルはIDを持つ必要があります
    var title: String
    var completed: Bool
}

var testData: [Todo] = [
    Todo( title: "Do Something 1", completed: false),
    Todo( title: "Do Something 2", completed: false)
]

struct ContentView: View {
    // プロパティはViewから変更することができません。
    // @StateをつけることでView内で変更した値を保持し、変更を通知することで依存するビューを更新できます。
    @State var todos: [Todo] = testData
    @State private var newTodo: String = "" // 新しく追加するTodoのテキストを保持します
    
    var body: some View {
        NavigationView {
            List {
                Section { // Sectionでリストのアイテムをグループ化してます
                    TextField("Do Something", text: self.$newTodo)
                    Button("Add Item", action: self.addTodo) // Buttonが押された時にaddTodoを呼び出します。
                }
                
                Section{ // Sectionでリストのアイテムをグループ化してます
                    ForEach(todos){ todo in
                        // Todo要素です。子Viewにしてもいいかもしれません。
                        HStack {
                            // Todoの左にあるチェックボックスはイメージで表示しています。
                            // systemNameで指定できるアイコンはSF Symbols.app(https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)をダウンロードすると一覧できます。
                            Image(systemName: todo.completed ? "checkmark.square" : "square")
                                .onTapGesture {
                                    // 配列からidが一致するもののインデックスを取得します。
                                    // 要素にアクセスするのにもっといい方法がありそうだけどとりあえず愚直に全要素比較します。
                                    let id = self.todos.firstIndex { (t) -> Bool in
                                        return t.id == todo.id
                                    }
                                    // toggle()はSwiftのBoolの標準的な機能で論理反転します
                                    self.todos[id!].completed.toggle()
                                    
                                }
                            
                            Text(todo.title)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle()) // リストのアイテムをグループ化して表示します。
            .navigationBarTitle("Todos")
        }
    }

    func addTodo(){
        self.todos.append(Todo(title: newTodo, completed: false)) // 配列に新しい要素を追加します
        newTodo = "" // テキストフィールドをクリアします。
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
