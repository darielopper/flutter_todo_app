import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToDoData {
  String _name;
  bool _checked;
  Key _key;
  int _createdAt;

  ToDoData(this._name) {
    this._checked = false;
    this._key = UniqueKey();
    this._createdAt = DateTime.now().millisecondsSinceEpoch;
  }

  ToDoData.fromData({String name, bool checked, int createdAt}) {
    this._checked = checked;
    this._key = UniqueKey();
    this._name = name;
    this._createdAt = createdAt;
  }

  ToDoData setName(String name) {
    this._name = name;
    return this;
  }

  ToDoData setChecked(bool value) {
    this._checked = value;
    return this;
  }

  Map<String, dynamic> toJson() => {
    'name': _name,
    'checked': _checked,
    'created_at': _createdAt
  };

  static ToDoData fromJson(Map<String, dynamic> data) => ToDoData.fromData(name: data['name'], checked: data['checked'] as bool, createdAt: data['created_at'] as int);

  get name => this._name;

  get checked => this._checked;

  get key => this._key;

  get createdAt => this._createdAt;
}

class ToDoDataList {
  List<ToDoData> _list;

  ToDoDataList() {
    _list = new List<ToDoData>();
  }

  add(ToDoData item) => _list.add(item);

  List<ToDoData> items() => this._list;

  setChecked(int index, bool value) => _list.elementAt(index).setChecked(value);

  setCheckedByKey(Key key, bool value) {
    ToDoData actual = _list.singleWhere((item) => item.key.hashCode == key.hashCode);
    actual.setChecked(value);
  }

  isChecked(int index) => _list.elementAt(index).checked;

  isCheckedByKey(Key key) => _list.any((item) => item.key.hashCode == key.hashCode && item.checked);

  removeAt(int index) => _list.removeAt(index);

  remove(Key key) => _list.removeWhere((item) => item.key.hashCode == key.hashCode);

  toggleChecked(int index) => _list.elementAt(index).setChecked(!_list.elementAt(index).checked);

  toggleCheckedByKey(Key key) {
    ToDoData actual = _list.singleWhere((item) => item.key.hashCode == key.hashCode);
    actual.setChecked(!actual.checked);
  }

  update(Key key, String value) {
    ToDoData actual = _list.singleWhere((item) => item.key.hashCode == key.hashCode);
    actual.setName(value);
  }

  clear() => _list.clear();

  get dones => _list.where((item) => item.checked).length;

  get count => _list.length;

  get percent {
    num result = _list.length > 0 ? (this.dones / _list.length * 100) : 0;
    return result.toStringAsFixed(0);
  }
}