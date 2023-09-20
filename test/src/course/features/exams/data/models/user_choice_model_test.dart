import 'dart:convert';

import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/exams/data/models/user_choice_model.dart';
import 'package:educational_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  const tUserChoiceModel = UserChoiceModel.empty();

  group('UserChoiceModel', () {
    test('should be a subclass of [UserChoice] entity', () async {
      expect(tUserChoiceModel, isA<UserChoice>());
    });

    final map = jsonDecode(fixture('user_choice.json')) as DataMap;

    group('fromMap', () {
      test(
          'should return a valid [UserChoiceModel] when the JSON '
          'is not null', () {
        final result = UserChoiceModel.fromMap(map);
        expect(result, tUserChoiceModel);
      });
    });

    group('toMap', () {
      test('should return a Dart map containing the proper data', () {
        final result = tUserChoiceModel.toMap();
        expect(result, map);
      });
    });

    group('copyWith', () {
      test('should return a new [UserChoiceModel] with the same values', () {
        final result = tUserChoiceModel.copyWith(questionId: '');
        expect(result.questionId, equals(''));
      });
    });
  });
}
