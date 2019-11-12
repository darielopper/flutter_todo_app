import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_example/components/bolder_markup_text.dart';

void main()
{
  testWidgets('not create extra Text if not found bolder signs', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: 'testing a text')))));
    // Check that bolder markup text component exist
    expect(find.byType(BolderMarkupText), findsOneWidget);
    // Check that only 1 Text component
    expect(find.byType(Text), findsOneWidget);
    // Check that text widget created has not style
    expect(tester.widget<Text>(find.byType(Text)).style, null);
    expect(tester.widget<Text>(find.byType(Text)).data, 'testing a texts');
  });

  testWidgets('create only a Text widget when found 1 bolder sign', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '*testing a text*')))));
    // Check that only 1 Text component
    expect(find.byType(Text), findsOneWidget);
    // Check that Text widget created is bolder
    expect(tester.widget<Text>(find.byType(Text)).style.fontWeight, FontWeight.bold);
    expect(tester.widget<Text>(find.byType(Text)).data, 'testing a text');
  });

  testWidgets('create correctly styled Text with leading bolder style', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '*testing* a text')))));
    // Check that 2 Text widget created correctly
    expect(find.byType(Text), findsNWidgets(2));
    // Check that first Text ('testing') has bolder style
    expect(tester.widget<Text>(find.byType(Text).first).style.fontWeight, FontWeight.bold);
    expect(tester.widget<Text>(find.byType(Text).first).data, 'testing');
    // Check that last Text (' a text') has not style
    expect(tester.widget<Text>(find.byType(Text).last).style, null);
    expect(tester.widget<Text>(find.byType(Text).last).data, ' a text');
  });

  testWidgets('create correctly styled Text with trailing bolder style', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: 'testing a *text*')))));
    // Check that 2 Text widget created correctly
    expect(find.byType(Text), findsNWidgets(2));
    // Check that first Text (' a text') has not style
    expect(tester.widget<Text>(find.byType(Text).first).style, null);
    expect(tester.widget<Text>(find.byType(Text).first).data, 'testing a ');
    // Check that last Text ('testing') has bolder style
    expect(tester.widget<Text>(find.byType(Text).last).style.fontWeight, FontWeight.bold);
    expect(tester.widget<Text>(find.byType(Text).last).data, 'text');
  });

  testWidgets('create correctly styled Text with multiples bolder style', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '*testing* a *simple* text')))));
    // Check that 2 Text widget created correctly
    expect(find.byType(Text), findsNWidgets(4));
    // Check that was stylized correctly Text widgets
    expect(tester.widget<Text>(find.byType(Text).first).style.fontWeight, FontWeight.bold);
    expect(tester.widget<Text>(find.byType(Text).first).data, 'testing');
    expect(tester.widget<Text>(find.byType(Text).at(1)).style, null);
    expect(tester.widget<Text>(find.byType(Text).at(1)).data, ' a ');
    expect(tester.widget<Text>(find.byType(Text).at(2)).style.fontWeight, FontWeight.bold);
    expect(tester.widget<Text>(find.byType(Text).at(2)).data, 'simple');
    expect(tester.widget<Text>(find.byType(Text).last).style, null);
    expect(tester.widget<Text>(find.byType(Text).last).data, ' text');
  });

  testWidgets('not set style if not found pattern', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '*testing')))));
    // Check that Text created was not formated because not match with bolder sign pattern
    expect(find.text('*testing'), findsOneWidget);
  });

  testWidgets('not set style if bolder sign not enclose some words', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '**testing')))));
    // Check that Text created was not formated because not match with bolder sign pattern (leading)
    expect(find.text('**testing'), findsOneWidget);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: 'testing**')))));
    // Check that Text created was not formated because not match with bolder sign pattern (trailing)
    expect(find.text('testing**'), findsOneWidget);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: 'test**ing')))));
    // Check that Text created was not formated because not match with bolder sign pattern (in middle)
    expect(find.text('test**ing'), findsOneWidget);
  });

  testWidgets('respect character intersection with multiple bolder signs', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '*T*e*S*t*')))));
    // Check that impar bolder sign is present on Text creation
    expect(find.text('t*'), findsOneWidget);
    // Check that Text that correspond to 'T' char has bolder style
    expect(tester.widget<Text>(find.text('T').first).style.fontWeight, FontWeight.bold);
    // Check that Text that correspond to 'e' char has not been stylized
    expect(tester.widget<Text>(find.text('e').first).style, null);
    // Check that Text that correspond to 'S' char has bolder style
    expect(tester.widget<Text>(find.text('S').first).style.fontWeight, FontWeight.bold);
    // Check that Text that correspond to 't*' substr has not been stylized
    expect(tester.widget<Text>(find.byType(Text).last).style, null);
  });

  testWidgets('keep extra bolder sign when find pattern', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '**test**')))));
    // Expect that was created correctly Text widgets
    expect(find.byType(Text), findsNWidgets(3));
    // Extra bolder sign not processed to format in a new stylized Text
    expect(find.text('*'), findsNWidgets(2));
    // Check that 'test' part has been stylized correctly
    expect(tester.widget<Text>(find.text('test')).style.fontWeight, FontWeight.bold);
  });

  testWidgets('not create Text widget if not text was provided', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '')))));
    // Check that bolder markup text widget was created correcly
    expect(find.byType(BolderMarkupText), findsOneWidget);
    // Check that not exist Text widget because any matches was found to be processed
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('not create stylized Text if not exist words between patterns', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container(child: BolderMarkupText(text: '********')))));
    // Check that bolder markup text widget was created correcly
    expect(find.byType(BolderMarkupText), findsOneWidget);
    // Check that not create Text widget stylized because any matches was found to be processed
    expect(find.byType(Text), findsOneWidget);
    expect(find.text('********'), findsOneWidget);
  });
}