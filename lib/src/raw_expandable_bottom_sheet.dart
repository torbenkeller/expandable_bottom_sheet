import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO: Consider imports instead of parts.
part 'expandable_bottom_sheet_controller.dart';
part 'expandable_bottom_sheet_drag_handler.dart';
part 'expansion_status.dart';

/// [ExpandableBottomSheet] is a BottomSheet with a draggable height like the
/// Google Maps App on Android.
///
/// __Example:__
///
/// ```dart
/// ExpandableBottomSheet(
///   background: Container(
///     color: Colors.red,
///     child: Center(
///       child: Text('Background'),
///     ),
///   ),
///   persistentHeader: Container(
///     height: 40,
///     color: Colors.blue,
///     child: Center(
///       child: Text('Header'),
///     ),
///   ),
///   expandableContent: Container(
///     height: 500,
///     color: Colors.green,
///     child: Center(
///       child: Text('Content'),
///     ),
///   ),
/// );
/// ```
class ExpandableBottomSheet extends StatefulWidget {
  /// Creates the [ExpandableBottomSheet].
  ///
  /// [persistentContentHeight] has to be greater 0.
  const ExpandableBottomSheet({
    Key? key,
    required this.expandableContent,
    required this.background,
    this.persistentHeader,
    this.persistentFooter,
    this.persistentContentHeight = 0.0,
    this.controller,
  })  : assert(persistentContentHeight >= 0),
        super(key: key);

  /// [expandableContent] is the widget which you can hide and show by dragging.
  /// It has to be a widget with a constant height. It is required for the [ExpandableBottomSheet].
  final Widget expandableContent;

  /// [background] is the widget behind the [expandableContent] which holds
  /// usually the content of your page. It is required for the [ExpandableBottomSheet].
  final Widget background;

  /// [persistentHeader] is a Widget which is on top of the [expandableContent]
  /// and will never be hidden. It is made for a widget which indicates the
  /// user he can expand the content by dragging.
  final Widget? persistentHeader;

  /// [persistentFooter] is a widget which is always shown at the bottom. The [expandableContent]
  /// is if it is expanded on top of it so you don't need margin to see all of
  /// your content. You can use it for example for navigation or a menu.
  final Widget? persistentFooter;

  /// [persistentContentHeight] is the height of the content which will never
  /// been contracted. It only relates to [expandableContent]. [persistentHeader]
  /// and [persistentFooter] will not be affected by this.
  final double persistentContentHeight;

  // Use to control the [ExpandableBottomSheet].
  final ExpandableBottomSheetController? controller;

  @override
  ExpandableBottomSheetState createState() => ExpandableBottomSheetState();
}

class ExpandableBottomSheetState extends State<ExpandableBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'contentKey');
  final GlobalKey _headerKey = GlobalKey(debugLabel: 'headerKey');
  final GlobalKey _footerKey = GlobalKey(debugLabel: 'footerKey');

  late ExpandableBottomSheetController _controller;
  late ExpandableBottomSheetDragHandler _dragHandler;

  @override
  void initState() {
    super.initState();

    _controller = ExpandableBottomSheetController(
      vsync: this,
    )..init();

    _dragHandler = ExpandableBottomSheetDragHandler(
      controller: _controller,
    );

    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _measure(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _checkPositionOutOfBounds(),
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: widget.background,
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, Widget? child) {
                  // TODO: Refactor this conditional statement.
                  if (_controller.isAnimating) {
                    _controller._positionOffset =
                        _controller._animationMinOffset +
                            _controller.value * _controller._draggableHeight;
                  }

                  return Positioned(
                    top: _controller._positionOffset,
                    right: 0.0,
                    left: 0.0,
                    child: child!,
                  );
                },
                child: GestureDetector(
                  onTap: _controller.toggle,
                  onVerticalDragDown: _dragHandler._dragDown,
                  onVerticalDragUpdate: _dragHandler._dragUpdate,
                  onVerticalDragEnd: _dragHandler._dragEnd,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        key: _headerKey,
                        child:
                            widget.persistentHeader ?? const SizedBox.shrink(),
                      ),
                      Container(
                        key: _contentKey,
                        child: widget.expandableContent,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          key: _footerKey,
          child: widget.persistentFooter ?? const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _measure() {
    double headerHeight = _headerKey.currentContext!.size!.height;
    double footerHeight = _footerKey.currentContext!.size!.height;
    double contentHeight = _contentKey.currentContext!.size!.height;

    double checkedPersistentContentHeight =
        (widget.persistentContentHeight < contentHeight)
            ? widget.persistentContentHeight
            : contentHeight;

    _controller._minOffset =
        context.size!.height - headerHeight - contentHeight - footerHeight;
    _controller._maxOffset = context.size!.height -
        headerHeight -
        footerHeight -
        checkedPersistentContentHeight;

    _controller._positionOffset = _controller._maxOffset;
    _controller._draggableHeight =
        _controller._maxOffset - _controller._minOffset;
  }

  void _checkPositionOutOfBounds() {
    _measure(); // TODO: Why do we require to measure?
    _controller._onPositionOutOfBounds();
  }
}
