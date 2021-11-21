import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExampleExpert(),
    );
  }
}

class ExampleExpert extends StatefulWidget {
  @override
  _ExampleExpertState createState() => _ExampleExpertState();
}

class _ExampleExpertState extends State<ExampleExpert> {
  final ExpandableBottomSheetController _controller =
      ExpandableBottomSheetController();

  int _contentAmount = 0;
  ExpansionStatus _expansionStatus = ExpansionStatus.contracted;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_expansionStatus.toString()),
        ),
        body: ExpandableBottomSheet(
          controller: _controller,

          //optional
          //callbacks (use it for example for an animation in your header)
          onIsContractedCallback: () => print('contracted'),
          onIsExtendedCallback: () => print('extended'),

          //optional; default: Duration(milliseconds: 250)
          //The durations of the animations.
          animationDurationExtend: Duration(milliseconds: 500),
          animationDurationContract: Duration(milliseconds: 250),

          //optional; default: Curves.ease
          //The curves of the animations.
          animationCurveExpand: Curves.bounceOut,
          animationCurveContract: Curves.ease,

          //optional
          //The content extend will be at least this height. If the content
          //height is smaller than the persistentContentHeight it will be
          //animated on a height change.
          //You can use it for example if you have no header.
          persistentContentHeight: 220,

          //required
          //This is the widget which will be overlapped by the bottom sheet.
          background: Container(
            color: Colors.blue[800],
          ),

          //optional
          //This widget is sticking above the content and will never be contracted.
          persistentHeader: Container(
            color: Colors.orange,
            constraints: BoxConstraints.expand(height: 40),
            child: Center(
              child: Container(
                height: 8.0,
                width: 50.0,
                color: Color.fromARGB((0.25 * 255).round(), 0, 0, 0),
              ),
            ),
          ),

          //required
          //This is the content of the bottom sheet which will be extendable by dragging.
          expandableContent: Container(
            constraints: BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < _contentAmount; i++)
                    Container(
                      height: 50,
                      color: Colors.red[((i % 8) + 1) * 100],
                    ),
                ],
              ),
            ),
          ),

          // optional
          // This will enable tap to toggle option on header.
          enableToggle: true,

          //optional
          //This is a widget aligned to the bottom of the screen and stays there.
          //You can use this for example for navigation.
          persistentFooter: Container(
            color: Colors.green,
            height: 100,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() {
                    _contentAmount++;
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () => setState(() {
                    _controller.expand();
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.cloud),
                  onPressed: () => setState(() {
                    _expansionStatus = _controller.expansionStatus;
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () => setState(() {
                    _controller.contract();
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() {
                    if (_contentAmount > 0) _contentAmount--;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
