import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/course/features/materials/data/datasoursces/material_remote_data_src.dart';
import 'package:educational_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:educational_app/src/course/features/materials/data/repos/material_repo_impl.dart';
import 'package:educational_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMaterialRemoteDataSrc extends Mock implements MaterialRemoteDataSrc {}

void main() {
  late MaterialRemoteDataSrc remoteDataSrc;
  late MaterialRepoImpl repoImpl;

  final tResource = ResourceModel.empty();

  setUp(() {
    remoteDataSrc = MockMaterialRemoteDataSrc();
    repoImpl = MaterialRepoImpl(remoteDataSrc);
    registerFallbackValue(tResource);
  });

  const tException = ServerException(
    message: 'message',
    statusCode: 'statusCode',
  );

  group('addMaterial', () {
    test(
        'should complete successfully when call to remote source is '
        'successfull', () async {
      when(
        () => remoteDataSrc.addMaterial(any()),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.addMaterial(tResource);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => remoteDataSrc.addMaterial(tResource)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessfull', () async {
      when(
        () => remoteDataSrc.addMaterial(any()),
      ).thenThrow(tException);

      final result = await repoImpl.addMaterial(tResource);

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDataSrc.addMaterial(tResource)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getMaterials', () {
    test(
      'should return [List<Material>] when call to remote source '
      'is successfull',
      () async {
        when(
          () => remoteDataSrc.getMaterials(any()),
        ).thenAnswer((_) async => [tResource]);

        final result = await repoImpl.getMaterials('courseId');

        expect(result, isA<Right<dynamic, List<Resource>>>());

        verify(() => remoteDataSrc.getMaterials('courseId')).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessfull', () async {
      when(
        () => remoteDataSrc.getMaterials(any()),
      ).thenThrow(tException);

      final result = await repoImpl.getMaterials('courseId');

      expect(
        result,
        equals(
          Left<ServerFailure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDataSrc.getMaterials('courseId')).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
