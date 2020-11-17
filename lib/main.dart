import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todoList = [];
  int listIndex;

//  int intIndex = int.parse(listIndex);

  //リストのindexを取得するのに詰まってる
  //indexを引数で取得しようとするとエラる
  deleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("タスクを削除しますか？"),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text("はい"),
                isDestructiveAction: true,
                onPressed: () {
                  setState(() {
                    todoList.removeAt(listIndex);
                    Navigator.pop(context);
                  });
                }),
            CupertinoDialogAction(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
    return;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODOリスト"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.edit),
                    padding: new EdgeInsets.all(15.0),
                    onPressed: () async {
                      final newListText = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return TodoEditPage();
                        }),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: deleteDialog,
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// リスト追加画面用Widget
class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("タスク追加"),
          ),
          body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_text, style: TextStyle(color: Colors.lightBlueAccent)),
                TextFormField(
                  onChanged: (String value) {
                    setState(() {
                      _text = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'タスク名を入力してください',
                    labelText: 'タスク名',
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      Navigator.of(context).pop(_text);
                    },
                    child: Text('タスク追加', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

//タスク編集
class TodoEditPage extends StatefulWidget {
  @override
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
   String editText = '';
   text(String text) {
    editText = text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("タスク編集"),
          ),
          body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(editText, style: TextStyle(color: Colors.pinkAccent)),
                TextFormField(
                  initialValue: editText,
                  onChanged: (String value) {
                    setState(() {
                      editText = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'タスク名を入力してください',
                    labelText: 'タスク名',
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.pinkAccent,
                    onPressed: () {
                      Navigator.of(context).pop(editText);
                    },
                    child: Text('タスク編集', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('キャンセル'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
