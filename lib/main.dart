import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'list_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.teal
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  bool _checked = false;
  TextEditingController _controller = new TextEditingController();
  ToDoDataList _list = new ToDoDataList();

  void addTask() {
    setState(() {
      int count = _list.count() + 1;
      _list.add(new ToDoData('Task: $count'));
    });
  }

  _showDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Add a new Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'eg New Task')
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    ));
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(itemBuilder: (context, index) => ListTile(
            title: Text(_list.items()[index].name()),
            leading: Checkbox(value: _list.isChecked(index),
              onChanged: (val) => this._updateCheckBox(val, index)
            ),
            trailing: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white,
                  child: SizedBox(height: 45, width: 45, child: Icon(Icons.delete)),
                  onTap: (){ removeTask(index); },
                ),
              ),
            )
          ),
          itemCount: _list.count(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
