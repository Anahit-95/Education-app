import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/exceptions.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:educational_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:educational_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test(
    'should be a subclass of [OnBoardinRepo]',
    () {
      expect(repoImpl, isA<OnBoardingRepo>());
    },
  );

  group('cacheFirstTimer', () {
    test(
      'should complete successfully when call to local source is successfull',
      () async {
        when(
          () => localDataSource.cacheFirstTimer(),
        ).thenAnswer((_) async => Future.value());

        final result = await repoImpl.cacheFirstTimer();

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => localDataSource.cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should return [CacheFailure] when call to local source is '
      'unsuccessful',
      () async {
        when(
          () => localDataSource.cacheFirstTimer(),
        ).thenThrow(
          const CacheException(
            message: 'Insufficient storage',
          ),
        );

        final result = await repoImpl.cacheFirstTimer();

        expect(
          result,
          equals(
            Left<CacheFailure, dynamic>(
              CacheFailure(
                message: 'Insufficient storage',
                statusCode: 500,
              ),
            ),
          ),
        );

        verify(
          () => localDataSource.cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'should return true when user is first timer',
      () async {
        when(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => Future.value(true));

        final result = await repoImpl.checkIfUserIsFirstTimer();

        expect(result, equals(const Right<dynamic, bool>(true)));

        verify(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should return false when user is not first timer',
      () async {
        when(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => Future.value(false));

        final result = await repoImpl.checkIfUserIsFirstTimer();

        expect(result, equals(const Right<dynamic, bool>(false)));

        verify(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'should return [CacheFailure] when call to local source '
      'is unsuccessful',
      () async {
        when(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).thenThrow(
          const CacheException(
            message: 'Insufficient storage',
            statusCode: 403,
          ),
        );

        final result = await repoImpl.checkIfUserIsFirstTimer();

        expect(
          result,
          equals(
            Left<CacheFailure, dynamic>(
              CacheFailure(
                message: 'Insufficient storage',
                statusCode: 403,
              ),
            ),
          ),
        );

        verify(
          () => localDataSource.checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );
  });
}
