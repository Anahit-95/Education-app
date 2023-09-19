import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:educational_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:educational_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:educational_app/src/course/features/materials/presentation/cubit/material_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddMaterial extends Mock implements AddMaterial {}

class MockGetVideos extends Mock implements GetMaterials {}

void main() {
  late AddMaterial addMaterial;
  late GetMaterials getMaterials;
  late MaterialCubit materialCubit;

  final tMaterial = ResourceModel.empty();

  setUp(() {
    addMaterial = MockAddMaterial();
    getMaterials = MockGetVideos();
    materialCubit = MaterialCubit(
      addMaterial: addMaterial,
      getMaterials: getMaterials,
    );

    registerFallbackValue(tMaterial);
  });

  tearDown(() {
    materialCubit.close();
  });

  test('initial state should be [MaterialInitial]', () async {
    expect(materialCubit.state, const MaterialInitial());
  });

  group('addMaterial', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialsAdded] when addMaterial is called.',
      build: () {
        when(() => addMaterial(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterials([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterials(),
        MaterialsAdded(),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [AddingMaterials, MaterialError] when addMaterial is failed.',
      build: () {
        when(() => addMaterial(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.addMaterials([tMaterial]),
      expect: () => const <MaterialState>[
        AddingMaterials(),
        MaterialError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => addMaterial(tMaterial)).called(1);
        verifyNoMoreInteractions(addMaterial);
      },
    );
  });

  group('getVideos', () {
    blocTest<MaterialCubit, MaterialState>(
      'emits [LoadingMaterials, MaterialLoaded] when getMaterials is called',
      build: () {
        when(() => getMaterials(any())).thenAnswer(
          (_) async => Right([tMaterial]),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterials('courseId'),
      expect: () => <MaterialState>[
        const LoadingMaterials(),
        MaterialsLoaded([tMaterial]),
      ],
      verify: (_) {
        verify(() => getMaterials('courseId')).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );

    blocTest<MaterialCubit, MaterialState>(
      'emits [MaterialLoading, MaterialError] when getMaterials is called.',
      build: () {
        when(() => getMaterials(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return materialCubit;
      },
      act: (cubit) => cubit.getMaterials('courseId'),
      expect: () => const <MaterialState>[
        LoadingMaterials(),
        MaterialError('500 Error: Something went wrong'),
      ],
      verify: (_) {
        verify(() => getMaterials('courseId')).called(1);
        verifyNoMoreInteractions(getMaterials);
      },
    );
  });
}
