part of 'raw_expandable_bottom_sheet.dart';

class ExpandableBottomSheetController extends AnimationController {
  // TODO: Include [onIsExtendedCallback] and [onIsContractedCallback].

  ExpandableBottomSheetController({
    required TickerProvider vsync,
    bool draggable = true,
    bool togglable = true,
  })  : _draggable = draggable,
        _togglable = togglable,
        super(
          vsync: vsync,
          lowerBound: _animationLowerBound,
          upperBound: _animationUpperBound,
        );

  static const _animationLowerBound = 0.0;
  static const _animationUpperBound = 1.0;

  // TODO: Make customizable.
  final Curve animationCurveContract = Curves.ease;
  final Curve animationCurveExpand = Curves.ease;
  final Duration animationDurationExtend = Duration(milliseconds: 250);
  final Duration animationDurationContract = Duration(milliseconds: 250);

  // TODO: Include method to set values appropiately.
  late final double _maxOffset;
  late final double _minOffset;

  double _animationMinOffset = 0;

  double _startOffsetAtDragDown = 0;
  double _startPositionAtDragDown = 0;

  late double _positionOffset;
  double get positionOffset => _positionOffset;
  set positionOffset(double value) {
    // TODO: Include range assertion.
    if (value == _positionOffset) return;

    _positionOffset = value;
    notifyListeners();
  }

  late double _draggableHeight;
  double get draggableHeight => _draggableHeight;
  set draggableHeight(double value) {
    if (value == _draggableHeight) return;

    _draggableHeight = value;
    notifyListeners();
  }

  late AnimationStatus _previousAnimationStatus;

  bool _togglable;
  bool get togglable => _togglable;
  set togglable(bool value) {
    if (value == _togglable) return;

    _togglable = value;
  }

  bool _draggable;
  bool get draggable => _draggable;
  set draggable(bool value) {
    if (value == _draggable) return;

    _draggable = value;
  }

  // TODO: Refactor method.
  void _animateOnIsAnimating() {
    if (isAnimating) {
      stop();
    }
  }

  ExpansionStatus get _expansionStatus {
    late ExpansionStatus expansionStatus;

    if (_positionOffset == null || _positionOffset == _maxOffset) {
      expansionStatus = ExpansionStatus.contracted;
    } else if (_positionOffset == _minOffset) {
      expansionStatus = ExpansionStatus.expanded;
    } else {
      expansionStatus = ExpansionStatus.middle;
    }

    return expansionStatus;
  }

  // TODO: Refactor method.
  // TODO: Add checks to avoid redundant calls.
  void init() {
    addStatusListener((status) => _onAnimationStatusUpdate(status));
  }

  void _onAnimationStatusUpdate(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;

    switch (_previousAnimationStatus) {
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.forward:
        _draggableHeight = _maxOffset - _minOffset;
        _positionOffset = _minOffset;
        break;
      case AnimationStatus.reverse:
        _draggableHeight = _maxOffset - _minOffset;
        _positionOffset = _maxOffset;
        break;
      case AnimationStatus.completed:
        break;
    }
  }

  void _animateToTop() {
    _animateOnIsAnimating();

    value = (_positionOffset - _minOffset) / _draggableHeight;
    _animationMinOffset = _minOffset;
    _previousAnimationStatus = AnimationStatus.forward;

    animateTo(
      _animationLowerBound,
      duration: animationDurationExtend,
      curve: animationCurveExpand,
    );
  }

  void expand() {
    // measure();
    _animateToTop();
  }

  void contract() {
    // measure();
    _animateToBottom();
  }

  void _animateToMin() {
    _animateOnIsAnimating();

    value = _animationUpperBound;
    _draggableHeight = _positionOffset - _minOffset;
    _animationMinOffset = _minOffset;
    _previousAnimationStatus = AnimationStatus.forward;

    animateTo(
      _animationLowerBound,
      duration: animationDurationContract,
      curve: animationCurveContract,
    );
  }

  void _animateToMax() {
    _animateOnIsAnimating();

    value = _animationUpperBound;

    _draggableHeight = _positionOffset - _maxOffset;
    _animationMinOffset = _maxOffset;
    _previousAnimationStatus = AnimationStatus.reverse;

    animateTo(
      _animationLowerBound,
      duration: animationDurationExtend,
      curve: animationCurveExpand,
    );
  }

  void _animateToBottom() {
    _animateOnIsAnimating();

    value = (_positionOffset - _minOffset) / _draggableHeight;

    _animationMinOffset = _minOffset;
    _previousAnimationStatus = AnimationStatus.reverse;

    animateTo(
      _animationUpperBound,
      duration: animationDurationContract,
      curve: animationCurveContract,
    );
  }

  void toggle() {
    if (!togglable) return;

    switch (_expansionStatus) {
      case ExpansionStatus.expanded:
        _animateToBottom();
        break;
      case ExpansionStatus.middle:
        break;
      case ExpansionStatus.contracted:
        _animateToBottom();
        break;
    }
  }

  // TODO: Refactor method.
  void _onPositionOutOfBounds() {
    final extendIsLargerThanContentHeight = _positionOffset < _minOffset;
    final extendIsSmallerThanPersistentContentHeight =
        _positionOffset > _maxOffset;

    if (extendIsLargerThanContentHeight) {
      _animateToMin();
    } else if (extendIsSmallerThanPersistentContentHeight) {
      _animateToMax();
    } else {
      _draggableHeight = _maxOffset - _minOffset;
    }
  }
}
