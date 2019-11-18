import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_example/components/app.dart';

void main() {
  const _key = 'data';

  MyApp app = new MyApp();

  Future setupPreference(String key, dynamic value, [bool preffixed = true]) async {
    final preffix = preffixed ? 'flutter.' : '';
    SharedPreferences.setMockInitialValues(<String, dynamic>{preffix+key: value});
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  testWidgets('Load empty list', (WidgetTester tester) async {
    await setupPreference(_key, null);
    final preference = await SharedPreferences.getInstance();
    expect(preference.getString(_key), null);
    await tester.pumpWidget(app);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Load a element from Shared Preference', (WidgetTester tester) async {
    await setupPreference(_key, '{"list":"[{\\"name\\":\\"Dariel\\",\\"checked\\":true,\\"created_at\\":null}]"}', false);
    await tester.pumpWidget(app);
    await tester.pump(Duration(seconds: 2));
    // Check that exist the element loaded from preferences
    expect(find.byType(ListTile), findsOneWidget);
    // Check that their text is the loaded correctly
    expect(find.text('Dariel'), findsOneWidget);
    // Check that checkbox status are checked
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
  });

  testWidgets('Load elements from Shared Preference', (WidgetTester tester) async {
    final date1 = DateTime.now().subtract(Duration(seconds: 10)).millisecondsSinceEpoch;
    final date2 = DateTime.now().millisecondsSinceEpoch;
    await setupPreference(_key, '{"list":"[{\\"name\\":\\"Dariel\\",\\"checked\\":true,\\"created_at\\":$date1},{\\"name\\":\\"Diana\\",\\"checked\\":false,\\"created_at\\":$date2}]"}', false);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    // Check that exist the elements loaded from preferences
    expect(find.byType(ListTile), findsNWidgets(2));
    // Check that their text is the loaded correctly
    expect(find.text('Dariel'), findsOneWidget);
    expect(find.text('Diana'), findsOneWidget);
    // Check that checkbox status are checked for first item
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, true);
    // Check that checkbox status are not checked for last item
    expect(tester.widget<Checkbox>(find.byType(Checkbox).last).value, false);
  });
}