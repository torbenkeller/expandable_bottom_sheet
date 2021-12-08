part of 'raw_expandable_bottom_sheet.dart';

// TODO: Implement.
class ExpandableBottomSheetDragHandler {
  const ExpandableBottomSheetDragHandler({
    required this.controller,
  });

  final ExpandableBottomSheetController controller;

  void _dragDown(DragDownDetails details) {
    if (!controller.draggable) return;

    if (!controller.isAnimating) {
      _startOffsetAtDragDown = details.localPosition.dy;
      _startPositionAtDragDown = _positionOffset;
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (!controller.draggable) return;

    if (!_useDrag) return;
    double offset = details.localPosition.dy;
    double newOffset =
        _startPositionAtDragDown! + offset - _startOffsetAtDragDown;
    if (_minOffset <= newOffset && _maxOffset >= newOffset) {
      setState(() {
        _positionOffset = newOffset;
      });
    } else {
      if (_minOffset > newOffset) {
        setState(() {
          _positionOffset = _minOffset;
        });
      }
      if (_maxOffset < newOffset) {
        setState(() {
          _positionOffset = _maxOffset;
        });
      }
    }
  }

  void _dragEnd(DragEndDetails details) {
    if (!controller.draggable) return;

    if (_startPositionAtDragDown == _positionOffset || !_useDrag) return;

    final velocity = details.primaryVelocity!;
    const highSpeed = 250;
    final draggedUpwardsWithHighVelocity = velocity < -highSpeed;
    final draggedDownwardsWithHighVelocity = velocity > highSpeed;

    if (draggedUpwardsWithHighVelocity) {
      _animateToTop();
    } else 
      if (draggedDownwardsWithHighVelocity) {
        _animateToBottom();
      } else {
        if (_positionOffset == _maxOffset &&
            widget.onIsContractedCallback != null) {
          widget.onIsContractedCallback!();
        }
        if (_positionOffset == _minOffset &&
            widget.onIsExtendedCallback != null) {
          widget.onIsExtendedCallback!();
        }
      }
    }
  }
}
