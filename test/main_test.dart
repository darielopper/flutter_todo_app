// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;

import 'package:todo_example/components/app.dart';

void checkEmptyList(WidgetTester tester) {
    expect(find.text('Simple ToDo'), findsOneWidget);
    expect(find.text('Dariel'), findsNothing);
}

void main() {
  MyApp app = new MyApp();

  testWidgets('Add a Task to List', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    // Add a new Task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Add New Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Dariel'), findsOneWidget);
  });

  testWidgets('Clear all for a empty List', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    // Tap on Clear All button
    await tester.tap(find.byIcon(Icons.clear_all));
    await tester.pump(Duration(seconds: 2));
    // Check that SnackBar is visible
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Empty List could not be cleared.'), findsOneWidget);
  });

  testWidgets('Check and Uncheck a Task', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    // Add new Task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Add New Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 1));
    expect(find.text('Dariel'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    // Check that initially checkbox are not checked
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
    // Checked the checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump(Duration(seconds: 1));
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    // Check that percent works correctly
    expect(find.text('100%'), findsOneWidget);
    // Check that done / total relation works correctly
    expect(find.text(' 1 of 1 ('), findsWidgets);
    // Unchecked checkbox
    await tester.tap(find.byType(ListTile));
    await tester.pump(Duration(seconds: 1));
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
    // Check percent works
    expect(find.text('0%'), findsOneWidget);
    // Check done / total relation was updated
    expect(find.text(' 0 of 1 ('), findsOneWidget);
  });

  testWidgets('Edit a Task', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    // Add new Task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Add New Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 1));
    expect(find.text('Dariel'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    // Edit it
    await tester.longPress(find.byType(ListTile));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Edit Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Diana');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 2));
    // Check edited value exist on List
    expect(find.text('Diana'), findsOneWidget);
    // Try edit again but not finish operation
    await tester.longPress(find.byType(ListTile));
    await tester.pump(Duration(seconds: 2));
    // Check that TextField has correct data
    expect(find.text('Diana'), findsNWidgets(2));
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    // Cancel edition
    await tester.tap(find.byKey(Key('add_dialog_cancel_button')));
    await tester.pump(Duration(seconds: 2));
    // Check that old value not changed
    expect(find.text('Dariel'), findsNothing);
    // Check that old value remains
    expect(find.text('Diana'), findsOneWidget);
  });

  testWidgets('Search a Task', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    // Add new Task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Add New Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 1));
    expect(find.text('Dariel'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    // Check search btn are visible
    expect(find.byIcon(Icons.search), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    // Check that search field are visible
    expect(find.byKey(Key('search_field')), findsOneWidget);
    tester.testTextInput.enterText('Algo');
    await tester.pump();
    // Check that message with no data information are visible
    expect(find.text('Sorry, not match found!'), findsOneWidget);
    // And no item are show
    expect(find.byType(ListTile), findsNothing);
    // Filter again for a value that exists
    tester.testTextInput.enterText('da');
    await tester.pump();
    // Check that filtered results has values
    expect(find.byType(ListTile), findsOneWidget);
    tester.testTextInput.enterText('das');
    await tester.pump();
    expect(find.byType(ListTile), findsNothing);
    // Close search
    await tester.tap(find.byKey(Key('close_btn')));
    await tester.pump();
    // Check that search field are not visible
    expect(find.byKey(Key('search_field')), findsNothing);
  });

  testWidgets('Remove a Task', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    // Add new Task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(Duration(seconds: 2));
    expect(find.text('Add New Task'), findsOneWidget);
    find.byKey(Key('add_dialog_input_field'));
    tester.testTextInput.enterText('Dariel');
    await tester.tap(find.byKey(Key('add_dialog_ok_button')));
    await tester.pump(Duration(seconds: 1));
    expect(find.text('Dariel'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    // Click on delete button
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(Duration(seconds: 2));
    // Check that confirmation dialog are open
    expect(find.text('Delete Task'), findsOneWidget);
    // Cancel operation
    await tester.tap(find.byKey(Key('cancel_btn')));
    await tester.pump(Duration(seconds: 2));
    // Check that item still remain on list
    expect(find.byType(ListTile), findsOneWidget);
     // Click on delete button again
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(Duration(seconds: 2));
    // Click on ok button
    await tester.tap(find.byKey(Key('confirm_btn')));
    await tester.pump(Duration(seconds: 2));
    // Check that list are empty
    expect(find.byType(ListTile), findsNothing);
    // Check that counter are correct
    expect(find.text(' 0 of 0 ('), findsOneWidget);
    // Check that percent data are correct
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('Clear All Task', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    var names = ['Dariel', 'Baby'];
    for (var name in names) {
      // Add new Task
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(Duration(seconds: 2));
      expect(find.text('Add New Task'), findsOneWidget);
      find.byKey(Key('add_dialog_input_field'));
      tester.testTextInput.enterText(name);
      await tester.tap(find.byKey(Key('add_dialog_ok_button')));
      await tester.pump(Duration(seconds: 1));
      expect(find.text(name), findsOneWidget);
    }
    // Check that two items new are created
    expect(find.byType(ListTile), findsNWidgets(2));
    // Click on Delete All button
    await tester.tap(find.byKey(Key('clear_all_btn')));
    await tester.pump(Duration(seconds: 2));
    // Check that confirm dialog are open
    expect(find.text('Clear All'), findsOneWidget);
    // Click on ok button
    await tester.tap(find.byKey(Key('confirm_btn')));
    await tester.pump(Duration(seconds: 2));
    // Check that list is empty now
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Sort operation', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    var items = ['B', 'C', 'A'];
    // Add new Tasks
    for (var item in items) {
      // Add new Task
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(Duration(seconds: 2));
      expect(find.text('Add New Task'), findsOneWidget);
      find.byKey(Key('add_dialog_input_field'));
      tester.testTextInput.enterText(item);
      await tester.tap(find.byKey(Key('add_dialog_ok_button')));
      await tester.pump(Duration(seconds: 1));
      expect(find.text(item), findsOneWidget);
    }
    // Check that all items are created
    expect(find.byType(ListTile), findsNWidgets(3));
    // Check that initial mode are NOT_SORT
    expect(find.byIcon(Icons.sort), findsOneWidget);
    // Check that B are the first element
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('B')), findsOneWidget);
    await tester.tap(find.byIcon(Icons.sort));
    await tester.pump();
    // Check icon change
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    // Check that order was changed
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('B')), findsNothing);
    // Check that A item is the first now, because in ascending order
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('A')), findsOneWidget);
    // Change sort order again
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    // Check icon change
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    // Check that C is the first now because is in descending order
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('C')), findsOneWidget);
    // Check that A is the last now
    expect(find.descendant(of: find.byType(ListTile).last, matching: find.text('A')), findsOneWidget);
    // Click on sort button to disable sorting
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pump();
    // Check disabled sort on button order are correct
    expect(find.byIcon(Icons.sort), findsOneWidget);
    // Check that B is the first item again because natural order was stablished
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('B')), findsOneWidget);
  });

  testWidgets('Search a Task checked and uncheked items in filter mode', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    checkEmptyList(tester);
    var names = ['Dariel', 'Baby'];
    for (var name in names) {
      // Add new Task
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(Duration(seconds: 2));
      expect(find.text('Add New Task'), findsOneWidget);
      find.byKey(Key('add_dialog_input_field'));
      tester.testTextInput.enterText(name);
      await tester.tap(find.byKey(Key('add_dialog_ok_button')));
      await tester.pump(Duration(seconds: 1));
      expect(find.text(name), findsOneWidget);
    }
    // Check that two items new are created
    expect(find.byType(ListTile), findsNWidgets(2));
    // Check search btn are visible
    expect(find.byIcon(Icons.search), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    // Check that search field are visible
    expect(find.byKey(Key('search_field')), findsOneWidget);
    // Checked item before search
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    // Filter again for a value that exists
    tester.testTextInput.enterText('da');
    await tester.pump();
    // Check that filtered results has values
    expect(find.byType(ListTile), findsOneWidget);
    // Check that after filtered the same items checked before are now checked
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value , true);
    // Unchecked checkbox on filter mode
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    // Click on Close btn to exit filter mode
    await tester.tap(find.byKey(Key('close_btn')));
    await tester.pump();
    // Check that original items are visible again
    expect(find.byType(ListTile), findsNWidgets(2));
    // Check that first checkbox changed value from filter mode
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value , false);
    // Check that first item is the original
    expect(find.descendant(of: find.byType(ListTile).first, matching: find.text('Dariel')) , findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    // Check that criteria are empty when search operation launch again
    expect(tester.widget<TextField>(find.byKey(Key('search_field'))).controller, null);
    find.byKey(Key('search_field'));
    // Filter by the second item that are unchecked
    tester.testTextInput.enterText('ba');
    await tester.pump();
    // Check that item are unchecked
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value,  false);
    expect(find.byType(Checkbox), findsOneWidget);
    // Checked checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    // Verify that checkbox are cheked now
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value , true);
    // Check that item filtered results are correct
    expect(find.text('Baby'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    // Exit search mode
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
    // Check all items are visible again
    expect(find.byType(ListTile), findsNWidgets(2));
    // Check that checkbox for Baby item still are checked
    expect(tester.widget<Checkbox>(
      find.descendant(
        of: find.ancestor(of: find.text('Baby'), matching: find.byType(ListTile)),
        matching: find.byType(Checkbox))
      ).value, true);
  });

}
