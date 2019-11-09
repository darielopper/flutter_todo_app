import 'package:flutter/material.dart';
import 'package:todo_example/bolder_markup_text.dart';
import 'list_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple ToDo',
      debugShowCheckedModeBanner: false, // Not show debug banner
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal),
      home: MyHomePage(title: 'Simple ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ToDoDataList _list = new ToDoDataList();

  void addTask() {
    this._neverSatisfied().then((value) {
      setState(() {
        _list.add(new ToDoData(value));
      });
    });
  }

  Future<String> _neverSatisfied() async {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Description'),
                  autofocus: true,
                  onSubmitted: (val) => Navigator.of(context).pop(val),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  void removeTask(int index) {
    _list.remove(index);
    setState(() => {});
  }

  _updateCheckBox(bool value, int index) {
    setState(() {
      _list.setChecked(index, value);
    });
  }

  get dones => _list.dones();

  get percent => _list.percent();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: BolderMarkupText(text: '*Done:* ${_list.dones} of ${_list.count} (*${_list.percent}%*)')),
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {},
                tooltip: 'Remove All',
              ),
            ],
          )),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.65,
        //color: Colors.brown,
        child: ListView.builder(
          itemBuilder: (context, index) => ListTile(
              title: Text(_list.items()[index].name()),
              leading: Checkbox(
                  value: _list.isChecked(index),
                  onChanged: (val) => this._updateCheckBox(val, index)),
              trailing: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white,
                    child: SizedBox(
                        height: 45, width: 45, child: Icon(Icons.delete)),
                    onTap: () {
                      removeTask(index);
                    },
                  ),
                ),
              )),
          itemCount: _list.count,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        tooltip: 'Add New',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
