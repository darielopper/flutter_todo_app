import 'package:flutter/material.dart';

class Utils
{
  static matchValue(RegExpMatch match) => match.input.substring(match.start + 1, match.end - 1);

  static Future<bool> confirmDialog({
    BuildContext context,
    String title = 'Delete Task',
    String message = 'Are you sure do you want remove this Task?'
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message)
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () { Navigator.of(context).pop(false); },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () { Navigator.of(context).pop(true); },
            ),
          ],
        );
      }
    );
  }
}