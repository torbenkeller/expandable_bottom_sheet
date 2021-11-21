import 'dart:core';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$ExpandableBottomSheetController', () {
    group('setState', () {
      test('throws error when unatacched', () {
        final controller = ExpandableBottomSheetController();

        expect(() => controller.draggable, throwsA(isInstanceOf<Error>()));
        expect(
            () => controller.draggable = false, throwsA(isInstanceOf<Error>()));
        expect(() => controller.expand(), throwsA(isInstanceOf<Error>()));
        expect(() => controller.contract(), throwsA(isInstanceOf<Error>()));
        expect(() => controller.isExpanded, throwsA(isInstanceOf<Error>()));
        expect(() => controller.isContracted, throwsA(isInstanceOf<Error>()));
      });
    });
  });
}
