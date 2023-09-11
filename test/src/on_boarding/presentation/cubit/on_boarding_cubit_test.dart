import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:educational_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:educational_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });
  tearDown(() => cubit.close());

  final tCacheFailure = CacheFailure(
    message: 'Insufficient Permissions',
    statusCode: 403,
  );

  test(
    'initial state should be [OnBoardingInitial]',
    () {
      expect(cubit.state, const OnBoardingInitial());
    },
  );

  group(
    'cacheFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTimer, UserCached] when successfull.',
        build: () => cubit,
        setUp: () {
          when(
            () => cacheFirstTimer(),
          ).thenAnswer((_) async => const Right(null));
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => const [
          CachingFirstTimer(),
          UserCached(),
        ],
        verify: (bloc) {
          verify(
            () => cacheFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTimer, OnBoardingError] when failed.',
        build: () => cubit,
        setUp: () {
          when(
            () => cacheFirstTimer(),
          ).thenAnswer((_) async => Left(tCacheFailure));
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => [
          const CachingFirstTimer(),
          OnBoardingError(tCacheFailure.errorMessage),
        ],
        verify: (bloc) {
          verify(
            () => cacheFirstTimer(),
          ).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    },
  );

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
      'when successfull.',
      build: () => cubit,
      setUp: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => const Right(false));
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isFirstTimer: false),
      ],
      verify: (bloc) {
        verify(
          () => checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus(true)] '
      'when unsuccessfull.',
      build: () => cubit,
      setUp: () {
        when(
          () => checkIfUserIsFirstTimer(),
        ).thenAnswer((_) async => Left(tCacheFailure));
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (bloc) {
        verify(
          () => checkIfUserIsFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
