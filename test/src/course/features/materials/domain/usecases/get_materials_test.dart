import 'package:dartz/dartz.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:educational_app/src/course/features/materials/domain/repos/material_repo.dart';
import 'package:educational_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'material_repo.mock.dart';

void main() {
  late MaterialRepo repo;
  late GetMaterials usecase;

  setUp(() {
    repo = MockMaterialRepo();
    usecase = GetMaterials(repo);
  });

  final tResource = Resource.empty();

  test('should call [MaterialRepo.getMaterials]', () async {
    when(
      () => repo.getMaterials(any()),
    ).thenAnswer((_) async => Right([tResource]));

    final result = await usecase('test_id');

    expect(result, isA<Right<dynamic, List<Resource>>>());

    verify(() => repo.getMaterials('test_id')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
