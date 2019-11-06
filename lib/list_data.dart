class ToDoData {
  String _name;
  bool _checked;

  ToDoData(this._name) {
    this._checked = false;
  }

  ToDoData setName(String name) {
    this._name = name;
    return this;
  }

  ToDoData setChecked(bool value) {
    this._checked = value;
    return this;
  }

  String Name() => this._name;

  bool Checked() => this._checked;
}

class TodoDataList {
  List<ToDoData> _list;

  TodoDataList() {
    _list = new List<ToDoData>();
  }
}