import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:todo_example/components/bolder_markup_text.dart';
import 'package:todo_example/classes/utils.dart';
import 'package:todo_example/classes/list_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Get Methods
  get isSorting => sortMode != NOT_SORT;
  get sortAsc => sortMode == SORT_ASCENDING;
  get sortDesc => sortMode == SORT_DESCENDING;
  get sortModes => [SORT_ASCENDING, SORT_DESCENDING, NOT_SORT];
  get sortIcons => [Icons.arrow_upward, Icons.arrow_downward, Icons.sort];
  get headerActionIcon => Icon(this._searching ? Icons.search : Icons.clear);
  get notMatchFound => this._criteria.length > 0 && this._searching && filterResults.length == 0;
  get showList => filterResults.length > 0;

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
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return result;
  }
  /// End Get Methods

  /// Methods
  void addTask() {
    Utils.addEditDialog(context: context).then((value) {
      if(value == null) return;
      setState(() {
        _list.add(new ToDoData(value));
      });
    });
  }

  void update(int index) {
    Utils.addEditDialog(
      text: filterResults[index].name,
      title: 'Edit Task',
      context: context
    ).then((value) {
      if (value == null) return;
      setState(() {
        _list.update(filterResults[index].key, value);
      });
    });
  }

  void nextMode() {
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

  void search(String filter) {
    setState(() {
      this._criteria = filter;
    });
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

  void removeAll() {
    if (_list.count == 0) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.info_outline),
            Padding(padding: EdgeInsets.only(left: 5), child: Text('Empty List could not be cleared.', style: TextStyle(fontWeight: FontWeight.bold)))
          ],
        ),
        duration: Duration(seconds: 7),
        action: SnackBarAction(
          key: Key('close_snackbar'),
          label: 'CLOSE',
          textColor: Colors.white,
          onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
        ),
      ));

      return;
    }

    Utils.confirmDialog(
      title: 'Clear All',
      message: 'Are you sure you want to remove all Tasks?',
      context: context
    ).then((val) => val ? setState(() { _list.clear(); }) : false);
  }

  void _updateCheckBox(bool value, int index) {
    setState(() {
      _list.setCheckedByKey(filterResults[index].key, value);
    });
  }

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
                key: Key('search_field'),
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
          Visibility(key: Key('search_btn'), child: IconButton(icon: Icon(Icons.search), onPressed: activeSearch, tooltip: 'Search',), visible: !_searching),
          Visibility(key: Key('close_btn'), child: IconButton(icon: Icon(Icons.clear), onPressed: deactiveSearch, tooltip: 'Cancel Search',), visible: _searching),
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
                key: Key('clear_all_btn'),
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

  _read() async {
    final preferences = await SharedPreferences.getInstance();
    _list = ToDoDataList.fromJson(jsonDecode(preferences.getString('data') ?? '{"list": []}'));
  }

  @override
  void initState() {
    super.initState();
    _read();
  }
}
