import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_example/classes/list_data.dart';

void main() {
  testWidgets('Serialize ToDo Data correctly', (WidgetTester tester) async {
    int createdAt =  DateTime.now().millisecondsSinceEpoch;
    ToDoData data = ToDoData.fromData(name: 'Dariel', checked: true, createdAt: createdAt);
    String encoded = jsonEncode(data);
    expect(encoded, '{"name":"Dariel","checked":true,"created_at":'+createdAt.toString()+'}');
  });

  testWidgets('Deserialize ToDo Data correctly', (WidgetTester tester) async {
    int createdAt =  DateTime.now().millisecondsSinceEpoch;
    String serializedData = '{"name":"Dariel","checked":true,"created_at":'+createdAt.toString()+'}';
    ToDoData data = ToDoData.fromJson(jsonDecode(serializedData));
    expect(data.name, 'Dariel');
    expect(data.checked, true);
    expect(data.createdAt, createdAt);
  });

  testWidgets('Serialize ToDo Data List correctly', (WidgetTester tester) async {
    ToDoDataList list = ToDoDataList();
    list.add(ToDoData.fromData(name: 'Testing', checked: true));
    list.add(ToDoData.fromData(name: 'Testing123', checked: false));
    String serialized = jsonEncode(list);
    expect(serialized, '{"list":"[{\\"name\\":\\"Testing\\",\\"checked\\":true,\\"created_at\\":null},{\\"name\\":\\"Testing123\\",\\"checked\\":false,\\"created_at\\":null}]"}');
  });
}