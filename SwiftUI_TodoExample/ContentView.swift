//
//  ContentView.swift
//  SwiftUI_TodoExample
//
//  Created by higashi on 2020/03/05.
//  Copyright © 2020 jnphgs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // View自体は表示とUI処理に専念させるためTodoのリストは ObserbableObject に準拠した TodoStore として
    // TodoStore.swift 内に定義します
    @EnvironmentObject var store: TodoStore
    @State private var newTodo: String = "" // 新しく追加するTodoのテキストを保持します
    
    var body: some View {
        NavigationView {
            List {
                Section { // Sectionでリストのアイテムをグループ化してます
                    TextField("Do Something", text: self.$newTodo)
                    Button("Add Item", action: self.addTodo) // Buttonが押された時にaddTodoを呼び出します。
                }
                
                Section{ // Sectionでリストのアイテムをグループ化してます
                    ForEach(store.todos){ todo in
                        // Todo要素です。子Viewにしてもいいかもしれません。
                        HStack {
                            // Todoの左にあるチェックボックスはイメージで表示しています。
                            // systemNameで指定できるアイコンはSF Symbols.app(https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)をダウンロードすると一覧できます。
                            Image(systemName: todo.completed ? "checkmark.square" : "square")
                                .onTapGesture {
                                    // 配列からidが一致するもののインデックスを取得します。
                                    // 要素にアクセスするのにもっといい方法がありそうだけどとりあえず愚直に全要素比較します。
                                    let id = self.store.todos.firstIndex { (t) -> Bool in
                                        return t.id == todo.id
                                    }
                                    // toggle()はSwiftのBoolの標準的な機能で論理反転します
                                    self.store.todos[id!].completed.toggle()
                                    
                                }
                            
                            Text(todo.title)
                        }
                    }
                    .onDelete(perform: delete) // UI上で削除するとself.delete(at offsets: IndexSet)が呼び出されるようになります。
                    .onMove(perform: move) // UI上で並べ替えするとself.move(from source: IndexSet, to destination: Int)がよびだされるようになります
                }
            }
            .listStyle(GroupedListStyle()) // リストのアイテムをグループ化して表示します。
            .navigationBarItems(trailing: EditButton()) //　並べ替えのためにEditButtonを表示します。
            .navigationBarTitle("Todos")
        }
    }

    func addTodo(){
        self.store.todos.append(Todo(title: newTodo, completed: false)) // 配列に新しい要素を追加します
        newTodo = "" // テキストフィールドをクリアします。
    }
    
    func delete(at offsets: IndexSet){
        self.store.todos.remove(atOffsets: offsets) // 配列から要素を削除します
    }
    
    func move(from source: IndexSet, to destination: Int){
        self.store.todos.move(fromOffsets: source, toOffset: destination) // 配列の要素を並べ替えます
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TodoStore())
    }
}
