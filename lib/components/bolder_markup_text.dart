import 'package:flutter/material.dart';
import 'package:todo_example/classes/utils.dart';

class BolderMarkupText extends StatefulWidget
{
  final String text;

  BolderMarkupText({Key key, this.text}): super(key: key);

  @override
  _BolderMarkupTextState createState() => _BolderMarkupTextState();
}

class _BolderMarkupTextState extends State<BolderMarkupText> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = new List<Widget>();
    RegExp regExp = new RegExp(r'\*[^\*]+\*', dotAll: true, multiLine: true);
    List<RegExpMatch> matches = regExp.allMatches(this.widget.text).toList();
    for(int i = 0; i < this.widget.text.length; i++) {
      if(matches.length > 0) {
        RegExpMatch actual = matches.first;
        if (i == actual.start) {
          widgets.add(Text(Utils.matchValue(actual), style: TextStyle(fontWeight: FontWeight.bold),));
          i += actual.end - actual.start - 1;
          matches.removeAt(0);
        } else {
          widgets.add(Text(this.widget.text.substring(i, actual.start)));
          i += actual.start - i - 1;
        }
      } else {
        widgets.add(Text(this.widget.text.substring(i)));
        break;
      }
    }

    return Row(children: widgets);
  }
}