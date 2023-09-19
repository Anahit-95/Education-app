import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educational_app/core/utils/typedef.dart';
import 'package:educational_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

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

  final tResourceModel = ResourceModel.empty();

  final tMap = jsonDecode(fixture('resource.json')) as DataMap;

  tMap['uploadDate'] = timestamp;

  test('should be a subclass of [Resource] entity', () {
    expect(tResourceModel, isA<Resource>());
  });

  group('fromMap', () {
    test(
      'should return [ResourceModel] with the correct data',
      () {
        final result = ResourceModel.fromMap(tMap);
        expect(result, equals(tResourceModel));
      },
    );
  });

  group('toMap', () {
    test('should return a [Map] with proper data', () {
      final result = tResourceModel.toMap()..remove('uploadDate');

      final map = DataMap.from(tMap)..remove('uploadDate');
      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [ResourceModel] with the new data', () {
      final result = tResourceModel.copyWith(author: 'New Author');
      expect(result.author, 'New Author');
    });
  });
}
