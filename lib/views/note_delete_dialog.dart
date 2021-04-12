import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  static const String id="/noteDelete";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("warning"),
      content: Text("Are you sure you want delete this note? "),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("yes")),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No")),
      ],
    );
  }
}
