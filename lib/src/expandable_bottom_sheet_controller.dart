part of 'raw_expandable_bottom_sheet.dart';

/// Allows controlling the state of [ExpandableBottomSheet].
class ExpandableBottomSheetController {
  late final ExpandableBottomSheetState _state;

  /// Hooks the [ExpandableBottomSheetController] to the [ExpandableBottomSheet].
  void _setState(ExpandableBottomSheetState state) {
    _state = state;
  }

  // Checks if the [ExpandableBottomSheet] can be dragged.
  bool get draggable {
    return _state._draggable;
  }

  // Allows dragging the content of the [ExpandableBottomSheet].
  set draggable(bool value) {
    _state._draggable = value;
  }

  // Animates the [ExpandableContent] to the full height.
  void expand() {
    _state._expand();
  }

  // Animates the [ExpandableContent] to zero height.
  void contract() {
    _state._contract();
  }

  // Checks the current expansion state of the [ExpandableBottomSheet].
  ExpansionStatus get expansionStatus {
    return _state._expansionStatus;
  }

  // Checks if the [ExpandableBottomSheet] is expanded.
  bool get isExpanded {
    return expansionStatus == ExpansionStatus.expanded;
  }

  // Checks if the [ExpandableBottomSheet] is collapsed.
  bool get isContracted {
    return expansionStatus == ExpansionStatus.contracted;
  }
}
