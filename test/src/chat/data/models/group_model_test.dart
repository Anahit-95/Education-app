import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/chat/data/models/group_model.dart';
import 'package:educational_app/src/chat/domain/entities/group.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  final timestamp = Timestamp.fromDate(date);

  final tGroupModel = GroupModel.empty();
  final tMap = jsonDecode(fixture('group.json')) as DataMap;
  tMap['lastMessageTimestamp'] = timestamp;

  test('should be a subclass of [Course] entity', () {
    expect(tGroupModel, isA<Group>());
  });

  group('empty', () {
    test('should return a [CourseModel] with empty date', () {
      final result = GroupModel.empty();
      expect(result.name, '');
    });
  });

  group('fromMap', () {
    test(
      'should return a [GroupModel] with the correct data',
      () {
        final result = GroupModel.fromMap(tMap);
        expect(result, tGroupModel);
      },
    );
  });

  group('toMap', () {
    test('should return a [Map] with the proper data', () {
      final result = tGroupModel.toMap()..remove('lastMessageTimestamp');

      final map = DataMap.from(tMap)..remove('lastMessageTimestamp');
      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [GroupModel] with the new data', () {
      final result = tGroupModel.copyWith(name: 'New Name');
      expect(result.name, 'New Name');
    });
  });
}
