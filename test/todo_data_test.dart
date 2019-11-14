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
}