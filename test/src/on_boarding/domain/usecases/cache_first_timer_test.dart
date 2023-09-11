import 'package:dartz/dartz.dart';
import 'package:educational_app/core/errors/failures.dart';
import 'package:educational_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:educational_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
    'should call the [OnBoardinRepo.cacheFirstTimer] '
    'and return the right data',
    () async {
      when(() => repo.cacheFirstTimer()).thenAnswer(
        (invocation) async => Left(
          ServerFailure(
            message: 'Unknown Error Occured',
            statusCode: 500,
          ),
        ),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'Unknown Error Occured',
              statusCode: 500,
            ),
          ),
        ),
      );

      verify(
        () => repo.cacheFirstTimer(),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
