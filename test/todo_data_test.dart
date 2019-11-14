import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_example/classes/list_data.dart';

void main() {
  test('Serialize ToDo Data correctly', () async {
    int createdAt =  DateTime.now().millisecondsSinceEpoch;
    ToDoData data = ToDoData.fromData(name: 'Dariel', checked: true, createdAt: createdAt);
    String encoded = jsonEncode(data);
    expect(encoded, '{"name":"Dariel","checked":true,"created_at":'+createdAt.toString()+'}');
  });

  test('Deserialize ToDo Data correctly', () async {
    int createdAt =  DateTime.now().millisecondsSinceEpoch;
    String serializedData = '{"name":"Dariel","checked":true,"created_at":'+createdAt.toString()+'}';
    ToDoData data = ToDoData.fromJson(jsonDecode(serializedData));
    expect(data.name, 'Dariel');
    expect(data.checked, true);
    expect(data.createdAt, createdAt);
  });

  test('Serialize ToDo Data List correctly', () async {
    ToDoDataList list = ToDoDataList();
    list.add(ToDoData.fromData(name: 'Testing', checked: true));
    list.add(ToDoData.fromData(name: 'Testing123', checked: false));
    String serialized = jsonEncode(list);
    expect(serialized, '{"list":"[{\\"name\\":\\"Testing\\",\\"checked\\":true,\\"created_at\\":null},{\\"name\\":\\"Testing123\\",\\"checked\\":false,\\"created_at\\":null}]"}');
  });

  test('Deserialize ToDo Data List correctly', () async {
    final encoded = '{"list":"[{\\"name\\":\\"Testing\\",\\"checked\\":true,\\"created_at\\":null},{\\"name\\":\\"Testing123\\",\\"checked\\":false,\\"created_at\\":null}]"}';
    ToDoDataList list = ToDoDataList.fromJson(jsonDecode(encoded));
    expect(list.count, 2);
    expect(list.items().first.compareTo(
      ToDoData('Testing')
      .. createdAt = null
      .. checked = true
      ), true);
    expect(list.items().last.compareTo(
      ToDoData('Testing123')
      .. createdAt = null
      .. checked = false
      ), true);
  });
}