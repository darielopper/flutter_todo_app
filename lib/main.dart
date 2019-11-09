import 'dart:collection';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:todo_example/bolder_markup_text.dart';
import 'package:todo_example/utils.dart';
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
  static const SORT_ASCENDING = 'asc';
  static const SORT_DESCENDING = 'desc';
  static const NOT_SORT = 'none';

  ToDoDataList _list = new ToDoDataList();
  bool _searching = false;
  String sortMode = NOT_SORT;
  IconData sortIcon = Icons.sort;
  String _criteria = "";


  void addTask() {
    this._showAddDialog().then((value) {
      if(value == null) return;
      setState(() {
        _list.add(new ToDoData(value));
      });
    });
  }

  void update(int index) {
    this._showAddDialog(
      text: filterResults[index].name,
      title: 'Edit Task'
    ).then((value) {
      if (value == null) return;
      setState(() {
        _list.update(filterResults[index].key, value);
      });
    });
  }

  get isSorting => sortMode != NOT_SORT;
  get sortAsc => sortMode == SORT_ASCENDING;
  get sortDesc => sortMode == SORT_DESCENDING;
  get sortModes => [SORT_ASCENDING, SORT_DESCENDING, NOT_SORT];
  get sortIcons => [Icons.arrow_upward, Icons.arrow_downward, Icons.sort];

  nextMode() {
    int actualIndex = sortModes.indexOf(this.sortMode);
    if(actualIndex++ < sortModes.length - 1) {
       setState(() {
         this.sortMode = sortModes[actualIndex];
         this.sortIcon = sortIcons[actualIndex];
       });
    } else {
      setState(() {
        this.sortMode = sortModes[0];
        this.sortIcon = sortIcons[0];
      });
    }
  }


  get filterResults {
    List<ToDoData> result = _criteria.length == 0
      ? _list.items()
      : _list.items().where((item) => item.name.toLowerCase().indexOf(_criteria.toLowerCase()) >= 0).toList();

    switch(sortMode) {
      case SORT_ASCENDING:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SORT_DESCENDING:
        result.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      default:
        result.sort((a, b) => a.created_at.compareTo(b.created_at));
        break;
    }

    return result;
  }

  void search(String filter) {
    setState(() {
      this._criteria = filter;
    });
  }

  get headerActionIcon => Icon(this._searching ? Icons.search : Icons.clear);

  Future<String> _showAddDialog({String text = '', String title = 'Add New Task'}) async {
    TextEditingController _controller = TextEditingController(text: text);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
                Navigator.of(context).pop(_controller.text != null ? _controller.text : '');
              },
            ),
          ],
        );
      },
    );
  }

  void removeTask(int index) {
    Utils.confirmDialog(context: context).then((val) {
      if (val) {
        setState(() {
          _list.remove(filterResults[index].key);
        });
      }
    });
  }

  void activeSearch() {
    setState(() {
      this._searching = true;
    });
  }

  void deactiveSearch() {
    setState(() {
      this._searching = false;
      this._criteria = "";
    });
  }

  removeAll() {
    Utils.confirmDialog(
      title: 'Clear All',
      message: 'Are you sure you want to remove all Tasks?',
      context: context
    ).then((val) => val ? setState(() { _list.clear(); }) : false);
  }

  _updateCheckBox(bool value, int index) {
    setState(() {
      _list.setChecked(index, value);
    });
  }

  get notMatchFound => this._criteria.length > 0 && this._searching && filterResults.length == 0;
  get showList => filterResults.length > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(child: Text(widget.title), visible: !_searching),
            Visibility(
              child: TextField(
                cursorColor: Colors.white,
                autofocus: true,
                autocorrect: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search text',
                  hintStyle: TextStyle(color: Colors.white)
                ),
                onChanged: (val) => search(val),
              ),
              visible: _searching
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(sortIcon), onPressed: nextMode),
          Visibility(child: IconButton(icon: Icon(Icons.search), onPressed: activeSearch, tooltip: 'Search',), visible: !_searching),
          Visibility(child: IconButton(icon: Icon(Icons.clear), onPressed: deactiveSearch, tooltip: 'Cancel Search',), visible: _searching),
        ],
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
                onPressed: removeAll,
                tooltip: 'Remove All',
              ),
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.info, color: Colors.orangeAccent, size: 40),
                      Text('Sorry, not match found!', style: TextStyle(fontSize: 16),)
                    ],
                  )
                )
              ]
            ),
            visible: notMatchFound
          ),
          Visibility(child: Expanded(
            child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                      title: Text(filterResults[index].name),
                      leading: Checkbox(
                          value: _list.isCheckedByKey(filterResults[index].key),
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
                      ),
                      onTap: () => setState((){
                        _list.toggleCheckedByKey(filterResults[index].key);
                      }),
                      onLongPress: () => update(index),
                    ),
                  itemCount: filterResults.length,
                ),
          ), visible: showList)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        tooltip: 'Add New',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
