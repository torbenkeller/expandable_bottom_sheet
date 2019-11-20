import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExampleEasy());

class ExampleEasy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ExpandableBottmSheet'),
        ),
        body: ExpandableBottomSheet(
          background: Container(
            color: Colors.red,
            child: Center(
              child: Text('Background'),
            ),
          ),
          persistentHeader: Container(
            height: 40,
            color: Colors.blue,
            child: Center(
              child: Text('Header'),
            ),
          ),
          expandableContent: Container(
            height: 500,
            color: Colors.green,
            child: Center(
              child: Text('Content'),
            ),
          ),
        ),
      ),
    );
  }
}
