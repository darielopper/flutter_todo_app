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

  String name() => this._name;

  bool checked() => this._checked;
}

class ToDoDataList {
  List<ToDoData> _list;

  ToDoDataList() {
    _list = new List<ToDoData>();
  }

  add(ToDoData item) => _list.add(item);

  List<ToDoData> items() => this._list;

  setChecked(int index, bool value) => _list.elementAt(index).setChecked(value);

  isChecked(int index) => _list.elementAt(index).checked();

  remove(int index) => _list.removeAt(index);

  count() => _list.length;
}