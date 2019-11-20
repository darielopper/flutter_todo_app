import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils
{
  static matchValue(RegExpMatch match) => match.input.substring(match.start + 1, match.end - 1);

  static Future<bool> confirmDialog({
    BuildContext context,
    String title = 'Delete Task',
    String message = 'Are you sure do you want remove this Task?'
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, widget) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(message)
              ),
              actions: <Widget>[
                FlatButton(
                  key: Key('cancel_btn'),
                  child: Text('Cancel'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () { Navigator.of(context).pop(false); },
                ),
                FlatButton(
                  key: Key('confirm_btn'),
                  child: Text('Ok'),
                  onPressed: () { Navigator.of(context).pop(true); },
                ),
              ],
            ),
          ),
        );
      },
      pageBuilder: (contex, anim1, anim2) { }
    );
  }

  static Future<String> addEditDialog({String text = '', String title = 'Add New Task', BuildContext context}) async {
    TextEditingController _controller = TextEditingController(text: text);
    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, widget) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              title: Text(title, key: Key('add_dialog_title')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      key: Key('add_dialog_text_field'),
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Description'),
                      autofocus: true,
                      onSubmitted: (val) => Navigator.of(context).pop(val),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  key: Key('add_dialog_cancel_button'),
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _controller.clear();
                  }
                ),
                FlatButton(
                  key: Key('add_dialog_ok_button'),
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(_controller.text != null ? _controller.text : '');
                    _controller.clear();
                  }
                ),
              ],
            )
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {}
    );
  }

}